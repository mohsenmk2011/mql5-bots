//+------------------------------------------------------------------+
//|                                                BBandsMaAngle.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+/
#include <Jooya/Strategy.mqh>
#include <Jooya/MaManager.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/DealInfo.mqh>

#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BBandsMaAngle : public Strategy
  {
private:
   bool              buyLock;
   bool              sellLock;

   bool              canSell;
   bool              canBuy;

   bool              trailBuy;
   bool              trailSell;

   TrailingManager   tm;
   MaManager         mam;
public:
                     BBandsMaAngle();
                    ~BBandsMaAngle();
   void              Run();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsMaAngle::BBandsMaAngle()
  {
   buyLock=false;
   sellLock=false;
   canBuy=false;
   canSell=false;
   trailBuy=true;
   trailSell=true;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsMaAngle::~BBandsMaAngle()
  {
  }
//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBandsMaAngle::Run()
  {
   string comment="";

//+------------------------------------------------------------------+
//|                    calculate angle of ma                         |
//+------------------------------------------------------------------+
//+---------------------[ get prices ]-----------------+
   MqlRates Prices[];
   ArraySetAsSeries(Prices,true);
   int count = CopyRates(Symbol(),Period(),0,10,Prices);
//+--------------------[ get ma ]----------------------+
   double maArray[];
   int maHandle= iMA(Symbol(),Period(),270,0,MODE_SMA,PRICE_CLOSE);
   CopyBuffer(maHandle,0,1,10,maArray);
   ArraySetAsSeries(maArray,true);
   double angle=mam.angle(Prices,maArray);
   comment+="angle => "+angle+"\n";

//+--------------------[ get bbands indicator ]----------------------+
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

//+--------------------[  bbands signals ]----------------------+
//if(!canBuy)
//{
//}
//if(!canSell)
//{
//}
   canBuy=Prices[2].close<=lowerBandArray[2]&&Prices[1].close>=lowerBandArray[1];
   canSell=Prices[2].close>=upperBandArray[2]&&Prices[1].close<=upperBandArray[1];

   if(canBuy&&canSell)
     {
      return;
     }

   if(canBuy)
     {
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
         tm.trailWithBalanceFraction(0.001);
        }
      else
        {
         trailBuy=true;
         //trailBuy=Prices[1].low<=upperBandArray[1]&&Prices[1].high>=upperBandArray[1];
         //trailBuy=angle>=0&&angle<=22.5;
         //trailBuy=angle>=-22.5&&angle<=22.5;
        }

      if(trailSell)
        {
         //tm.trail(POSITION_TYPE_SELL);
         //tm.trailWithAtr();
         tm.trailWithBalanceFraction(0.001);
        }
      else
        {
         trailSell=true;
         //trailSell=Prices[1].low<=lowerBandArray[1]&&Prices[1].high>=lowerBandArray[1];
         //trailSell=angle>=-22.5&&angle<=0 ;
         //trailSell=angle>=-22.5&&angle<=22.5;
        }
     }
   Comment(comment+tm.comment);
  }

//+------------------------------------------------------------------+
