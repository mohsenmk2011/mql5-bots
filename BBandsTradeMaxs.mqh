//+------------------------------------------------------------------+
//|                                              BBandsTradeMaxs.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|       trade the maximizes=> when prices goes over from bands(lower or upper)       |
//|       it will trade oppsite of trend       |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Jooya/Strategy.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/DealInfo.mqh>
#include <Jooya/MaManager.mqh>

#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BBandsTradeMaxs : public Strategy
{
private:
   bool              buyLock;
   bool              sellLock;

   bool              canSell;
   bool              canBuy;

   bool              trailBuy;
   bool              trailSell;

   TrailingManager   tm;
   PositionManager   pm;
   MaManager         mam;
   string            comment;
   string            positionComment;

   bool              IsMidLineStraight(double midLine);
   bool              IsMidLineGoingDown(double midLine);
   bool              IsMidLineGoingUp(double midLine);

   bool              IsPriceTouchedTop(MqlRates& prices[],double& line[]);
   bool              IsPriceTouchedDown(MqlRates& prices[],double& line[]);
   bool              IsPricePassedUp(MqlRates& prices[],double& line[]);
   bool              IsPricePassedDown(MqlRates& prices[],double& line[]);

public:
   BBandsTradeMaxs();
   ~BBandsTradeMaxs();
   void              Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsTradeMaxs::BBandsTradeMaxs()
{
   buyLock=false;
   sellLock=false;
   canBuy=false;
   canSell=false;

   this.comment="";
   this.positionComment="";
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsTradeMaxs::~BBandsTradeMaxs()
{
}
//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBandsTradeMaxs::Run()
{
   this.comment="";
   this.positionComment="";

//+----------------------------[ copy rates ]-----------------------------+
   MqlRates Prices[];
   ArraySetAsSeries(Prices,true);
   int count = CopyRates(Symbol(),Period(),0,10,Prices);
//+--------------------------[ bbands indicator ]-------------------------+
   double midBandArray[];
   double upperBandArray[];
   double lowerBandArray[];

   ArraySetAsSeries(midBandArray,true);
   ArraySetAsSeries(upperBandArray,true);
   ArraySetAsSeries(lowerBandArray,true);

   int bbHandl=iBands(Symbol(),Period(),20,0,2.0,PRICE_CLOSE);

   CopyBuffer(bbHandl,0,0,10,midBandArray);
   CopyBuffer(bbHandl,1,0,10,upperBandArray);
   CopyBuffer(bbHandl,2,0,10,lowerBandArray);
//+--------------------[ bband mide line Angle ]--------------------------------+
   double bbMidLineAngle= NormalizeDouble(mam.angle(Prices,midBandArray),2);
   comment+="bbMidLineAngle => "+bbMidLineAngle+"\n";
//+--------------------------[ atr indicator ]-------------------------+
   int atrHandle=iATR(Symbol(),Period(),14);
   double atrArray[];
   ArraySetAsSeries(atrArray,true);
   CopyBuffer(atrHandle,0,0,3,atrArray);
   double atrValue=NormalizeDouble(atrArray[0],5);
   double stoplossPoint=atrValue*100000;
//+--------------------------[ signals ]-------------------------+
   bool isGreenCanlde=Prices[0].close>Prices[0].open;
   bool isRedCanlde=Prices[0].open>Prices[0].close;
   if(isGreenCanlde&& Prices[0].close>=upperBandArray[0]+atrValue)//sell and close buy positions
   {
      //trade.PositionCloseAll(POSITION_TYPE_BUY);
      if(positionInfo.sellCount()==0)
      {        
         trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01));
      }
   }
   else if(isRedCanlde&& Prices[0].close<=lowerBandArray[0]-atrValue) //buy and close sell positions
   {
      //trade.PositionCloseAll(POSITION_TYPE_SELL);
      if(positionInfo.buyCount()==0)
      {
         trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01));
      }
   }
   tm.trailWithAtr();


   Comment(this.comment+tm.comment);
}
//+------------------------------------------------------------------+
//|                  Is MidLine Straight                             |
//+------------------------------------------------------------------+
bool BBandsTradeMaxs::IsMidLineStraight(double angle)
{
   return angle>=-33.3&&angle<=33.3;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going down                             |
//+------------------------------------------------------------------+
bool BBandsTradeMaxs::IsMidLineGoingDown(double angle)
{
   return angle<=33.3;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going up                            |
//+------------------------------------------------------------------+
bool BBandsTradeMaxs::IsMidLineGoingUp(double angle)
{
   return angle>=33.3;
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Top                             |
//+------------------------------------------------------------------+
bool BBandsTradeMaxs::IsPriceTouchedTop(MqlRates& prices[],double& line[])
{
   return prices[2].close>=line[2]&&prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Down                            |
//+------------------------------------------------------------------+
bool BBandsTradeMaxs::IsPriceTouchedDown(MqlRates& prices[],double& line[])
{
   return prices[2].close<=line[2]&&prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Up                              |
//+------------------------------------------------------------------+
bool BBandsTradeMaxs::IsPricePassedUp(MqlRates& prices[],double& line[])
{
   return prices[2].close<=line[2]&&prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Down                            |
//+------------------------------------------------------------------+
bool BBandsTradeMaxs::IsPricePassedDown(MqlRates& prices[],double& line[])
{
   return prices[2].close>=line[2]&&prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
