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


data options;
  o = "{";                                                       output;
  o = "  title: 'Age vs. Weight comparison',";                   output;
  o = "  hAxis: {title: 'Age'   , minValue: 0, maxValue: 15},";  output;
  o = "  vAxis: {title: 'Weight', minValue: 0, maxValue: 15},";  output;
  o = "  legend: 'none'";                                        output;
  o = "}";                                                       output;
run;

%hz_gg_scatter(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_scatter.html",
  options = options
);