%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  length StartDate EndDate $19;
  input TaskID $ TaskName $ 10-28 StartDate $ 30-39 Days PercentComplete Dependencies $48-65;
  
  EndDate   = put(input(StartDate, yymmdd10.) +Days, yymmdd10.)||' 00:00:00';
  StartDate = trim(StartDate)||' 00:00:00';
  
  Duration  = Days * 24 * 60 * 60 * 1000;
  
datalines;
Research Find sources        2015-01-01  4 100
Write    Write paper         2015-01-06  3  25 Research,Outline
Cite     Create bibliography 2015-01-06  1  20 Research
Complete Hand in paper       2015-01-09  1   0 Cite,Write
Outline  Outline paper       2015-01-05  1 100 Research
;


%hz_gg_gantt(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_gantt.html"
);