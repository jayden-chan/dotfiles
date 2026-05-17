#!/usr/bin/env -S node
import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";

import { apoToJson } from "./apo_to_json.ts";
import { genEqualizerAPO } from "./json_to_eqapo.ts";
import { genLSP } from "./json_to_lsp.ts";
import { genPeq } from "./json_to_peq.ts";
import { lspToJson } from "./lsp_to_json.ts";
import type { Device } from "./util.ts";

const utf8 = { encoding: "utf8" as const };

const syncAll = () => {
  const path = `${import.meta.dirname}/devices`;
  const files = readdirSync(path);

  const syncDevice = (device: Device) => {
    if (device.settings.bands.length > 16) {
      throw new Error(
        `Device "${device.name}" has too many EQ bands (${device.settings.bands.length})`,
      );
    }

    const slug = `${device.type}-${device.name.replace(/\s+/g, "_")}`;

    const apoOutPath = `${import.meta.dirname}/dist/apo/${slug}.txt`;
    const apoOutput = genEqualizerAPO(device);
    writeFileSync(apoOutPath, apoOutput);

    const lspOutPath = `${import.meta.dirname}/dist/lsp/${slug}.cfg`;
    const lspOutput = genLSP(device);
    writeFileSync(lspOutPath, lspOutput);

    const peqOutPath = `${import.meta.dirname}/dist/peq/${slug}.json`;
    const peqOutput = genPeq(device);
    writeFileSync(peqOutPath, peqOutput);
  };

  for (const f of files) {
    const p = `${path}/${f}`;
    const device = JSON.parse(readFileSync(p, utf8)) as Device;

    if (!device.parent) {
      syncDevice(device);
      continue;
    }

    const parent = JSON.parse(
      readFileSync(
        join(dirname(p), device.parent.replace(/\s+/g, "_") + ".json"),
        utf8,
      ),
    ) as Device;

    const joinedDevice = structuredClone(device);

    joinedDevice.settings.bands = joinedDevice.settings.bands.concat(
      parent.settings.bands,
    );
    joinedDevice.settings.bands.sort((a, b) => a.freq - b.freq);

    device.name = `${device.name} (solo)`;
    joinedDevice.name = `${joinedDevice.name} (combined)`;

    syncDevice(device);
    syncDevice(joinedDevice);
  }
};

const lspReverseSync = () => {
  const path = `${import.meta.dirname}/dist/lsp`;
  const files = readdirSync(path).filter((p) => !p.includes("(combined)"));

  const devicesPath = `${import.meta.dirname}/devices`;
  const devicesFiles = readdirSync(devicesPath);
  const deviceFileNames = Object.fromEntries(
    [...devicesFiles].map((file) => {
      const p = `${devicesPath}/${file}`;
      const device = JSON.parse(readFileSync(p, utf8)) as Device;
      const slug = `${device.type}-${device.name.replace(/\s+/g, "_")}`;
      const outFile = device.parent ? `${slug}_(solo).cfg` : `${slug}.cfg`;
      return [outFile, [p, device] as [string, Device]];
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

    device.settings.preamp = preamp;
    device.settings.bands = bands;
    device.settings.zoom = isSink ? undefined : zoom;

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
