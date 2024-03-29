#!/usr/bin/env -S bun run

import { readFileSync, writeFileSync } from "node:fs";

const HOST = readFileSync("/etc/hostname", { encoding: "utf8" }).trim();
const HOME = process.env.HOME ?? "/home/jayden";
const PACKAGES_PATH = `${HOME}/.config/dotfiles/packages.json`;
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

type Package = string;
type Packages = {
  installed: {
    grace: Package[];
    swift: Package[];
    all: Package[];
  };
  ignored: Package[];
};

/**
 * @param {Object} packages Packages list
 */
function writePackagesList(packages: Packages): void {
  writeFileSync(PACKAGES_PATH, JSON.stringify(packages, null, 2) + "\n");
}

function checkBootMount(): boolean {
  const mountInfo = readFileSync("/proc/mounts", { encoding: "utf8" });
  const isMounted = /\/dev\/\w+ \/boot /.test(mountInfo);
  if (isMounted) {
    return true;
  }

  const response = prompt("Warning: /boot is not mounted. Continue? [Y/n]");
  if (["y", "Y"].includes(response ?? "")) {
    return true;
  } else {
    return false;
  }
}

async function paccache(): Promise<number> {
  if (!checkBootMount()) {
    return 1;
  }

  const p = Bun.spawn(["paccache", "-r"], {
    stdout: "inherit",
    stderr: "inherit",
    stdin: "inherit",
  });

  return await p.exited;
}

/**
 * @param {String} yayCommand Yay command to run
 * @param {Object} packages Packages list
 * @param {String[]} args Command line args
 */
async function handleYayCommand(
  yayCommand: string,
  packages: Packages,
  args: string[]
): Promise<number> {
  // if our boot partition is not mounted it probably isn't safe to continue
  if (!checkBootMount()) {
    return 1;
  }

  const progs = args.filter((a) => !a.startsWith("-"));
  const p = Bun.spawn(["yay", yayCommand, ...args], {
    stdout: "inherit",
    stderr: "inherit",
    stdin: "inherit",
  });

  const status = await p.exited;
  if (status !== 0) {
    return status;
  }

  switch (yayCommand) {
    case YAY_COMMANDS[0]: {
      const newProgs = progs.filter(
        (prog) =>
          Object.values(packages.installed).every(
            (arr) => !arr.includes(prog)
          ) && !packages.ignored.includes(prog)
      );

      if (newProgs.length === 0) {
        return status;
      }

      const progsString =
        newProgs.length === 1
          ? `${newProgs[0]}`
          : newProgs.length === 2
          ? `${newProgs[0]} and ${newProgs[1]}`
          : `${newProgs.join(", ")}`;

      const response = prompt(
        `\nDo you want to add ${progsString} to the packages list? [g/s/y/n]:`
      );
      const matches = {
        all: ["", "y", "Y"],
        grace: ["g", "G"],
        swift: ["s", "S"],
      };

      for (const [host, arr] of Object.entries(matches)) {
        if (arr.includes(response ?? "")) {
          packages.installed[host as "all" | "grace" | "swift"].push(
            ...newProgs
          );
          console.log(`${progsString} added to "${host}" list`);
          break;
        }
      }

      writePackagesList(packages);
      return status;
    }
    case YAY_COMMANDS[1]: {
      progs
        .filter((prog) =>
          Object.values(packages.installed).some((arr) => arr.includes(prog))
        )
        .forEach((prog) => {
          Object.values(packages.installed).forEach((arr) => {
            if (arr.includes(prog)) {
              arr.splice(arr.indexOf(prog), 1);
            }
          });
        });

      writePackagesList(packages);
      return status;
    }
    default: {
      return status;
    }
  }
}

/**
 * @param {Object} packages Packages list
 */
async function verifyPackages(packages: Packages): Promise<void> {
  const p = Bun.spawn(["yay", "-Qq"], {
    stdout: "pipe",
    stderr: "pipe",
  });

  const status = await p.exited;
  const stdout = await new Response(p.stdout).text();
  const stderr = await new Response(p.stderr).text();
  if (status !== 0) {
    console.error(`error!: ${stdout} ${stderr}`);
    return;
  }

  const installed = stdout.split("\n");
  Object.entries(packages.installed).forEach(([host, arr]) => {
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
 * @param {Object} packages Package list
 */
async function showUnlisted(packages: Packages): Promise<void> {
  const p = Bun.spawn(["yay", "-Qqettn"], {
    stdout: "pipe",
    stderr: "pipe",
  });

  const status = await p.exited;
  const stdout = await new Response(p.stdout).text();
  const stderr = await new Response(p.stderr).text();

  if (status !== 0) {
    console.error(`error!: ${stdout} ${stderr}`);
    return;
  }

  const installed = stdout.trim().split("\n");
  const ignored = packages.ignored;
  const listed = Object.values(packages.installed).flat();

  installed
    .filter((p) => !listed.includes(p) && !ignored.includes(p))
    .forEach((notListed) => console.log(notListed));
}

async function list(): Promise<void> {
  const p1 = Bun.spawn(["yay", "-Qqettn"], {
    stdout: "pipe",
    stderr: "pipe",
  });

  const p2 = Bun.spawn(["yay", "-Qqettm"], {
    stdout: "pipe",
    stderr: "pipe",
  });

  const status1 = await p1.exited;
  const stdout1 = await new Response(p1.stdout).text();
  const stderr1 = await new Response(p1.stderr).text();
  const status2 = await p2.exited;
  const stdout2 = await new Response(p2.stdout).text();
  const stderr2 = await new Response(p2.stderr).text();

  if (status1 !== 0 || status2 !== 0) {
    console.error(`error!: ${stdout1} ${stdout2} ${stderr1} ${stderr2}`);
    return;
  }

  const native = stdout1.trim();
  const aur = stdout2.trim();
  console.log("Native\n");
  console.log(native);
  console.log("\nAUR\n");
  console.log(aur);
}

async function main(): Promise<number> {
  const packages = JSON.parse(
    readFileSync(PACKAGES_PATH, { encoding: "utf8" })
  );
  const command = process.argv[2];
  const args = process.argv.slice(3);

  if (command === undefined) {
    const yayCode = await handleYayCommand(YAY_COMMANDS[3], packages, args);
    if (yayCode !== 0) {
      return yayCode;
    }

    // Only keep the last three versions of packages in the cache
    return await paccache();
  }

  switch (command) {
    case "i":
    case "install":
      return await handleYayCommand(YAY_COMMANDS[0], packages, args);
    case "u":
    case "uninstall":
      return await handleYayCommand(YAY_COMMANDS[1], packages, args);
    case "c":
    case "clean":
      return await handleYayCommand(YAY_COMMANDS[2], packages, args);
    case "cc":
    case "cache": {
      const cacheCode = await handleYayCommand(YAY_COMMANDS[4], packages, args);
      if (cacheCode !== 0) {
        return cacheCode;
      }
      return await paccache();
    }
    case "m":
    case "missing":
      await verifyPackages(packages);
      return 0;
    case "ul":
    case "unlisted":
      await showUnlisted(packages);
      return 0;
    case "l":
    case "list":
      await list();
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

let code: number;
try {
  code = await main();
} catch (e) {
  if (typeof e === "number") {
    code = e;
  } else {
    console.error(e);
    code = 1;
  }
}
process.exit(code);
