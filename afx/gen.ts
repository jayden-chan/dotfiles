#!/usr/bin/env -S bun run

import { readdirSync, readFileSync, writeFileSync } from "node:fs";

import { apoToJson } from "./apo_to_json";
import { genEqualizerAPO } from "./json_to_eqapo";
import { genLSP } from "./json_to_lsp";
import { genPeq } from "./json_to_peq";
import { lspToJson } from "./lsp_to_json";
import { Device, STANDARD_SINK_ZOOM } from "./util";

const __dirname = import.meta.dir;
const utf8 = { encoding: <"utf8">"utf8" };

const syncAll = () => {
  const path = `${__dirname}/devices`;
  const files = readdirSync(path);

  for (const f of files) {
    const p = `${path}/${f}`;
    const device = JSON.parse(readFileSync(p, utf8));

    const outFile = `${device.type}-${device.name.replace(/\s+/g, "_")}`;

    const apoOutPath = `${__dirname}/apo/${outFile}.txt`;
    const apoOutput = genEqualizerAPO(device);
    writeFileSync(apoOutPath, apoOutput);

    const lspOutPath = `${__dirname}/lsp/${outFile}.cfg`;
    const lspOutput = genLSP(device);
    writeFileSync(lspOutPath, lspOutput);

    const peqOutPath = `${__dirname}/peq/${outFile}.json`;
    const peqOutput = genPeq(device);
    writeFileSync(peqOutPath, peqOutput);
  }
};

const lspReverseSync = () => {
  const path = `${__dirname}/lsp`;
  const files = readdirSync(path);

  const devicesPath = `${__dirname}/devices`;
  const devicesFiles = readdirSync(devicesPath);
  const deviceFileNames = Object.fromEntries(
    [...devicesFiles].map((file) => {
      const p = `${devicesPath}/${file}`;
      const device = JSON.parse(readFileSync(p, utf8));
      const outFile = `${device.type}-${device.name.replace(/\s+/g, "_")}.cfg`;
      return [outFile, [p, device]];
    }),
  );

  for (const f of files) {
    const p = `${path}/${f}`;
    const contents = readFileSync(p, utf8);
    const { preamp, zoom, bands } = lspToJson(contents);

    const info = deviceFileNames[f];
    if (info === undefined) {
      console.error(`WARN: file ${f} is not associated with a device`);
      return;
    }

    const fullPath = info[0];
    const device = info[1] as Device;
    const isSink = device.type === "sink";
    const effectToEdit = device.effects.findIndex((e) => e.type === "eq");

    device.effects[effectToEdit].settings.preamp = preamp;
    device.effects[effectToEdit].settings.bands = bands;
    device.effects[effectToEdit].settings.zoom = isSink ? undefined : zoom;

    writeFileSync(fullPath, JSON.stringify(device, null, 2) + "\n");
  }
};

function main() {
  const args = process.argv.slice(2);
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

  if (cmd === "apoToJson") {
    const path = args[1];
    const contents = readFileSync(path, utf8);
    console.log(JSON.stringify(apoToJson(contents), null, 2));
    return;
  }

  console.log("No command specified");
}

main();
