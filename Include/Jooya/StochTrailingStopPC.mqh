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
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   int StochHandle = iStochastic(Symbol(),PERIOD_M1,54,6,9,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(StochHandle,0,1,2,KArray);
   CopyBuffer(StochHandle,1,1,2,DArray);

   if(!KCrossedD)
     {
      KCrossedD=CrossOver(KArray,DArray);
     }
   if(!DCrossedK)
     {
      DCrossedK=CrossOver(DArray,KArray);
     }

   if(KCrossedD)
     {
      if(positionInfo.count()>0)
        {
         trade.PositionClose(Symbol());
        }
      trade.Buy(0.01,Symbol(),symbolInfo.Ask());
      DCrossedK=false;
     }


   if(DCrossedK)
     {
      if(positionInfo.count()>0)
        {
         trade.PositionClose(Symbol());
        }
      trade.Sell(0.01,Symbol(),symbolInfo.Ask());
      KCrossedD=false;
     }
//tm.trail();

  }
//+------------------------------------------------------------------+
