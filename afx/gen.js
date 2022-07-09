#!/usr/bin/env node

const { readFileSync, writeFileSync, readdirSync } = require("fs");
const { genPipewire, qToBw } = require("./json_to_pipewire.js");
const { genEqualizerAPO } = require("./json_to_eqapo.js");
const { genLSP } = require("./json_to_lsp");
const { apoToJson } = require("./apo_to_json.js");

function main() {
  const arg = process.argv[2];
  if (arg === "all") {
    const base = process.argv[3] ?? ".";
    const path = `${base}/devices`;
    const files = readdirSync(path);

    files.forEach((f) => {
      const p = `${path}/${f}`;
      const contents = JSON.parse(readFileSync(p, { encoding: "utf8" }));

      const outFile = `${contents.type}-${contents.name.replace(/\s+/g, "_")}`;

      const pwOutPath = `${base}/pipewire/${outFile}.conf`;
      const pwOutput = genPipewire(contents);
      writeFileSync(pwOutPath, pwOutput);

      const apoOutPath = `${base}/apo/${outFile}.txt`;
      const apoOutput = genEqualizerAPO(contents);
      writeFileSync(apoOutPath, apoOutput);

      const lspOutPath = `${base}/lsp/${outFile}.cfg`;
      const lspOutput = genLSP(contents);
      writeFileSync(lspOutPath, lspOutput);
    });
  }

  if (arg === "pw") {
    const path = process.argv[3];
    const contents = JSON.parse(readFileSync(path, { encoding: "utf8" }));
    console.log(genPipewire(contents));
  }

  if (arg === "bw") {
    const path = process.argv[3];
    const contents = JSON.parse(readFileSync(path, { encoding: "utf8" }));
    contents.effects = contents.effects.map((e) => {
      if (e.type === "eq") {
        e.settings.bands = e.settings.bands.map((b) => ({
          ...b,
          bw: qToBw(b.Q),
        }));
      }

      return e;
    });

    console.log(JSON.stringify(contents, null, 2));
  }

  if (arg === "apo") {
    const path = process.argv[3];
    const contents = JSON.parse(readFileSync(path, { encoding: "utf8" }));
    console.log(genEqualizerAPO(contents));
  }

  if (arg === "apoToJson") {
    const path = process.argv[3];
    const contents = readFileSync(path, { encoding: "utf8" });
    console.log(apoToJson(contents));
  }

  if (arg === "lsp") {
    const path = process.argv[3];
    const contents = JSON.parse(readFileSync(path, { encoding: "utf8" }));
    console.log(genLSP(contents));
  }
}

main();
