//+------------------------------------------------------------------+
//|                                       BBandsMidLineComplex03.mqh |
// when price passed mid line in m15
//look at m5
// if mid line angle in m5 is going down -> sell and opsit buy
//|                                  Copyright 2022, MetaQuotes Ltd. |
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
class BBandsMidLineComplex03 : public Strategy
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

   bool              IsMidLineStraight(double midLine);
   bool              IsMidLineGoingDown(double midLine);
   bool              IsMidLineGoingUp(double midLine);

   bool              IsPriceTouchedTop(MqlRates& H1Prices[],double& line[]);
   bool              IsPriceTouchedDown(MqlRates& H1Prices[],double& line[]);
   bool              IsPricePassedUp(MqlRates& H1Prices[],double& line[]);
   bool              IsPricePassedDown(MqlRates& H1Prices[],double& line[]);

public:
   BBandsMidLineComplex03();
   ~BBandsMidLineComplex03();
   void              Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsMidLineComplex03::BBandsMidLineComplex03()
{
   buyLock=false;
   sellLock=false;
   canBuy=false;
   canSell=false;

   this.comment="";
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsMidLineComplex03::~BBandsMidLineComplex03()
{
}
//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBandsMidLineComplex03::Run()
{
   this.comment="";

//+----------------------------[ H1 copy rates ]-----------------------------+
   MqlRates H1Prices[];
   ArraySetAsSeries(H1Prices,true);
   CopyRates(Symbol(),Period(),0,10,H1Prices);
//+----------------------------[ H4 copy rates ]-----------------------------+
   MqlRates H4Prices[];
   ArraySetAsSeries(H4Prices,true);
   CopyRates(Symbol(),PERIOD_H4,0,10,H4Prices);
//+--------------------------[ H1 bbands indicator ]-------------------------+
   double h1MidBandArray[];
   double h1UpperBandArray[];
   double h1LowerBandArray[];

   ArraySetAsSeries(h1MidBandArray,true);
   ArraySetAsSeries(h1UpperBandArray,true);
   ArraySetAsSeries(h1LowerBandArray,true);

   int h1BBHandl=iBands(Symbol(),Period(),20,0,2.0,PRICE_CLOSE);

   CopyBuffer(h1BBHandl,0,0,10,h1MidBandArray);
   CopyBuffer(h1BBHandl,1,0,10,h1UpperBandArray);
   CopyBuffer(h1BBHandl,2,0,10,h1LowerBandArray);
//+--------------------------[ H4 bbands indicator ]-------------------------+
   double h4MidBandArray[];
   double h4UpperBandArray[];
   double h4LlowerBandArray[];

   ArraySetAsSeries(h4MidBandArray,true);
   ArraySetAsSeries(h4UpperBandArray,true);
   ArraySetAsSeries(h4LlowerBandArray,true);

   int h4BBHandl=iBands(Symbol(),PERIOD_H4,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(h4BBHandl,0,0,10,h4MidBandArray);
   CopyBuffer(h4BBHandl,1,0,10,h4UpperBandArray);
   CopyBuffer(h4BBHandl,2,0,10,h4LlowerBandArray);
//+--------------------[ H1 bband mide line Angle ]--------------------------------+
   double h1BBMidLineAngle= NormalizeDouble(mam.angle(H1Prices,h1MidBandArray),2);
   comment+="h1BBMidLineAngle => "+h1BBMidLineAngle+"\n";
//+--------------------[ H4 bband mide line Angle ]--------------------------------+
   double h4BBMidLineAngle= NormalizeDouble(mam.angle(H4Prices,h4MidBandArray),2);
   comment+="h4BBMidLineAngle => "+h4BBMidLineAngle+"\n";
//+--------------------------[ signals ]-------------------------+
   if(IsMidLineGoingDown(h4BBMidLineAngle)&&IsMidLineGoingDown(h1BBMidLineAngle)&&H1Prices[0].close<h1MidBandArray[0])
   {
      if(positionInfo.sellCount()==0)
      {
         trade.Sell(pm.newPositionVolume(100),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01));
      }
   }////////////////////////////////////////////////////
   else if(IsMidLineGoingUp(h4BBMidLineAngle)&&IsMidLineGoingUp(h1BBMidLineAngle)&&H1Prices[0].close>h1MidBandArray[0])//buy signal
   {
      if(positionInfo.buyCount()==0)
      {
         trade.Buy(pm.newPositionVolume(100),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01));
      }
   }
   else if(IsPricePassedDown(H1Prices,h1MidBandArray))
   {
      trade.PositionCloseAll(POSITION_TYPE_BUY);
   }
   else if(IsPricePassedUp(H1Prices,h1MidBandArray))
   {
      trade.PositionCloseAll(POSITION_TYPE_SELL);
   }
   //tm.trailWithBalanceFraction(0.01);
   Comment(this.comment+tm.comment);
}
//+------------------------------------------------------------------+
//|                  Is MidLine Straight                             |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex03::IsMidLineStraight(double angle)
{
   return angle>=-11.25&&angle<=11.25;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going down                             |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex03::IsMidLineGoingDown(double angle)
{
   return angle<=-11.25;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going up                            |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex03::IsMidLineGoingUp(double angle)
{
   return angle>=11.25;
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Top                             |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex03::IsPriceTouchedTop(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close>=line[2]&&H1Prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Down                            |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex03::IsPriceTouchedDown(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close<=line[2]&&H1Prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Up                              |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex03::IsPricePassedUp(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close<=line[2]&&H1Prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Down                            |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex03::IsPricePassedDown(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close>=line[2]&&H1Prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
