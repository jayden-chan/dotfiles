import { Band, Contents } from "./gen.ts";

export type LSPBand = {
  idx: number;
  bandType: number;
  mode: number;
  slope: number;
  solo: boolean;
  mute: boolean;
  freq: number;
  gain: number;
  Q: number;
  hue: number;
};

const hues = [
  0.0, 0.0625, 0.125, 0.1875, 0.25, 0.3125, 0.375, 0.4375, 0.5, 0.5625, 0.625,
  0.6875, 0.75, 0.8125, 0.875, 0.9375,
];

export function genLSP(contents: Contents) {
  const eq = contents.effects.find((e) => e.type === "eq");
  if (eq === undefined) {
    throw new Error("couldn't find EQ effect in effects list");
  }

  const bands = eq.settings.bands.map((b, i) => jsonBandToLSPBand(b, i));
  const fillerBands = [...Array(16 - bands.length).keys()].map((e) => {
    return defaultLSPBand(e + bands.length);
  });
  const finalBands = [...bands, ...fillerBands];

  return `bypass = false
g_in = ${eq.settings.preamp.toFixed(4)} db
g_out = 0.00 db
mode = 0
fft = 2
react = 0.10000
shift = 0.00 db
zoom = ${eq.settings.zoom.toFixed(3)} db
fsel = 0
bal = 0.00000
frqs = 0.00000
fftv_l = true
fftv_r = true
${finalBands.map(formatLSPBand).join("\n")}
out_latency = 0`;
}

const formatLSPBand = (lspBand: LSPBand) => {
  return `ft_${lspBand.idx} = ${lspBand.bandType}
fm_${lspBand.idx} = ${lspBand.mode}
s_${lspBand.idx} = ${lspBand.slope}
xs_${lspBand.idx} = ${lspBand.solo}
xm_${lspBand.idx} = ${lspBand.mute}
f_${lspBand.idx} = ${lspBand.freq.toFixed(4)}
g_${lspBand.idx} = ${lspBand.gain.toFixed(4)} db
q_${lspBand.idx} = ${lspBand.Q.toFixed(4)}
hue_${lspBand.idx} = ${lspBand.hue}`;
};

export function defaultLSPBand(idx: number) {
  return {
    bandType: 0,
    mode: 0,
    slope: 0,
    solo: false,
    mute: false,
    freq: 500,
    Q: 0.0,
    gain: 0.0,
    hue: hues[idx],
    idx,
  };
}

export function jsonBandToLSPBand(band: Band, idx: number) {
  let bandType = 0;

  // Filter type 0: 0..8
  //   0: Off
  //   1: Bell
  //   2: Hi-pass
  //   3: Hi-shelf
  //   4: Lo-pass
  //   5: Lo-shelf
  //   6: Notch
  //   7: Resonance
  //   8: Allpass
  switch (band.type) {
    case "peaking":
      bandType = 1;
      break;
    case "highpass":
      bandType = 2;
      break;
    case "lowpass":
      bandType = 4;
      break;
    case "highshelf":
      bandType = 3;
      break;
    case "lowshelf":
      bandType = 5;
      break;
    default:
      throw new Error(`Unknown band type ${band.type} encountered`);
  }

  // Filter mode 0: 0..6
  //   0: RLC (BT)
  //   1: RLC (MT)
  //   2: BWC (BT)
  //   3: BWC (MT)
  //   4: LRX (BT)
  //   5: LRX (MT)
  //   6: APO (DR)
  let mode = 0;
  switch (band.mode) {
    case "RLC_BT":
      mode = 0;
      break;
    case "RLC_MT":
      mode = 1;
      break;
    case "BWC_BT":
      mode = 2;
      break;
    case "BWC_MT":
      mode = 3;
      break;
    case "LRX_BT":
      mode = 4;
      break;
    case "LRX_MT":
      mode = 5;
      break;
    case "APO_DR":
      mode = 6;
      break;
  }

  // Filter slope 0: 0..3
  //   0: x1
  //   1: x2
  //   2: x3
  //   3: x4
  const slope = band.slope ?? 0;

  const solo = false;
  const mute = false;

  return {
    ...band,
    bandType,
    mode,
    slope,
    solo,
    mute,
    hue: hues[idx],
    idx,
  };
}
