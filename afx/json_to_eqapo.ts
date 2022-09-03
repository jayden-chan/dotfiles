import { Band, Contents } from "./gen.ts";

function bandToAPOLine(band: Band) {
  switch (band.type) {
    case "highpass":
      return highpassToAPO(band);
    case "lowshelf":
      return lowshelfToAPO(band);
    case "highshelf":
      return highshelfToAPO(band);
    case "peaking":
      return peakingToAPO(band);
  }
}

const highpassToAPO = (band: Band) => `ON HPQ Fc ${band.freq} Hz Q ${band.Q}`;

const lowshelfToAPO = (band: Band) =>
  `ON LSC Fc ${band.freq} Hz Gain ${band.gain} dB Q ${band.Q}`;

const highshelfToAPO = (band: Band) =>
  `ON HSC Fc ${band.freq} Hz Gain ${band.gain} dB Q ${band.Q}`;

const peakingToAPO = (band: Band) =>
  `ON PK Fc ${band.freq} Hz Gain ${band.gain} dB Q ${band.Q}`;

export function genEqualizerAPO(contents: Contents) {
  const eq = contents.effects.find((e) => e.type === "eq");
  if (eq === undefined) {
    throw new Error("couldn't find EQ effect in effects list");
  }

  let output = "";
  output += `Preamp: ${eq.settings.preamp} dB\n`;
  eq.settings.bands.forEach((band, i) => {
    output += `Filter ${i + 1}: ${bandToAPOLine(band)}\n`;
  });

  return output;
}
