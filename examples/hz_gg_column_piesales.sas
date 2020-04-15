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
  
proc sort data=piesales;
  by Flavor;
  
data temp(keep=Flavor TotalPiesSold __hz__style __hz__annotation __hz__tooltip);
   set piesales;
   by Flavor;
   if First.Flavor then TotalPiesSold=0;
   TotalPiesSold + PiesSold;
   
   /* Special column __hz__style sets the color of bars*/
   length __hz__style $6;
   select(Flavor);
     when('apple'    ) __hz__style = 'orange';
     when('blueberry') __hz__style = 'blue';
     when('cherry'   ) __hz__style = 'yellow';
     when('rhubarb'  ) __hz__style = 'red';
   end;
   
   /* Special column __hz__annotation sets the annotation of bars*/
   __hz__annotation = TotalPiesSold;
   
   /* Special column __hz__tooltip sets the tooltip of bars*/
   __hz__tooltip = cats("Total Pies Sold \n ", put(TotalPiesSold, best.));
   
   if last.Flavor;
run;


data options;
  o = "{legend:'none'}"; output;
run;

%hz_gg_column(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_column_piesales.html",
  options = options
);
