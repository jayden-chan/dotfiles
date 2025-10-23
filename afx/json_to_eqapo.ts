import type { Band, Device } from "./util";

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
    case "lowpass":
      return lowpassToAPO(band);
    default:
      throw new Error(
        `Warning: unknown/unsupported filter type "${band.type}" detected`,
      );
  }
}

const highpassToAPO = (band: Band) => `ON HPQ Fc ${band.freq} Hz Q ${band.Q}`;
const lowpassToAPO = (band: Band) => `ON LPQ Fc ${band.freq} Hz Q ${band.Q}`;

const lowshelfToAPO = (band: Band) =>
  `ON LSC Fc ${band.freq} Hz Gain ${band.gain} dB Q ${band.Q}`;

const highshelfToAPO = (band: Band) =>
  `ON HSC Fc ${band.freq} Hz Gain ${band.gain} dB Q ${band.Q}`;

const peakingToAPO = (band: Band) =>
  `ON PK Fc ${band.freq} Hz Gain ${band.gain} dB Q ${band.Q}`;

export function genEqualizerAPO(device: Device) {
  let output = "";
  output += `Preamp: ${device.settings.preamp} dB\n`;
  device.settings.bands.forEach((band, i) => {
    output += `Filter ${i + 1}: ${bandToAPOLine(band)}\n`;
  });

  return output;
}
