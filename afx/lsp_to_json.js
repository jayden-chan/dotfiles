const preampRe = /^g_in = ((?:\d|\.|\+|-)+) db$/;
const typeRe = /^ft_(?:\d+) = (\d+)$/;
const gainRe = /^g_(?:\d+) = ((?:\d|\.|\+|-)+) db$/;
const qRe = /^q_(?:\d+) = ((?:\d|\.|\+|-)+)$/;
const freqRe = /^f_(?:\d+) = ((?:\d|\.|\+|-)+)$/;

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

exports.lspToJson = (contents) => {
  const lines = contents
    .split(/\r?\n/g)
    .filter((l) => l.length !== 0 && !l.trim().startsWith("#"));

  const [, preamp] = lines.find((l) => preampRe.test(l)).match(preampRe);

  const types = lines
    .map((l) => l.match(typeRe))
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
      types.length === qs.length &&
      types.length === freqs.length
    )
  ) {
    throw new Error(
      `types/gains/qs/freqs lengths don't match (${types.length}, ${gains.length}, ${qs.length}, ${freqs.length})`
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
      freq: freqs[i],
      Q: qs[i],
      gain: gains[i],
    });
  }

  return {
    preamp: Number(preamp),
    bands,
  };
};
