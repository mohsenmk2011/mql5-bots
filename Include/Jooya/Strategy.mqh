//+------------------------------------------------------------------+
//|                                                     Strategy.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Jooya/RatesManager.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/Trade.mqh>
#include <Trade/OrderInfo.mqh>
#include <Jooya/CrossStates.mqh>
#include <Jooya/MaLine.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Jooya/MaManager.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/JooyaRates.mqh>
#include <Jooya/LineManager.mqh>
#include <Jooya/LogManager.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Strategy
{
protected:
   JooyaRates jr;
   RatesManager rm;
   TrailingManager   tm;
   PositionManager   pm;
   MaManager         mam;
   LineManager lm;
   LogManager logm;
   PositionInfo      positionInfo;
   SymbolInfo        symbolInfo;
   Trade             trade;
   COrderInfo        orderInfo;
   //---------------------------
   bool buyLock;
   bool sellLock;
   bool canSell;
   bool canBuy;
private:

public:
   Strategy();
   ~Strategy();
   //checks all positions and will close each positon that should be close based on strategy
   virtual void checkCloseCondition();
   ///read the value of indictor in multipe time frames
   virtual void readIndicotor();
   //checks the buy and sell signals and will open new positions based on signal
   virtual void checkSignal();
   virtual void updateStatus();
   bool IsOkForTrade();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Strategy::Strategy()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Strategy::~Strategy()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Strategy::checkSignal()
{
   Print("Strategy::checkSignal");
}
//+------------------------------------------------------------------+
void Strategy::checkCloseCondition()
{
   Print("Strategy::checkCloseCondition");
}
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void Strategy::updateStatus()
{
   Print("Strategy::updateStatus");
//read the rates
   rm.copyRates();
   readIndicotor();
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Strategy::IsOkForTrade()
{
   if(symbolInfo.Spread()<=2)
   {
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
