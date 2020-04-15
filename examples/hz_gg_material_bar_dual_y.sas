%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Galaxy $ 1-20 Distance Brightness;
datalines;
Canis Major Dwarf     8000 23.3
Sagittarius Dwarf    24000  4.5
Ursa Major II Dwarf  30000 14.3
Lg. Magellanic Cloud 50000  0.9
Bootes I             60000 13.1
;

data options;
  length o $100;
  o = "{";                                                             output;
  o = "  chart: {";                                                    output;
  o = "    title: 'Nearby galaxies',";                                 output;
  o = "    subtitle: 'distance on the bottom, brightness on the top'"; output;
  o = "  },";                                                          output;
  o = "  bars: 'horizontal', ";                                        output;
  o = "  series: {";                                                   output;
  o = "    0: { axis: 'distance' }, ";                                 output;
  o = "    1: { axis: 'brightness' }";                                 output;
  o = "  },";                                                          output;
  o = "  axes: {";                                                     output;
  o = "    x: {";                                                      output;
  o = "      distance: {label: 'parsecs'}, ";                          output;
  o = "      brightness: {side: 'top', label: 'apparent magnitude'} "; output;
  o = "    }";                                                         output;
  o = "  }";                                                           output;
  o = "}";                                                            output;
run;

%hz_gg_material_bar(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_material_bar_dual_y.html",
  options = options
);




