//+------------------------------------------------------------------+
//|      IN H1 TimeFrame:
//|                      When It has a buy Bolligner bands signal (mid buy or lower buy):
//|                                             if stoch is going up so buy
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//--------------------------------------
input int InpBarCount = 6; //bar count

#include <Jooya/BBandsManager.mqh>
#include <Jooya/BBandsStatus.mqh>
#include <Jooya/StochManager.mqh>
#include <Jooya/StochStatus.mqh>
#include <Jooya/Trade.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Jooya/PositionInfo.mqh>

//--------------------------------------
BBandsManager bb;
StochManager stoch;
Trade trade;
PositionManager pm;
SymbolInfo symbolInfo;
TrailingManager tm;
PositionInfo pi;
double highM5 = 0; // highest price of last N bar
double lowM5 = 0; // lowest price of last N bar
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // calculate high and low in M5 for open position
   highM5 = iHigh(Symbol(),PERIOD_M5,iHighest(Symbol(),PERIOD_M5,MODE_HIGH,InpBarCount,1));
   lowM5 = iLow(Symbol(),PERIOD_M5,iLowest(Symbol(),PERIOD_M5,MODE_LOW,InpBarCount,1));
   DrawObjectM5();
   bb.updateStatus();
   stoch.updateStatus();
   if(bb.h1_Status==BBands_Status_PassedDown_UpperBand && stoch.H1Status==StochStatus_IsGoingDown)
   {
      Print("bb passed down upper band,stoch is going down => sell");
      if(pi.sellCount()>0)
      {
         return;
      }
      bb.Sell();
   }
   else if(bb.h1_Status==BBands_Status_PassedUp_LowerBand && stoch.H1Status==StochStatus_IsGoingUp)
   {
      Print("bb passed up lower band,stoch is going up => buy");
      if(pi.buyCount()>0)
      {
         return;
      }
      bb.Buy();
   }
   tm.trailWithLowHigh(lowM5,highM5);
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


/// draw lowM5 line
   ObjectDelete(NULL,"lowM5");
   ObjectCreate(NULL,"lowM5",OBJ_TREND,0,time,lowM5,TimeCurrent(),lowM5);
   ObjectSetInteger(NULL,"lowM5",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"lowM5",OBJPROP_COLOR,clrBlack);
}