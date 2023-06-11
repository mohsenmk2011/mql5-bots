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

input int FMA_Period = 54;  // Fast Moving Average period
input ENUM_MA_METHOD FMA_Method = MODE_SMA;  // Fast Moving Average method
input ENUM_APPLIED_PRICE FMA_Price = PRICE_CLOSE;  // Fast Moving Average price type

input int SMA_Period = 270;  // Slow Moving Average period
input ENUM_MA_METHOD SMA_Method = MODE_SMA;  // Slow Moving Average method
input ENUM_APPLIED_PRICE SMA_Price = PRICE_CLOSE;  // Slow Moving Average price type

//-----------------[ set buffers ]-------------------------
double DistanceBuffer[];


double FMABuffer[];
double SMABuffer[];
//-----------------[ ma handles ]-------------------------
int fmaHandle;  // Fast MA indicator handle
int smaHandle;  // Slow MA indicator handle


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {

// Create the MA indicator
   fmaHandle = iMA(_Symbol, _Period, FMA_Period, 0, FMA_Method, FMA_Price);
   if(fmaHandle == INVALID_HANDLE)
     {
      Print("Failed to create the Fast MA indicator!");
      return INIT_FAILED;
     }
   smaHandle = iMA(_Symbol, _Period, SMA_Period, 0, SMA_Method, SMA_Price);
   if(smaHandle == INVALID_HANDLE)
     {
      Print("Failed to create the Slow MA indicator!");
      return INIT_FAILED;
     }

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
   CalculateMAs();
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+

// Calculate the MA indicator values
void CalculateMAs()
  {
   ArraySetAsSeries(FMABuffer, true);
   int copied = CopyBuffer(fmaHandle, 0, 0, Bars(Symbol(),Period()), FMABuffer);

   if(copied <= 0)
     {
      Print("Failed to copy MA values!");
      return;
     }

   ArraySetAsSeries(SMABuffer, true);
   copied = CopyBuffer(smaHandle, 0, 0, Bars(Symbol(),Period()), SMABuffer);

   if(copied <= 0)
     {
      Print("Failed to copy MA values!");
      return;
     }

// Use the MA values for further calculations
// ...
  }
//+------------------------------------------------------------------+
