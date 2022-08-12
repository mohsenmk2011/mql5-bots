//+------------------------------------------------------------------+
//|                                               BBandsStrategy.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Jooya/Strategy.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/DealInfo.mqh>

#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class BBandsStrategy : public Strategy
  {
private:
   //==============[ bb propeties ]===============
   bool              buyLock;
   bool              sellLock;

   bool              bbCanSell;
   bool              bbCanBuy;
   //==============[ stoch propeties ]===============
   double            KArray[];
   double            DArray[];
   bool              stochCanBuy;
   bool              stochCanSell;

public:
                     BBandsStrategy();
                    ~BBandsStrategy();
   void              Run();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsStrategy::BBandsStrategy()
  {
   buyLock=false;
   sellLock=false;
   bbCanBuy=false;
   bbCanSell=false;


   stochCanBuy=false;
   stochCanSell=false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsStrategy::~BBandsStrategy()
  {
  }
//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBandsStrategy::Run()
  {
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   int StochHandle = iStochastic(Symbol(),Period(),18,9,9,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(StochHandle,0,1,2,KArray);
   CopyBuffer(StochHandle,1,1,2,DArray);

   MqlRates Prices[];
   datetime dt;
   ArraySetAsSeries(Prices,true);
//int count=CopyRates(Symbol(),Period(),0,Bars(Symbol(),Period()),Prices);
   int count = CopyRates(Symbol(),Period(),0,3,Prices);
   string signal="";
   double midBandArray[];
   double upperBandArray[];
   double lowerBandArray[];

   ArraySetAsSeries(midBandArray,true);
   ArraySetAsSeries(upperBandArray,true);
   ArraySetAsSeries(lowerBandArray,true);

   int bbHandl=iBands(Symbol(),Period(),18,0,2.7,PRICE_CLOSE);

   CopyBuffer(bbHandl,0,0,3,midBandArray);
   CopyBuffer(bbHandl,1,0,3,upperBandArray);
   CopyBuffer(bbHandl,2,0,3,lowerBandArray);

   bbCanBuy=Prices[2].close<=lowerBandArray[2]&&Prices[1].close>=lowerBandArray[1];
   bbCanSell=Prices[2].close>=upperBandArray[2]&&Prices[1].close<=upperBandArray[1];

   stochCanBuy=CrossOver(KArray,DArray);
   stochCanSell=CrossOver(DArray,KArray);

   if((bbCanBuy&&bbCanSell)||(stochCanBuy&&stochCanSell))
     {
      return;
     }

   if(bbCanBuy)
     {
      if(buyLock)
        {
         return;
        }
      trade.Buy(1.0,Symbol(),symbolInfo.Ask());
      buyLock=true;
      sellLock=false;

      if(stochCanBuy)
        {

         if(positionInfo.count()>0)
           {
            trade.PositionCloseAll(POSITION_TYPE_SELL);
           }
         stochCanSell=false;
        }
      return;
     }
   else
     {
      buyLock=false;
     }
   if(bbCanSell)
     {
      signal="sell";
      if(sellLock)
        {
         return;
        }
      if(!stochCanSell)
        {
         if(stochCanSell)
           {
            if(positionInfo.count()>0)
              {
               trade.PositionCloseAll(POSITION_TYPE_BUY);
              }
            trade.Sell(1.0,Symbol(),symbolInfo.Ask());
            stochCanBuy=false;
           }
        }
      buyLock=false;
      sellLock=true;
     }
   else
     {
      sellLock=false;
     }
  }

//+------------------------------------------------------------------+
