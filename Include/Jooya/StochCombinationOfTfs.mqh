//+------------------------------------------------------------------+
//|                               StochCombinationOfTfs.mqh          |
//|                               Combination of time frames.mqh     |
// the initial Code is from   StochWithTrailingStop.mqh              |
//|                             Copyright 2022, MetaQuotes Ltd.      |
//|                                    https://www.mql5.com          |
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
class StochCombinationOfTfs : public Strategy
  {
private:
   SymbolInfo        symbolInfo;

   double            H4KArray[];
   double            H4DArray[];
   bool              H4KCrossedD;
   bool              H4DCrossedK;

   double            H1KArray[];
   double            H1DArray[];
   bool              H1KCrossedD;
   bool              H1DCrossedK;
   //Passed the Minimun Distance
   bool              PassedMinimunDistance;

public:
                     StochCombinationOfTfs();
                    ~StochCombinationOfTfs();
   void              Run();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StochCombinationOfTfs::StochCombinationOfTfs()
  {
   H4KCrossedD=false;
   H4DCrossedK=false;
   H1KCrossedD=false;
   H1DCrossedK=false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StochCombinationOfTfs::~StochCombinationOfTfs()
  {
  }
//+------------------------------------------------------------------+
void StochCombinationOfTfs::Run()
  {
   string message="stock com ts strategy \n";
   double AskPrice= symbolInfo.AskTick();
   double BidPrice= symbolInfo.BidTick();
   ArraySetAsSeries(H4KArray,true);
   ArraySetAsSeries(H4DArray,true);
   ArraySetAsSeries(H1KArray,true);
   ArraySetAsSeries(H1DArray,true);
//int StochHandle = iStochastic(Symbol(),PERIOD_M1,24,4,3,MODE_EMA,STO_LOWHIGH);

   int StochHandleH4 = iStochastic(Symbol(),PERIOD_H4,18,9,9,MODE_SMA,STO_LOWHIGH);
   int StochHandleH1 = iStochastic(Symbol(),PERIOD_H1,18,9,9,MODE_SMA,STO_LOWHIGH);

   CopyBuffer(StochHandleH4,0,1,2,H4KArray);
   CopyBuffer(StochHandleH4,1,1,2,H4DArray);
   CopyBuffer(StochHandleH1,0,1,2,H1KArray);
   CopyBuffer(StochHandleH1,1,1,2,H1DArray);

   message+="H1 K= "+NormalizeDouble(H1KArray[0],2)+"\n";
   message+="H1 D= "+NormalizeDouble(H1DArray[0],2)+"\n";
//int IchimokuHandle=iIchimoku(Symbol(),PERIOD_H1,10,49,54);
// double DistanceKD=NormalizeDouble(Distance(KArray[0],DArray[0]),Digits());
//message+="Distance= "+DoubleToString(DistanceKD,2)+"\n";

   if(!H4KCrossedD)
     {
      H4KCrossedD=CrossOver(H4KArray,H4DArray);
     }
   if(H4KCrossedD) //in h1 just buy
     {
      H4DCrossedK=false;
      if(!H1KCrossedD)
        {
         H1KCrossedD=CrossOver(H1KArray,H1DArray);
         if(H1KCrossedD)
           {
            if(positionInfo.count()>0)
              {
               trade.PositionClose(Symbol());
              }
            trade.Buy(0.01,Symbol(),symbolInfo.Ask());
            H1DCrossedK=false;
           }
        }

      if(!H1DCrossedK)
        {
         H1DCrossedK=CrossOver(H1DArray,H1KArray);
         if(H1DCrossedK)
           {
            if(positionInfo.count()>0)
              {
               trade.PositionClose(Symbol());
              }
            H1KCrossedD=false;
           }
        }
        
     }
   if(!H4DCrossedK)
     {
      H4DCrossedK=CrossOver(H4DArray,H4KArray);
     }
   if(H4DCrossedK)//in h1 just sell
     {
      H4KCrossedD=false;
      if(!H1DCrossedK)
        {
         H1DCrossedK=CrossOver(H1DArray,H1KArray);
         if(H1DCrossedK)
           {
            if(positionInfo.count()>0)
              {
               trade.PositionClose(Symbol());
              }
            trade.Sell(0.01,Symbol(),symbolInfo.Ask());
            H1KCrossedD=false;
           }
        }
     }
   Comment(message);
  }
//+------------------------------------------------------------------+
