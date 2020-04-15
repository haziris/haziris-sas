%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Day $3. min start end max;
datalines;
Mon 20 28 38 45
Tue 31 38 55 66
Wed 50 55 77 80
Thu 77 77 66 50
Fri 68 66 22 15
;

data options;
  o = "{legend:'none'}"; output;
run;

%hz_gg_candlestick(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_candlestick.html",
  options = options
);