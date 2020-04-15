%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input From $ 1 To $ 3 Weight;
datalines;
A X 5
A Y 7
A Z 6
B X 2
B Y 9
B Z 4
;

%hz_gg_sankey(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_sankey.html"
);