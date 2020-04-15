%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Age Weight;
datalines;
 8 12
 4  5
11 14
 4  5
 3  3
 6  7
;

%hz_gg_material_scatter(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_material_scatter.html"
);