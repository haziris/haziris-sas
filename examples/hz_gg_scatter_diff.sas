%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input X Medicine1 Medicine2 @@;
datalines;
22 . 12  7 . 40 14 . 31 37 . 30
18 . 17  9 . 20 26 . 36  5 . 13
36 . 30 35 . 15 24 . 12  7 . 31
10 . 12 24 . 40 37 . 18 32 . 21
35 .  7 31 . 30 21 . 42 12 . 10
10 13 . 40 12 . 28 29 . 32 22 .
31 37 . 38  5 .  6  4 . 21 36 .
22  8 . 21 22 . 28 17 . 12  5 .
37 30 . 41  7 . 41 27 . 15 20 .
14 36 . 42  3 . 14 37 . 15 36 .
;

data previous;
  input X Medicine1 Medicine2 @@;
datalines;
23 . 12  9 . 39 15 . 28 37 . 30
21 . 14 12 . 18 29 . 34  8 . 12
38 . 28 35 . 12 26 . 10 10 . 29
11 . 10 27 . 38 39 . 17 34 . 20
38 .  5 33 . 27 23 . 39 12 . 10
 8 15 . 39 15 . 27 31 . 30 24 .
31 39 . 35  6 .  5  5 . 19 39 .
22  8 . 19 23 . 27 20 . 11  6 .
34 33 . 38  8 . 39 29 . 13 23 .
13 36 . 39  6 . 14 37 . 13 39 .
;

%hz_gg_scatter(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_scatter_diff.html",
  previous = previous
);