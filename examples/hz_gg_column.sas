%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Element $8. Density;
datalines;
Copper    8.94
Silver   10.49
Gold     19.30
Platinum 21.45
;

  
data options;
  o = "{legend:'none'}"; output;
run;

%hz_gg_column(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_column.html",
  options = options
);