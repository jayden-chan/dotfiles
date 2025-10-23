export const STANDARD_SINK_ZOOM = -36;

export type Band = {
  type: string;
  mode: string;
  slope: number;
  freq: number;
  Q: number;
  gain: number;
};

export type Device = {
  name: string;
  type: "source" | "sink";
  output: "FL FR" | "MONO";
  parent?: string;
  settings: {
    preamp: number;
    zoom?: number;
    bands: Band[];
  };
};
