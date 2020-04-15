/* Example from
https://documentation.sas.com/?docsetId=proc&docsetTarget=n0ihaaujg5q5hen1ag5nl7wpvuvf.htm&docsetVersion=9.4&locale=en
*/
%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data piesales;
   input Bakery $ 1-8 Flavor $ 10-19 Year PiesSold;
   datalines;
Samford  apple      2005  234
Samford  apple      2006  288
Samford  blueberry  2005  103
Samford  blueberry  2006  143
Samford  cherry     2005  173
Samford  cherry     2006  195
Samford  rhubarb    2005   26
Samford  rhubarb    2006   28
Oak      apple      2005  219
Oak      apple      2006  371
Oak      blueberry  2005  174
Oak      blueberry  2006  206
Oak      cherry     2005  226
Oak      cherry     2006  311
Oak      rhubarb    2005   51
Oak      rhubarb    2006   56
Clyde    apple      2005  213
Clyde    apple      2006  415
Clyde    blueberry  2005  177
Clyde    blueberry  2006  201
Clyde    cherry     2005  230
Clyde    cherry     2006  328
Clyde    rhubarb    2005   60
Clyde    rhubarb    2006   59
;
  
proc sql;
  create table temp as 
  select 
    Bakery,
    Flavor,
    SUM(PiesSold) AS TotalPiesSold
  from piesales
  group by 
    Bakery,
    Flavor
  order by
    Bakery,
    Flavor
  ;
quit;

proc transpose data=temp out=salesbybakery(drop=_name_);
  by Bakery;
  id Flavor;
  var TotalPiesSold;
run;


%hz_gg_column(
  intable = salesbybakery, 
  outfile = "&hz_loc./examples/hz_gg_column_piesales_grouped.html"
);
