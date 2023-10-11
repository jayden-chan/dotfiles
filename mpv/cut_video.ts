import { rm } from "node:fs/promises";
import { writeFile } from "node:fs/promises";

const RESOLUTION = "1920:1080";
const DEBUG = false;
const id = new Date()
  .toLocaleString()
  .replaceAll("/", "-")
  .replaceAll(":", "-")
  .replace(/\s/g, "_")
  .replaceAll(",", "");

const debugFile = `/tmp/cut_video_${id}_DEBUG.log`;

type LoudnessInfo = {
  input_i: string;
  input_tp: string;
  input_lra: string;
  input_thresh: string;
  output_i: string;
  output_tp: string;
  output_lra: string;
  output_thresh: string;
  normalization_type: string;
  target_offset: string;
};

const cmd = async (command: string[], label: string) => {
  const proc = Bun.spawn(command, {
    stdout: "pipe",
    stderr: "pipe",
  });

  const stdout = await new Response(proc.stdout).text();
  const stderr = await new Response(proc.stderr).text();
  const code = await proc.exited;

  if (code !== 0) {
    await notify(`Error: command failed: ${label}`, { err: true });
    await writeFile(
      debugFile,
      command.join("\n") + "\n\n" + stdout + "\n\n" + stderr
    );
    process.exit(1);
  }

  return { code, stdout, stderr };
};

const notify = async (msg: string, opts?: { err?: boolean }) => {
  const proc = Bun.spawn({
    cmd: [
      "notify-send",
      ...(opts?.err ? ["-u", "critical"] : []),
      "cut_video.ts",
      msg,
    ],
    stdout: "ignore",
    stdin: "ignore",
    stderr: "ignore",
  });

  await proc.exited;
};

const genCutsFilter = (args: string[]) => {
  const cutPoints = args.map((a) => parseFloat(a).toFixed(4));
  const numCuts = cutPoints.length / 2;
  const cuts = [...Array(numCuts).keys()].map((n) => n + 1);
  let filter = `[0:1][0:2]amix=inputs=2:weights=0.6 0.6:normalize=0[outl];`;
  const vcopies = cuts.map((i) => `[vcopy${i}]`).join("");
  const acopies = cuts.map((i) => `[acopy${i}]`).join("");
  filter += `[0:v]split=${numCuts}${vcopies};`;

  cuts.forEach((i) => {
    const startIdx = (i - 1) * 2;
    const startPos = cutPoints[startIdx];
    const endPos = cutPoints[startIdx + 1];
    filter += `[vcopy${i}]trim=start=${startPos}:end=${endPos},setpts=PTS-STARTPTS[v${i}];`;
  });

  filter += `[outl]asplit=${numCuts}${acopies};\n`;
  cuts.forEach((i) => {
    const startIdx = (i - 1) * 2;
    const startPos = cutPoints[startIdx];
    const endPos = cutPoints[startIdx + 1];
    filter += `[acopy${i}]atrim=start=${startPos}:end=${endPos},asetpts=PTS-STARTPTS[a${i}];`;
  });

  const channelPairs = cuts.map((i) => `[v${i}][a${i}]`).join("");
  filter += `${channelPairs}concat=n=${numCuts}:v=1:a=1[vpre][a];`;
  filter += `[vpre]scale=${RESOLUTION}:flags=bicubic,setsar=1:1[v]`;
  return filter;
};

const path = process.argv[2];
const args = process.argv.slice(3);

if (args.length % 2 !== 0) {
  await notify("Error: Mismatched cut points", { err: true });
  process.exit(1);
}

if (args.some((a) => Number.isNaN(parseFloat(a)))) {
  await notify("Error: one or more arguments are not numbers", { err: true });
  process.exit(1);
}

const tmpPath = `/tmp/cut_video_${id}.mp4`;
const cutsFilter = genCutsFilter(args);

// prettier-ignore
const renderTmpClipCommand = [
  "ffmpeg",
  // don't spam up the stdout/stderr
  "-hide_banner",
  "-nostats",
  "-i",              path,

  // video codec settings
  // https://www.nvidia.com/en-us/geforce/guides/broadcasting-guide/
  // https://git.dec05eba.com/gpu-screen-recorder/tree/src/main.cpp#n411
  "-c:v",            "hevc_nvenc",
  "-preset",         "p6",
  "-profile",        "main",
  "-tune",           "hq",
  "-rc",             "constqp",
  "-qp",             "24",

  // set audio settings to AAC 320 kbps
  "-c:a",            "aac",
  "-b:a",            "320k",

  // apply our generated filter_complex parameter to clip up the video
  "-filter_complex", cutsFilter,

  // select the clipped up and normalized video/audio that we made
  // with the filter_complex parameter
  "-map",            "[v]",
  "-map",            "[a]",

  // output path
  tmpPath,

  // overwrite output file if already exists
  "-y",
]

await cmd(renderTmpClipCommand, "temp clip");

let loudnessInfo: LoudnessInfo;

await Bun.sleep(1);

// prettier-ignore
const loudnessAnalysisCommand = [
  "ffmpeg",
  // don't spam up the stdout/stderr
  "-hide_banner",
  "-nostats",
  "-i",           tmpPath,
  // print the loudnorm information as JSON format
  "-filter:a",    "loudnorm=print_format=json",
  "-f",           "null",
  "NULL",
];

const { stderr: loudnessOutput } = await cmd(
  loudnessAnalysisCommand,
  "loudness analysis"
);

const jsonPortion = loudnessOutput
  .slice(loudnessOutput.lastIndexOf("{"), loudnessOutput.length)
  .trim();

try {
  loudnessInfo = JSON.parse(jsonPortion);
} catch (e) {
  await notify("Error: Failed to parse JSON from loudnorm", { err: true });
  process.exit(1);
}

const loudnormFilter = `loudnorm=linear=true
i=-23.0
lra=${loudnessInfo.input_lra}
tp=-2.0
offset=${loudnessInfo.target_offset}
measured_I=${loudnessInfo.input_i}
measured_tp=${loudnessInfo.input_tp}
measured_LRA=${loudnessInfo.input_lra}
measured_thresh=${loudnessInfo.input_thresh},aresample=resampler=soxr
out_sample_rate=48000
precision=28`.replaceAll("\n", ":");

const outputPath = path
  .replace(".mp4", "_clip.mp4")
  .replace("/replays/", "/clips/");

// prettier-ignore
const finalCmd = [
  "ffmpeg",
  // don't spam up the stdout/stderr
  "-hide_banner",
  "-nostats",
  "-i",              tmpPath,

  // select all input streams for the output
  "-map",            "0",

  // copy the video over without transcoding
  // or modifying in any way
  "-c:v",            "copy",

  // apply the computed loudness normalization filter
  "-filter:a",       loudnormFilter,

  // AAC 320 kbps
  "-c:a",            "aac",
  "-b:a",            "320k",

  // set the number of audio channels to 2. this is supposed to be
  // automatically determined by the input but it sometimes doesn't
  // work when using the loudnorm filter
  "-ac",             "2",

  outputPath,

  "-y",
]

await cmd(finalCmd, "final render");

if (!DEBUG) {
  await rm(tmpPath);
}

let debugOut = "";
debugOut += "First render command:\n";
debugOut += `$ ${renderTmpClipCommand.map((c) => `'${c}'`).join(" ")}\n\n`;
debugOut += renderTmpClipCommand.join("\n") + "\n\n";
debugOut += `\n\n${"-".repeat(64)}\n\n`;

debugOut += "First render filter:\n";
debugOut += cutsFilter.replaceAll(";", "\n");
debugOut += `\n\n${"-".repeat(64)}\n\n`;

debugOut += "Loudness analysis command:\n";
debugOut += `$ ${loudnessAnalysisCommand.map((c) => `'${c}'`).join(" ")}\n\n`;
debugOut += loudnessAnalysisCommand.join("\n") + "\n\n";
debugOut += `\n\n${"-".repeat(64)}\n\n`;

debugOut += "Final ffmpeg command:\n";
debugOut += `$ ${finalCmd.map((c) => `'${c}'`).join(" ")}\n\n`;
debugOut += finalCmd.join("\n") + "\n\n";
debugOut += `\n\n${"-".repeat(64)}\n\n`;

await writeFile(debugFile, debugOut);
await notify("Rendering finished!");
