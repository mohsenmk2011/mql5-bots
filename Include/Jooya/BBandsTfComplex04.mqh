//+------------------------------------------------------------------+
//|                                            BBandsTfComplex04.mqh(intial code from BBandsTfComplex02) |
//|                                            Copyright 2022, Jooya |
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
class BBandsTfComplex04 : public Strategy
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

   bool M1MidIsStright;
   bool M5MidIsStright;
   bool M15MidIsStright;
   bool M30MidIsStright;
   bool H1MidIsStright;
   bool H4MidIsStright;

public:
   BBandsTfComplex04();
   ~BBandsTfComplex04();
   void              Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsTfComplex04::BBandsTfComplex04()
{
   buyLock=false;
   sellLock=false;
   canBuy=false;
   canSell=false;

   M1MidIsStright=false;
   M5MidIsStright=false;
   M15MidIsStright=false;
   M30MidIsStright=false;
   H1MidIsStright=false;
   H4MidIsStright=false;

   this.comment="";

}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsTfComplex04::~BBandsTfComplex04()
{
}
//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBandsTfComplex04::Run()
{
   this.comment="";

//+----------------------------[ M1 copy rates ]-----------------------------+
   MqlRates M1Prices[];
   ArraySetAsSeries(M1Prices,true);
   CopyRates(Symbol(),PERIOD_M1,0,10,M1Prices);
   //+----------------------------[ M5 copy rates ]-----------------------------+
   MqlRates M5Prices[];
   ArraySetAsSeries(M5Prices,true);
   CopyRates(Symbol(),PERIOD_M5,0,10,M5Prices);
   //+----------------------------[ M15 copy rates ]-----------------------------+
   MqlRates M15Prices[];
   ArraySetAsSeries(M15Prices,true);
   CopyRates(Symbol(),PERIOD_M15,0,10,M15Prices);
   //+----------------------------[ M30 copy rates ]-----------------------------+
   MqlRates M30Prices[];
   ArraySetAsSeries(M30Prices,true);
   CopyRates(Symbol(),PERIOD_M30,0,10,M30Prices);
//+----------------------------[ H1 copy rates ]-----------------------------+
   MqlRates H1Prices[];
   ArraySetAsSeries(H1Prices,true);
   CopyRates(Symbol(),PERIOD_H1,0,10,H1Prices);
//+----------------------------[ H4 copy rates ]-----------------------------+
   MqlRates H4Prices[];
   ArraySetAsSeries(H4Prices,true);
   CopyRates(Symbol(),PERIOD_H4,0,10,H4Prices);
   //+--------------------------[ M1 bbands indicator ]-------------------------+
   double M1MidBandArray[];
   double M1UpperBandArray[];
   double M1LowerBandArray[];

   ArraySetAsSeries(M1MidBandArray,true);
   ArraySetAsSeries(M1UpperBandArray,true);
   ArraySetAsSeries(M1LowerBandArray,true);

   int M1BBHandl=iBands(Symbol(),PERIOD_M1,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M1BBHandl,0,0,10,M1MidBandArray);
   CopyBuffer(M1BBHandl,1,0,10,M1UpperBandArray);
   CopyBuffer(M1BBHandl,2,0,10,M1LowerBandArray);
   //+--------------------------[ M5 bbands indicator ]-------------------------+
   double M5MidBandArray[];
   double M5UpperBandArray[];
   double M5LowerBandArray[];

   ArraySetAsSeries(M5MidBandArray,true);
   ArraySetAsSeries(M5UpperBandArray,true);
   ArraySetAsSeries(M5LowerBandArray,true);

   int M5BBHandl=iBands(Symbol(),PERIOD_M5,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M5BBHandl,0,0,10,M5MidBandArray);
   CopyBuffer(M5BBHandl,1,0,10,M5UpperBandArray);
   CopyBuffer(M5BBHandl,2,0,10,M5LowerBandArray);
   //+--------------------------[ M15 bbands indicator ]-------------------------+
   double M15MidBandArray[];
   double M15UpperBandArray[];
   double M15LowerBandArray[];

   ArraySetAsSeries(M15MidBandArray,true);
   ArraySetAsSeries(M15UpperBandArray,true);
   ArraySetAsSeries(M15LowerBandArray,true);

   int M15BBHandl=iBands(Symbol(),PERIOD_M15,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M15BBHandl,0,0,10,M15MidBandArray);
   CopyBuffer(M15BBHandl,1,0,10,M15UpperBandArray);
   CopyBuffer(M15BBHandl,2,0,10,M15LowerBandArray);
   //+--------------------------[ M30 bbands indicator ]-------------------------+
   double M30MidBandArray[];
   double M30UpperBandArray[];
   double M30LowerBandArray[];

   ArraySetAsSeries(M30MidBandArray,true);
   ArraySetAsSeries(M30UpperBandArray,true);
   ArraySetAsSeries(M30LowerBandArray,true);

   int M30BBHandl=iBands(Symbol(),PERIOD_M30,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M30BBHandl,0,0,10,M30MidBandArray);
   CopyBuffer(M30BBHandl,1,0,10,M30UpperBandArray);
   CopyBuffer(M30BBHandl,2,0,10,M30LowerBandArray);
//+--------------------------[ H1 bbands indicator ]-------------------------+
   double h1MidBandArray[];
   double h1UpperBandArray[];
   double h1LowerBandArray[];

   ArraySetAsSeries(h1MidBandArray,true);
   ArraySetAsSeries(h1UpperBandArray,true);
   ArraySetAsSeries(h1LowerBandArray,true);

   int h1BBHandl=iBands(Symbol(),PERIOD_H1,20,0,2.0,PRICE_CLOSE);

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
   //+--------------------[ M1 bband mide line Angle ]--------------------------------+
   double M1BBMidLineAngle= NormalizeDouble(mam.angle(M1Prices,M1MidBandArray),2);
   comment+="M1 BBMidLineAngle => "+M1BBMidLineAngle+"\n";
   //+--------------------[ M5 bband mide line Angle ]--------------------------------+
   double M5BBMidLineAngle= NormalizeDouble(mam.angle(M5Prices,M5MidBandArray),2);
   comment+="M5 BBMidLineAngle => "+M5BBMidLineAngle+"\n";
   //+--------------------[ M15 bband mide line Angle ]--------------------------------+
   double M15BBMidLineAngle= NormalizeDouble(mam.angle(M15Prices,M15MidBandArray),2);
   comment+="M15 BBMidLineAngle => "+M15BBMidLineAngle+"\n";
   //+--------------------[ M30 bband mide line Angle ]--------------------------------+
   double M30BBMidLineAngle= NormalizeDouble(mam.angle(M30Prices,M30MidBandArray),2);
   comment+="M30 BBMidLineAngle => "+M30BBMidLineAngle+"\n";
//+--------------------[ H1 bband mide line Angle ]--------------------------------+
   double h1BBMidLineAngle= NormalizeDouble(mam.angle(H1Prices,h1MidBandArray),2);
   comment+="h1 BBMidLineAngle => "+h1BBMidLineAngle+"\n";
//+--------------------[ H4 bband mide line Angle ]--------------------------------+
   double h4BBMidLineAngle= NormalizeDouble(mam.angle(H4Prices,h4MidBandArray),2);
   comment+="h4 BBMidLineAngle => "+h4BBMidLineAngle+"\n";
//+--------------------[  bbands height ]--------------------------------+
   double M1BBandsHeight= (M1UpperBandArray[0]-M1LowerBandArray[0])*(1/Point());
   bool CanTradeInM1=(symbolInfo.Spread()<=18)&&((M1BBandsHeight/symbolInfo.Spread())>=0.9);
   comment+="M1BBandsHeight => "+M1BBandsHeight+"\n";
   comment+="si.Spread() => "+symbolInfo.Spread()+"\n";
   comment+="CanTradeInM1 => "+CanTradeInM1+"\n";
//+--------------------------[      signals                signals           signals     ]-------------------------+
   if(IsMidLineStraight(M1BBMidLineAngle))
   {
      M1MidIsStright=true;
   }
   if(IsMidLineStraight(M5BBMidLineAngle))
   {
      M5MidIsStright=true;
   }
   if(IsMidLineStraight(M15BBMidLineAngle))
   {
      M15MidIsStright=true;
   }
   if(IsMidLineStraight(M30BBMidLineAngle))
   {
      M30MidIsStright=true;
   }
   if(IsMidLineStraight(h1BBMidLineAngle))
   {
      H1MidIsStright=true;
   }
   if(IsMidLineStraight(h4BBMidLineAngle))
   {
      H4MidIsStright=true;
   }

   if(IsPriceTouchedTop(M1Prices,M1UpperBandArray))
   {
      //sell
      trade.PositionCloseAll(POSITION_TYPE_SELL);
      if(positionInfo.buyCount()==0&&CanTradeInM1)
      {
         trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01));
      }
   }
   else if(IsPriceTouchedDown(M1Prices,M1LowerBandArray))
   {
      //buy
      trade.PositionCloseAll(POSITION_TYPE_BUY);
      if(positionInfo.sellCount()==0&&CanTradeInM1)
      {
         trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01));
      }
   }
   if(IsPricePassedDown(M1Prices,M1MidBandArray))
   {
      //sell
      if(positionInfo.sellCount()==0&&CanTradeInM1)
      {
         trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01));
      }
   }
   if(IsPricePassedUp(M1Prices,M1MidBandArray))
   {
      if(positionInfo.sellCount()==0&&CanTradeInM1)
      {
         trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01));
      }
   }


   Comment(this.comment+tm.comment);
}
//+------------------------------------------------------------------+
//|                  Is MidLine Straight                             |
//+------------------------------------------------------------------+
bool BBandsTfComplex04::IsMidLineStraight(double angle)
{
   return angle>=-27&&angle<=27;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going down                             |
//+------------------------------------------------------------------+
bool BBandsTfComplex04::IsMidLineGoingDown(double angle)
{
   return angle<=27;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going up                            |
//+------------------------------------------------------------------+
bool BBandsTfComplex04::IsMidLineGoingUp(double angle)
{
   return angle>=27;
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Top                             |
//+------------------------------------------------------------------+
bool BBandsTfComplex04::IsPriceTouchedTop(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close>=line[2]&&H1Prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Down                            |
//+------------------------------------------------------------------+
bool BBandsTfComplex04::IsPriceTouchedDown(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close<=line[2]&&H1Prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Up                              |
//+------------------------------------------------------------------+
bool BBandsTfComplex04::IsPricePassedUp(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close<=line[2]&&H1Prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Down                            |
//+------------------------------------------------------------------+
bool BBandsTfComplex04::IsPricePassedDown(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close>=line[2]&&H1Prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
