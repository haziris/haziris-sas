%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Year $4. Sales Expenses Profit;
datalines;
2014 1000  400 200
2015 1170  460 250
2016  660 1120 300
2017 1030  540 350
;

%hz_gg_stepped_area(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_stepped_area.html" 
);