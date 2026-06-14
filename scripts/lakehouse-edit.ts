#!/usr/bin/env -S node

import { randomBytes } from "node:crypto";
import { readFile, rm, writeFile } from "node:fs/promises";
import { spawn } from "node:child_process";
import { once } from "node:events";
import { join } from "node:path";

const error = async (err: string) => {
  console.error(err);
  const proc = spawn("notify-send", ["lakehouse-edit", `${err}`]);
  await once(proc, "close");
  process.exit(1);
};

const noteId = process.argv[2];

if (!noteId) {
  await error("Missing note ID");
}

const ENV = Object.fromEntries(
  (await readFile(join(process.env.HOME!, ".config/ENV"), "utf8"))
    .split(/\r?\n/g)
    .map((l) => l.trim())
    .filter((l) => l.length > 0 && !l.startsWith("#"))
    .map((l) =>
      l
        .replaceAll(/^export /g, "")
        .split("=")
        .map((part) => {
          const p = part.trim();
          if (
            (p.startsWith('"') && p.endsWith('"')) ||
            (p.startsWith("'") && p.endsWith("'"))
          ) {
            return p.slice(1, -1);
          }
          return p;
        }),
    ),
);

const TERMINAL = process.env["TERMINAL"];
if (!TERMINAL) {
  await error("$TERMINAL env var isn't set");
}

const LAKEHOUSE_URL = ENV["LAKEHOUSE_URL"];
const LAKEHOUSE_TOKEN = ENV["LAKEHOUSE_TOKEN"];

if (!LAKEHOUSE_URL || !LAKEHOUSE_TOKEN) {
  await error("Missing Lakehouse URL or token");
}

const res1 = await fetch(`${LAKEHOUSE_URL}/api/notes/${noteId}`, {
  headers: {
    authorization: `Bearer ${LAKEHOUSE_TOKEN}`,
    accept: "application/json",
  },
});

if (res1.status !== 200) {
  console.error(`Non-200 status from GET request`);
  console.error(res1.status);
  await error(await res1.text());
}

const currentContent = ((await res1.json()) as any).content;
if (!currentContent || typeof currentContent !== "string") {
  await error(`Missing current contents or it's not a string`);
}

const tmpFile = `/dev/shm/lakehouse-${randomBytes(4).toString("hex")}.md`;
await writeFile(tmpFile, currentContent);

const proc = spawn(
  TERMINAL,
  ["--class=lakehouse-nvim", "-e", "nvim", "-c", "setlocal nowrap", tmpFile],
  { stdio: "inherit" },
);

await once(proc, "close");

const updatedContent = await readFile(tmpFile, "utf8");
await rm(tmpFile);

const res2 = await fetch(`${LAKEHOUSE_URL}/api/notes/${noteId}`, {
  method: "PATCH",
  headers: {
    authorization: `Bearer ${LAKEHOUSE_TOKEN}`,
    accept: "application/json",
    "content-type": "application/json",
  },
  body: JSON.stringify({ content: updatedContent.trim() }),
});

if (res2.status !== 200) {
  await error(await res2.text());
}
