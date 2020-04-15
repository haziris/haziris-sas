%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input President $ 1-17 Start $ 19-37 End $ 39-57;
datalines;
George Washington 1789-03-30 00:00:00 1797-02-04 00:00:00
John Adams        1797-02-04 00:00:00 1801-02-04 00:00:00
Thomas Jefferson  1801-02-04 00:00:00 1809-02-04 00:00:00
;

data options;
  o = "{timeline: {showRowLabels: false}}";
output;

%hz_gg_timeline(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_timeline_no_label.html",
  options = options
);