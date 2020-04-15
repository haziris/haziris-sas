%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  length StartDate EndDate $19;
  input TaskID    $  1-10 
        TaskName  $ 12-28 
        Resource  $ 30-35 
        StartDate $ 37-46 
        EndDate   $ 48-57 
        PercentComplete;
  
  StartDate = trim(StartDate)||' 00:00:00';
  EndDate   = trim(EndDate)||' 00:00:00';
    
datalines;
2014Spring Spring 2014       spring 2014-03-23 2014-06-20 100
2014Summer Summer 2014       summer 2014-06-22 2014-09-20 100
2014Autumn Autumn 2014       autumn 2014-09-22 2014-12-20 100
2014Winter Winter 2014       winter 2014-12-22 2015-03-21 100
2015Spring Spring 2015       spring 2015-03-23 2015-06-20  50
2015Summer Summer 2015       summer 2015-06-22 2015-09-20   0
2015Autumn Autumn 2015       autumn 2015-09-22 2015-12-20   0
2015Winter Winter 2015       winter 2015-12-22 2016-03-21   0
Football   Football Season   sports 2014-09-05 2015-02-01 100
Baseball   Baseball Season   sports 2015-03-31 2015-10-20  14
Basketball Basketball Season sports 2014-10-29 2015-06-20  86
Hockey     Hockey Season     sports 2014-10-09 2015-06-21  89
;


%hz_gg_gantt(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_gantt_grouping.html"
);