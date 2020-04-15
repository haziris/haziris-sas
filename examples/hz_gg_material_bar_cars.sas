%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

PROC FREQ DATA=SASHELP.CARS(where=(Make in ("Audi"))) noprint;
    TABLE Length / out=temp(keep=Length Count);
RUN;

/*Convert column Length to Character */
DATA Temp(drop=Length);
  /* Make  LengthOfCar the first column  */
  length LengthOfCar $3;
  set temp;
  LengthOfCar = put(Length, 3.);
RUN;

DATA options;
  length o $100;
  o = "{";                                            output;
  o = "  chart: {";                                   output;
  o = "    title: 'Cars Dataset',";                   output;
  o = "    subtitle: 'Frequency by Length of Audi',"; output;
  o = "  },";                                         output;  
  o = "  legend:{position:'none'},";                  output; 
  o = "  axes: {";                                    output;
  o = "    x: {0: { label: 'Length of Car'}},";       output;
  o = "    y: {0: { label: 'Frequency'}}";            output;
  o = "  }";                                          output; 
  o = "}";                                            output;  
RUN;
          
%hz_gg_material_bar(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_material_bar_cars.html",
  options = options
);

