//+-----------------------------------------------------------------------+
//|                                                  JooyaTradingTool.mq5 |
//|                                            Copyright 2024, Jooya      |
//|                            https://www.JooyaTradingTool.jooyabash.com |
//+-----------------------------------------------------------------------+
#property copyright "Copyright 2024, Jooya"
#property link      "https://www.JooyaTradingTool.jooyabash.com"
#property version   "1.0.0"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // read default template from json file
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrWhite);
   ChartSetInteger(0,CHART_COLOR_FOREGROUND,clrBlack);

   // Set bull candle color to red
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrLimeGreen);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrHotPink);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrRed);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrGreen);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   
  }
//+------------------------------------------------------------------+
