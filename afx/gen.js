#!/usr/bin/env node

const { readFileSync, writeFileSync, readdirSync } = require("fs");
const { genPipewire, qToBw } = require("./json_to_pipewire.js");
const { genEqualizerAPO } = require("./json_to_eqapo.js");
const { genLSP } = require("./json_to_lsp");
const { apoToJson } = require("./apo_to_json.js");
const { lspToJson } = require("./lsp_to_json.js");
const { json } = require("stream/consumers");

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

  if (arg === "lspRevSync") {
    const base = process.argv[3] ?? ".";
    const path = `${base}/lsp`;
    const files = readdirSync(path);

    const devicesPath = `${base}/devices`;
    const devicesFiles = readdirSync(devicesPath);
    const deviceFileNames = Object.fromEntries(
      devicesFiles.map((f) => {
        const p = `${devicesPath}/${f}`;
        const contents = JSON.parse(readFileSync(p, { encoding: "utf8" }));
        const outFile = `${contents.type}-${contents.name.replace(
          /\s+/g,
          "_"
        )}.cfg`;
        return [outFile, [p, contents]];
      })
    );

    files.forEach((f) => {
      const p = `${path}/${f}`;
      const contents = readFileSync(p, { encoding: "utf8" });
      const { preamp, bands } = lspToJson(contents);

      const info = deviceFileNames[f];
      if (info === undefined) {
        console.error(`WARN: file ${f} is not associated with a device`);
        return;
      }

      const [fullPath, jsonContents] = info;
      const effectToEdit = jsonContents.effects.findIndex(
        (e) => e.type === "eq"
      );
      jsonContents.effects[effectToEdit].settings.preamp = preamp;
      jsonContents.effects[effectToEdit].settings.bands = bands;
      writeFileSync(fullPath, JSON.stringify(jsonContents, null, 2));
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
    console.log(JSON.stringify(apoToJson(contents), null, 2));
  }

  if (arg === "lspToJson") {
    const path = process.argv[3];
    const contents = readFileSync(path, { encoding: "utf8" });
    console.log(JSON.stringify(lspToJson(contents), null, 2));
  }

  if (arg === "lsp") {
    const path = process.argv[3];
    const contents = JSON.parse(readFileSync(path, { encoding: "utf8" }));
    console.log(genLSP(contents));
  }
}

main();
