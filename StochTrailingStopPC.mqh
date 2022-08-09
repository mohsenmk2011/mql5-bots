//+------------------------------------------------------------------+
//|                 Stochastic Strategy  With Trailing Stop |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Jooya/Strategy.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Trade/Trade.mqh>
#include <Trade/DealInfo.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/SymbolInfo.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class StochTrailingStopPC : public Strategy
  {
private:
   double            KArray[];
   double            DArray[];
   bool              KCrossedD;
   bool              DCrossedK;
   //Passed the Minimun Distance
   bool              PassedMinimunDistance;
   TrailingManager   tm;

public:
                     StochTrailingStopPC();
                    ~StochTrailingStopPC();
   void              Run();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StochTrailingStopPC::StochTrailingStopPC()
  {
   KCrossedD=false;
   DCrossedK=false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StochTrailingStopPC::~StochTrailingStopPC()
  {
  }
//+------------------------------------------------------------------+
void StochTrailingStopPC::Run()
  {
   string message="stock strategy with traling stop loss \n";
   double AskPrice= NormalizeDouble(symbolInfo.AskTick(),_Digits);
   double BidPrice= NormalizeDouble(symbolInfo.BidTick(),_Digits);
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   int StochHandle = iStochastic(Symbol(),PERIOD_M1,54,6,9,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(StochHandle,0,1,2,KArray);
   CopyBuffer(StochHandle,1,1,2,DArray);
   message+="K= "+NormalizeDouble(KArray[0],2)+"\n";
   message+="D= "+NormalizeDouble(DArray[0],2)+"\n";

   double DistanceKD=NormalizeDouble(Distance(KArray[0],DArray[0]),Digits());
   message+="Distance= "+DoubleToString(DistanceKD,2)+"\n";

   if(!KCrossedD)
     {
      KCrossedD=CrossOver(KArray,DArray);
      if(KCrossedD)
        {
         if(positionInfo.count()>0)
           {
            trade.PositionClose(Symbol());
           }
         trade.Buy(0.01,Symbol(),symbolInfo.Ask());
         DCrossedK=false;
        }
     }
   if(!DCrossedK)
     {
      DCrossedK=CrossOver(DArray,KArray);
      if(DCrossedK)
        {
         if(positionInfo.count()>0)
           {
            trade.PositionClose(Symbol());
           }
         trade.Sell(0.01,Symbol(),symbolInfo.Ask());
         KCrossedD=false;
        }
     }
   tm.trail();
   
  }
//+------------------------------------------------------------------+
