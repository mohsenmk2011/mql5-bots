//+------------------------------------------------------------------+
//|                                                  ScoreCandle.mq5 |
//|                                            Copyright 2022, Jooya |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Jooya"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_plots   1
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  clrGreen, clrRed
#property indicator_width1  2
#property indicator_label1  "Heiken Ashi Open;Heiken Ashi High;Heiken Ashi Low;Heiken Ashi Close"

#include <Jooya/RatesManager.mqh>

double haOpen[];
double haHigh[];
double haLow[];
double haClose[];
double haColor[];
RatesManager rm;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0,haOpen,INDICATOR_DATA);
   SetIndexBuffer(1,haHigh,INDICATOR_DATA);
   SetIndexBuffer(2,haLow,INDICATOR_DATA);
   SetIndexBuffer(3,haClose,INDICATOR_DATA);
   SetIndexBuffer(4,haColor,INDICATOR_COLOR_INDEX);
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   IndicatorSetString(INDICATOR_SHORTNAME,"Score candle");
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0);
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
//   int start;
//   if(prev_calculated==0)
//   {
//      double score = rm.getScore(1);
//      haLow[0]=low[0];
//      haHigh[0]=high[0];
//      haOpen[0]=open[0];
//      haClose[0]=open[0]+score;//close[0];
//      start=1;
//   }
//   else
//      start=prev_calculated-1;
//   for(int i=start; i<rates_total && !IsStopped(); i++)
//   {
//      double score = rm.getScore(i+1);
//      haLow[i]=low[i];
//      haHigh[i]=high[i];
//      haOpen[i]=open[i];
//      haClose[i]=open[i]+score;//close[0];
//
//      if(score>=0)
//         haColor[i]=0.0;
//      else
//         haColor[i]=1.0;
//   }
   printf("tick_volume count => " +tick_volume.Size());
   for(int i=0; i<rates_total && !IsStopped(); i++)
   {
      ///double score = rm.getScore(i+1);
      haLow[i]=low[i];
      haHigh[i]=high[i];
      haOpen[i]=open[i];
      haClose[i]=close[i];
      if(close[i]>=open[i])
         haColor[i]=0.0;
      else
         haColor[i]=1.0;
   }
//for(int i=0; i<rates_total && !IsStopped(); i++)
//{
//   haLow[i]=low[i];
//   haHigh[i]=high[i];
//   haOpen[i]=open[i];
//   haClose[i]=close[i];
//}
   return(rates_total);
}
//+------------------------------------------------------------------+
