#!/usr/bin/env node
// @ts-check
"use strict";

const { spawn, spawnSync } = require("child_process");
const readline = require("readline");
const { readFileSync, writeFileSync } = require("fs");
const HOST = readFileSync("/etc/hostname", { encoding: "utf8" }).trim();

const PROGRAMS_PATH = "/home/jayden/Documents/Git/dotfiles/packages.json";
const YAY_COMMANDS = ["-S", "-Rsn", "-Yc", "-Syu", "-Sc"];

/**
 * @param {Object} programs Programs list
 */
function writeProgramsList(programs) {
  writeFileSync(PROGRAMS_PATH, JSON.stringify(programs, null, 2) + "\n");
}

function usage() {
  console.log("p - A helper script on top of another helper script");
  console.log();
  console.log("Commands:");
  console.log("      install  (i): <package>            install packages");
  console.log("    uninstall  (u): <package>            uninstall packages"); // prettier-ignore
  console.log("        clean  (c):                      clean unused packages"); // prettier-ignore
  console.log("    fullclean (fc):                      remove unused packages from packages.json"); // prettier-ignore
  console.log("          add  (a): <host> <packages...> add packages to the list"); // prettier-ignore
  console.log("       verify  (v):                      list packages from list that aren't installed"); // prettier-ignore
  console.log("     unlisted (ul):                      list packages that are installed but not in package.json"); // prettier-ignore
  console.log("        cache (cc):                      clear the package cache directories"); // prettier-ignore
  console.log("         help  (h):                      print help"); // prettier-ignore
  console.log();
  console.log("    Executing with no arguments will perform a system update");
}

/**
 * @param {String} question Question to ask
 * @param {Object} rl readline instance
 */
async function yesno(question, rl) {
  return new Promise((resolve) => {
    rl.question(question, (res) => {
      if (res === "N" || res === "n") {
        resolve(false);
      } else {
        resolve(true);
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
          const newProgs = progs.filter((prog) =>
            Object.values(programs).every((arr) => !arr.includes(prog))
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
                programs[host].push(...newProgs);
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
              Object.values(programs).some((arr) => arr.includes(prog))
            )
            .forEach((prog) => {
              Object.values(programs).forEach((arr) => {
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
 * @param {String[]} args Command line args
 */
function addProgram(programs, args) {
  // args[0] = host
  // remaining args = packages
  if (!args.slice(1).length || !Object.keys(programs).includes(args[0])) {
    console.error("Missing package name or host");
  } else {
    programs[args[0]].push(...args.slice(1));
    writeProgramsList(programs);
  }
}

/**
 * @param {Object} programs Programs list
 */
function verifyPrograms(programs) {
  const installed = spawnSync("yay", ["-Qq"]).stdout.toString().split("\n");
  Object.entries(programs).forEach(([host, arr]) => {
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
  const installed = spawnSync("yay", ["-Qqettn"]).stdout.toString().split("\n");
  // @ts-ignore -- ES2019 but I'm too lazy to configure tsserver
  const listed = Object.values(programs).flat();
  installed
    .filter((p) => !listed.includes(p))
    .forEach((notListed) => console.log(notListed));
}

/**
 * @param {Object} programs Programs list
 */
async function fullClean(programs) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

  const toUninstall = [];
  const programsEntries = Object.entries(programs);
  for (let i = 0; i < programsEntries.length; i++) {
    const [host, arr] = programsEntries[i];
    if (host === "all" || HOST === host) {
      for (let j = 0; j < arr.length; j++) {
        const p = arr[j];
        const res = await yesno(`Keep ${p}? [y/n]: `, rl);
        if (res === false) {
          toUninstall.push(p);
          console.log(`Removed ${p} from packages list.`);
        }
      }
    }
  }

  console.log(`To uninstall removed programs: p u ${toUninstall.join(" ")}`);
  rl.close();
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
    case "a":
    case "add":
      addProgram(programs, args);
      return 0;
    case "v":
    case "verify":
      verifyPrograms(programs);
      return 0;
    case "ul":
    case "unlisted":
      showUnlisted(programs);
      return 0;
    case "fc":
    case "fullclean":
      await fullClean(programs);
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
  const code = await main();
  process.exit(code);
})();
