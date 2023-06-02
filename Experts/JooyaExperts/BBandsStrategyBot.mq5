//+------------------------------------------------------------------+
//|                                                        Bot02.mq5 |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//| This bot will trade when price passed from upper or lower bands  |
//| in H1,then in M1 or M5 when a buy or sell signal appears will trade.                                                                      |
//+------------------------------------------------------------------+
#include <Jooya/RatesManager.mqh>
#include <Jooya/BBandsManager.mqh>

#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "2.00"
#define EXPERT_MAGIC 10000   // MagicNumber of the bot

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
RatesManager ratesManager;
BBandsManager bBandsManager;

//====================< Bollinger bands strategy >=====================================

//====================< Bollinger bands strategy >=====================================
input double   InpLots           = 1.0;      // Lots

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
   Print("Is Running Bot");
//set the TimeFrimes that should be copy
   ratesManager.setTimeframes();
//read the bbands indicator

   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("Ending Running Bot");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   bBandsManager.currentStrategy = BBandsStrategies_MultiTimeFrame;
   bBandsManager.checkSignal();
   Comment(bBandsManager.comment);
}
//+------------------------------------------------------------------+
