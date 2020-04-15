%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input ID $3. LifeExpectancy FertilityRate Region $ 16-28 Population;
datalines;
CAN 80.66 1.67 North America  33739900
DEU 79.84 1.36 Europe         81902307
DNK 78.60 1.84 Europe          5523095
EGY 72.73 2.78 Middle East    79716203
GBR 80.05 2.00 Europe         61801570
IRN 72.49 1.70 Middle East    73137148
IRQ 68.09 4.77 Middle East    31090763
ISR 81.55 2.96 Middle East     7485600
RUS 68.60 1.54 Europe        141850000
USA 78.09 2.05 North America 307007000
;

DATA options;
  length o $100;
  o = "{";                                                                 output;
  o = "  title: 'Correlation between life expectancy, fertility rate ' +"; output;
  o = "    'and population of some world countries (2010)',";              output;
  o = "  hAxis: {title: 'Life Expectancy'},";                              output;
  o = "  vAxis: {title: 'Fertility Rate'},";                               output;
  o = "  bubble: {textStyle: {fontSize: 11}}";                             output;
  o = "}";                                                                 output;
RUN;

%hz_gg_bubble(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_bubble.html",
  options = options
);