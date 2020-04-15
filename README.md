# haziris
Visualizations for SAS

- [Wiki](https://github.com/haziris/haziris-sas/wiki)

## How to use
Clone this repository to a folder and include in SAS program like the example below for Google charts

### Google Charts
The macros in `haziris_google.sas` provides SAS code to create HTML files with Google Charts from SAS datasets.

For example the below program creates an HTML file `hz_gg_area.html` that contains Google Area chart for the `temp` dataset.

```sas
%let hz_loc = /folders/myfolders/haziris-sas;

%include "&hz_loc./macros/haziris_google.sas";

data temp;
  input Year $4. Sales Expenses Profit;
datalines;
2014 1000  400 200
2015 1170  460 250
2016  660 1120 300
2017 1030  540 350
;

%hz_gg_area(
  intable = temp, 
  outfile = "&hz_loc./examples/hz_gg_area.html" 
);
```

### Examples
- [Google Area](http://haziris.org/examples/haziris-sas-hz_gg_area.html)
- [Google Area Stacked](http://haziris.org/examples/haziris-sas-hz_gg_area_stacked.html)
- [Google Area Stacked Full](http://haziris.org/examples/haziris-sas-hz_gg_area_stacked_full.html)
- [Google Bar](http://haziris.org/examples/haziris-sas-hz_gg_bar.html)
- [Google Bar Style](http://haziris.org/examples/haziris-sas-hz_gg_bar_style.html)
- [Google Bubble](http://haziris.org/examples/haziris-sas-hz_gg_bubble.html)
- [Google Bubble Temperature](http://haziris.org/examples/haziris-sas-hz_gg_bubble_temperature.html)
- [Google Calendar](http://haziris.org/examples/haziris-sas-hz_gg_calendar.html)
- [Google Calendar Stocks](http://haziris.org/examples/haziris-sas-hz_gg_calendar_stocks.html)
- [Google Candlestick](http://haziris.org/examples/haziris-sas-hz_gg_candlestick.html)
- [Google Candlestick Waterfall](http://haziris.org/examples/haziris-sas-hz_gg_candlestick_waterfall.html)
- [Google Column](http://haziris.org/examples/haziris-sas-hz_gg_column.html)
- [Google Column Piesales](http://haziris.org/examples/haziris-sas-hz_gg_column_piesales.html)
- [Google Column Grouped](http://haziris.org/examples/haziris-sas-hz_gg_column_grouped.html)
- [Google Column Piesales Grouped](http://haziris.org/examples/haziris-sas-hz_gg_column_piesales_grouped.html)
- [Google Column Stacked](http://haziris.org/examples/haziris-sas-hz_gg_column_stacked.html)
- [Google Column PieSales Stacked](http://haziris.org/examples/haziris-sas-hz_gg_column_piesales_stacked.html)
- [Google Column Stacked Full](http://haziris.org/examples/haziris-sas-hz_gg_column_stacked_full.html)
- [Google Gantt](http://haziris.org/examples/haziris-sas-hz_gg_gantt.html)
- [Google Gantt Grouped](http://haziris.org/examples/haziris-sas-hz_gg_gantt_grouping.html)
- [Google Geo](http://haziris.org/examples/haziris-sas-hz_gg_geo.html)
- [Google Line](http://haziris.org/examples/haziris-sas-hz_gg_line.html)
- [Google Line Interval](http://haziris.org/examples/haziris-sas-hz_gg_line_interval.html)
- [Google Line Interval Area](http://haziris.org/examples/haziris-sas-hz_gg_line_interval_area.html)
- [Google Line Trendlines](http://haziris.org/examples/haziris-sas-hz_gg_line_trendlines.html)
- [Google Material Bar](http://haziris.org/examples/haziris-sas-hz_gg_material_bar.html)
- [Google Material Bar Cars dataset](http://haziris.org/examples/haziris-sas-hz_gg_material_bar_cars.html)
- [Google Material Bar Dual Y Axis](http://haziris.org/examples/haziris-sas-hz_gg_material_bar_dual_y.html)
- [Google Material Line](http://haziris.org/examples/haziris-sas-hz_gg_material_line.html)
- [Google Material Scatter](http://haziris.org/examples/haziris-sas-hz_gg_material_scatter.html)
- [Google Material Scatter Dual Y](http://haziris.org/examples/haziris-sas-hz_gg_material_scatter_dual_y.html)
- [Google Pie](http://haziris.org/examples/haziris-sas-hz_gg_pie.html)
- [Google Pie 3D](http://haziris.org/examples/haziris-sas-hz_gg_pie_3d.html)
- [Google Pie Donut](http://haziris.org/examples/haziris-sas-hz_gg_pie_donut.html)
- [Google Sankey](http://haziris.org/examples/haziris-sas-hz_gg_sankey.html)
- [Google Sankey Multiple](http://haziris.org/examples/haziris-sas-hz_gg_sankey_multiple.html)
- [Google Scatter](http://haziris.org/examples/haziris-sas-hz_gg_scatter.html)
- [Google Scatter Diff](http://haziris.org/examples/haziris-sas-hz_gg_scatter_diff.html)
- [Google Scatter Dual Y](http://haziris.org/examples/haziris-sas-hz_gg_scatter_dual_y.html)
- [Google Stepped Area](http://haziris.org/examples/haziris-sas-hz_gg_stepped_area.html)
- [Google Timeline](http://haziris.org/examples/haziris-sas-hz_gg_timeline.html)
- [Google Timeline Grouping](http://haziris.org/examples/haziris-sas-hz_gg_timeline_grouping.html)
- [Google Timeline No Label](http://haziris.org/examples/haziris-sas-hz_gg_timeline_no_label.html)
- [Google Treemap](http://haziris.org/examples/haziris-sas-hz_gg_treemap.html)
- [Google Treemap Highlights](http://haziris.org/examples/haziris-sas-hz_gg_treemap_highlights.html)