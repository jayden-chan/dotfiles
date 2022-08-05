#!/usr/bin/env node

const {
  readFileSync,
  writeFileSync,
  readdirSync,
  existsSync,
  rmdirSync,
  mkdirSync,
} = require("fs");
const { genEqualizerAPO } = require("./json_to_eqapo.js");
const { genLSP } = require("./json_to_lsp");
const { genLV2 } = require("./json_to_lv2");
const { apoToJson } = require("./apo_to_json.js");
const { lspToJson } = require("./lsp_to_json.js");

const qToBw = (Q) => {
  const l2 = 2 / Math.LN2;
  const l1 = 1 / Q + Math.sqrt(1 / (Q * Q) + 4);
  const l3 = Math.log(0.5 * l1);
  const bw = l2 * l3;
  return bw;
};

const syncAll = () => {
  const path = `${__dirname}/devices`;
  const files = readdirSync(path);

  files.forEach((f) => {
    const p = `${path}/${f}`;
    const contents = JSON.parse(readFileSync(p, { encoding: "utf8" }));

    const outFile = `${contents.type}-${contents.name.replace(/\s+/g, "_")}`;

    const apoOutPath = `${__dirname}/apo/${outFile}.txt`;
    const apoOutput = genEqualizerAPO(contents);
    writeFileSync(apoOutPath, apoOutput);

    const lspOutPath = `${__dirname}/lsp/${outFile}.cfg`;
    const lspOutput = genLSP(contents);
    writeFileSync(lspOutPath, lspOutput);

    const lv2OutDir = `${__dirname}/lv2/${outFile}.preset.lv2`;
    const [lv2Manifest, lv2Preset] = genLV2(contents, outFile);
    if (existsSync(lv2OutDir)) {
      rmdirSync(lv2OutDir);
    }

    mkdirSync(lv2OutDir);
    writeFileSync(`${lv2OutDir}/manifest.ttl`, lv2Manifest);
    writeFileSync(`${lv2OutDir}/${outFile}.ttl`, lv2Preset);
  });
};

const lspReverseSync = () => {
  const path = `${__dirname}/lsp`;
  const files = readdirSync(path);

  const devicesPath = `${__dirname}/devices`;
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
    const { preamp, zoom, bands } = lspToJson(contents);

    const info = deviceFileNames[f];
    if (info === undefined) {
      console.error(`WARN: file ${f} is not associated with a device`);
      return;
    }

    const [fullPath, jsonContents] = info;
    const effectToEdit = jsonContents.effects.findIndex((e) => e.type === "eq");
    jsonContents.effects[effectToEdit].settings.preamp = preamp;
    jsonContents.effects[effectToEdit].settings.bands = bands;
    jsonContents.effects[effectToEdit].settings.zoom = zoom;
    writeFileSync(fullPath, JSON.stringify(jsonContents, null, 2));
  });
};

const bw = (path) => {
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
};

function main() {
  const arg = process.argv[2];
  if (arg === "all") {
    syncAll();
  }

  if (arg === "lspRevSync") {
    lspReverseSync();
    syncAll();
  }

  if (arg === "bw") {
    const path = process.argv[3];
    bw(path);
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
