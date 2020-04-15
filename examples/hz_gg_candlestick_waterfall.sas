%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Day $3. min start end max;
datalines;
Mon 28 28 38 38
Tue 38 38 55 55
Wed 55 55 77 77
Thu 77 77 66 66
Fri 66 66 22 22
;

data options;
  length o $100;
  o = "{";                                                       output;
  o = "  legend:'none',";                                        output;
  o = "  bar: { groupWidth: '100%' }, ";                         output;
  o = "  candlestick: {";                                        output;
  o = "    fallingColor: { strokeWidth: 0, fill: '#a52714' }, "; output;
  o = "    risingColor: { strokeWidth: 0, fill: '#0f9d58' } ";   output;
  o = "  }";                                                     output;
  o = "}";                                                       output;
run;


%hz_gg_candlestick(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_candlestick_waterfall.html",
  options = options
);