const filterRe =
  /^Filter (\d+): ON (\w+) Fc ((?:\d|\.|-)+) Hz Gain ((?:\d|\.|-)+) dB Q ((?:\d|\.|-)+)$/;
const preampRe = /^Preamp: ((?:\d|\.|-)+) dB$/;

function apoTypeToJsonType(apoType: string) {
  switch (apoType) {
    case "PK":
      return "peaking";
    case "LP":
    case "LPQ":
      return "lowpass";
    case "HP":
    case "HPQ":
      return "highpass";
    case "LS":
      return "lowshelf";
    case "HS":
      return "highshelf";
  }
}

export function apoToJson(contents: string) {
  const lines = contents
    .split(/\r?\n/g)
    .map((l) => l.trim())
    .filter((l) => l.length > 0);
  if (lines.length === 0) {
    throw new Error("no lines in input file");
  }

  const [, preamp] = lines[0].match(preampRe) ?? [null, 0];
  const bands = lines
    .slice(1)
    .map((l, i) => {
      const matchResults = l.match(filterRe) ?? [];
      const [didMatch, , filterType, freq, gain, q] = matchResults;

      if (!didMatch) {
        throw new Error(`Failed to parse line ${i + 2}: ${l}`);
      }

      return {
        type: apoTypeToJsonType(filterType),
        freq: Number(freq),
        Q: Number(q),
        gain: Number(gain),
      };
    })
    .sort((a, b) => {
      return a.freq - b.freq;
    });

  return {
    preamp: Number(preamp),
    bands,
  };
}
