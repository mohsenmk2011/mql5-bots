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
#include <Controls/Button.mqh>
#property copyright "Copyright 2024, Jooya"
#property link      "https://www.JooyaTradingTool.jooyabash.com"
#property version   "1.0.0"
#define  DIALOGWIDTH 180
CAppDialog dialogMain;
CButton btnBuy;
CButton btnSell;
CButton btnM1Period;
CButton btnM5Period;
CButton btnM15Period;
CButton btnM30Period;
CButton btnH1Period;
CButton btnH4Period;
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
   dialogMain.Create(ChartID(),"Jooya Trading Tool",0,0,0,DIALOGWIDTH+8,270);   
   btnBuy.Create(ChartID(),"btnBuy",0,0,0,0,0);
   btnBuy.Width(DIALOGWIDTH/2);
   btnBuy.Height(36);
   btnBuy.Text("Buy");
   dialogMain.Add(btnBuy);
   btnSell.Create(ChartID(),"btnSell",0,DIALOGWIDTH/2,0,0,0);
   btnSell.Width(DIALOGWIDTH/2);
   btnSell.Height(36);
   btnSell.Text("Sell");
   dialogMain.Add(btnSell);
   btnH4Period.Create(ChartID(),"btnH4Period",0,0,36,0,0);
   btnH4Period.Width(20);
   btnH4Period.Height(20);
   btnH4Period.Text("H4");
   dialogMain.Add(btnH4Period);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
      dialogMain.Destroy();
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  }
//+------------------------------------------------------------------+
void  OnChartEvent(
   const int       id,       // event ID 
   const long&     lparam,   // long type event parameter
   const double&   dparam,   // double type event parameter
   const string&   sparam    // string type event parameter
   )
   {
      dialogMain.ChartEvent(id,lparam,dparam,sparam);
      if(sparam == btnH4Period.Name()&& id == CHARTEVENT_OBJECT_CLICK)
      {
         chart.SetSymbolPeriod(Symbol(),PERIOD_H4);
      }
   }