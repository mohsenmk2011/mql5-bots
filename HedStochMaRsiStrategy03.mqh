//+------------------------------------------------------------------+
//|                                       HedStochMaRsiStrategy.mqh |
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

class HedStochMaRsiStrategy : public Strategy{
   private:
   SymbolInfo symbolInfo;
   double KArray[];
   double DArray[];
   bool KCrossedD;
   bool DCrossedK;
   //Passed the Minimun Distance
   bool PassedMinimunDistance;
   
   public:
      HedStochMaRsiStrategy();
     ~HedStochMaRsiStrategy();
     void Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HedStochMaRsiStrategy::HedStochMaRsiStrategy(){
   KCrossedD=false;
   DCrossedK=false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HedStochMaRsiStrategy::~HedStochMaRsiStrategy(){
}
//+------------------------------------------------------------------+
void HedStochMaRsiStrategy::Run(){
   string message="";
   double AskPrice= symbolInfo.AskTick();
   double BidPrice= symbolInfo.BidTick();
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   //int StochHandle = iStochastic(Symbol(),PERIOD_M1,24,4,3,MODE_EMA,STO_LOWHIGH);
   
   int StochHandle = iStochastic(Symbol(),PERIOD_H1,24,4,4,MODE_EMA,STO_LOWHIGH);
   CopyBuffer(StochHandle,0,1,2,KArray);
   CopyBuffer(StochHandle,1,1,2,DArray);
   Comment("K= ",KArray[0],"\n");
   Comment("D= ",DArray[0],"\n");
   double DistanceKD=NormalizeDouble(Distance(KArray[0],DArray[0]),Digits());
   message+="Distance= "+DoubleToString(DistanceKD,2)+"\n";
   
   if(KArray[0]<20&&DArray[0]<20){
      if(!KCrossedD){
         KCrossedD=CrossOver(KArray,DArray);
         if(KCrossedD){
            //if BuyLock is false
            if(positionInfo.count()>0){
              trade.PositionClose(Symbol());
            }
            trade.Buy(10.0,Symbol(),symbolInfo.Ask());
            DCrossedK=false;
         }
      }
   }
   else if(KArray[0]>80&&DArray[0]>80)
   {
      if(!DCrossedK){
         DCrossedK=CrossOver(DArray,KArray);  
         if(DCrossedK){
            if(positionInfo.count()>0){
              trade.PositionClose(Symbol());
            }    
            trade.Sell(10.0,Symbol(),symbolInfo.Ask());
            KCrossedD=false;
         }    
      } 
   } 
   Comment(message);
   
}