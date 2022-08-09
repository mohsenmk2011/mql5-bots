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
   bool              buyLock;
   bool              sellLock;

   bool              canSell;
   bool              canBuy;

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
   canBuy=false;
   canSell=false;
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

   canBuy=Prices[2].close<=lowerBandArray[2]&&Prices[1].close>=lowerBandArray[1];
   canSell=Prices[2].close>=upperBandArray[2]&&Prices[1].close<=upperBandArray[1];

   if(canBuy&&canSell)
     {
      return;
     }

   if(canBuy)
     {
      signal="buy";
      if(buyLock)
        {
         return;
        }
      if(positionInfo.count()>0)
        {
        trade.PositionCloseAll(POSITION_TYPE_SELL);
        }
      trade.Buy(1.0,Symbol(),symbolInfo.Ask());
      buyLock=true;
      sellLock=false;
      return;
     }
   else
     {
      buyLock=false;
     }
   if(canSell)
     {
      signal="sell";
      if(sellLock)
        {
         return;
        }
      if(positionInfo.count()>0)
        {
        trade.PositionCloseAll(POSITION_TYPE_BUY);
        }
      trade.Sell(1.0,Symbol(),symbolInfo.Ask());
      buyLock=false;
      sellLock=true;
     }
   else
     {
      sellLock=false;
     }
  }

//+------------------------------------------------------------------+
