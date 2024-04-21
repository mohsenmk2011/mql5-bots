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

//+-------------------------< Includes >-----------------------------+
#include <Jooya/LogManager.mqh>
#include <Jooya/Trade.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Controls/Dialog.mqh>
#include <Charts/Chart.mqh>
#include <Controls/Button.mqh>

#property copyright "Copyright 2024, Jooya"
#property link      "https://www.JooyaTradingTool.jooyabash.com"
#property version   "1.0.0"
#define  DIALOGWIDTH 180

//+---------------------< Global variables >------------------------+
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
LogManager lm;
Trade trade;
SymbolInfo si;
PositionInfo pi;
PositionManager pm;
TrailingManager tm;
// is ea is running in strategy tester?
bool isTesting = true;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // read default template from json file
   //and set it to chart
   Print("is going to initialize ");
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
   if (UninitializeReason() == REASON_CHARTCHANGE)
   {
      return;
   }
   dialogMain.Destroy();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   if(isTesting)
   {
      CheckEvents();   
   }
}
//+------------------------------------------------------------------+
void OnChartEvent(
   const int       id,       // event ID
   const long&     lparam,   // long type event parameter
   const double&   dparam,   // double type event parameter
   const string&   sparam    // string type event parameter
)
{
   Print("OnChartEvent ===> ");
   // if this function is running so ea is running in mt5 not strategy tester
   isTesting = false;
   dialogMain.ChartEvent(id,lparam,dparam,sparam);
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam == btnH4Period.Name())
      {
         printf("is going to change time frame to H4");
         chart.SetSymbolPeriod(Symbol(),PERIOD_H4);
      }
      else if(sparam == btnBuy.Name())
      {
         Print("is going to open buy position");
         //if(!trade.IsOkForTrade())
         //{
         //   Print("is not ok for trade so return");
         //   return;
         //}
         Print("calculate stop loss");
         double sl=0;
         double ask = si.Ask();
         if(trade.Buy(pm.newPositionVolume(10),Symbol(),ask,sl))
         {
            Print("buy position opened successfully");
            return;
         }
         Print("buy position was not succeed");
         btnBuy.Pressed(false);
      }
      else if(sparam == btnSell.Name())
      {

      }
   }
}
//+------------------------------------------------------------------+
void CheckEvents()
{
   // if we are in strategy tester OnChartEvent will not work
   // so we should implement it with files,
   // in a qt quick application by clikcing button,it will write on the file in bot we read this file
   // for example we write in file ,sell 0.01 EurUsd or other things...   
}