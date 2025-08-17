//+------------------------------------------------------------------+
//|   When In H1 Stoch has Sell Cross Signal and It is bigger than UpperLevel                               |
//|   In M5 When it has Sell signal So sell
//|                                             |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//--------------------------------------
input int InpBarCount = 6; //bar count
//--------------------------------------
#include <Jooya/StochManager.mqh>
#include <Jooya/StochStatus.mqh>
#include <Jooya/Trade.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/RatesManager.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Charts/Chart.mqh>
#include <Jooya/LogManager.mqh>
//+---------------------< Global variables >------------------------+
CChart chart;
StochManager stoch;
Trade trade;
PositionManager pm;
SymbolInfo si;
RatesManager rm;
TrailingManager tm;
PositionInfo pi;
LogManager lm;
double highM5 = 0; // highest price of last N bar
double lowM5 = 0; // lowest price of last N bar
int lowCount = 0; // the count of bar that low is not changed
int highCount = 0; // the count of bar that high is not changed
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   lm.addNewPosition("lowCount");
   lm.addNewPosition("highCount");
   chart.Attach(0);
   chart.ShowLineAsk(true);
   chart.ColorForeground(clrBlack);
   chart.ColorBackground(clrWhite);
   chart.ColorBarUp(clrGreen);
   chart.ColorBarDown(clrRed);
   chart.ColorCandleBull(clrLimeGreen);
   chart.ColorCandleBear(clrHotPink);
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
   // calculate high and low in M5 for open position
   
   double currentHigh = iHigh(Symbol(),PERIOD_M5,iHighest(Symbol(),PERIOD_M5,MODE_HIGH,InpBarCount,1));
   double currentLow = iLow(Symbol(),PERIOD_M5,iLowest(Symbol(),PERIOD_M5,MODE_LOW,InpBarCount,1));
   if(currentHigh == highM5)
   {
      if(rm.isNewCandle(PERIOD_M5))
      {
         highCount += 1;
         lm.set("highCount",highCount);
      }
   }
   else
   {
      highCount = 0;
      highM5 = currentHigh;
   }
   if(currentLow == lowM5)
   {
      if(rm.isNewCandle(PERIOD_M5))
      {
         lowCount += 1;
         lm.set("lowCount",lowCount);      
      }
   }
   else
   {
      lowCount = 0;
      lowM5 = currentLow;
   }
   lm.comment();
   DrawObjectM5();
   stoch.updateStatus();
   if(stoch.H1Status==StochStatus_IsGoingDown||stoch.H1Status==StochStatus_PassedDownUpperLevel||stoch.H1Status==StochStatus_DCrossedK)
   {
      if(stoch.M5Status==StochStatus_PassedDownUpperLevel)
      {
         //sell
         if(pi.sellCount()>0)
         {
            return;
         }
         stoch.Sell();
      }
   }
   else if(stoch.H1Status==StochStatus_IsGoingUp||stoch.H1Status==StochStatus_PassedUpLowerLevel||stoch.H1Status==StochStatus_KCrossedD)
   {
      //buy
      if(stoch.M5Status==StochStatus_PassedUpLowerLevel)
      {
         if(pi.buyCount()>0)
         {
            return;
         }
         stoch.Buy();
      }
   }
   tm.trailWithLowHigh(lowM5,highM5);
   //stoch.Trail(PERIOD_M5);
   //if(stoch.M15Status == StochStatus_PassedUpLowerLevel)
   //{
   //   //close sell postions
   //}
   //else if (stoch.M15Status == StochStatus_PassedDownUpperLevel)
   //{
   //   //close buy postions
   //   pm...ClosePositiveTrades();
   //   trade.
   //}
   //int minProfit = 100;
   //int count=pi.count();
   //for(int i=0; i<count; i++)
   //{
   //   positionInfo.SelectByIndex(i);
   //   if(positionInfo.Profit()<=-30)
   //   {
   //      trade.PositionClose(positionInfo.Ticket());
   //   }
   //}
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawObjectM5()
{
   datetime time = iTime(Symbol(),PERIOD_M5,InpBarCount);
/// draw highM5 line
   ObjectDelete(NULL,"highM5");
   ObjectCreate(NULL,"highM5",OBJ_TREND,0,time,highM5,TimeCurrent(),highM5);
   ObjectSetInteger(NULL,"highM5",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"highM5",OBJPROP_COLOR,clrBlack);
   /// draw highM5 text 
   ObjectDelete(NULL,"highText");
   ObjectCreate(NULL,"highText",OBJ_TEXT,0,time,highM5);
   ObjectSetInteger(NULL,"highText",OBJPROP_ANCHOR,ANCHOR_LOWER);
   ObjectSetInteger(NULL,"highText",OBJPROP_COLOR,clrBlack);
   ObjectSetString(NULL,"highText",OBJPROP_TEXT,(string)highCount);


/// draw lowM5 line
   ObjectDelete(NULL,"lowM5");
   ObjectCreate(NULL,"lowM5",OBJ_TREND,0,time,lowM5,TimeCurrent(),lowM5);
   ObjectSetInteger(NULL,"lowM5",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"lowM5",OBJPROP_COLOR,clrBlack);
   /// draw lowM5 text 
   ObjectDelete(NULL,"lowText");
   ObjectCreate(NULL,"lowText",OBJ_TEXT,0,time,lowM5);
   ObjectSetInteger(NULL,"lowText",OBJPROP_ANCHOR,ANCHOR_UPPER);
   ObjectSetInteger(NULL,"lowText",OBJPROP_COLOR,clrBlack);
   ObjectSetString(NULL,"lowText",OBJPROP_TEXT,(string)lowCount);
}