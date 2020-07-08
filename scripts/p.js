#!/usr/bin/env node
// @ts-check
"use strict";

const { spawn, spawnSync } = require("child_process");
const { readFileSync, writeFileSync } = require("fs");

const PROGRAMS_PATH = "/home/jayden/Documents/Git/dotfiles/packages.json";
const YAY_COMMANDS = ["-S", "-Rsn", "-Yc", "-Syu"];

const programs = JSON.parse(readFileSync(PROGRAMS_PATH, { encoding: "utf8" }));
const command = process.argv[2];
const args = process.argv.slice(3);
const progs = args.filter((a) => !a.startsWith("-"));

function removePacks(toRemove) {
  toRemove.forEach((pack) => {
    Object.entries(programs).forEach(([host, arr]) => {
      const found = arr.indexOf(pack);
      if (found !== -1) {
        programs[host].splice(found, 1);
      }
    });
  });
}

let yayCommand;
switch (command) {
  case "i":
  case "install":
    yayCommand = YAY_COMMANDS[0];
    break;
  case "u":
  case "uninstall":
    yayCommand = YAY_COMMANDS[1];
    break;
  case "c":
  case "clean":
    yayCommand = YAY_COMMANDS[2];
    break;
  case "a":
  case "add":
    // args[0] = host
    // remaining args = packages
    if (!args.slice(1).length || !Object.keys(programs).includes(args[0])) {
      console.error("Missing package name or host");
    } else {
      programs[args[0]].push(...args.slice(1));
      writeFileSync(PROGRAMS_PATH, JSON.stringify(programs, null, 2));
    }
    break;
  case "r":
  case "remove":
    if (!args[0]) {
      console.log("Provide packages to remove");
    } else {
      removePacks(args);
      writeFileSync(PROGRAMS_PATH, JSON.stringify(programs, null, 2));
    }
    break;
  case "v":
  case "verify":
    const installed = spawnSync("yay", ["-Qqe"]).stdout.toString().split("\n");
    Object.entries(programs).forEach(([host, arr]) => {
      if (host === "all" || process.env.HOST === host) {
        arr.forEach((p) => {
          if (!installed.includes(p)) {
            console.log(p);
          }
        });
      }
    });
    break;
  case "h":
  case "-h":
  case "--help":
    console.log("p - A helper script on top of another helper script");
    console.log();
    console.log("Commands:");
    console.log("      install (i): <package>            install packages");
    console.log("    uninstall (u): <package>            uninstall packages"); // prettier-ignore
    console.log("        clean (c):                      clean unused packages"); // prettier-ignore
    console.log("          add (a): <host> <packages...> add packages to the list"); // prettier-ignore
    console.log("       remove (r): <packages...>        remove packages from the list"); // prettier-ignore
    console.log("       verify (v):                      list packages from list that aren't installed"); // prettier-ignore
    console.log("         help (h):                      print help"); // prettier-ignore
    console.log();
    console.log("    Executing with no arguments will perform a system update");
    break;
  default:
    yayCommand = YAY_COMMANDS[3];
}

if (!yayCommand) process.exit(0);

const yay = spawn("yay", [yayCommand, ...args], {
  stdio: "inherit",
});

yay.on("close", (code) => {
  if (code !== 0) {
    process.exit(code);
  }

  switch (yayCommand) {
    case YAY_COMMANDS[0]:
      const newProgs = progs.filter((prog) =>
        Object.values(programs).every((arr) => !arr.includes(prog))
      );

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

        writeFileSync(PROGRAMS_PATH, JSON.stringify(programs, null, 2));
        process.exit(code);
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

      writeFileSync(PROGRAMS_PATH, JSON.stringify(programs, null, 2));
      process.exit(code);
  }
});