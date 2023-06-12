//+------------------------------------------------------------------+
//|                                       DonchainChannelManager.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class DonchainChannelManager
{
private:
   int               handle;
   //------------------------------------
   JooyaRates        jr;
   RatesManager      rm;
   TrailingManager   tm;
   PositionManager   pm;
   MaManager         mam;
   LineManager lm;
   PositionInfo      positionInfo;
   SymbolInfo        symbolInfo;
   Trade             trade;
   COrderInfo        orderInfo;
   bool              buyLock;
   bool              sellLock;

   bool              canSell;
   bool              canBuy;
public:
   DonchainChannelManager();
   ~DonchainChannelManager();
   void readIndicator();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DonchainChannelManager::DonchainChannelManager()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DonchainChannelManager::~DonchainChannelManager()
{
}
//+------------------------------------------------------------------+
void DonchainChannelManager::readIndicator()
{
   handle = iCustom(Symbol(),Period(),"JooyaIndicators/donchain_channels.ex5");
}
//+------------------------------------------------------------------+
