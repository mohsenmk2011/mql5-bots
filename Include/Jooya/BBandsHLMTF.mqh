//+------------------------------------------------------------------------------------------------------+
//|               BBandsHLMTF.mqh => Bollinger Bands High And Low Multi Time Frames                      |
//|                                            Copyright 2022, Jooya                                     |
//| This bot will trade when price passed from upper or lower bands in H1,then in M1 or M5 when a buy or |
//| sell signal appears will trade.                                                                      |
//+------------------------------------------------------------------------------------------------------+
#include <Jooya/Strategy.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/DealInfo.mqh>
#include <Jooya/MaManager.mqh>
#include <jooya/BBandsStatus.mqh>

#property copyright "Copyright 2022, Jooya"
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BBandsHLMTF : public Strategy
{
private:
   TrailingManager   tm;
   PositionManager   pm;
   MaManager         mam;
   string            comment;

public:
                     BBandsHLMTF();
                    ~BBandsHLMTF();
   void              Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsHLMTF::BBandsHLMTF()
{
   this.comment="";
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsHLMTF::~BBandsHLMTF()
{
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBandsHLMTF::Run()
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
   double h4LowerBandArray[];

   ArraySetAsSeries(h4MidBandArray,true);
   ArraySetAsSeries(h4UpperBandArray,true);
   ArraySetAsSeries(h4LowerBandArray,true);

   int h4BBHandl=iBands(Symbol(),PERIOD_H4,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(h4BBHandl,0,0,10,h4MidBandArray);
   CopyBuffer(h4BBHandl,1,0,10,h4UpperBandArray);
   CopyBuffer(h4BBHandl,2,0,10,h4LowerBandArray);
//+--------------------[  bbands height ]--------------------------------+
//double M1BBandsHeight= (M1UpperBandArray[0]-M1LowerBandArray[0])*(1/Point());
//bool CanTradeInM1=(symbolInfo.Spread()<=18)&&((M1BBandsHeight/symbolInfo.Spread())>=0.9);
//comment+="M1BBandsHeight => "+M1BBandsHeight+"\n";
//comment+="si.Spread() => "+symbolInfo.Spread()+"\n";
//comment+="CanTradeInM1 => "+CanTradeInM1+"\n";
//+--------------------------[      signals                signals           signals     ]-------------------------+
   if(H4Prices[0].close>h4UpperBandArray[0])
   {
      comment+="H4 => Sell\n";
   }
   else if(H4Prices[0].close < h4LowerBandArray[0])
   {
      comment+="H4 => Buy\n";
   }
   if(H1Prices[0].close>h1UpperBandArray[0])
   {
      comment+="H1 => Sell\n";
   }
   else if(H1Prices[0].close<h1LowerBandArray[0])
   {
      comment+="H1 => Buy\n";
   }
   if(M15Prices[0].close>M15UpperBandArray[0])
   {
      comment+="M15 => Sell\n";
   }
   else if(M15Prices[0].close<M15LowerBandArray[0])
   {
      comment+="M15 => Buy\n";
   }
   if(M5Prices[0].close>M5UpperBandArray[0])
   {
      comment+="M5 => Sell\n";
   }
   else if(M5Prices[0].close<M5LowerBandArray[0])
   {
      comment+="M5 => Buy\n";
   }
   if(M1Prices[0].close>M1UpperBandArray[0])
   {
      comment+="M1 => Sell\n";
   }
   else if(M1Prices[0].close<M1LowerBandArray[0])
   {
      comment+="M1 => Buy\n";
   }
//if(IsPriceTouchedTop(M1Prices,M1UpperBandArray))
//{
//   //sell
//   trade.PositionCloseAll(POSITION_TYPE_SELL);
//   if(positionInfo.buyCount()==0&&CanTradeInM1)
//   {
//      trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01));
//   }
//}
//else if(IsPriceTouchedDown(M1Prices,M1LowerBandArray))
//{
//   //buy
//   trade.PositionCloseAll(POSITION_TYPE_BUY);
//   if(positionInfo.sellCount()==0&&CanTradeInM1)
//   {
//      trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01));
//   }
//}
//if(IsPricePassedDown(M1Prices,M1MidBandArray))
//{
//   //sell
//   if(positionInfo.sellCount()==0&&CanTradeInM1)
//   {
//      trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01));
//   }
//}
//if(IsPricePassedUp(M1Prices,M1MidBandArray))
//{
//   if(positionInfo.sellCount()==0&&CanTradeInM1)
//   {
//      trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01));
//   }
//}

   Comment(this.comment+tm.comment);
}
//+------------------------------------------------------------------+
