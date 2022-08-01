//+------------------------------------------------------------------+
//|                                        StochWithTrailingStop.mqh |
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class StochWithTrailingStop : public Strategy
  {
private:
   SymbolInfo        symbolInfo;
   double            KArray[];
   double            DArray[];
   bool              KCrossedD;
   bool              DCrossedK;
   //Passed the Minimun Distance
   bool              PassedMinimunDistance;

public:
                     StochWithTrailingStop();
                    ~StochWithTrailingStop();
   void              Run();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StochWithTrailingStop::StochWithTrailingStop()
  {
   KCrossedD=false;
   DCrossedK=false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StochWithTrailingStop::~StochWithTrailingStop()
  {
  }
//+------------------------------------------------------------------+
void StochWithTrailingStop::Run()
  {
   string message="stock strategy \n";
   double AskPrice= symbolInfo.AskTick();
   double BidPrice= symbolInfo.BidTick();
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
//int StochHandle = iStochastic(Symbol(),PERIOD_M1,24,4,3,MODE_EMA,STO_LOWHIGH);

   int StochHandle = iStochastic(Symbol(),PERIOD_H4,18,9,9,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(StochHandle,0,1,2,KArray);
   CopyBuffer(StochHandle,1,1,2,DArray);
   message+="K= "+NormalizeDouble(KArray[0],2)+"\n";
   message+="D= "+NormalizeDouble(DArray[0],2)+"\n";
//int IchimokuHandle=iIchimoku(Symbol(),PERIOD_H1,10,49,54);
   double DistanceKD=NormalizeDouble(Distance(KArray[0],DArray[0]),Digits());
   message+="Distance= "+DoubleToString(DistanceKD,2)+"\n";

   if(!KCrossedD)
     {
      KCrossedD=CrossOver(KArray,DArray);
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
         trade.Sell(1.0,Symbol(),symbolInfo.Ask());
         KCrossedD=false;
        }
     }
   Comment(message);

  }
//+------------------------------------------------------------------+
