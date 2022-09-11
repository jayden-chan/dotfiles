import { Contents } from "./gen.ts";
import { jsonBandToLSPBand, defaultLSPBand, LSPBand } from "./json_to_lsp.ts";

const unBoolean = (val: boolean) => {
  if (typeof val === "boolean") {
    return val ? 1 : 0;
  }
  return val;
};

const fixGain = (gain: number) => {
  return 1.122 ** gain;
};

const LSPBandToLV2Params = (lspBand: LSPBand) => {
  return {
    [`ft_${lspBand.idx}`]: lspBand.bandType,
    [`fm_${lspBand.idx}`]: lspBand.mode,
    [`s_${lspBand.idx}`]: lspBand.slope,
    [`xs_${lspBand.idx}`]: unBoolean(lspBand.solo),
    [`xm_${lspBand.idx}`]: unBoolean(lspBand.mute),
    [`f_${lspBand.idx}`]: lspBand.freq,
    [`g_${lspBand.idx}`]: fixGain(lspBand.gain),
    [`q_${lspBand.idx}`]: lspBand.Q,
    [`hue_${lspBand.idx}`]: lspBand.hue,
  };
};

const manifest = (
  name: string,
  appliesTo: string
) => `@prefix atom: <http://lv2plug.in/ns/ext/atom#> .
@prefix lv2: <http://lv2plug.in/ns/lv2core#> .
@prefix pset: <http://lv2plug.in/ns/ext/presets#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix state: <http://lv2plug.in/ns/ext/state#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<https://lv2.jayden.codes/presets/${name}>
\tlv2:appliesTo <${appliesTo}> ;
\ta pset:Preset ;
\trdfs:seeAlso <${name}.ttl> .`;

const header = (
  name: string,
  appliesTo: string
) => `@prefix atom: <http://lv2plug.in/ns/ext/atom#> .
@prefix lv2: <http://lv2plug.in/ns/lv2core#> .
@prefix pset: <http://lv2plug.in/ns/ext/presets#> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix state: <http://lv2plug.in/ns/ext/state#> .
@prefix xsd: <http://www.w3.org/2001/XMLSchema#> .

<https://lv2.jayden.codes/presets/${name}>
\ta pset:Preset ;
\tlv2:appliesTo <${appliesTo}> ;
\trdfs:label "${name}" ;
\tlv2:port`;

const footer = (appliesTo: string) => `
\tstate:state [
\t\t<${appliesTo}/KVT> [
\t\t\ta atom:Tuple ;
\t\t\trdf:value ()
\t\t]
\t] .
\n`;

const validControls = [
  "bal",
  "enabled",
  "f_0",
  "f_1",
  "f_10",
  "f_11",
  "f_12",
  "f_13",
  "f_14",
  "f_15",
  "f_2",
  "f_3",
  "f_4",
  "f_5",
  "f_6",
  "f_7",
  "f_8",
  "f_9",
  "fft",
  "fftv_l",
  "fftv_r",
  "fm_0",
  "fm_1",
  "fm_10",
  "fm_11",
  "fm_12",
  "fm_13",
  "fm_14",
  "fm_15",
  "fm_2",
  "fm_3",
  "fm_4",
  "fm_5",
  "fm_6",
  "fm_7",
  "fm_8",
  "fm_9",
  "frqs",
  "fsel",
  "ft_0",
  "ft_1",
  "ft_10",
  "ft_11",
  "ft_12",
  "ft_13",
  "ft_14",
  "ft_15",
  "ft_2",
  "ft_3",
  "ft_4",
  "ft_5",
  "ft_6",
  "ft_7",
  "ft_8",
  "ft_9",
  "g_0",
  "g_1",
  "g_10",
  "g_11",
  "g_12",
  "g_13",
  "g_14",
  "g_15",
  "g_2",
  "g_3",
  "g_4",
  "g_5",
  "g_6",
  "g_7",
  "g_8",
  "g_9",
  "g_in",
  "g_out",
  "hue_0",
  "hue_1",
  "hue_10",
  "hue_11",
  "hue_12",
  "hue_13",
  "hue_14",
  "hue_15",
  "hue_2",
  "hue_3",
  "hue_4",
  "hue_5",
  "hue_6",
  "hue_7",
  "hue_8",
  "hue_9",
  "mode",
  "q_0",
  "q_1",
  "q_10",
  "q_11",
  "q_12",
  "q_13",
  "q_14",
  "q_15",
  "q_2",
  "q_3",
  "q_4",
  "q_5",
  "q_6",
  "q_7",
  "q_8",
  "q_9",
  "react",
  "s_0",
  "s_1",
  "s_10",
  "s_11",
  "s_12",
  "s_13",
  "s_14",
  "s_15",
  "s_2",
  "s_3",
  "s_4",
  "s_5",
  "s_6",
  "s_7",
  "s_8",
  "s_9",
  "shift",
  "xm_0",
  "xm_1",
  "xm_10",
  "xm_11",
  "xm_12",
  "xm_13",
  "xm_14",
  "xm_15",
  "xm_2",
  "xm_3",
  "xm_4",
  "xm_5",
  "xm_6",
  "xm_7",
  "xm_8",
  "xm_9",
  "xs_0",
  "xs_1",
  "xs_10",
  "xs_11",
  "xs_12",
  "xs_13",
  "xs_14",
  "xs_15",
  "xs_2",
  "xs_3",
  "xs_4",
  "xs_5",
  "xs_6",
  "xs_7",
  "xs_8",
  "xs_9",
  "zoom",
];

function getAppliesTo(outputType: string): string {
  if (outputType === "MONO") {
    return "http://lsp-plug.in/plugins/lv2/para_equalizer_x16_mono";
  } else {
    return "http://lsp-plug.in/plugins/lv2/para_equalizer_x16_stereo";
  }
}

export function genLV2(contents: Contents, name: string) {
  const eq = contents.effects.find((e) => e.type === "eq");
  const appliesTo = getAppliesTo(contents.output);
  if (eq === undefined) {
    throw new Error("couldn't find EQ effect in effects list");
  }

  const bands = eq.settings.bands.map(jsonBandToLSPBand);
  const fillerBands = [...Array(16 - bands.length).keys()].map((e) => {
    return defaultLSPBand(e + bands.length);
  });

  const finalBands = [...bands, ...fillerBands].map(LSPBandToLV2Params);
  let params = {
    bypass: 0,
    enabled: 1,
    g_in: fixGain(eq.settings.preamp),
    g_out: fixGain(0.0),
    mode: 0,
    fft: 0,
    react: 0.2,
    shift: fixGain(0.0),
    zoom: fixGain(eq.settings.zoom),
    fsel: 0,
    bal: 0.0,
    frqs: 0.0,
    fftv_l: 1,
    fftv_r: 1,
    out_latency: 0,
  };

  finalBands.forEach((b) => {
    params = { ...params, ...b };
  });

  const ports = Object.entries(params)
    .filter(([key]) => validControls.includes(key))
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([key, val]) => {
      const finalVal = typeof val === "number" ? val.toFixed(6) : val;
      return `[\n\t\tlv2:symbol "${key}" ;\n\t\tpset:value ${finalVal}\n\t]`;
    })
    .join(" , ");

  return [
    manifest(name, appliesTo),
    `${header(name, appliesTo)} ${ports} ;${footer(appliesTo)}`,
  ];
}
