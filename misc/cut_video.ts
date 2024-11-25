import { rm } from "node:fs/promises";
import { writeFile } from "node:fs/promises";

const AUDIO_EXTS = [".m4a", ".ogg", ".mp3", ".opus"];
const RESOLUTION = "1920:1080";
const DEBUG = false;
const id = new Date()
  .toLocaleString()
  .replaceAll("/", "-")
  .replaceAll(":", "-")
  .replace(/\s/g, "_")
  .replaceAll(",", "");

const debugFile = `/tmp/cut_video_${id}_DEBUG.log`;

const path = process.argv[2];
const args = process.argv.slice(3);

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

async function cmd(command: string[], label: string) {
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
      command.join("\n") + "\n\n" + stdout + "\n\n" + stderr,
    );
    process.exit(1);
  }

  return { code, stdout, stderr };
}

async function notify(msg: string, opts?: { err?: boolean }): Promise<void> {
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
}

function genComplexFilter(args: string[]): string {
  const cutPoints = args.map((a) => parseFloat(a).toFixed(4));
  const numCuts = cutPoints.length / 2;
  const cuts = [...Array(numCuts).keys()].map((n) => n + 1);

  // combine 2 input audio channels into one channel
  let filter = `[0:1][0:2]amix=inputs=2:weights=0.6 0.6:normalize=0[outl];`;
  const vcopies = cuts.map((i) => `[vcopy${i}]`).join("");
  const acopies = cuts.map((i) => `[acopy${i}]`).join("");

  // create video copies equal to the number of cuts
  filter += `[0:v]split=${numCuts}${vcopies};`;

  // for each copy of the video, trim it according to the cut timestamps
  cuts.forEach((i) => {
    const startIdx = (i - 1) * 2;
    const startPos = cutPoints[startIdx];
    const endPos = cutPoints[startIdx + 1];
    filter += `[vcopy${i}]trim=start=${startPos}:end=${endPos},setpts=PTS-STARTPTS[v${i}];`;
  });

  // create audio copies equal to the number of cuts
  filter += `[outl]asplit=${numCuts}${acopies};\n`;

  // for each copy of the audio, trim it according to the cut timestamps
  cuts.forEach((i) => {
    const startIdx = (i - 1) * 2;
    const startPos = cutPoints[startIdx];
    const endPos = cutPoints[startIdx + 1];
    filter += `[acopy${i}]atrim=start=${startPos}:end=${endPos},asetpts=PTS-STARTPTS[a${i}];`;
  });

  // concatenate the trimmed clips
  const channelPairs = cuts.map((i) => `[v${i}][a${i}]`).join("");
  filter += `${channelPairs}concat=n=${numCuts}:v=1:a=1[vcut][a];`;

  // scale the video to 1080p
  filter += `[vcut]scale=${RESOLUTION}:flags=bicubic,setsar=1:1[v]`;
  return filter;
}

if (AUDIO_EXTS.some((e) => path.endsWith(e))) {
  // prettier-ignore
  const command = [
    "ffmpeg",
    // don't spam up the stdout/stderr
    "-hide_banner",
    "-nostats",

    "-i",       path,

    // seek to starting position
    "-ss",      args[0],

    // seek to end
    "-to",      "9999999999",

    path.replace(path.slice(path.lastIndexOf(".")), ".ogg"),

    // overwrite output file if already exists
    "-y",
  ];

  await cmd(command, "final render");
  process.exit(0);
}

if (args.length % 2 !== 0) {
  await notify("Error: Mismatched cut points", { err: true });
  process.exit(1);
}

if (args.some((a) => Number.isNaN(parseFloat(a)))) {
  await notify("Error: one or more arguments are not numbers", { err: true });
  process.exit(1);
}

const tmpPath = `/tmp/cut_video_${id}.mp4`;
const cutsFilter = genComplexFilter(args);

// prettier-ignore
const renderTmpClipCommand = [
  "ffmpeg",
  // don't spam up the stdout/stderr
  "-hide_banner",
  "-nostats",
  "-i",              path,

  // set the framerate to 60
  "-r",              "60",

  // video codec settings
  // run ffmpeg -h encoder=av1_nvenc for options
  // https://www.nvidia.com/en-us/geforce/guides/broadcasting-guide/
  "-c:v",            "av1_nvenc",
  "-preset",         "p7",
  "-tune",           "hq",
  "-rc",             "constqp",
  "-multipass",      "qres",

  // Number of frames to look ahead for rate-control (from 0 to INT_MAX) (default 0)
  "-rc-lookahead",   "53",

  // Constant quantization parameter rate control method (from -1 to 255) (default -1)
  // lower value = higher quality
  "-qp",             `${((18/51)*255).toFixed(0)}`,

  // full color range
  "-color_range",     "2",
  // BT.709
  "-colorspace",      "1",
  // BT.709
  "-color_primaries", "1",
  // BT.709
  "-color_trc",       "1",

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
  "loudness analysis",
);

const jsonPortion = loudnessOutput
  .slice(loudnessOutput.lastIndexOf("{"), loudnessOutput.lastIndexOf("}") + 1)
  .trim();

try {
  loudnessInfo = JSON.parse(jsonPortion);
} catch (e) {
  await notify("Error: Failed to parse JSON from loudnorm", { err: true });
  await writeFile(debugFile, `${loudnessOutput}\n\n${e}\n\n${jsonPortion}`);
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
