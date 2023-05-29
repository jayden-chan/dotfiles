import { Band, Contents } from "./gen.ts";

function bandToPeqType(band: Band): number {
  switch (band.type) {
    case "peaking":
      return 3;
    case "lowshelf":
      return 4;
    case "highshelf":
      return 5;
    case "lowpass":
      return 0;
    case "highpass":
      return 1;
    default:
      throw new Error(
        `Warning: unknown/unsupported filter type "${band.type}" detected`
      );
  }
}

export function genPeq(contents: Contents): string {
  const eq = contents.effects.find((e) => e.type === "eq");
  if (!eq) {
    throw new Error(`Contents "${contents.name}" can't be converted to peq`);
  }

  const ret = {
    name: contents.name,
    preamp: eq.settings.preamp,
    parametric: true,
    bands: [
      // Bass "tone knob"
      {
        type: 0,
        channels: 0,
        frequency: 90,
        q: 0.0,
        gain: 0.0,
        color: 0,
      },
      // Treble "tone knob"
      {
        type: 1,
        channels: 0,
        frequency: 10000,
        q: 0.0,
        gain: 0.0,
        color: 0,
      },
      ...eq.settings.bands.map((b, i) => ({
        type: bandToPeqType(b),
        channels: 0,
        frequency: Math.round(b.freq),
        q: b.Q,
        gain: b.gain,
        color: i % 2 === 0 ? -13421773 : -8947849,
      })),
    ],
  };

  return JSON.stringify([ret], null, 2);
}
