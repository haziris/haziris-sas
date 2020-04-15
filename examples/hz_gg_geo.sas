%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Country $14. Popularity;
datalines;
Germany       200
United States 300
Brazil        400
Canada        500
France        600
RU            700
;


%hz_gg_geo(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_geo.html"
);