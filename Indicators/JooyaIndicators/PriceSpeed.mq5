//+------------------------------------------------------------------+
//|                                                   PriceSpeed.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window

// Indicator input parameters
input int Period = 10;   // Number of bars to calculate speed
input int DecimalPlaces = 5;   // Number of decimal places to display

// Indicator buffers
double SpeedBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
// Set indicator buffers
   SetIndexBuffer(0, SpeedBuffer, INDICATOR_DATA);

// Set indicator label
   IndicatorSetString(INDICATOR_SHORTNAME, "Price Speed");

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
for (int i = 0; i < rates_total; i++)
    {
        double speed = MathAbs(close[i] - close[i + Period]) * MathPow(10, DecimalPlaces);
        SpeedBuffer[i] = speed;
    }


//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
