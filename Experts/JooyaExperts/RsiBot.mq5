//+------------------------------------------------------------------+
//|                                                       RsiBot.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//| Includes
//+------------------------------------------------------------------+
#include <Jooya/RsiManager.mqh>
#include <Jooya/LogManager.mqh>
#include <Jooya/Trade.mqh>
//+------------------------------------------------------------------+
//| Objects
//+------------------------------------------------------------------+
RsiManager rsi;
LogManager lm;
Trade trade;
//+------------------------------------------------------------------+
//| Inputs
//+------------------------------------------------------------------+
static input long InpMagicNumber = 36455463; //bot magic number
input int InpRsiPeriod = 21 ; //rsi period
input int InpRsiUpperLevel = 70; //rsi upper level
input int InpRsiLowerLevel = 30; //rsi lower level

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   if(InpMagicNumber<=0)
   {
      Alert("Magic number should be 1 or bigger number");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(InpRsiUpperLevel<=50||InpRsiUpperLevel>=100)
   {
      Alert("rsi level should be a number between 50 and 100");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(InpRsiLowerLevel>=50||InpRsiLowerLevel<=1)
   {
      Alert("rsi lower level should be a number between 1 and 50");
      return INIT_PARAMETERS_INCORRECT;
   }
   if(InpRsiPeriod<=1)
   {
      Alert("rsi period should be a number bigger than 1");
      return INIT_PARAMETERS_INCORRECT;
   }
   lm.addNewPosition("h1 => ");
   lm.addNewPosition("m5 => ");
   trade.setMagicNumber(InpMagicNumber);

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
   rsi.updateStatus();
   lm.set("h1 => ",rsi.H1Status);
   lm.set("m5 => ",rsi.M5Status);
   lm.comment();
   if(rsi.M5Status==RsiStatus_PassedUpLowerLevel)
   {
      rsi.Buy(PERIOD_M5);
   }
   else if(rsi.M5Status==RsiStatus_PassedDownUpperLevel)
   {
      rsi.Sell(PERIOD_M5);
   }
}
//+------------------------------------------------------------------+
