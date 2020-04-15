%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Task $ 1-8 HoursPerDay;
datalines;
Work     11
Eat       2
Commute   2
Watch TV  2
Sleep     7
;

%hz_gg_pie(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_pie.html"
);