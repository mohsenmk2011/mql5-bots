//+------------------------------------------------------------------+
//|                                                        Bot02.mq5 |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//| This bot will trade when price passed from upper or lower bands  |
//| in H1,then in M1 or M5 when a buy or sell signal appears will trade.                                                                      |
//+------------------------------------------------------------------+
#include <Jooya/RatesManager.mqh>
#include <Jooya/BBandsManager.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Jooya/MaManager.mqh>
#include <Jooya/PositionManager.mqh>

#include <Jooya/PositionInfo.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/Trade.mqh>
#include <Trade/OrderInfo.mqh>
#include <Jooya/CrossStates.mqh>
#include <Jooya/MaLine.mqh>

#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "2.00"
#define EXPERT_MAGIC 10000   // MagicNumber of the bot

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
RatesManager ratesManager;
BBandsManager bBandsManager;
TrailingManager   tm;
PositionManager   pm;
MaManager         mam;
PositionInfo      positionInfo;
SymbolInfo        symbolInfo;
Trade            trade;
COrderInfo        orderInfo;
string            comment;
bool              buyLock;
bool              sellLock;

bool              canSell;
bool              canBuy;
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
   comment="";
   comment +="h1 status=> ";
   ratesManager.copyRates();
   bBandsManager.readIndicotor();
   bBandsManager.updateStatus(ratesManager);
   if(bBandsManager.h1_Status==BBands_Status_Passed_LowerBand)
   {
      comment +="Passed UpperBand\n";
      canBuy=ratesManager.M1Prices[2].close<=bBandsManager.M1LowerBandArray[2]&&ratesManager.M1Prices[1].close>=bBandsManager.M1LowerBandArray[1];
      if(canBuy)
      {
         if(buyLock)
         {
            return;
         }
         if(positionInfo.count()>0)
         {
            trade.PositionCloseAll(POSITION_TYPE_SELL);
         }
         trade.Buy(1.0,Symbol(),symbolInfo.Ask());
         buyLock=true;
         sellLock=false;
         return;

      }
      else
      {
         buyLock=false;
      }
   }
   else if(bBandsManager.h1_Status==BBands_Status_Passed_UpperBand)
   {
      comment +="Passed LowerBand\n";
      canSell = ratesManager.M1Prices[2].close>=bBandsManager.M1UpperBandArray[2]&&ratesManager.M1Prices[1].close<=bBandsManager.M1UpperBandArray[1];
      if(canSell)
      {
         if(sellLock)
         {
            return;
         }
         if(positionInfo.count()>0)
         {
            trade.PositionCloseAll(POSITION_TYPE_BUY);
         }
         trade.Sell(1.0,Symbol(),symbolInfo.Ask());
         buyLock=false;
         sellLock=true;
      }
      else
      {
         sellLock=false;
      }
   }
   else if(bBandsManager.h1_Status==BBands_Status_Between_Lower_MiddleBand)
   {
      comment +="Between Lower MiddleBand\n";
   }
   else if(bBandsManager.h1_Status==BBands_Status_Between_Upper_MiddleBand)
   {
      comment +="Between Upper MiddleBand\n";
   }
   Comment(comment);
}
//+------------------------------------------------------------------+
