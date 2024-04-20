//+-----------------------------------------------------------------------+
//|                                                  JooyaTradingTool.mq5 |
//|                                            Copyright 2024, Jooya      |
//|                            https://www.JooyaTradingTool.jooyabash.com |
//+-----------------------------------------------------------------------+
//                  links
//+-----------------------------------------------------------------------+
//| https://www.mql5.com/en/docs/standardlibrary/controls                 |
//|                                            Copyright 2024, Jooya      |
//|                            https://www.JooyaTradingTool.jooyabash.com |
//+-----------------------------------------------------------------------+
#include <Controls/Dialog.mqh>
#include <Charts/Chart.mqh>

#property copyright "Copyright 2024, Jooya"
#property link      "https://www.JooyaTradingTool.jooyabash.com"
#property version   "1.0.0"

CDialog dialogMain;
CChart chart;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // read default template from json file
   //and set it to chart   
   chart.Attach(ChartID());
   chart.ShowLineAsk(true);
   chart.ColorForeground(clrBlack);
   chart.ColorBackground(clrWhite);
   chart.ColorBarUp(clrGreen);
   chart.ColorBarDown(clrRed);
   chart.ColorCandleBull(clrLimeGreen);
   chart.ColorCandleBear(clrHotPink);
   // create dialog
   dialogMain.Create(ChartID(),"Jooya Trading Tool",0,0,0,180,270);
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
