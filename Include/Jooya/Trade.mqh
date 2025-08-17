//+------------------------------------------------------------------+
//|                                                        Trade.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/LogManager.mqh>
#include <Jooya/RatesManager.mqh>

#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Trade : public CTrade
{
private:
   LogManager lm;
   PositionInfo pi;
   PositionManager pm;
   SymbolInfo si;
   RatesManager rm;
public:
   Trade();
   ~Trade();
   void PositionCloseAll(ENUM_POSITION_TYPE type);
   bool ClosePositiveTrades(double minProfit);
   bool IsOkForTrade(int maxSpread=25);
   void OpenSellPosition(ENUM_TIMEFRAMES period=PERIOD_CURRENT,string symbol ="current symbol");
   void OpenBuyPosition(ENUM_TIMEFRAMES period=PERIOD_CURRENT,string symbol ="current symbol");
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Trade::Trade()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Trade::~Trade()
{
}
//+------------------------------------------------------------------+
void Trade::PositionCloseAll(ENUM_POSITION_TYPE type)
{
   //Print("Close positions of type => "+type);
   //Print("Open position count => "+pi.count());
   for(int i=pi.count()-1; i>=0; i--)
   {
      pi.SelectByIndex(i);
      //Print("Current position type => "+pi.PositionType());
      if(pi.PositionType()==type)
      {
         ulong ticket = pi.Ticket();
         lm.postionType(pi.PositionType());
         Print("founded one position by ticket => "+IntegerToString(ticket));
         PositionClose(ticket);
      }
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Trade::IsOkForTrade(int maxSpread)
{
   if(si.Spread()<=maxSpread)
   {
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Trade::OpenSellPosition(ENUM_TIMEFRAMES period,string symbol)
{
   if(symbol=="current symbol")
   {
      symbol = Symbol();
   }
   if(period == PERIOD_CURRENT)
   {
      period = Period();
   }
   if(rm.currentCandleHasAnyPosition(period,symbol))
   {
      return;
   }
   if(!IsOkForTrade())
   {
      return;
   }
   double sl=rm.getLowerHigh(PERIOD_M5);
   double ask = si.Ask();
   if(ask == sl)
   {
      sl = pm.stopLoss(5,POSITION_TYPE_SELL);
   }
   if(Sell(pm.newPositionVolume(100),Symbol(),ask,sl))
   {

   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Trade::OpenBuyPosition(ENUM_TIMEFRAMES period,string symbol)
{
   rm.copyRates();
   if(symbol=="current symbol")
   {
      symbol = Symbol();
   }
   if(period == PERIOD_CURRENT)
   {
      period = Period();
   }
   if(rm.currentCandleHasAnyPosition(period,symbol))
   {
      Print("current candle has position so return");
      return;
   }
   if(!IsOkForTrade())
   {
      Print("is not ok for trade so return");
      return;
   }
   Print("calculate stop loss");
   double sl=rm.getHigherLow(PERIOD_M5);
   double ask = si.Ask();
   if(ask == sl)
   {
      sl = pm.stopLoss(5,POSITION_TYPE_BUY);
   }
   if(Buy(pm.newPositionVolume(100),Symbol(),ask,sl))
   {
      Print("buy position opened successfully");
      return;
   }
   Print("buy position was not succeed");
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Trade::ClosePositiveTrades(double minProfit)
{
   int count=pi.count();
   for(int i=0; i<count; i++)
   {
      pi.SelectByIndex(i);
      if(pi.Profit()>minProfit)
      {
         PositionClose(pi.Ticket());
         pi.Next();
      }
   }
   return pi.count()>0;
}
//+------------------------------------------------------------------+
