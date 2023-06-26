//+------------------------------------------------------------------+
//|   When In H1 Stoch has Sell Cross Signal and It is bigger than UpperLevel                               |
//|   In M5 When it has Sell signal So sell
//|                                             |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//--------------------------------------
#include <Jooya/StochManager.mqh>
#include <Jooya/StochStatus.mqh>
#include <Jooya/Trade.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/RatesManager.mqh>
//--------------------------------------
StochManager stoch;
Trade trade;
PositionManager pm;
SymbolInfo symbolInfo;
RatesManager rm;
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

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   stoch.updateStatus();
   if(stoch.H1Status==StochStatus_IsGoingDown||stoch.H1Status==StochStatus_PassedDownUpperLevel||stoch.H1Status==StochStatus_DCrossedK)
   {
      if(stoch.M5Status==StochStatus_PassedDownUpperLevel)
      {
         //sell
         stoch.Sell();
      }
   }
   else if(stoch.H1Status==StochStatus_IsGoingUp||stoch.H1Status==StochStatus_PassedUpLowerLevel||stoch.H1Status==StochStatus_KCrossedD)
   {
      //buy
      if(stoch.M5Status==StochStatus_PassedUpLowerLevel)
      {
         stoch.Buy();
      }
   }
   stoch.Trail(PERIOD_M5);
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
