const formatNode = (node, depth) => {
  let str = " ".repeat(depth * 4) + "{\n";
  Object.entries(node)
    .filter(([key]) => !key.startsWith("__"))
    .forEach(([key, val]) => {
      if (key === undefined || val === undefined) {
        throw new Error("detected undefined key/value somewhere");
      }

      const keyFormat =
        key.includes(" ") || ["Freq", "Q", "Gain", "Function"].includes(key)
          ? `"${key}"`
          : `${key}`;
      const valFormat =
        typeof val === "object"
          ? formatNode(val, depth + 1).trimStart()
          : typeof val === "number"
          ? val.toFixed(5)
          : `${val}`;
      str += " ".repeat((depth + 1) * 4) + `${keyFormat} = ${valFormat}\n`;
    });

  str += " ".repeat(depth * 4) + "}";
  return str;
};

const eqToNodes = (eq) => {
  let nodes = [
    {
      __input_name: "In",
      __output_name: "Out",
      type: "builtin",
      name: "eq_preamp",
      label: "bq_highshelf",
      control: {
        Freq: 0,
        Q: 1.0,
        Gain: eq.preamp,
      },
    },
  ];

  nodes = nodes.concat(
    eq.bands.map((band, i) => {
      return {
        __input_name: "In",
        __output_name: "Out",
        type: "builtin",
        name: `eq_band_${i + 1}`,
        label: `bq_${band.type}`,
        control: {
          Freq: band.freq,
          Q: band.Q,
          Gain: band.gain,
        },
      };
    })
  );

  return nodes;
};

const noisegateToNodes = (ng) => {
  return [
    {
      __input_name: "Input",
      __output_name: "Output",
      type: "ladspa",
      plugin: "/usr/lib/ladspa/tap_dynamics_m.so",
      name: "dynamics_m",
      label: "tap_dynamics_m",
      control: {
        "Attack [ms]": ng.attack,
        "Release [ms]": ng.release,
        "Offset Gain [dB]": ng.offset_gain,
        "Makeup Gain [dB]": ng.makeup_gain,
        Function: 11,
      },
    },
  ];
};

exports.genPipewire = (contents) => {
  const nodes = contents.effects.flatMap((e) => {
    if (e.type === "eq") {
      return eqToNodes(e.settings);
    } else if (e.type === "noisegate") {
      return noisegateToNodes(e.settings);
    }
  });

  const input = `${nodes[0].name}:${nodes[0].__input_name}`;
  const output = `${nodes[nodes.length - 1].name}:${
    nodes[nodes.length - 1].__output_name
  }`;

  const cap_pb =
    contents.type === "sink"
      ? `            audio.channels = 2
            capture.props = {
                node.name   = "effect_input.${contents.pw_name}"
                media.class = Audio/Sink
            }
            playback.props = {
                node.name   = "effect_output.${contents.pw_name}"
                node.passive = true
            }`
      : `            capture.props = {
                node.name = "effect_input.${contents.pw_name}"
                node.passive = true
            }
            playback.props = {
                node.name = "effect_output.${contents.pw_name}"
                media.class = Audio/Source
            }`;

  const links = [];
  for (let i = 1; i < nodes.length; i++) {
    const prev_name = nodes[i - 1].name;
    const prev_output = nodes[i - 1].__output_name;
    const curr_name = nodes[i].name;
    const curr_input = nodes[i].__input_name;
    links.push(
      `{ output = "${prev_name}:${prev_output}" input = "${curr_name}:${curr_input}" }`
    );
  }

  return `###
### Generated automatically by json_to_pipewire.js
###
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

    { name = libpipewire-module-filter-chain
        args = {
            node.description = "${contents.name} ${contents.type}"
            media.name       = "${contents.name} ${contents.type}"
            filter.graph = {
                nodes = [
${nodes.map((node) => formatNode(node, 5)).join("\n")}
                ]
                inputs = [ "${input}" ]
                links = [
${links.map((l) => " ".repeat(20) + l).join("\n")}
                ]
                outputs = [ "${output}" ]
            }
            audio.position = [ ${contents.output} ]
${cap_pb}
        }
    }
]
`;
};
