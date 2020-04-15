%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp(keep=StockDate open);
  length stockDate $10;
  set sashelp.stocks(where=(stock='IBM') keep=Stock Date Open);
  stockDate = put(Date, YYMMDD10.);
run;

%hz_gg_calendar(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_calendar_stocks.html"
);