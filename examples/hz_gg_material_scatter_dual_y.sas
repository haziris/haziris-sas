%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input StudentID HoursStudied FinalGrade @@;
datalines;
 0  0 67  1  1 88  2  2 77  3  3 93
 4  4 85  5  5 91  6  6 71  7  7 78
 8  8 93  9  9 80 10 10 82 11  0 75
12  5 80 13  3 90 14  1 72 15  5 75
16  6 68 17  7 98 18  3 82 19  9 94
20  2 79 21  2 95 22  2 86 23  3 67
24  4 60 25  2 80 26  6 92 27  2 81
28  8 79 29  9 83
;

data options;
  length o $100;
  o = "{";                                                 output;
  o = "  chart:{";                                         output;
  o = "    title:'Students Final Grades',";                output;
  o = "    subtitle: 'based on hours studied'";            output;
  o = "  },";                                              output;
  o = "  series: {";                                       output;
  o = "    0: {axis: 'HoursStudied'},";                    output;
  o = "    1: {axis: 'FinalGrade'}";                       output;
  o = "  },";                                              output;
  o = "  axes: {";                                         output;
  o = "    y: {";                                          output;
  o = "      'HoursStudied': {label: 'Hours Studied'},";   output;
  o = "      'FinalGrade': {label: 'Final Exam Grade'}";   output;
  o = "    }";                                             output;
  o = "  }";                                               output;
  o = "}";                                                 output;
run;


%hz_gg_material_scatter(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_material_scatter_dual_y.html",
  options = options
);