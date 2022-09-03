#!/usr/bin/env -S deno run --allow-read --allow-write

import { genEqualizerAPO } from "./json_to_eqapo.ts";
import { genLSP } from "./json_to_lsp.ts";
import { genLV2 } from "./json_to_lv2.ts";
import { apoToJson } from "./apo_to_json.ts";
import { lspToJson } from "./lsp_to_json.ts";

import { dirname } from "https://deno.land/x/dirname_es/mod.ts";
const __dirname = dirname(import.meta);

export type Band = {
  type: string;
  mode: string;
  slope: number;
  freq: number;
  Q: number;
  gain: number;
};

export type Contents = {
  name: string;
  type: string;
  output: string;
  effects: {
    type: "eq";
    settings: {
      preamp: number;
      zoom: number;
      bands: Band[];
    };
  }[];
};

const qToBw = (Q: number) => {
  const l2 = 2 / Math.LN2;
  const l1 = 1 / Q + Math.sqrt(1 / (Q * Q) + 4);
  const l3 = Math.log(0.5 * l1);
  const bw = l2 * l3;
  return bw;
};

function dirExistsSync(path: string): boolean {
  try {
    const fileInfo = Deno.lstatSync(path);
    return fileInfo.isDirectory;
  } catch (_) {
    return false;
  }
}

const syncAll = () => {
  const path = `${__dirname}/devices`;
  const files = Deno.readDirSync(path);

  for (const file of files) {
    const f = file.name;
    const p = `${path}/${f}`;
    const contents = JSON.parse(Deno.readTextFileSync(p));

    const outFile = `${contents.type}-${contents.name.replace(/\s+/g, "_")}`;

    const apoOutPath = `${__dirname}/apo/${outFile}.txt`;
    const apoOutput = genEqualizerAPO(contents);
    Deno.writeTextFileSync(apoOutPath, apoOutput);

    const lspOutPath = `${__dirname}/lsp/${outFile}.cfg`;
    const lspOutput = genLSP(contents);
    Deno.writeTextFileSync(lspOutPath, lspOutput);

    const lv2OutDir = `${__dirname}/lv2/${outFile}.preset.lv2`;
    const [lv2Manifest, lv2Preset] = genLV2(contents, outFile);
    if (dirExistsSync(lv2OutDir)) {
      Deno.removeSync(lv2OutDir, { recursive: true });
    }

    Deno.mkdirSync(lv2OutDir);
    Deno.writeTextFileSync(`${lv2OutDir}/manifest.ttl`, lv2Manifest);
    Deno.writeTextFileSync(`${lv2OutDir}/${outFile}.ttl`, lv2Preset);
  }
};

const lspReverseSync = () => {
  const path = `${__dirname}/lsp`;
  const files = Deno.readDirSync(path);

  const devicesPath = `${__dirname}/devices`;
  const devicesFiles = Deno.readDirSync(devicesPath);
  const deviceFileNames = Object.fromEntries(
    [...devicesFiles].map((file) => {
      const p = `${devicesPath}/${file.name}`;
      const contents = JSON.parse(Deno.readTextFileSync(p));
      const outFile = `${contents.type}-${contents.name.replace(
        /\s+/g,
        "_"
      )}.cfg`;
      return [outFile, [p, contents]];
    })
  );

  for (const file of files) {
    const f = file.name;
    const p = `${path}/${f}`;
    const contents = Deno.readTextFileSync(p);
    const { preamp, zoom, bands } = lspToJson(contents);

    const info = deviceFileNames[f];
    if (info === undefined) {
      console.error(`WARN: file ${f} is not associated with a device`);
      return;
    }

    const fullPath = info[0];
    const jsonContents = info[1] as Contents;
    const effectToEdit = jsonContents.effects.findIndex((e) => e.type === "eq");
    jsonContents.effects[effectToEdit].settings.preamp = preamp;
    jsonContents.effects[effectToEdit].settings.bands = bands;
    jsonContents.effects[effectToEdit].settings.zoom = zoom;
    Deno.writeTextFileSync(fullPath, JSON.stringify(jsonContents, null, 2));
  }
};

const bw = (path: string) => {
  const contents = JSON.parse(Deno.readTextFileSync(path)) as Contents;
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
  const args = Deno.args;
  const cmd = args[0];
  if (cmd === "all") {
    syncAll();
    return;
  }

  if (cmd === "lspRevSync") {
    lspReverseSync();
    syncAll();
    return;
  }

  if (cmd === "bw") {
    const path = args[1];
    bw(path);
    return;
  }

  if (cmd === "apo") {
    const path = args[1];
    const contents = JSON.parse(Deno.readTextFileSync(path));
    console.log(genEqualizerAPO(contents));
    return;
  }

  if (cmd === "apoToJson") {
    const path = args[1];
    const contents = Deno.readTextFileSync(path);
    console.log(JSON.stringify(apoToJson(contents), null, 2));
    return;
  }

  if (cmd === "lspToJson") {
    const path = args[1];
    const contents = Deno.readTextFileSync(path);
    console.log(JSON.stringify(lspToJson(contents), null, 2));
    return;
  }

  if (cmd === "lsp") {
    const path = args[1];
    const contents = JSON.parse(Deno.readTextFileSync(path));
    console.log(genLSP(contents));
    return;
  }

  console.log("No command specified");
}

main();
