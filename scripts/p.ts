#!/usr/bin/env -S deno run --allow-read --allow-write --allow-run=paccache,yay --no-lock

const HOST = Deno.readTextFileSync("/etc/hostname").trim();
const PACKAGES_PATH = "/home/jayden/.config/dotfiles/packages.json";
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
function writePackagesList(packages: Packages) {
  Deno.writeTextFileSync(
    PACKAGES_PATH,
    JSON.stringify(packages, null, 2) + "\n"
  );
}

function checkBootMount() {
  const mountInfo = Deno.readTextFileSync("/proc/mounts");
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

  const p = Deno.run({
    cmd: ["paccache", "-r"],
    stdin: "inherit",
    stdout: "inherit",
    stderr: "inherit",
  });
  return (await p.status()).code;
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
  const p = Deno.run({
    cmd: ["yay", yayCommand, ...args],
    stdin: "inherit",
    stdout: "inherit",
    stderr: "inherit",
  });

  const status = await p.status();
  if (status.code !== 0) {
    return status.code;
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
        return status.code;
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
      return status.code;
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
      return status.code;
    }
    default: {
      return status.code;
    }
  }
}

/**
 * @param {Object} packages Packages list
 */
async function verifyPackages(packages: Packages) {
  const p = Deno.run({
    cmd: ["yay", "-Qq"],
    stderr: "piped",
    stdout: "piped",
  });
  const [status, stdout] = await Promise.all([p.status(), p.output()]);
  p.close();
  if (status.code !== 0) {
    console.error(`error!: ${stdout}`);
    return;
  }

  const installed = new TextDecoder().decode(stdout).split("\n");
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
async function showUnlisted(packages: Packages) {
  const p = Deno.run({
    cmd: ["yay", "-Qqettn"],
    stderr: "piped",
    stdout: "piped",
  });
  const [status, stdout] = await Promise.all([p.status(), p.output()]);
  p.close();

  if (status.code !== 0) {
    console.error(`error!: ${stdout}`);
    return;
  }

  const installed = new TextDecoder().decode(stdout).trim().split("\n");
  const ignored = packages.ignored;
  const listed = Object.values(packages.installed).flat();

  installed
    .filter((p) => !listed.includes(p) && !ignored.includes(p))
    .forEach((notListed) => console.log(notListed));
}

async function list() {
  const p1 = Deno.run({
    cmd: ["yay", "-Qqettn"],
    stderr: "piped",
    stdout: "piped",
  });
  const p2 = Deno.run({
    cmd: ["yay", "-Qqettm"],
    stderr: "piped",
    stdout: "piped",
  });

  const [status1, stdout1, status2, stdout2] = await Promise.all([
    p1.status(),
    p1.output(),
    p2.status(),
    p2.output(),
  ]);
  p1.close();
  p2.close();

  if (status1.code !== 0 || status2.code !== 0) {
    console.error(`error!: ${stdout1} ${stdout2}`);
    return;
  }

  const native = new TextDecoder().decode(stdout1).trim();
  const aur = new TextDecoder().decode(stdout2).trim();
  console.log("Native\n");
  console.log(native);
  console.log("\nAUR\n");
  console.log(aur);
}

async function main() {
  const packages = JSON.parse(Deno.readTextFileSync(PACKAGES_PATH));
  const command = Deno.args[0];
  const args = Deno.args.slice(1);

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

(async () => {
  let code;
  try {
    code = await main();
  } catch (e) {
    code = e;
  }
  Deno.exit(code);
})();
