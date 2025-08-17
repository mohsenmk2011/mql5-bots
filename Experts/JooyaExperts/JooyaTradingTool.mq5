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
#include <Controls/WndContainer.mqh>
#include <Charts/Chart.mqh>
#include <Controls/Button.mqh>

#property copyright "Copyright 2024, Jooya"
#property link      "https://www.JooyaTradingTool.jooyabash.com"
#property version   "1.0.0"
#define  DIALOGWIDTH 180

//+---------------------< Global variables >------------------------+
//CAppDialog dialogMain;
CWndContainer dialogMain;
CButton btnBuy;
CButton btnSell;
CButton btnClose;
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
   btnClose.Create(ChartID(),"btnClose",0,0,36,0,0);
   btnClose.Width(36);
   btnClose.Height(36);
   btnClose.Text("x");
   dialogMain.Add(btnClose);
   double highM1 = iHigh(Symbol(),PERIOD_M5,iHighest(Symbol(),PERIOD_M5,MODE_HIGH,6,0));
   double lowM1 = iLow(Symbol(),PERIOD_H4,iLowest(Symbol(),PERIOD_H4,MODE_LOW,6,0));
   // =========== time frame buttons ==================
   //btnM1Period.Create(ChartID(),"btnM1Period",0,0,36,0,0);
   //btnM1Period.Width(36);
   //btnM1Period.Height(36);
   //btnM1Period.Text("M1");
   //dialogMain.Add(btnM1Period);
   //btnM5Period.Create(ChartID(),"btnM5Period",0,btnM1Period.Right()+1,36,0,0);
   //btnM5Period.Width(36);
   //btnM5Period.Height(36);
   //btnM5Period.Text("M5");
   //dialogMain.Add(btnM5Period);
   //btnM15Period.Create(ChartID(),"btnM15Period",0,btnM5Period.Right()+1,36,0,0);
   //btnM15Period.Width(45);
   //btnM15Period.Height(36);
   //btnM15Period.Text("M15");
   //dialogMain.Add(btnM15Period);
   //btnM30Period.Create(ChartID(),"btnM30Period",0,btnM15Period.Right()+1,36,0,0);
   //btnM30Period.Width(45);
   //btnM30Period.Height(36);
   //btnM30Period.Text("M30");
   //dialogMain.Add(btnM30Period);
   //btnH1Period.Create(ChartID(),"btnH1Period",0,btnM30Period.Right()+1,36,0,0);
   //btnH1Period.Width(36);
   //btnH1Period.Height(36);
   //btnH1Period.Text("H1");
   //dialogMain.Add(btnH1Period);
   //btnH4Period.Create(ChartID(),"btnH4Period",0,btnH1Period.Right()+1,36,0,0);
   //btnH4Period.Width(36);
   //btnH4Period.Height(36);
   //btnH4Period.Text("H4");
   //dialogMain.Add(btnH4Period);
   ChartRedraw();
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if (UninitializeReason() == REASON_CHARTCHANGE)
   {
      ChartRedraw();
      return;
   }
   dialogMain.Destroy();
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   CheckEvents();
   //if(pi.count()>0)
   //{
   //   changeCloseButtonXY();
   //}
   if(isTesting)
   {
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
   dialogMain.OnEvent(id,lparam,dparam,sparam);
   if(id == CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam == btnH4Period.Name())
      {
         printf("is going to change time frame to H4");
         //chart.SetSymbolPeriod(Symbol(),PERIOD_H4);
         ChartSetSymbolPeriod(0,Symbol(),PERIOD_H4);
      }
      else if(sparam == btnBuy.Name())
      {
         onBtnBuyClick();
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

//   Print("==[ CheckEvents ]==");
//   if(btnBuy.IsActive())
//   {
//      Print("btn Buy IsActive");
//   }
//   else
//   {
//      Print("btn Buy Is not Active");
//   }
//      Print("btnBuy.MouseX() => "+btnBuy.MouseX());
//
//   if(btnSell.IsActive())
//   {
//      Print("btn Sell IsActive");
//   }
//   else
//   {
//      Print("btn Sell Is not Active");
//   }
//   if(btnBuy.MouseFlags())
//   {
//      Print("btnBuy.MouseFlags() => "+btnBuy.MouseFlags());
//   }
   if(btnBuy.Pressed())
   {
      onBtnBuyClick();
   }
   else if(btnSell.Pressed())
   {
      onBtnSellClick();
   }
   else if(btnClose.Pressed())
   {
      if(pi.buyCount()>0)
      {
         trade.PositionCloseAll(POSITION_TYPE_BUY);      
      }
      if(pi.sellCount()>0)
      {
         trade.PositionCloseAll(POSITION_TYPE_SELL);      
      }
      btnClose.Pressed(false);
   }
   else if(btnM1Period.Pressed())
   {
      Print("btnM1Period Pressed");
      chart.SetSymbolPeriod(Symbol(),PERIOD_M1);
      btnM1Period.Pressed(false);
   }
   else if(btnM5Period.Pressed())
   {
      Print("btnM5Period Pressed");
      chart.SetSymbolPeriod(Symbol(),PERIOD_M5);
      btnM5Period.Pressed(false);
   }
   else if(btnM15Period.Pressed())
   {
      Print("btnM15Period Pressed");
      chart.SetSymbolPeriod(Symbol(),PERIOD_M15);
      btnM15Period.Pressed(false);
   }
   else if(btnM30Period.Pressed())
   {
      Print("btnM30Period Pressed");
      chart.SetSymbolPeriod(Symbol(),PERIOD_M30);
      btnM30Period.Pressed(false);
   }
   else if(btnH1Period.Pressed())
   {
      Print("btnH1Period Pressed");
      chart.SetSymbolPeriod(Symbol(),PERIOD_H1);
      btnH1Period.Pressed(false);
   }
   else if(btnH4Period.Pressed())
   {
      Print("btnH4Period Pressed");
      chart.SetSymbolPeriod(Symbol(),PERIOD_H4);
      btnH4Period.Pressed(false);
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void onBtnBuyClick()
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
      btnBuy.Pressed(false);
      Print("buy position opened successfully");
      return;
   }
   Print("buy position was not succeed");
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void onBtnSellClick()
{
   Print("is going to open sell position");
   //if(!trade.IsOkForTrade())
   //{
   //   Print("is not ok for trade so return");
   //   return;
   //}
   Print("calculate stop loss");
   double sl=0;
   double bid = si.Bid();
   if(trade.Sell(pm.newPositionVolume(10),Symbol(),bid,sl))
   {
      btnSell.Pressed(false);
      Print("sell position opened successfully");
      return;
   }
   Print("sell position was not succeed");
}
//+------------------------------------------------------------------+
//void changeCloseButtonXY()
//{
//   // =========== Close button ==================   
//   // Delete existing button// Get the time value of the last candle
//   datetime lastCandleTime = iTime(_Symbol, PERIOD_CURRENT, 0);
//   // Calculate the corresponding X coordinate for the last candle
//   int newX = ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS) - 1; // Last pixel of the chart
//   // Get the current bid price
//   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
//   // Convert price to chart coordinate
//   double newY = ChartXYToTimePrice(ChartID(), lastCandleTime, price,0,);
//
//   ObjectDelete(NULL,btnClose.Name());
//   // Create new button with updated position
//   btnClose.Create(ChartID(),"btnClose",0,newX,newY,0,0);
//   btnClose.Width(36);
//   btnClose.Height(36);
//   btnClose.Text("x");
//}