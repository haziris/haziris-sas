%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Date $10. Attendance;
datalines;
2012-03-13 37032
2012-03-14 38024
2012-03-15 38024
2012-03-16 38108
2012-03-17 38229
2013-06-18 37967
2013-06-20 36770
2013-06-21 37839
2013-06-30 37359
;

%hz_gg_calendar(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_calendar.html"
);