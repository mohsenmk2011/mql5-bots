//+------------------------------------------------------------------------------+
//|                                                  bbAtHighLow.mqh             |
//|       this bot will buy and sell at high and low of bbands                   |
//|                                             https://www.mql5.com          |
//+------------------------------------------------------------------------------+
#include <Jooya/Strategy.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/DealInfo.mqh>
#include <Jooya/LineManager.mqh>

#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BBAtHighLow : public Strategy
{
private:
   bool              buyLock;
   bool              sellLock;

   bool              sellSignal;
   bool              buySignal;

   bool              trailBuy;
   bool              trailSell;

   TrailingManager   tm;
   PositionManager   pm;
   LineManager lm;
   string            comment;

public:
   BBAtHighLow();
   ~BBAtHighLow();
   void              Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBAtHighLow::BBAtHighLow()
{
   buyLock=false;
   sellLock=false;
   buySignal=false;
   sellSignal=false;

   this.comment="";
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBAtHighLow::~BBAtHighLow()
{
}
//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBAtHighLow::Run()
{
   this.comment="";
//+--------------------[ copy rates ]--------------------------------+
   MqlRates Prices[];
   ArraySetAsSeries(Prices,true);
   int count = CopyRates(Symbol(),Period(),0,10,Prices);
//+--------------------[ ma 270 ma270Angle ]--------------------------------+
   double maArray[];
   int maHandle= iMA(Symbol(),Period(),270,0,MODE_SMA,PRICE_CLOSE);
   CopyBuffer(maHandle,0,1,10,maArray);
   ArraySetAsSeries(maArray,true);
   double ma270Angle= lm.angle(Prices,maArray);
   comment+="MA Angle (270) => "+ma270Angle+"\n";
//+-------------------- initioal bbands indicator--------------------------------+
   double midBandArray[];
   double upperBandArray[];
   double lowerBandArray[];

   ArraySetAsSeries(midBandArray,true);
   ArraySetAsSeries(upperBandArray,true);
   ArraySetAsSeries(lowerBandArray,true);

   int bbHandl=iBands(Symbol(),Period(),20,0,2.0,PRICE_CLOSE);

   CopyBuffer(bbHandl,0,0,3,midBandArray);
   CopyBuffer(bbHandl,1,0,3,upperBandArray);
   CopyBuffer(bbHandl,2,0,3,lowerBandArray);

//+-------------------- bbands signals--------------------------------+
   buySignal=Prices[0].low<lowerBandArray[0]&&ma270Angle>=-11.25;
   sellSignal=Prices[0].high>upperBandArray[0]&& ma270Angle<=11.25;

   sellSignal=Prices[0].high>upperBandArray[0]&& ma270Angle<=11.25;

   if(buySignal&&sellSignal)
   {
      return;
   }
   if(buySignal)
   {
      if(buyLock)
      {
         return;
      }
      if(positionInfo.count()>0)
      {
         trade.PositionCloseAll(POSITION_TYPE_SELL);
      }
      trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01));
      buyLock=true;
      sellLock=false;
      return;
   }
   else
   {
      buyLock=false;
   }
   if(sellSignal)
   {
      if(sellLock)
      {
         return;
      }
      if(positionInfo.count()>0)
      {
         trade.PositionCloseAll(POSITION_TYPE_BUY);
      }
      trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01));
      buyLock=false;
      sellLock=true;
   }
   else
   {
      sellLock=false;
   }
   if(trailBuy)
   {
      if(positionInfo.buyCount()==0)
      {
         trailBuy=false;
      }
   }
   if(trailSell)
   {
      if(positionInfo.sellCount()==0)
      {
         trailSell=false;
      }
   }
   if(positionInfo.count()>0)
   {
      if(trailBuy)
      {
         //tm.trail(POSITION_TYPE_BUY);
         //tm.trailWithAtr();
      }
      else
      {
         trailBuy=Prices[1].low<=upperBandArray[1]&&Prices[1].high>=upperBandArray[1];
      }

      if(trailSell)
      {
         //tm.trail(POSITION_TYPE_SELL);
         //tm.trailWithAtr();
         // tm.trailWithBalanceFraction(0.01);
      }
      else
      {
         trailSell=Prices[1].low<=lowerBandArray[1]&&Prices[1].high>=lowerBandArray[1];

      }

   }
//tm.trailWithBalanceFraction(0.01);//---

   Comment(this.comment+tm.comment);
}

//+------------------------------------------------------------------+
