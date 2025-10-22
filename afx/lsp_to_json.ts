import { Band } from "./util";

const preampRe = /^g_in = ((?:\d|\.|\+|-)+) db$/;
const typeRe = /^ft_(?:\d+) = (\d+)$/;
const modeRe = /^fm_(?:\d+) = (\d+)$/;
const slopeRe = /^s_(?:\d+) = (\d+)$/;
const gainRe = /^g_(?:\d+) = ((?:\d|\.|\+|-)+) db$/;
const qRe = /^q_(?:\d+) = ((?:\d|\.|\+|-)+)$/;
const muteRe = /^xm_(?:\d+) = (true|false)$/;
const freqRe = /^f_(?:\d+) = ((?:\d|\.|\+|-)+)$/;
const zoomRe = /^zoom = ((?:\d|\.|\+|-)+) db$/;

const lspBandToJsonBand = (band: number) => {
  switch (band) {
    case 1:
      return "peaking";
    case 2:
      return "highpass";
    case 3:
      return "highshelf";
    case 4:
      return "lowpass";
    case 5:
      return "lowshelf";
    default:
      throw new Error("unknown LSP band type detected");
  }
};

const lspModeToJsonMode = (type: number) => {
  switch (type) {
    case 0:
      return "RLC_BT";
    case 1:
      return "RLC_MT";
    case 2:
      return "BWC_BT";
    case 3:
      return "BWC_MT";
    case 4:
      return "LRX_BT";
    case 5:
      return "LRX_MT";
    case 6:
      return "APO_DR";
    default:
      throw new Error("unknown LSP band mode detected");
  }
};

export function lspToJson(contents: string): {
  preamp: number;
  zoom: number;
  bands: Band[];
} {
  const lines = contents
    .split(/\r?\n/g)
    .filter((l) => l.length !== 0 && !l.trim().startsWith("#"));

  const [, preamp] = lines.find((l) => preampRe.test(l))?.match(preampRe) ?? [];
  const [, zoom] = lines.find((l) => zoomRe.test(l))?.match(zoomRe) ?? [];

  const types = lines
    .map((l) => l.match(typeRe))
    .filter((m) => m !== null)
    .map((m) => Number(m![1]));
  const modes = lines
    .map((l) => l.match(modeRe))
    .filter((m) => m !== null)
    .map((m) => Number(m![1]));
  const mutes = lines
    .map((l) => l.match(muteRe))
    .filter((m) => m !== null)
    .map((m) => m![1] === "true");
  const slopes = lines
    .map((l) => l.match(slopeRe))
    .filter((m) => m !== null)
    .map((m) => Number(m![1]));
  const gains = lines
    .map((l) => l.match(gainRe))
    .filter((m) => m !== null)
    .map((m) => Number(m![1]));
  const qs = lines
    .map((l) => l.match(qRe))
    .filter((m) => m !== null)
    .map((m) => Number(m![1]));
  const freqs = lines
    .map((l) => l.match(freqRe))
    .filter((m) => m !== null)
    .map((m) => Number(m![1]));

  if (
    !(
      types.length === gains.length &&
      types.length === modes.length &&
      types.length === mutes.length &&
      types.length === slopes.length &&
      types.length === qs.length &&
      types.length === freqs.length
    )
  ) {
    throw new Error(
      `types/gains/modes/mutes/qs/freqs lengths don't match (${types.length}, ${gains.length}, ${qs.length}, ${freqs.length})`,
    );
  }

  const bands = [];
  for (let i = 0; i < types.length; i++) {
    // band is disabled
    if (types[i] === 0 || mutes[i] === true) {
      continue;
    }

    bands.push({
      type: lspBandToJsonBand(types[i]),
      mode: lspModeToJsonMode(modes[i]),
      slope: Number(slopes[i].toFixed(3)),
      freq: Number(freqs[i].toFixed(3)),
      Q: Number(qs[i].toFixed(3)),
      gain: Number(gains[i].toFixed(3)),
    });
  }

  bands.sort((a, b) => a.freq - b.freq);

  return {
    preamp: Number(Number(preamp).toFixed(3)),
    zoom: Number(Number(zoom).toFixed(3)),
    bands,
  };
}
