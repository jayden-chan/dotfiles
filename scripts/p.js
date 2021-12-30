#!/usr/bin/env node
// @ts-check
"use strict";

const { spawn, spawnSync } = require("child_process");
const { readFileSync, writeFileSync } = require("fs");

const HOST = readFileSync("/etc/hostname", { encoding: "utf8" }).trim();
const PROGRAMS_PATH = "/home/jayden/.config/dotfiles/packages.json";
const YAY_COMMANDS = ["-S", "-Rsn", "-Yc", "-Syu", "-Sc"];

function usage() {
  console.log(
    `p - A helper script on top of another helper script

Commands:
      install  (i): <package> install packages
    uninstall  (u): <package> uninstall packages
        clean  (c):           clean orphaned packages
      missing  (m):           show packages from list that aren't installed
     unlisted (ul):           show packages that are installed but not in packages.json
         list  (l):           list installed packages
        cache (cc):           clear the package cache directories
         help  (h):           print help

    Executing with no arguments will perform a system update`
  );
}

/**
 * @param {Object} programs Programs list
 */
function writeProgramsList(programs) {
  writeFileSync(PROGRAMS_PATH, JSON.stringify(programs, null, 2) + "\n");
}

function checkBootMount() {
  const mountInfo = readFileSync("/proc/mounts", { encoding: "ascii" });
  const isMounted = /\/dev\/sd\w\d \/boot/.test(mountInfo);
  return new Promise((resolve) => {
    if (isMounted) {
      resolve(true);
      return;
    }

    process.stdout.write(`Warning: /boot is not mounted. Continue? [Y/n] `);
    process.stdin.on("data", (data) => {
      const key = data.toString("utf8").trim();
      const matches = ["", "y", "Y"];
      if (matches.includes(key)) {
        resolve(true);
      } else {
        resolve(false);
      }
    });
  });
}

/**
 * @param {String} yayCommand Yay command to run
 * @param {Object} programs Programs list
 * @param {String[]} args Command line args
 */
async function handleYayCommand(yayCommand, programs, args) {
  // if our boot partition is not mounted it probably isn't safe to continue
  if (!(await checkBootMount())) {
    return Promise.resolve(1);
  }

  return new Promise((resolve) => {
    const progs = args.filter((a) => !a.startsWith("-"));
    const yay = spawn("yay", [yayCommand, ...args], {
      stdio: "inherit",
    });

    yay.on("close", (code) => {
      if (code !== 0) {
        resolve(code);
        return;
      }

      switch (yayCommand) {
        case YAY_COMMANDS[0]:
          const newProgs = progs.filter(
            (prog) =>
              Object.values(programs.installed).every(
                (arr) => !arr.includes(prog)
              ) && !programs.ignored.includes(prog)
          );

          if (newProgs.length === 0) {
            resolve(code);
            return;
          }

          const progsString =
            newProgs.length === 1
              ? `${newProgs[0]}`
              : newProgs.length === 2
              ? `${newProgs[0]} and ${newProgs[1]}`
              : `${newProgs.join(", ")}`;

          process.stdout.write(
            `\nDo you want to add ${progsString} to the programs list? [g/s/y/n]: `
          );

          process.stdin.on("data", (data) => {
            const key = data.toString("utf8").trim();
            const matches = {
              all: ["", "y", "Y"],
              grace: ["g", "G"],
              swift: ["s", "S"],
            };

            Object.entries(matches).some(([host, arr]) => {
              if (arr.includes(key)) {
                programs.installed[host].push(...newProgs);
                console.log(`${progsString} added to "${host}" list`);
                return true;
              }
            });

            writeProgramsList(programs);
            resolve(code);
            return;
          });
          break;

        case YAY_COMMANDS[1]:
          progs
            .filter((prog) =>
              Object.values(programs.installed).some((arr) =>
                arr.includes(prog)
              )
            )
            .forEach((prog) => {
              Object.values(programs.installed).forEach((arr) => {
                if (arr.includes(prog)) {
                  arr.splice(arr.indexOf(prog), 1);
                }
              });
            });

          writeProgramsList(programs);
          resolve(code);
          return;
        default:
          resolve(code);
          return;
      }
    });
  });
}

/**
 * @param {Object} programs Programs list
 */
function verifyPrograms(programs) {
  const installed = spawnSync("yay", ["-Qq"]).stdout.toString().split("\n");
  Object.entries(programs.installed).forEach(([host, arr]) => {
    if (host === "all" || HOST === host) {
      arr.forEach((p) => {
        if (!installed.includes(p)) {
          console.log(p);
        }
      });
    }
  });
}

/**
 * @param {Object} programs Programs list
 */
function showUnlisted(programs) {
  const installed = spawnSync("yay", ["-Qqettn"])
    .stdout.toString()
    .trim()
    .split("\n");
  const ignored = programs.ignored;
  // @ts-ignore -- ES2019 but I'm too lazy to configure tsserver
  const listed = Object.values(programs.installed).flat();
  installed
    .filter((p) => !listed.includes(p) && !ignored.includes(p))
    .forEach((notListed) => console.log(notListed));
}

function list() {
  const native = spawnSync("yay", ["-Qqettn"]).stdout.toString().trim();
  const aur = spawnSync("yay", ["-Qqettm"]).stdout.toString().trim();
  console.log("Native\n");
  console.log(native);
  console.log("\nAUR\n");
  console.log(aur);
}

async function main() {
  const programs = JSON.parse(
    readFileSync(PROGRAMS_PATH, { encoding: "utf8" })
  );
  const command = process.argv[2];
  const args = process.argv.slice(3);

  if (command === undefined) {
    return await handleYayCommand(YAY_COMMANDS[3], programs, args);
  }

  switch (command) {
    case "i":
    case "install":
      return await handleYayCommand(YAY_COMMANDS[0], programs, args);
    case "u":
    case "uninstall":
      return await handleYayCommand(YAY_COMMANDS[1], programs, args);
    case "c":
    case "clean":
      return await handleYayCommand(YAY_COMMANDS[2], programs, args);
    case "cc":
    case "cache":
      return await handleYayCommand(YAY_COMMANDS[4], programs, args);
    case "m":
    case "missing":
      verifyPrograms(programs);
      return 0;
    case "ul":
    case "unlisted":
      showUnlisted(programs);
      return 0;
    case "l":
    case "list":
      list();
      return 0;
    case "h":
    case "-h":
    case "--help":
      usage();
      return 0;
    default:
      usage();
      return 0;
  }
}

(async () => {
  let code;
  try {
    code = await main();
  } catch (e) {
    code = e;
  }
  process.exit(code);
})();
