//+-----------------------------------------------------------------------------------------------+
//|                                             BBStochStrategy.mqh                               |
//|                                this bot work with BBand and stoch strategy                    |
//|                                when bband has buy signal and then stoch has buy it will buy   |
//|                               when bband has sell signal and then stoch has sell it will sell |
//|                               this bot just show ma(45) slop and comments it                  |
//|                               this bot will not trail stoploss                                |
//+-----------------------------------------------------------------------------------------------+
#include <Jooya/Strategy.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/DealInfo.mqh>
#include <Jooya/MaManager.mqh>
#include <Jooya/TrailingManager.mqh>

#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

class BBStochStrategy : public Strategy
  {
private:
   //==============[ bb properties ]===============
   bool              buyLock;
   bool              sellLock;

   bool              bbCanSell;
   bool              bbCanBuy;
   //==============[ stoch properties ]===============
   double            KArray[];
   double            DArray[];
   bool              stochCanBuy;
   bool              stochCanSell;
   //==============[ ma properties ]===============
   MaManager         mam;
   
   //==============[ trailing properties ]===============
   TrailingManager   tm;
   bool              trailBuy;
   bool              trailSell;

public:
                     BBStochStrategy();
                    ~BBStochStrategy();
   void              Run();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBStochStrategy::BBStochStrategy()
  {
   buyLock=false;
   sellLock=false;
   bbCanBuy=false;
   bbCanSell=false;


   stochCanBuy=false;
   stochCanSell=false;

   trailBuy=false;
   trailSell=false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBStochStrategy::~BBStochStrategy()
  {
  }
//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBStochStrategy::Run()
  {
   string comment ="";
   
   MqlRates Prices[];
   datetime dt;
   ArraySetAsSeries(Prices,true);
//int count=CopyRates(Symbol(),Period(),0,Bars(Symbol(),Period()),Prices);
   int count = CopyRates(Symbol(),Period(),0,10,Prices);
   
   double maArray[];
   int maHandle= iMA(Symbol(),Period(),45,0,MODE_SMA,PRICE_CLOSE);
   CopyBuffer(maHandle,0,1,10,maArray);
   ArraySetAsSeries(maArray,true);
   double angle=mam.angle(Prices,maArray);
   comment+="angle => "+angle+"\n";
   
   
   ArraySetAsSeries(KArray,true);
   ArraySetAsSeries(DArray,true);
   int StochHandle = iStochastic(Symbol(),Period(),18,9,9,MODE_SMA,STO_LOWHIGH);
   CopyBuffer(StochHandle,0,1,2,KArray);
   CopyBuffer(StochHandle,1,1,2,DArray);

   string signal="";
   double midBandArray[];
   double upperBandArray[];
   double lowerBandArray[];

   ArraySetAsSeries(midBandArray,true);
   ArraySetAsSeries(upperBandArray,true);
   ArraySetAsSeries(lowerBandArray,true);

   int bbHandl=iBands(Symbol(),Period(),20,0,2.5,PRICE_CLOSE);

   CopyBuffer(bbHandl,0,0,3,midBandArray);
   CopyBuffer(bbHandl,1,0,3,upperBandArray);
   CopyBuffer(bbHandl,2,0,3,lowerBandArray);
//------- one canle close under and next close up of lower bnand
   if(!bbCanBuy)
     {
      //bbCanBuy=Prices[0].low<=lowerBandArray[0]&&Prices[0].high>=lowerBandArray[0];
      bbCanBuy=Prices[2].close<=lowerBandArray[2]&&Prices[1].close>=lowerBandArray[1];
      if(bbCanBuy)
        {
         bbCanSell=false;
        }
     }
   if(!bbCanSell)
     {
      //bbCanSell=Prices[0].low<=upperBandArray[0]&&Prices[0].high>=upperBandArray[0];
      bbCanSell=Prices[2].close>=upperBandArray[2]&&Prices[1].close<=upperBandArray[1];
      if(bbCanSell)
        {
         bbCanBuy=false;
        }
     }
   if(!stochCanBuy)
     {
      stochCanBuy=CrossOver(KArray,DArray);
      if(stochCanBuy)
        {
         stochCanSell=false;
        }
     }
   if(!stochCanSell)
     {
      stochCanSell=CrossOver(DArray,KArray);
      if(stochCanSell)
        {
         stochCanBuy=false;
        }
     }

   if((bbCanBuy&&bbCanSell)||(stochCanBuy&&stochCanSell))
     {
      return;
     }

   if(bbCanBuy&&stochCanBuy)
     {
      if(buyLock)
        {
         return;
        }
      trade.Buy(1.0,Symbol(),symbolInfo.Ask());
      buyLock=true;
      sellLock=false;

      if(positionInfo.count()>0)
        {
         trade.PositionCloseAll(POSITION_TYPE_SELL);
        }
      return;
     }
   if(bbCanSell&&stochCanSell)
     {
      if(sellLock)
        {
         return;
        }
      trade.Sell(1.0,Symbol(),symbolInfo.Bid());
      buyLock=false;
      sellLock=true;
      if(positionInfo.count()>0)
        {
         trade.PositionCloseAll(POSITION_TYPE_BUY);
        }
     }
   comment+="bbCanBuy     => "+bbCanBuy+"\n";
   comment+="bbCanSell    => "+bbCanSell+"\n";
   comment+="stochCanBuy  => "+stochCanBuy+"\n";
   comment+="stochCanSell => "+stochCanSell+"\n";
   Comment(comment);
  }

//+------------------------------------------------------------------+
