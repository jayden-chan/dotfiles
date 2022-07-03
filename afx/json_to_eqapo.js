const bandToAPOLine = (band) => {
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
};

const highpassToAPO = (band) => {
  return `ON HPQ Fc ${band.freq} Hz Q ${band.Q}`;
};

const lowshelfToAPO = (band) => {
  return `ON LSC Fc ${band.freq} Hz Gain ${band.gain} dB Q ${band.Q}`;
};

const highshelfToAPO = (band) => {
  return `ON HSC Fc ${band.freq} Hz Gain ${band.gain} dB Q ${band.Q}`;
};

const peakingToAPO = (band) => {
  return `ON PK Fc ${band.freq} Hz Gain ${band.gain} dB Q ${band.Q}`;
};

exports.genEqualizerAPO = (contents) => {
  const eq = contents.effects.find((e) => e.type === "eq");
  let output = "";
  output += `Preamp: ${eq.settings.preamp} dB\n`;
  eq.settings.bands.forEach((band, i) => {
    output += `Filter ${i + 1}: ${bandToAPOLine(band)}\n`;
  });

  return output;
};
