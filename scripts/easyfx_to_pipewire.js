#!/usr/bin/env node

const { readFileSync } = require("fs");

if (!process.argv[2] || !process.argv[3]) {
  console.log("specify input json and name of eq");
  process.exit(1);
}

const file = JSON.parse(readFileSync(process.argv[2], { encoding: "utf8" }));
const eq = file.output.equalizer;
const bands = eq.left;

// prettier-ignore
console.log(
  `# equalizer
#
# start with pipewire -c file.conf
#
context.properties = {
    log.level = 0
}

context.spa-libs = {
    audio.convert.* = audioconvert/libspa-audioconvert
    support.*       = support/libspa-support
}

context.modules = [
    { name = libpipewire-module-rt
        args = {
            #rt.prio      = 88
            #rt.time.soft = -1
            #rt.time.hard = -1
        }
        flags = [ ifexists nofail ]
    }
    { name = libpipewire-module-protocol-native }
    { name = libpipewire-module-client-node }
    { name = libpipewire-module-adapter }

    { name = libpipewire-module-session-manager }

        { name = libpipewire-module-filter-chain
        args = {
            node.description = "${process.argv[3]} Equalizer Sink"
            media.name       = "${process.argv[3]} Equalizer Sink"
            filter.graph = {
                nodes = [
                    {
                        type = builtin
                        name = eq_preamp
                        label = bq_highshelf
                        control = { "Freq" = 0 "Q" = 5.0 "Gain" = ${ eq["input-gain"].toFixed(3) } }
                    }
${Object.values(bands)
  .map((val, i) => {
    let bandtype = "";
    if (val.type === "Bell") {
      bandtype = "bq_peaking";
    } else if (val.type === "Lo-shelf") {
      bandtype = "bq_lowshelf";
    } else {
      throw new Error("UNKNOWN FILTER TYPE");
    }

    const freq = val.frequency.toFixed(3);
    const q = val.q.toFixed(3);
    const gain = val.gain.toFixed(3);

    return `                    {
                        type = builtin
                        name = eq_band_${i+1}
                        label = ${bandtype}
                        control = { "Freq" = ${freq} "Q" = ${q} "Gain" = ${gain} }
                    }`;
  })
  .join("\n")}
                ]
                inputs = [ "eq_preamp:In" ]
                links = [
${Object.values(bands)
  .map((_, i) => {
    return i === 0
      ? `${" ".repeat(20)}{ output = "eq_preamp:Out" input = "eq_band_1:In" }`
      : `${" ".repeat(20)}{ output = "eq_band_${i}:Out" input = "eq_band_${i+1}:In" }`
  })
  .join("\n")}
                ]
                outputs = [ "eq_band_${Object.values(bands).length}:Out" ]
            }
            audio.channels = 2
            audio.position = [ FL FR ]
            capture.props = {
                node.name   = "effect_input.eq"
                media.class = Audio/Sink
            }
            playback.props = {
                node.name   = "effect_output.eq"
                node.passive = true
            }
        }
    }
]
`
);
