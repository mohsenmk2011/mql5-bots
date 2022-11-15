//+------------------------------------------------------------------+
//|                                                BBandsMidLine02.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+/
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
class BBandsMidLine02 : public Strategy
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
   BBandsMidLine02();
   ~BBandsMidLine02();
   void              Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsMidLine02::BBandsMidLine02()
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
BBandsMidLine02::~BBandsMidLine02()
{
}
//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBandsMidLine02::Run()
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
//+--------------------------[ signals ]-------------------------+
   if(IsMidLineStraight(bbMidLineAngle)&&false)
   {
      comment+="bbMidLine => straight \n";
      if(IsPriceTouchedTop(Prices,upperBandArray))//sell and close buy positions
      {
         trade.PositionCloseAll(POSITION_TYPE_BUY);
         if(positionInfo.sellCount()==0)
         {
            this.positionComment="bbMidLine Is Straigh,Price Touched top,so sell.";
            Print(this.positionComment);
            trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01),0,positionComment);
         }
      }
      else if(IsPriceTouchedDown(Prices,lowerBandArray)) //buy and close sell positions
      {
         trade.PositionCloseAll(POSITION_TYPE_SELL);
         if(positionInfo.buyCount()==0)
         {
            trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01),0,"bbMidLine Is Straigh,Price Touched down,so buy.");
         }
      }
   }

//+------------------------------------------------------------------+
   if(IsPricePassedUp(Prices,midBandArray))//close sell position
   {
      if(positionInfo.buyCount()==0&&!IsMidLineStraight(bbMidLineAngle))
      {
         trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01),0,"bbMidLine Is goin up,Price passed up,so buy.");
      }
      trade.PositionCloseAll(POSITION_TYPE_SELL);
   }
   else if(IsPricePassedDown(Prices,midBandArray)) //open a sell position
   {
      if(positionInfo.sellCount()==0)
      {
         trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01),0,"bbMidLine Is goin down,Price passed down,so sell.");
      }
      trade.PositionCloseAll(POSITION_TYPE_BUY);
   }
   Comment(this.comment+tm.comment);
}
//+------------------------------------------------------------------+
//|                  Is MidLine Straight                             |
//+------------------------------------------------------------------+
bool BBandsMidLine02::IsMidLineStraight(double angle)
{
   return angle>=-33.3&&angle<=33.3;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going down                             |
//+------------------------------------------------------------------+
bool BBandsMidLine02::IsMidLineGoingDown(double angle)
{
   return angle<=33.3;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going up                            |
//+------------------------------------------------------------------+
bool BBandsMidLine02::IsMidLineGoingUp(double angle)
{
   return angle>=33.3;
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Top                             |
//+------------------------------------------------------------------+
bool BBandsMidLine02::IsPriceTouchedTop(MqlRates& prices[],double& line[])
{
   return prices[2].close>=line[2]&&prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Down                            |
//+------------------------------------------------------------------+
bool BBandsMidLine02::IsPriceTouchedDown(MqlRates& prices[],double& line[])
{
   return prices[2].close<=line[2]&&prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Up                              |
//+------------------------------------------------------------------+
bool BBandsMidLine02::IsPricePassedUp(MqlRates& prices[],double& line[])
{
   return prices[2].close<=line[2]&&prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Down                            |
//+------------------------------------------------------------------+
bool BBandsMidLine02::IsPricePassedDown(MqlRates& prices[],double& line[])
{
   return prices[2].close>=line[2]&&prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
