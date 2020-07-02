#!/usr/bin/env node
// @ts-check
"use strict";

const { spawn } = require("child_process");
const { readFileSync, writeFileSync } = require("fs");

const PROGRAMS_PATH = `/home/jayden/Documents/Git/dotfiles/packages.json`;
const YAY_COMMANDS = ["-S", "-Rsn", "-Yc"];

const programs = JSON.parse(readFileSync(PROGRAMS_PATH, { encoding: "utf8" }));
const command = process.argv[2];
const args = process.argv.slice(3);
const progs = args.filter((a) => !a.startsWith("-"));

let yayCommand = "";
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
  case "-h":
  case "--help":
    console.log("p - A helper script on top of another helper script");
    console.log();
    console.log("Commands:");
    console.log("      install (i): install packages");
    console.log("    uninstall (u): uninstall packages");
    console.log("        clean (c): clean unused packages");
    process.exit(0);
}

const yay = spawn("yay", [yayCommand, ...args], {
  stdio: "inherit",
});

programs.all.splice(programs.all.indexOf("wget"), 1);
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
        if (["", "y", "Y"].includes(key)) {
          programs.all.push(...newProgs);
          console.log(`${progsString} added to global list`);
        } else if (["g", "G"].includes(key)) {
          programs.grace.push(...newProgs);
          console.log(`${progsString} added to global list`);
        } else if (["s", "S"].includes(key)) {
          programs.swift.push(...newProgs);
          console.log(`${progsString} added to global list`);
        }

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
