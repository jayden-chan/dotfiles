#!/usr/bin/env node

const { readFileSync, writeFileSync, readdirSync } = require("fs");
const { genPipewire } = require("./json_to_pipewire.js");
const { genEqualizerAPO } = require("./json_to_eqapo.js");

function main() {
  const arg = process.argv[2];
  if (arg === "all") {
    const path = "./devices";
    const files = readdirSync(path);

    files.forEach((f) => {
      const p = `${path}/${f}`;
      const contents = JSON.parse(readFileSync(p, { encoding: "utf8" }));

      const outFile = `${contents.type}-${contents.name.replace(/\s+/g, "_")}`;

      const pwOutPath = `./pipewire/${outFile}.conf`;
      const pwOutput = genPipewire(contents);
      writeFileSync(pwOutPath, pwOutput);

      const apoOutPath = `./apo/${outFile}.txt`;
      const apoOutput = genEqualizerAPO(contents);
      writeFileSync(apoOutPath, apoOutput);
    });
  }

  if (arg === "pw") {
    const path = process.argv[3];
    const contents = JSON.parse(readFileSync(path, { encoding: "utf8" }));
    console.log(genPipewire(contents));
  }

  if (arg === "apo") {
    const path = process.argv[3];
    const contents = JSON.parse(readFileSync(path, { encoding: "utf8" }));
    console.log(genEqualizerAPO(contents));
  }
}

main();
