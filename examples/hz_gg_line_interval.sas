%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input name $1 s1 s2 s3 s4 s5 s6 s7;
datalines;
a 100  90 110  85  96 104 120
b 120  95 130  90 113 124 140
c 130 105 140 100 117 133 139
d  90  85  95  85  88  92  95
e  70  74  63  67  69  70  72
f  30  39  22  21  28  34  40
g  80  77  83  70  77  85  90
h 100  90 110  85  95 102 110
;

data options;
  o = "{'curveType':'function'}"; output;
run;

%hz_gg_line(
  intable   = temp, 
  outfile   = "&hz_loc./examples/hz_gg_line_interval.html",
  options   = options,
  intervals = %quote(['s2', 's3', 's4', 's5', 's6', 's7'])
);