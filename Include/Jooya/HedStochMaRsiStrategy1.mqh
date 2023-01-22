//+------------------------------------------------------------------+
//|                                       HedStochMaRsiStrategy1.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Jooya/Strategy.mqh>
#include <Trade/Trade.mqh>
#include <Trade/DealInfo.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/SymbolInfo.mqh>

class HedStochMaRsiStrategy1 : public Strategy{
   private:
   SymbolInfo symbolInfo;
   double KArray[];
   double DArray[];
   bool KCrossedD;
   bool DCrossedK;
   //Passed the Minimun Distance
   bool PassedMinimunDistance;
   
   public:
      HedStochMaRsiStrategy1();
     ~HedStochMaRsiStrategy1();
     void Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HedStochMaRsiStrategy1::HedStochMaRsiStrategy1(){
   KCrossedD=true;
   DCrossedK=true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HedStochMaRsiStrategy1::~HedStochMaRsiStrategy1(){
}
//+------------------------------------------------------------------+
void HedStochMaRsiStrategy1::Run(){
   double AskPrice= symbolInfo.AskTick();
   double BidPrice= symbolInfo.BidTick();
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   //int StochHandle = iStochastic(Symbol(),PERIOD_M1,24,4,3,MODE_EMA,STO_LOWHIGH);
   
   int StochHandle = iStochastic(Symbol(),PERIOD_M1,13,5,5,MODE_EMA,STO_LOWHIGH);
   CopyBuffer(StochHandle,0,0,3,KArray);
   CopyBuffer(StochHandle,1,0,3,DArray);
   Comment("K= ",KArray[0],"\n");
   Comment("D= ",DArray[0],"\n");
   double DistanceKD=NormalizeDouble(Distance(KArray[0],DArray[0]),Digits());
   Comment("Distance= ",DoubleToString(DistanceKD,2),"\n");

   if(KArray[0]<20&&DArray[0]<20){
      if(!KCrossedD){
         KCrossedD=CrossOver(KArray,DArray);
         if(KCrossedD){
            DCrossedK=false;
            PassedMinimunDistance=false;
         }
      }
      if(KCrossedD){
         //if distance of mas is max buy or sell 
         if(!PassedMinimunDistance)
         {
            PassedMinimunDistance= PassedMinDistance(KArray,DArray,10);
            if(PassedMinimunDistance){
               //if BuyLock is false
               if(positionInfo.count()>0){
                 trade.PositionClose(Symbol());
               }
               trade.Buy(1.0,Symbol(),symbolInfo.Ask());
               
            } 
         } 
      }   
   }
   else if(KArray[0]>80&&DArray[0]>80)
   {
      if(!DCrossedK){
         DCrossedK=CrossOver(DArray,KArray);
         if(DCrossedK){
            KCrossedD=false;
            PassedMinimunDistance=false;
         }
      }
      if(DCrossedK){
         if(!PassedMinimunDistance)
         {
            PassedMinimunDistance= PassedMinDistance(KArray,DArray,10);
            if(PassedMinimunDistance){
               //if distance of mas is max buy or sell        
               if(positionInfo.count()>0){
                 trade.PositionClose(Symbol());
               }    
               trade.Sell(1.0,Symbol(),symbolInfo.Ask()); 
               
               //close with traling stop instad of this 
            }
         }
      }   
   }
}