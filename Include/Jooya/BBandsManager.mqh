//+------------------------------------------------------------------+
//|                                                BBandsManager.mqh |
//|                                            Copyright 2022, Jooya |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Jooya"
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Jooya/BBandsStatus.mqh>
#include <Jooya/BBandsStrategies.mqh>
#include <Jooya/Strategy.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BBandsManager:public Strategy
{

private:
   BBandsStatus              getStatus(MqlRates& price[],double& upperband[],double& midband[],double& lowerband[]);
public:
   BBandsManager();
   ~BBandsManager();
   void              updateStatus();

   void              checkPassedOverBandsStrategy();
   void              checkMultTimeFrameStrategy();
   void              checkSimpleStrategy();
   void checkMidlineMultiTimeFrame();
   void checkSimpleMidline();

   void              drawObject();

   BBandsStrategies  currentStrategy;

   bool              use_Simple_Strategy;
   bool              use_Passed_OverBands_Strategy;
   bool              use_SimpleMultiTimeFrame_Strategy;
   bool              use_MultiTimeFrameWithAngle_Strategy;
   bool use_SimpleMidline;
   bool use_MidlineMultiTimeFrame;

   BBandsStatus      m1_Status;
   BBandsStatus      m5_Status;
   BBandsStatus      m15_Status;
   BBandsStatus      m30_Status;
   BBandsStatus      h1_Status;
   BBandsStatus      h4_Status;
   double            M1MidBandArray[];
   double            M1UpperBandArray[];
   double            M1LowerBandArray[];


   double            M5MidBandArray[];
   double            M5UpperBandArray[];
   double            M5LowerBandArray[];


   double            M15MidBandArray[];
   double            M15UpperBandArray[];
   double            M15LowerBandArray[];


   double            M30MidBandArray[];
   double            M30UpperBandArray[];
   double            M30LowerBandArray[];

   double            h1MidBandArray[];
   double            h1UpperBandArray[];
   double            h1LowerBandArray[];


   double            h4MidBandArray[];
   double            h4UpperBandArray[];
   double            h4LowerBandArray[];
   //-----------------------------------------

   string            comment;
   //=======================================
   ///read the value of bollinger bands indictory in multipe time frames
   void readIndicotor();
   //checks the buy and sell signals and will open new positions based on signal
   void checkSignal();
   //checks all positions and will close each positon that should be close based on strategy
   void checkCloseCondition();

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsManager::BBandsManager()
{
   m1_Status = BBands_Status_Unkown;
   m5_Status = BBands_Status_Unkown;
   m15_Status = BBands_Status_Unkown;
   m30_Status = BBands_Status_Unkown;
   h1_Status = BBands_Status_Unkown;
   h4_Status = BBands_Status_Unkown;

   currentStrategy = BBandsStrategies_Unkown;

}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsManager::~BBandsManager()
{
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|       returns the status of price vs bollinger bands             |
//+------------------------------------------------------------------+
void BBandsManager::readIndicotor()
{
//+--------------------------[ M1 bbands indicator ]-------------------------+
   ArraySetAsSeries(M1MidBandArray,true);
   ArraySetAsSeries(M1UpperBandArray,true);
   ArraySetAsSeries(M1LowerBandArray,true);

   int M1BBHandl=iBands(Symbol(),PERIOD_M1,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M1BBHandl,0,0,10,M1MidBandArray);
   CopyBuffer(M1BBHandl,1,0,10,M1UpperBandArray);
   CopyBuffer(M1BBHandl,2,0,10,M1LowerBandArray);
//+--------------------------[ M5 bbands indicator ]-------------------------+

   ArraySetAsSeries(M5MidBandArray,true);
   ArraySetAsSeries(M5UpperBandArray,true);
   ArraySetAsSeries(M5LowerBandArray,true);

   int M5BBHandl=iBands(Symbol(),PERIOD_M5,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M5BBHandl,0,0,10,M5MidBandArray);
   CopyBuffer(M5BBHandl,1,0,10,M5UpperBandArray);
   CopyBuffer(M5BBHandl,2,0,10,M5LowerBandArray);
//+--------------------------[ M15 bbands indicator ]-------------------------+

   ArraySetAsSeries(M15MidBandArray,true);
   ArraySetAsSeries(M15UpperBandArray,true);
   ArraySetAsSeries(M15LowerBandArray,true);

   int M15BBHandl=iBands(Symbol(),PERIOD_M15,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M15BBHandl,0,0,10,M15MidBandArray);
   CopyBuffer(M15BBHandl,1,0,10,M15UpperBandArray);
   CopyBuffer(M15BBHandl,2,0,10,M15LowerBandArray);
//+--------------------------[ M30 bbands indicator ]-------------------------+
   ArraySetAsSeries(M30MidBandArray,true);
   ArraySetAsSeries(M30UpperBandArray,true);
   ArraySetAsSeries(M30LowerBandArray,true);

   int M30BBHandl=iBands(Symbol(),PERIOD_M30,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M30BBHandl,0,0,10,M30MidBandArray);
   CopyBuffer(M30BBHandl,1,0,10,M30UpperBandArray);
   CopyBuffer(M30BBHandl,2,0,10,M30LowerBandArray);
//+--------------------------[ H1 bbands indicator ]-------------------------+

   ArraySetAsSeries(h1MidBandArray,true);
   ArraySetAsSeries(h1UpperBandArray,true);
   ArraySetAsSeries(h1LowerBandArray,true);

   int h1BBHandl=iBands(Symbol(),PERIOD_H1,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(h1BBHandl,0,0,10,h1MidBandArray);
   CopyBuffer(h1BBHandl,1,0,10,h1UpperBandArray);
   CopyBuffer(h1BBHandl,2,0,10,h1LowerBandArray);
//+--------------------------[ H4 bbands indicator ]-------------------------+

   ArraySetAsSeries(h4MidBandArray,true);
   ArraySetAsSeries(h4UpperBandArray,true);
   ArraySetAsSeries(h4LowerBandArray,true);

   int h4BBHandl=iBands(Symbol(),PERIOD_H4,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(h4BBHandl,0,0,10,h4MidBandArray);
   CopyBuffer(h4BBHandl,1,0,10,h4UpperBandArray);
   CopyBuffer(h4BBHandl,2,0,10,h4LowerBandArray);
}
//+------------------------------------------------------------------+
void BBandsManager::updateStatus()
{
//read the rates
   rm.copyRates();
//+--------------------[  bbands height ]--------------------------------+
//double M1BBandsHeight= (M1UpperBandArray[0]-M1LowerBandArray[0])*(1/Point());
//bool CanTradeInM1=(symbolInfo.Spread()<=18)&&((M1BBandsHeight/symbolInfo.Spread())>=0.9);
//comment+="M1BBandsHeight => "+M1BBandsHeight+"\n";
//comment+="si.Spread() => "+symbolInfo.Spread()+"\n";
//comment+="CanTradeInM1 => "+CanTradeInM1+"\n";
//+--------------------------[      signals                signals           signals     ]-------------------------+
   m1_Status = getStatus(rm.M1Prices,M1UpperBandArray,M1MidBandArray,M1LowerBandArray);
   m5_Status = getStatus(rm.M5Prices,M5UpperBandArray,M5MidBandArray,M5LowerBandArray);
   m15_Status = getStatus(rm.M15Prices,M15UpperBandArray,M15MidBandArray,M15LowerBandArray);
   m30_Status = getStatus(rm.M30Prices,M30UpperBandArray,M30MidBandArray,M30LowerBandArray);
   h1_Status = getStatus(rm.H1Prices,h1UpperBandArray,h1MidBandArray,h1LowerBandArray);
   h4_Status = getStatus(rm.H4Prices,h4UpperBandArray,h4MidBandArray,h4LowerBandArray);
   Print("BBand Status at m1 => "+m1_Status);
   Print("BBand Status at m5 => "+m5_Status);
   Print("BBand Status at m15 => "+m15_Status);
   Print("BBand Status at m30 => "+m30_Status);
   Print("BBand Status at h1 => "+h1_Status);
   Print("BBand Status at h4 => "+h4_Status);
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

//Comment(this.comment+tm.comment);
}
//+------------------------------------------------------------------+
BBandsStatus BBandsManager::getStatus(MqlRates& price[],double& upperband[],double& midband[],double& lowerband[])
{
   if(price[0].close>upperband[0]&&price[1].close<upperband[1])
   {
      return BBands_Status_Buy_UpperBand;
   }
   else if(price[0].close>upperband[0])
   {
      return BBands_Status_UpperBand;
   }
   else if(price[0].close < lowerband[0]&&price[1].close > lowerband[1])
   {
      return BBands_Status_Sell_LowerBand;
   }
   else if(price[0].close < lowerband[0])
   {
      return BBands_Status_LowerBand;
   }
   else if(price[1].close >= midband[1]&&price[0].close<=midband[0])
   {
      return BBands_Status_Sell_MiddleBand;
   }
   else if(price[1].close <= midband[1]&&price[0].close>=midband[0])
   {
      return BBands_Status_Buy_MiddleBand;
   }
   else if(price[0].close >= lowerband[0]&&price[0].close<=midband[0])
   {
      return BBands_Status_Between_Lower_MiddleBand;
   }
   else if(price[0].close <= upperband[0]&&price[0].close>=midband[0])
   {
      return BBands_Status_Between_Upper_MiddleBand;
   }
   return BBands_Status_Unkown;
}
//+------------------------------------------------------------------+
void BBandsManager::checkSignal()
{
   readIndicotor();
   comment="";
   if(symbolInfo.Spread()>2)
   {
      return;
   }
   if(use_Passed_OverBands_Strategy)
   {
      updateStatus();
      comment +="Strategy => Passed_OverBands\n";
      checkPassedOverBandsStrategy();
   }
   if(use_Simple_Strategy)
   {
      comment +="Strategy => Simple\n";
      checkSimpleStrategy();
   }
   if(use_SimpleMultiTimeFrame_Strategy)
   {
      comment +="Strategy => MultiTimeFrame\n";
      checkMultTimeFrameStrategy();
   }
   if(use_SimpleMidline)
   {
      comment +="Strategy => Simple Midline\n";
      checkSimpleMidline();
   }
   if(use_MidlineMultiTimeFrame)
   {
      comment +="Strategy => Midline MultiTimeFrame\n";
      checkMultTimeFrameStrategy();
   }

   checkCloseCondition();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BBandsManager::checkSimpleMidline()
{
//+--------------------[ bband mide line Angle ]--------------------------------+
   double bbMidLineAngle= lm.angle(rm.M5Prices,M5MidBandArray);
   comment+="bbMidLineAngle => "+bbMidLineAngle+"\n";
//+--------------------------[ signals ]-------------------------+
   if(lm.IsStraight(bbMidLineAngle))
   {
      comment+="bbMidLine Is Straigh,";
      if(jr.IsPriceTouchedTop(rm.M1Prices, M1UpperBandArray))   //sell and close buy positions
      {
         trade.PositionCloseAll(POSITION_TYPE_BUY);
         if(positionInfo.sellCount()==0)
         {
            comment="Price Touched top,so sell.";
            trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.sellStopLoss(0.01),0,comment);
         }
      }
      else if(jr.IsPriceTouchedDown(rm.M1Prices,M1LowerBandArray))     //buy and close sell positions
      {
         trade.PositionCloseAll(POSITION_TYPE_SELL);
         if(positionInfo.buyCount()==0)
         {
            trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01),0,"bbMidLine Is Straigh,Price Touched down,so buy.");
         }
      }
   }
   else if(lm.IsGoingDown(bbMidLineAngle))
   {
      comment+="bbMidLine => going down \n";
      if(jr.IsPricePassedUp(rm.M1Prices,M1MidBandArray))   //close sell position
      {
         trade.PositionCloseAll(POSITION_TYPE_SELL);
      }
      else if(jr.IsPricePassedDown(rm.M1Prices,M1MidBandArray))     //open a sell position
      {
         if(positionInfo.sellCount()==0)
         {
            trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Bid(),pm.sellStopLoss(0.01),0,"bbMidLine Is goin down,Price passed down,so sell.");
         }
      }
   }
   else if(lm.IsGoingUp(bbMidLineAngle))
   {
      comment+="bbMidLine => going up \n";
      if(jr.IsPricePassedUp(rm.M1Prices,M1MidBandArray))   //open a buy position
      {
         if(positionInfo.buyCount()==0)
         {
            trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),pm.buyStopLoss(0.01),0,"bbMidLine Is goin up,Price passed up,so buy.");
         }
      }
      else if(jr.IsPricePassedDown(rm.M1Prices,M1MidBandArray))     //close buy position
      {
         trade.PositionCloseAll(POSITION_TYPE_BUY);
      }
   }
   Comment(this.comment+tm.comment);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BBandsManager::checkMidlineMultiTimeFrame()
{

}
//+------------------------------------------------------------------+
//|          will check passed over bands strategy                   |
//+------------------------------------------------------------------+
void BBandsManager::checkPassedOverBandsStrategy()
{
   comment +="h1 status=> ";
   if(h1_Status==BBands_Status_Sell_LowerBand)
   {
      comment +="Passed LowerBand\n";
      canBuy=jr.IsPriceTouchedDown(rm.M1Prices,M1LowerBandArray);
      if(canBuy)
      {
         if(buyLock)
         {
            return;
         }
         bool isUpCandle0 = jr.IsUpCandle(rm.M1Prices[0]);
         bool isUpCandle1 = jr.IsUpCandle(rm.M1Prices[1]);
         bool isUpCandle = isUpCandle0&&isUpCandle1;
         if(isUpCandle)
         {
            double sl = rm.getFirstLowerLow();
            Print("stop loss => "+sl);
            trade.Buy(10.0,Symbol(),symbolInfo.Ask(),sl);
            buyLock=true;
            sellLock=false;
         }
      }
      else
      {
         buyLock=false;
      }
   }
   else if(h1_Status==BBands_Status_Buy_UpperBand)
   {
      comment +="Passed UpperBand\n";
      canSell = jr.IsPriceTouchedTop(rm.M1Prices,M1UpperBandArray);
      if(canSell)
      {
         if(sellLock)
         {
            return;
         }
         bool isDownCandle0 = jr.IsDownCandle(rm.M1Prices[0]);
         bool isDownCandle1 = jr.IsDownCandle(rm.M1Prices[1]);
         bool isDownCandle = isDownCandle0&&isDownCandle1;
         if(isDownCandle)
         {
            double sl = rm.getFirstHigherHigh();
            Print("stop loss => "+sl);
            trade.Sell(10.0,Symbol(),symbolInfo.Ask(),sl);
            buyLock=false;
            sellLock=true;
         }
      }
      else
      {
         sellLock=false;
      }
   }
   else if(h1_Status==BBands_Status_Between_Lower_MiddleBand)
   {
      comment +="Between Lower MiddleBand\n";
   }
   else if(h1_Status==BBands_Status_Between_Upper_MiddleBand)
   {
      comment +="Between Upper MiddleBand\n";
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BBandsManager::checkMultTimeFrameStrategy()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void BBandsManager::checkSimpleStrategy()
{
   comment +="h1 status=> ";
   comment +="Passed LowerBand\n";
   canBuy=jr.IsPriceTouchedDown(rm.M1Prices,M1LowerBandArray);
   if(canBuy)
   {
      if(buyLock)
      {
         return;
      }
      bool isUpCandle0 = jr.IsUpCandle(rm.M1Prices[0]);
      bool isUpCandle1 = jr.IsUpCandle(rm.M1Prices[1]);
      bool isUpCandle = isUpCandle0&&isUpCandle1;
      if(isUpCandle)
      {
         double sl = rm.getFirstLowerLow();
         Print("stop loss => "+sl);
         trade.Buy(10.0,Symbol(),symbolInfo.Ask(),sl);
         buyLock=true;
         sellLock=false;
         return;
      }
   }
   else
   {
      buyLock=false;
   }

   comment +="Passed UpperBand\n";
   canSell = jr.IsPriceTouchedTop(rm.M1Prices,M1UpperBandArray);
   if(canSell)
   {
      if(sellLock)
      {
         return;
      }
      bool isDownCandle0 = jr.IsDownCandle(rm.M1Prices[0]);
      bool isDownCandle1 = jr.IsDownCandle(rm.M1Prices[1]);
      bool isDownCandle = isDownCandle0&&isDownCandle1;
      if(isDownCandle)
      {
         double sl = rm.getFirstHigherHigh();
         Print("stop loss => "+sl);
         trade.Sell(10.0,Symbol(),symbolInfo.Bid(),sl);
         buyLock=false;
         sellLock=true;
      }
   }
   else
   {
      sellLock=false;
   }
}
//+------------------------------------------------------------------+
void BBandsManager::checkCloseCondition()
{
   int minProfit = 100;
   int count=positionInfo.count();
   for(int i=0; i<count; i++)
   {
      positionInfo.SelectByIndex(i);
      if(positionInfo.Profit()<=-30)
      {
         trade.PositionClose(positionInfo.Ticket());
      }
      //if(positionInfo.Profit()>minProfit)
      //{
      //   trade.PositionClose(positionInfo.Ticket());
      //}
      //else if(positionInfo.Time()==iTime(Symbol(),PERIOD_M1,0))//is position has opend in current candle
      //{
      //   if(positionInfo.PositionType()==POSITION_TYPE_BUY&&jr.IsDownCandle(rm.M1Prices[0]))
      //   {
      //      trade.PositionClose(positionInfo.Ticket());
      //   }
      //   else if(positionInfo.PositionType()==POSITION_TYPE_SELL&&jr.IsUpCandle(rm.M1Prices[0]))
      //   {
      //      trade.PositionClose(positionInfo.Ticket());
      //   }
      //}
      //else if(positionInfo.Time()==iTime(Symbol(),PERIOD_M1,1))//is position has opend in current candle
      //{
      //   if(positionInfo.PositionType()==POSITION_TYPE_BUY&&jr.IsDownCandle(rm.M1Prices[1]))
      //   {
      //      trade.PositionClose(positionInfo.Ticket());
      //   }
      //   else if(positionInfo.PositionType()==POSITION_TYPE_SELL&&jr.IsUpCandle(rm.M1Prices[1]))
      //   {
      //      trade.PositionClose(positionInfo.Ticket());
      //   }
      //}
   }
}

//+------------------------------------------------------------------+
void BBandsManager::drawObject()
{
//ObjectCreate(Symbol(),"",OBJ_BUTTON)
}
//+------------------------------------------------------------------+
