%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Genre $4. FantasySciFi Romance MysteryCrime;
datalines;
2010 10 24 28
2020 16 22 19
2030 28 23 29
;

data options;
  o = "{'colors': ['#FFD700', '#C0C0C0', '#8C7853']}"; output;
run;

%hz_gg_column(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_columnn_grouped.html",
  options = options
);