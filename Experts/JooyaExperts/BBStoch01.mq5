//+------------------------------------------------------------------+
//|      IN H1 TimeFrame:
//|                      When It has a buy Bolligner bands signal (mid buy or lower buy):
//|                                             if stoch is going up so buy
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//--------------------------------------
#include <Jooya/BBandsManager.mqh>
#include <Jooya/BBandsStatus.mqh>
#include <Jooya/StochManager.mqh>
#include <Jooya/StochStatus.mqh>
#include <Jooya/Trade.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/SymbolInfo.mqh>

//--------------------------------------
BBandsManager bb;
StochManager stoch;
Trade trade;
PositionManager pm;
SymbolInfo symbolInfo;
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
   bb.updateStatus();
   stoch.updateStatus();
   if(bb.h1_Status==BBands_Status_PassedDown_UpperBand && stoch.H1Status==StochStatus_IsGoingDown)
   {
      Print("bb passed down upper band,stoch is going down => sell");
      bb.Sell();
   }
   else if(bb.h1_Status==BBands_Status_PassedUp_LowerBand && stoch.H1Status==StochStatus_IsGoingUp)
   {
      Print("bb passed up lower band,stoch is going up => buy");
      bb.Buy();
   }
}
//+------------------------------------------------------------------+
