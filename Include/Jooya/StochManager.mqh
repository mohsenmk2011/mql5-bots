//+------------------------------------------------------------------+
//|                                                 StochManager.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Jooya/Strategy.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class StochManager:public Strategy
{
private:
   double            KArray[];
   double            DArray[];
   bool              KCrossedD;
   bool              DCrossedK;
   //Passed the Minimun Distance
   bool              PassedMinimunDistance;
   TrailingManager   tm;
   double            previosAtrValue;

public:
   StochManager();
   ~StochManager();
   void checkSignal() override;
   void checkCloseCondition() override;
   void readIndicotor() override;
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StochManager::StochManager()
{
   KCrossedD=false;
   DCrossedK=false;
   logm.addNewPosition("strategy => ");
   logm.addNewPosition("k => ");
   logm.addNewPosition("d => ");
   logm.addNewPosition("distance => ");
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StochManager::~StochManager()
{
}
//+------------------------------------------------------------------+
void StochManager::checkSignal()
{
   //Print("StochManager::checkSignal");
   logm.set("strategy => ","stoch");
   rm.copyRates();
   readIndicotor();
   double DistanceKD=NormalizeDouble(lm.Distance(KArray[0],DArray[0]),Digits());
   //----------------------------------------
   logm.set("k => ",NormalizeDouble(KArray[0],2));
   logm.set("d => ",NormalizeDouble(DArray[0],2));
   logm.set("distance => ",DistanceKD);
   //----------------------------------------

   if(!KCrossedD)
   {
      KCrossedD=lm.CrossOver(KArray,DArray);
      if(KCrossedD)
      {
         //if BuyLock is false
         if(positionInfo.count()>0)
         {
            trade.PositionClose(Symbol());
         }
         trade.Buy(1.0,Symbol(),symbolInfo.Ask());
         DCrossedK=false;
      }
      else
      {
      }
   }
   if(!DCrossedK)
   {
      DCrossedK=lm.CrossOver(DArray,KArray);
      if(DCrossedK)
      {
         if(positionInfo.count()>0)
         {
            trade.PositionClose(Symbol());
         }
         trade.Sell(1.0,Symbol(),symbolInfo.Ask());
         KCrossedD=false;
      }
      else
      {
      }
   }
   //tm.trailWithAtr();
   logm.comment();
}
//+------------------------------------------------------------------+
void StochManager::checkCloseCondition()
{
   Print("StochManager::checkCloseCondition");

}
//+------------------------------------------------------------------+
void StochManager::readIndicotor()
{
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   int StochHandle = iStochastic(Symbol(),Period(),5,3,3,MODE_SMA,STO_LOWHIGH);

   CopyBuffer(StochHandle,0,0,2,KArray);
   CopyBuffer(StochHandle,1,0,2,DArray);
}
//+------------------------------------------------------------------+
