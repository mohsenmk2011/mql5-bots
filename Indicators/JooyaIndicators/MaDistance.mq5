//+------------------------------------------------------------------+
//|                                                   MaDistance.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//#property indicator_chart_window
// indicator in a separate window
#property indicator_separate_window
// one graphic plots are used: for display distace of two ma
#property indicator_plots 1
// one indicator's buffers
#property indicator_buffers 1
//------------------------------------------
// set drawing type line,candle
#property indicator_type1 DRAW_LINE
// set drawing color
#property indicator_color1 clrGreen
// set drawing style of  line
#property indicator_style1 STYLE_SOLID
// set the line width
#property indicator_width1  2
// set the label of this line
#property indicator_label1 "Ma Distance"
//-----------------[ set input of indicator ]-------------------------
input color LineColor = clrGreen; // Line Color
//-----------------[ set buffers ]-------------------------
double DistanceBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
// indicator buffers mapping

// the Distanc Buffer is an indicator buffer
   SetIndexBuffer(0,DistanceBuffer,INDICATOR_DATA);
// setting EMPTY_VALUE for Distance line
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
