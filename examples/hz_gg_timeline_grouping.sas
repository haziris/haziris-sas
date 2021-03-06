%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Position $ 1-18 Name $ 20-36 Start $ 38-56 End $ 58-76;
datalines;
President          George Washington 1789-04-30 00:00:00 1797-03-04 00:00:00
President          John Adams        1797-03-04 00:00:00 1801-03-04 00:00:00
President          Thomas Jefferson  1801-03-04 00:00:00 1809-03-04 00:00:00
Vice President     John Adams        1789-04-21 00:00:00 1797-03-04 00:00:00
Vice President     Thomas Jefferson  1797-03-04 00:00:00 1801-03-04 00:00:00
Vice President     Aaron Burr        1801-03-04 00:00:00 1805-03-04 00:00:00
Vice President     George Clinton    1805-03-04 00:00:00 1812-04-20 00:00:00
Secretary of State John Jay          1789-09-26 00:00:00 1790-03-22 00:00:00
Secretary of State Thomas Jefferson  1790-03-22 00:00:00 1793-12-31 00:00:00
Secretary of State Edmund Randolph   1794-01-02 00:00:00 1795-08-20 00:00:00
Secretary of State Timothy Pickering 1795-08-20 00:00:00 1800-05-12 00:00:00
Secretary of State Charles Lee       1800-05-13 00:00:00 1800-06-05 00:00:00
Secretary of State John Marshall     1800-06-13 00:00:00 1801-03-04 00:00:00
Secretary of State Levi Lincoln      1801-03-05 00:00:00 1801-05-01 00:00:00
Secretary of State James Madison     1801-05-02 00:00:00 1809-03-03 00:00:00
;

data options;
  o = "{timeline: {showRowLabels: false}}";
output;

%hz_gg_timeline(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_timeline_grouping.html",
  options = options
);