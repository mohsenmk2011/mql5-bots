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
#include <Jooya/LogManager.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class DonchainChannelManager {
 private:
//+--------------------------[ buffers ]--------------------------------+
   double            M1MidArray[];
   double            M1UpperArray[];
   double            M1LowerArray[];

   double            M5MidArray[];
   double            M5UpperArray[];
   double            M5LowerArray[];

   double            M15MidArray[];
   double            M15UpperArray[];
   double            M15LowerArray[];

   double            M30MidArray[];
   double            M30UpperArray[];
   double            M30LowerArray[];

   double            h1MidArray[];
   double            h1UpperArray[];
   double            h1LowerArray[];

   double            h4MidArray[];
   double            h4UpperArray[];
   double            h4LowerArray[];
   //------------------------------------
   LogManager logm;
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
   //checks the buy and sell signals and will open new positions based on signal
   void              checkSignal();
   //checks all positions and will close each positon that should be close based on strategy
   void              checkCloseCondition();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DonchainChannelManager::DonchainChannelManager() {
   logm.addNewPosition("h1 upper");
   logm.addNewPosition("h1 mid");
   logm.addNewPosition("h1 lower");
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DonchainChannelManager::~DonchainChannelManager() {
}
//+------------------------------------------------------------------+
void DonchainChannelManager::readIndicator() {
   //ArraySetAsSeries(M1MidArray,true);
   //ArraySetAsSeries(M1UpperArray,true);
   //ArraySetAsSeries(M1LowerArray,true);

   int M1Handl = iCustom(Symbol(),PERIOD_M1,"JooyaIndicators\\donchian_channels.ex5");

   CopyBuffer(M1Handl,0,0,10,M1UpperArray);
   CopyBuffer(M1Handl,1,0,10,M1MidArray);
   CopyBuffer(M1Handl,2,0,10,M1LowerArray);
//+--------------------------[ M5 bs indicator ]-------------------------+

   //ArraySetAsSeries(M5MidArray,true);
   //ArraySetAsSeries(M5UpperArray,true);
   //ArraySetAsSeries(M5LowerArray,true);

   int M5Handl = iCustom(Symbol(),PERIOD_M5,"JooyaIndicators\\donchian_channels.ex5");

   CopyBuffer(M5Handl,0,0,10,M5UpperArray);
   CopyBuffer(M5Handl,1,0,10,M5MidArray);
   CopyBuffer(M5Handl,2,0,10,M5LowerArray);
//+--------------------------[ M15 bs indicator ]-------------------------+

   //ArraySetAsSeries(M15MidArray,true);
   //ArraySetAsSeries(M15UpperArray,true);
   //ArraySetAsSeries(M15LowerArray,true);

   int M15Handl = iCustom(Symbol(),PERIOD_M15,"JooyaIndicators\\donchian_channels.ex5");

   CopyBuffer(M15Handl,0,0,10,M15UpperArray);
   CopyBuffer(M15Handl,1,0,10,M15MidArray);
   CopyBuffer(M15Handl,2,0,10,M15LowerArray);
//+--------------------------[ M30 bs indicator ]-------------------------+
   //ArraySetAsSeries(M30MidArray,true);
   //ArraySetAsSeries(M30UpperArray,true);
   //ArraySetAsSeries(M30LowerArray,true);

   int M30Handl = iCustom(Symbol(),PERIOD_M30,"JooyaIndicators\\donchian_channels.ex5");

   CopyBuffer(M30Handl,0,0,10,M30UpperArray);
   CopyBuffer(M30Handl,1,0,10,M30MidArray);
   CopyBuffer(M30Handl,2,0,10,M30LowerArray);
//+--------------------------[ H1 bs indicator ]-------------------------+

   //ArraySetAsSeries(h1MidArray,true);
   //ArraySetAsSeries(h1UpperArray,true);
   //ArraySetAsSeries(h1LowerArray,true);

   int h1Handl = iCustom(Symbol(),PERIOD_H1,"JooyaIndicators\\donchian_channels.ex5");

   CopyBuffer(h1Handl,0,0,10,h1UpperArray);
   CopyBuffer(h1Handl,1,0,10,h1MidArray);
   CopyBuffer(h1Handl,2,0,10,h1LowerArray);
//+--------------------------[ H4 bs indicator ]-------------------------+

   //ArraySetAsSeries(h4MidArray,true);
   //ArraySetAsSeries(h4UpperArray,true);
   //ArraySetAsSeries(h4LowerArray,true);

   int h4Handl = iCustom(Symbol(),PERIOD_H4,"JooyaIndicators\\donchian_channels.ex5");

   CopyBuffer(h4Handl,0,0,10,h4UpperArray);
   CopyBuffer(h4Handl,1,0,10,h4MidArray);
   CopyBuffer(h4Handl,2,0,10,h4LowerArray);
   logm.set("h1 upper",h1UpperArray[0]);
   logm.set("h1 mid",h1MidArray[0]);
   logm.set("h1 lower",h1LowerArray[0]);
   logm.comment();
}
//+------------------------------------------------------------------+

//checks the buy and sell signals and will open new positions based on signal
void DonchainChannelManager::checkSignal() {
   rm.copyRates();
   readIndicator();
   if(symbolInfo.Spread()>2) {
      return;
   }
   //double bid = symbolInfo.Bid();
   if(rm.H1Prices[0].close>=h1UpperArray[0]) {
      Print("buy signal");
      trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01),0,"bid is bigger than upper line so buy");
   } else if(rm.H1Prices[0].close<=h1LowerArray[0]) {
      Print("sell signal");
      trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01),0,"bid is smaller than lower line so sell");
   }
}
//checks all positions and will close each positon that should be close based on strategy
void DonchainChannelManager::checkCloseCondition() {

}
//+------------------------------------------------------------------+
