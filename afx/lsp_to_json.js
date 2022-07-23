const preampRe = /^g_in = ((?:\d|\.|\+|-)+) db$/;
const typeRe = /^ft_(?:\d+) = (\d+)$/;
const modeRe = /^fm_(?:\d+) = (\d+)$/;
const slopeRe = /^s_(?:\d+) = (\d+)$/;
const gainRe = /^g_(?:\d+) = ((?:\d|\.|\+|-)+) db$/;
const qRe = /^q_(?:\d+) = ((?:\d|\.|\+|-)+)$/;
const freqRe = /^f_(?:\d+) = ((?:\d|\.|\+|-)+)$/;
const zoomRe = /^zoom = ((?:\d|\.|\+|-)+) db$/;

const lspBandToJsonBand = (band) => {
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
  }
};

const lspModeToJsonMode = (type) => {
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
  }
};

exports.lspToJson = (contents) => {
  const lines = contents
    .split(/\r?\n/g)
    .filter((l) => l.length !== 0 && !l.trim().startsWith("#"));

  const [, preamp] = lines.find((l) => preampRe.test(l)).match(preampRe);
  const [, zoom] = lines.find((l) => zoomRe.test(l)).match(zoomRe);

  const types = lines
    .map((l) => l.match(typeRe))
    .filter((m) => m !== null)
    .map((m) => Number(m[1]));
  const modes = lines
    .map((l) => l.match(modeRe))
    .filter((m) => m !== null)
    .map((m) => Number(m[1]));
  const slopes = lines
    .map((l) => l.match(slopeRe))
    .filter((m) => m !== null)
    .map((m) => Number(m[1]));
  const gains = lines
    .map((l) => l.match(gainRe))
    .filter((m) => m !== null)
    .map((m) => Number(m[1]));
  const qs = lines
    .map((l) => l.match(qRe))
    .filter((m) => m !== null)
    .map((m) => Number(m[1]));
  const freqs = lines
    .map((l) => l.match(freqRe))
    .filter((m) => m !== null)
    .map((m) => Number(m[1]));

  if (
    !(
      types.length === gains.length &&
      types.length === modes.length &&
      types.length === slopes.length &&
      types.length === qs.length &&
      types.length === freqs.length
    )
  ) {
    throw new Error(
      `types/gains/modes/qs/freqs lengths don't match (${types.length}, ${gains.length}, ${qs.length}, ${freqs.length})`
    );
  }

  const bands = [];
  for (let i = 0; i < types.length; i++) {
    // band is disabled
    if (types[i] === 0) {
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

  return {
    preamp: Number(Number(preamp).toFixed(3)),
    zoom: Number(Number(zoom).toFixed(3)),
    bands,
  };
};
