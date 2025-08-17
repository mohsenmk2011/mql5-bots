//+------------------------------------------------------------------+
//|                                              PositionManager.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Jooya/SymbolInfo.mqh>
#include <Trade/AccountInfo.mqh>
#include <Jooya/PositionInfo.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PositionManager
{
private:
   CAccountInfo      ai;
   SymbolInfo        si;
   PositionInfo      pi;
   double            slByAccountFraction(double fraction);

public:
   PositionManager();
   ~PositionManager();

   double            newPositionVolume(double factor=10);

   double            stopLoss(double pips,ENUM_POSITION_TYPE type);
   double            sellStopLoss(double balanceFactor);
   double            buyStopLoss(double balanceFactor);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PositionManager::PositionManager()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PositionManager::~PositionManager()
{
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double PositionManager::newPositionVolume(double factor)
{
   double v=(ai.Balance()*factor)/100000;
   return NormalizeDouble(v,2);
}
//+------------------------------------------------------------------+
//|                        Sell Stop Loss                            |
//+------------------------------------------------------------------+
double PositionManager::buyStopLoss(double balanceFactor)
{
   double stopLostPips=slByAccountFraction(balanceFactor);
   return stopLoss(stopLostPips,POSITION_TYPE_BUY);
}
//+------------------------------------------------------------------+
//|                        Buy Stop Loss                             |
//+------------------------------------------------------------------+
double PositionManager::sellStopLoss(double balanceFactor)
{
   double stopLostPips=slByAccountFraction(balanceFactor);
   return stopLoss(stopLostPips,POSITION_TYPE_SELL);
}

//+------------------------------------------------------------------+
//|                        Buy Stop Loss                             |
//+------------------------------------------------------------------+
double PositionManager::stopLoss(double pips,ENUM_POSITION_TYPE type)
{
   double sl=0;
   if(type==POSITION_TYPE_BUY)
   {
      sl= si.Ask()-(pips*Point());
   }

   if(type==POSITION_TYPE_SELL)
   {
      sl= si.Bid()+(pips*Point());
   }
   return sl;
}
//+------------------------------------------------------------------+
//|                        Buy Stop Loss                             |
//| calculate stop loss(in pip) based on a fraction of your account balance   |
double PositionManager::slByAccountFraction(double fraction)
{
   if(fraction<=0.0005||fraction>=0.2)
   {
      Print("balance factor should be bigger than 0.0005 and smaller than 0.02");
      return 0;
   }
   double maxLoss=ai.Balance()*fraction;
//PipProfit is propfit or loss with every pip
   double PipProfit = newPositionVolume()*100000*Point();
//z is amount of stop loss in pip
   double z=maxLoss/PipProfit;
   return z;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
