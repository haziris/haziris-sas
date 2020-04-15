%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input ID $1. X Y Temperature;
datalines;
  80 167 120
  79 136 130
  78 184  50
  72 278 230
  81 200 210
  72 170 100
  68 477  80
;

DATA options;
  o = "{colorAxis: {colors: ['yellow', 'red']}}";  output;
RUN;

%hz_gg_bubble(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_bubble_temperature.html",
  options = options
);



