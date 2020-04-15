/* LICENSE
BSD 3-Clause License

Copyright (c) 2020, Naushad Pasha Puliyambalath
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
*/

%macro hz_gg_put(var, type);
    put '  "' "&var." '":'@; 
    
    %if &type. = 2 %then %do; 
      if missing(&var.) then put 'null'@;
      else put '"' &var. +(-1) '"'@;
    %end;
    %else %do;
      if missing(&var.) then put 'NaN';
      else put &var. BEST12.@;
    %end;
%mend;

%macro hz_gg_material_bar( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;

  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
  
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    put "  <title>Haziris: Google Material Bar Chart</title>";
    put "</head>";
    put "<script src='https://www.gstatic.com/charts/loader.js'></script>";
    put "<script src='https://code.jquery.com/jquery-3.4.1.min.js'></script>";
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleMaterialBarChart( df, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['bar']})";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put "      ";
    put "      google.charts.setOnLoadCallback( chart )";
    put "      let columns = Object.keys(df[0])";
    put "      let colLables = columns.map(";
    put "         c=>(";
    put "             c=='__hz__style'      ?  {role:'style'}";
    put "           : c=='__hz__annotation' ? {role:'annotation'}";
    put "           : c=='__hz__tooltip'    ? {role:'tooltip'}";
    put "              : c";
    put "            )";
    put "      )";
    put ;
    put "      let data = [colLables].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "      function chart(){";
    put "        let chart = new google.charts.Bar(document.getElementById('chart-div'))";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "      }";
    put "  }";
    put "  googleMaterialBarChart(";  
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put "      )";
    put "  </script>";
    put " </div>";
    put "</body>";
    put "</html>";
    
    stop;
  run;

%mend;

%macro hz_gg_area( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put '<!DOCTYPE html>';
    put '<html lang="en">';
    put ;
    put '<head>';
    put '  <meta charset="utf-8">';
    put '  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">';
    put '  <meta http-equiv="x-ua-compatible" content="ie=edge">';
    put '  <title>Haziris: Google Area Chart</title>';
    put '</head>';
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put '<body>';
    put ' <div id="chart-div"></div>';
    put '  <script>';
    put '    function googleAreaChart( df, options ){';
    put ;
    put '      google.charts.load("current", {"packages": ["corechart"]})';
    put ;
    put '      $("#chart-div")';
    put '          .width(  0.95*window.innerWidth  )';
    put '          .height( 0.95*window.innerHeight )';
    put '      ';
    put '      google.charts.setOnLoadCallback( chart )';
    put "         let columns = Object.keys(df[0])";
    put "          let colLables = columns.map(";
    put "            c=>(";
    put "                c=='__hz__style'      ?  {role:'style'}";
    put "           : c=='__hz__annotation' ? {role:'annotation'}";
    put "           : c=='__hz__tooltip'    ? {role:'tooltip'}";
    put "           : c";
    put "         )";
    put "       )";
    put ;
    put "      let data = [colLables].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put '      function chart(){';
    put '        let chart = new google.visualization.AreaChart(document.getElementById("chart-div"));';
    put ;
    put '        chart.draw( google.visualization.arrayToDataTable( data ), options );';
    put '      }';
    put '  }';
    put '  googleAreaChart(';
      
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_bar( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put '<!DOCTYPE html>';
    put '<html lang="en">';
    put ;
    put '<head>';
    put '  <meta charset="utf-8">';
    put '  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">';
    put '  <meta http-equiv="x-ua-compatible" content="ie=edge">';
    put '  <title>Haziris: Google Bar Chart</title>';
    put '</head>';
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put '<body>';
    put ' <div id="chart-div"></div>';
    put '  <script>';
    put '    function googleBarChart( df, options ){';
    put ;
    put '      google.charts.load("current", {"packages": ["corechart"]})';
    put ;
    put '      $("#chart-div")';
    put '          .width(  0.95*window.innerWidth  )';
    put '          .height( 0.95*window.innerHeight )';
    put '      ';
    put '      google.charts.setOnLoadCallback( chart )';
    put "         let columns = Object.keys(df[0])";
    put "       let colLables = columns.map(";
    put "         c=>(";
    put "                c=='__hz__style'      ?  {role:'style'}";
    put "           : c=='__hz__annotation' ? {role:'annotation'}";
    put "           : c=='__hz__tooltip'    ? {role:'tooltip'}";
    put "              : c";
    put "            )";
    put "          )";
    put ;
    put "      let data = [colLables].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put '      function chart(){';
    put '        let chart = new google.visualization.BarChart(document.getElementById("chart-div"));';
    put ;
    put '        chart.draw( google.visualization.arrayToDataTable( data ), options );';
    put '      }';
    put '  }';
    put '  googleBarChart(';
      
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_bubble( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put '<!DOCTYPE html>';
    put '<html lang="en">';
    put ;
    put '<head>';
    put '  <meta charset="utf-8">';
    put '  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">';
    put '  <meta http-equiv="x-ua-compatible" content="ie=edge">';
    put '  <title>Haziris: Google Bubble Chart</title>';
    put '</head>';
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put '<body>';
    put ' <div id="chart-div"></div>';
    put '  <script>';
    put '    function googleBubbleChart( df, options ){';
    put ;
    put '      google.charts.load("current", {"packages": ["corechart"]})';
    put ;
    put '      $("#chart-div")';
    put '          .width(  0.95*window.innerWidth  )';
    put '          .height( 0.95*window.innerHeight )';
    put '      ';
    put '      google.charts.setOnLoadCallback( chart )';
    put ;
    put "      let columns = Object.keys(df[0])";
    put ;
    put "      let data = [columns].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put '      function chart(){';
    put '        let chart = new google.visualization.BubbleChart(document.getElementById("chart-div"));';
    put ;
    put '        chart.draw( google.visualization.arrayToDataTable( data ), options );';
    put '      }';
    put '  }';
    put '  googleBubbleChart(';
      
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_calendar( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    put "  <title>Haziris: Google Calendar Chart</title>";
    put "</head>";
    put "<script src='https://www.gstatic.com/charts/loader.js'></script>";
    put "<script src='https://code.jquery.com/jquery-3.4.1.min.js'></script>";
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleCalendarChart( df, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['calendar']})";
    put ;
    put "       let col      = Object.keys(df[0]),";
    put "           data     = [col].concat(df.map( row => ( [ new Date(row[col[0]]+' 00:00:00'), row[col[1]] ] ) )),";
    put "          dates    = data.filter((_,i) => i>0 ).map( r => r[0].getFullYear() ),";
    put "          numYears = Math.max(...dates) - Math.min(...dates) + 1,";
    put "          width    = 0.95 * window.innerWidth,";
    put "          cellSize = width / 59,";
    put "          height   = (7 * cellSize + 56)* numYears;";
    put ;
    put "      options.calendar = options.calendar || {};";
    put "      options.calendar.cellSize = cellSize ;";
    put ;
    put "      $('#chart-div')";
    put "          .width(  width  )";
    put "          .height( height )";
    put ;
    put "      google.charts.setOnLoadCallback( chart )";
    put ;
    put "      function chart(){";
    put "        let chart = new google.visualization.Calendar(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "      }";
    put "  }";
    put "  googleCalendarChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;

%macro hz_gg_candlestick( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    put "  <title>Haziris: Google Candlestick Chart</title>";
    put "</head>";
    put "<script src='https://www.gstatic.com/charts/loader.js'></script>";
    put "<script src='https://code.jquery.com/jquery-3.4.1.min.js'></script>";
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleCandlestickChart( df, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['corechart']})";
    put ;
    put '      $("#chart-div")';
    put '          .width(  0.95*window.innerWidth  )';
    put '          .height( 0.95*window.innerHeight )';
    put ;
    put "      google.charts.setOnLoadCallback( chart )";
    put "         let columns = Object.keys(df[0])";
    put "          let colLables = columns.map(";
    put "         c=>(";
    put "             c=='__hz__style'      ?  {role:'style'}";
    put "           : c=='__hz__annotation' ? {role:'annotation'}";
    put "           : c=='__hz__tooltip'    ? {role:'tooltip'}";
    put "           : c";
    put "         )";
    put "       )";
    put ;
    put "      let data = [colLables].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "      function chart(){";
    put "        let chart = new google.visualization.CandlestickChart(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data, true ), options );";
    put "      }";
    put "  }";
    put "  googleCandlestickChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_column( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    put "  <title>Haziris: Google Column Chart</title>";
    put "</head>";
    put "<script src='https://www.gstatic.com/charts/loader.js'></script>";
    put "<script src='https://code.jquery.com/jquery-3.4.1.min.js'></script>";
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "  function googleColumnChart( df, options ){";
    put ;
    put "    google.charts.load('current', {'packages': ['corechart']})";
    put ;
    put "    $('#chart-div')";
    put "        .width(  0.95*window.innerWidth  )";
    put "        .height( 0.95*window.innerHeight )";
    put ;
    put "    google.charts.setOnLoadCallback( chart )";
    put "       let columns = Object.keys(df[0])";
    put "     let colLables = columns.map(";
    put "       c=>(";
    put "           c=='__hz__style'      ?  {role:'style'}";
    put "         : c=='__hz__annotation' ? {role:'annotation'}";
    put "         : c=='__hz__tooltip' ? {role:'tooltip'}";
    put "         : c";
    put "       )";
    put "     )";
    put ;
    put "     let data = [colLables].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "    function chart(){";
    put "      let chart = new google.visualization.ColumnChart(document.getElementById('chart-div'));";
    put ;
    put "      chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "    }";
    put "  }";
    put "  googleColumnChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_gantt( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    put "  <title>Haziris: Google Gantt Chart</title>";
    put "</head>";
    put "<script src='https://www.gstatic.com/charts/loader.js'></script>";
    put "<script src='https://code.jquery.com/jquery-3.4.1.min.js'></script>";
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    
    put "  function googleGanttChart( df, options ){";
    put "    google.charts.load('current', {'packages': ['gantt']})";
    put ;
    put "    $('#chart-div')";
    put "        .width(  0.95*window.innerWidth  )";
    put "        .height( 0.95*window.innerHeight )";
    put ;
    put "    google.charts.setOnLoadCallback( chart )";
    put ;
    put "    function chart(){";
    put "      let mapRow = (r => ([";
    put "         r[ 'TaskID'          ],";
    put "         r[ 'TaskName'        ],";
    put "         r[ 'Resource'        ],";
    put "         r[ 'StartDate'       ] != null ? new Date(r['StartDate']) : null,";
    put "         r[ 'EndDate'         ] != null ? new Date(r['EndDate'  ]) : null,";
    put "         r[ 'Duration'        ],";
    put "         r[ 'PercentComplete' ],";
    put "         r[ 'Dependencies'    ]";
    put "      ]))";
    put ;
    put "      let ganttData = df.map( r => mapRow(r) )";
    put ;
    put "      let data =  new google.visualization.DataTable();";
    put ;
    put "      data.addColumn( 'string', 'Task ID'          );";
    put "      data.addColumn( 'string', 'Task Name'        );";
    put "      data.addColumn( 'string', 'Resource'         );";
    put "      data.addColumn( 'date'  , 'Start Date'       );";
    put "      data.addColumn( 'date'  , 'End Date'         );";
    put "      data.addColumn( 'number', 'Duration'         );";
    put "      data.addColumn( 'number', 'Percent Complete' );";
    put "      data.addColumn( 'string', 'Dependencies'     );";
    put ;
    put "      data.addRows(ganttData)";
    put ;
    put "      let chart = new google.visualization.Gantt(document.getElementById('chart-div'));";
    put ;
    put "      chart.draw( data, options );";
    put "    }";
    put "}";
    put "googleGanttChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_geo( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";

    put "  <title>Haziris: Google Geo Chart</title>";
    put "</head>";
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleGeoChart( df, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['geochart']})";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put ;
    put "      google.charts.setOnLoadCallback( chart )";
    put "         let columns = Object.keys(df[0])";
    put ;
    put "       let data = [columns].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "      function chart(){";
    put "        let chart = new google.visualization.GeoChart(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "      }";
    put "  }";
    put "  googleGeoChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_line( intable=, outfile=, options=, intervals=[] );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";

    put "  <title>Haziris: Google Line Chart</title>";
    put "</head>";
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleLineChart( df, intervals, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['corechart']})";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put ;
    put "      google.charts.setOnLoadCallback( chart )";
    put "         let columns = Object.keys(df[0])";
    put ;
    put "       dfarray = [columns].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "      function chart(){";
    put "        let data = new google.visualization.DataTable();";
    put ;
    put "        dfarray[0].forEach(function(col,i){  ";
    put "          if(i==0) data.addColumn(typeof dfarray[1][0] === 'string' ? 'string' : 'number', col)";
    put "          else if(intervals.includes(col)) data.addColumn({id:col,type: 'number',role: 'interval'})";
    put "          else data.addColumn('number', col)";
    put "        })";
    put ;
    put "        data.addRows(dfarray.slice(1))";
    put ;
    put "        let chart = new google.visualization.LineChart(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( data, options );";
    put "      }";
    put "    }";
    put ;
    put "    googleLineChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    put ",&intervals.";
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_material_line( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    
    put "  <title>Haziris: Google Material Line Chart</title>";
    put "</head>";
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleMaterialLineChart( df, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['line']})";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put "      ";
    put "      google.charts.setOnLoadCallback( chart )";
    put ;
    put "         let columns = Object.keys(df[0])";
    put ;
    put "       let data = [columns].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "      function chart(){";
    put "        let chart = new google.charts.Line(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "      }";
    put "  }";
    put "  googleMaterialLineChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_material_scatter( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    
    put "  <title>Haziris: Google Material Scatter Chart</title>";
    put "</head>";
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleMaterialScatterChart( df, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['scatter']})";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put ;
    put "      google.charts.setOnLoadCallback( chart )";
    put "         let columns = Object.keys(df[0])";
    put "       let colLables = columns.map(";
    put "         c=>(";
    put "             c=='__hz__style'      ?  {role:'style'}";
    put "           : c=='__hz__annotation' ? {role:'annotation'}";
    put "           : c=='__hz__tooltip'    ? {role:'tooltip'}";
    put "           : c";
    put "         )";
    put "       )";
    put ;
    put "      let data = [colLables].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "      function chart(){";
    put "        let chart = new google.charts.Scatter(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "      }";
    put "  }";
    put "  googleMaterialScatterChart(";

    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_pie( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    
    put "  <title>Haziris: Google Pie Chart</title>";
    put "</head>";
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googlePieChart( df, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['corechart']})";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put "      ";
    put "      google.charts.setOnLoadCallback( chart )";
    put "         let columns = Object.keys(df[0])";
    put "       let colLables = columns.map(";
    put "         c=>(";
    put "             c=='__hz__style'      ?  {role:'style'}";
    put "           : c=='__hz__annotation' ? {role:'annotation'}";
    put "           : c=='__hz__tooltip'    ? {role:'tooltip'}";
    put "           : c";
    put "         )";
    put "       )";
    put ;
    put "      let data = [colLables].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "      function chart(){";
    put "        let chart = new google.visualization.PieChart(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "      }";
    put "  }";
    put "  googlePieChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_sankey( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    
    put "  <title>Haziris: Google Sankey Chart</title>";
    put "</head>";
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleSankeyChart( df, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['sankey']})";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put "      ";
    put "      google.charts.setOnLoadCallback( chart )";
    put ;
    put "         let columns = Object.keys(df[0])";
    put ;
    put "       let data = [columns].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "      function chart(){";
    put "        let chart = new google.visualization.Sankey(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "      }";
    put "  }";
    put "  googleSankeyChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;



%macro hz_gg_scatter( intable=, outfile=, options=, previous= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";

    put "  <title>Haziris: Google Scatter Chart</title>";
    put "</head>";
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleScatterChart(current, options, previous){";
    put ;
    put "      google.charts.load('current', {'packages': ['corechart']})";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put ;
    put "      google.charts.setOnLoadCallback( arguments.length == 2 ? chart : diffChart )";
    put ;
    put "      function chart(){";
    put "           let columns = Object.keys(current[0])";
    put "         let data = [columns].concat(current.map( row => ( columns.map( c => row[c] )) ))";
    put "        let datag = google.visualization.arrayToDataTable(data);";
    put "        let chart = new google.visualization.ScatterChart(document.getElementById('chart-div'));";
    put "        chart.draw(datag, options);";
    put "      }";
    put ;
    put "      function diffChart(){";
    put "        let chart = new google.visualization.ScatterChart(document.getElementById('chart-div'));";
    put ;
    put "           let columns = Object.keys(current[0])";
    put "         let data = [columns].concat(current.map( row => ( columns.map( c => row[c] )) ))";
    put "        let datacurr = google.visualization.arrayToDataTable(data);";
    put ;
    put "           columns = Object.keys(previous[0])";
    put "         data = [columns].concat(previous.map( row => ( columns.map( c => row[c] )) ))";
    put "        let dataprev = google.visualization.arrayToDataTable(data);";
    put ;
    put "        let diffData = chart.computeDiff(dataprev, datacurr);";
    put "        chart.draw(diffData, options);";
    put "      }";
    put "  }";
    put ;
    put "  googleScatterChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    %if not %sysevalf(%superq(previous)=,boolean) %then %do;
      put ",[";
      do until(__hz__last_prev);
        set &previous. end=__hz__last_prev;   

        put '{';
        %do i = 1 %to &nvar.;
          %hz_gg_put( &&var&i, &&type&i );
          %if &i < &nvar. %then %do;
            put ",";
          %end;
          %else %do;
            put "}"@;
          %end;
        %end;
    
        if not __hz__last_prev then do;
          put ',';
        end;      
        else do;
          put ']';
        end;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_stepped_area( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    
    put "  <title>Haziris: Google Stepped Area Chart</title>";
    put "</head>";
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleSteppedAreaChart( df, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['corechart']})";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put "      ";
    put "      google.charts.setOnLoadCallback( chart )";
    put "         let columns = Object.keys(df[0])";
    put "       let colLables = columns.map(";
    put "         c=>(";
    put "             c=='__hz__style'      ?  {role:'style'}";
    put "           : c=='__hz__annotation' ? {role:'annotation'}";
    put "           : c=='__hz__tooltip'    ? {role:'tooltip'}";
    put "           : c";
    put "         )";
    put "       )";
    put ;
    put "      let data = [colLables].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "      function chart(){";
    put "        let chart = new google.visualization.SteppedAreaChart(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "      }";
    put "  }";
    put "  googleSteppedAreaChart(";
    
    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_timeline( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";
    
    put "  <title>Haziris: Google Timeline Chart</title>";
    put "</head>";
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleTimelineChart( df, options ){";
    put ;
    put "     let columns = Object.keys(df[0])";
    put "      let data = [columns].concat(df.map( row => ( columns.map( ";
    put "        c => (c=='Start' || c=='End' ? new Date(row[c]) : row[c] ))) ))";        
    put ;
    put "      google.charts.load('current', {'packages': ['timeline']})";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put ;
    put "      google.charts.setOnLoadCallback( chart )";
    put ;
    put "      function chart(){";
    put "        let chart = new google.visualization.Timeline(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "      }";
    put "  }";
    put "  googleTimelineChart(";

    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;


%macro hz_gg_treemap( intable=, outfile=, options= );
  proc contents data=&intable. noprint out=__hz__cont;

  proc sort data=__hz__cont; 
    by varnum;
    
  /* Create Macro variables for column names. */
  data _null_;
    set __hz__cont end=eof;
    
    call symputx( compress( "var" ||put( _n_, best10. ) ), name, 'L' );
    call symputx( compress( "type"||put( _n_, best10. ) ), type, 'L' );
    
    if eof then do; 
      call symputx( "nvar" , put( _N_ , best10. ), 'L' ); 
    end;
  run;
  
  proc datasets library=work nolist;
    delete __hz__cont;
  run;
  
  data _null_;
    file &outfile. PS=32767;
    
    put "<!DOCTYPE html>";
    put "<html lang='en'>";
    put ;
    put "<head>";
    put "  <meta charset='utf-8'>";
    put "  <meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>";
    put "  <meta http-equiv='x-ua-compatible' content='ie=edge'>";

    put "  <title>Haziris: Google Timelines Chart</title>";
    put "</head>";
    put '<script src="https://www.gstatic.com/charts/loader.js"></script>';
    put '<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>';
    put ;
    put "<body>";
    put " <div id='chart-div'></div>";
    put "  <script>";
    put "    function googleTreemapChart( df, options ){";
    put ;
    put "      google.charts.load('current', {'packages': ['treemap']})";
    put ;
    put "      let columns = Object.keys(df[0])";
    put ;
    put "      let data = [columns].concat(df.map( row => ( columns.map( c => row[c] )) ))";
    put ;
    put "      data = data.map( d => ( d.map( x=> x !== x ? null : x ) ) )";
    put ;
    put "      $('#chart-div')";
    put "          .width(  0.95*window.innerWidth  )";
    put "          .height( 0.95*window.innerHeight )";
    put "      ";
    put "      google.charts.setOnLoadCallback( chart )";
    put ;
    put "      function chart(){";
    put "        let chart = new google.visualization.TreeMap(document.getElementById('chart-div'));";
    put ;
    put "        chart.draw( google.visualization.arrayToDataTable( data ), options );";
    put "      }";
    put "    }";
    put "    googleTreemapChart(";

    put '['@;
    
    do until(__hz__last_data);
      set &intable. end=__hz__last_data;   

      put '{';
      %do i = 1 %to &nvar.;
        %hz_gg_put( &&var&i, &&type&i );
        %if &i < &nvar. %then %do;
          put ",";
        %end;
        %else %do;
          put "}"@;
        %end;
      %end;
    
      if not __hz__last_data then do;
        put ',';
      end;      
      else do;
        put ']';
      end;
    end;
    
    %if %sysevalf(%superq(options)=,boolean) %then %do;
      put ",{}";
    %end;
    %else %do;
      put ",";
      do until(__hz__last_option);
        set &options.(rename=(o=__hz__option)) end=__hz__last_option;  
        put __hz__option;
      end;
    %end;
    
    put '  )';
    put '  </script>';
    put ' </div>';
    put '</body>';
    put '</html>';
    
    stop;
  run;

%mend;
