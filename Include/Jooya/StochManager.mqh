//+------------------------------------------------------------------+
//|                                                 StochManager.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Jooya/Strategy.mqh>
#include <Jooya/StochStatus.mqh>
#include <Jooya/LineManager.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class StochManager:public Strategy
{
private:
   //-------< Buffers >-----------
   double            M1KArray[];
   double            M1DArray[];
   double            M5KArray[];
   double            M5DArray[];
   double            M15KArray[];
   double            M15DArray[];
   double            M30KArray[];
   double            M30DArray[];
   double            H1KArray[];
   double            H1DArray[];
   double            H4KArray[];
   double            H4DArray[];
   //Passed the Minimun Distance
   bool              PassedMinimunDistance;
   double            previosAtrValue;

   StochStatus getStatus(double& dArray[],double& kArray[]);

public:
   StochManager();
   ~StochManager();
   void checkSignal() override;
   void checkCloseCondition() override;
   void readIndicotor() override;
   void updateStatus() override;

   void Sell();
   void Buy();
   void Trail(ENUM_TIMEFRAMES period);
   ///------------------------------
   StochStatus M1Status;
   StochStatus M5Status;
   StochStatus M15Status;
   StochStatus M30Status;
   StochStatus H1Status;
   StochStatus H4Status;
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StochManager::StochManager()
{
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
   //double DistanceKD=NormalizeDouble(lm.Distance(KArray[0],DArray[0]),Digits());
   //logm.set("distance => ",DistanceKD);
   //----------------------------------------
//
//   if(!KCrossedD)
//   {
//      KCrossedD=lm.CrossOver(KArray,DArray);
//      if(KCrossedD)
//      {
//         //if BuyLock is false
//         if(positionInfo.count()>0)
//         {
//            trade.PositionClose(Symbol());
//         }
//         trade.Buy(1.0,Symbol(),symbolInfo.Ask());
//         DCrossedK=false;
//      }
//      else
//      {
//      }
//   }
//   if(!DCrossedK)
//   {
//      DCrossedK=lm.CrossOver(DArray,KArray);
//      if(DCrossedK)
//      {
//         if(positionInfo.count()>0)
//         {
//            trade.PositionClose(Symbol());
//         }
//         trade.Sell(1.0,Symbol(),symbolInfo.Ask());
//         KCrossedD=false;
//      }
//      else
//      {
//      }
//   }
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
   ArraySetAsSeries(M1KArray,true);
   ArraySetAsSeries(M1DArray,true);
   int M1Handle = iStochastic(Symbol(),Period(),5,3,3,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(M1Handle,0,0,2,M1KArray);
   CopyBuffer(M1Handle,1,0,2,M1DArray);

   ArraySetAsSeries(M5KArray,true);
   ArraySetAsSeries(M5DArray,true);
   int M5Handle = iStochastic(Symbol(),Period(),5,3,3,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(M5Handle,0,0,2,M5KArray);
   CopyBuffer(M5Handle,1,0,2,M5DArray);

   ArraySetAsSeries(M15KArray,true);
   ArraySetAsSeries(M15DArray,true);
   int M15Handle = iStochastic(Symbol(),Period(),5,3,3,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(M15Handle,0,0,2,M15KArray);
   CopyBuffer(M15Handle,1,0,2,M15DArray);

   ArraySetAsSeries(M30KArray,true);
   ArraySetAsSeries(M30DArray,true);
   int M30Handle = iStochastic(Symbol(),Period(),5,3,3,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(M30Handle,0,0,2,M30KArray);
   CopyBuffer(M30Handle,1,0,2,M30DArray);

   ArraySetAsSeries(H1KArray,true);
   ArraySetAsSeries(H1DArray,true);
   int H1Handle = iStochastic(Symbol(),Period(),5,3,3,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(H1Handle,0,0,2,H1KArray);
   CopyBuffer(H1Handle,1,0,2,H1DArray);

   ArraySetAsSeries(H4KArray,true);
   ArraySetAsSeries(H4DArray,true);
   int H4Handle = iStochastic(Symbol(),Period(),5,3,3,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(H4Handle,0,0,2,H4KArray);
   CopyBuffer(H4Handle,1,0,2,H4DArray);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void StochManager::updateStatus()
{
   rm.copyRates();
   readIndicotor();

   M1Status = getStatus(M1DArray,M1KArray);
   M5Status = getStatus(M5DArray,M5KArray);
   M15Status = getStatus(M15DArray,M15KArray);
   M30Status = getStatus(M30DArray,M30KArray);
   H1Status = getStatus(H1DArray,H1KArray);
   H4Status = getStatus(H4DArray,H4KArray);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StochStatus StochManager::getStatus(double& dArray[],double& kArray[])
{
   if(lm.CrossOver(dArray,kArray))
   {
      return StochStatus_DCrossedK;
   }
   else if(lm.CrossOver(kArray,dArray))
   {
      return StochStatus_KCrossedD;
   }
   else if(lm.BiggerThan(kArray,dArray))
   {
      if((kArray[1]<20&&kArray[0]>20)||(dArray[1]<20&&dArray[0]>20))
      {
         return StochStatus_PassedUpLowerLevel;
      }
      return StochStatus_IsGoingUp;
   }
   else if(lm.SmallerThan(kArray,dArray))
   {
      if((kArray[1]>80&&kArray[0]<80)||(dArray[1]>80&&dArray[0]<80))
      {
         return StochStatus_PassedDownUpperLevel;
      }
      return StochStatus_IsGoingDown;
   }
   return StochStatus_NotCrossed;
}