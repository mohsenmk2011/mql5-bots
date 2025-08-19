//+------------------------------------------------------------------+
//|                                                     SwingBot.mq5 |
//|                                     Copyright 2025 Aug 17, Jooya |
//|                             https://www.tradertool.jooyabash.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Jooya"
#property link      "https://www.tradertool.jooyabash.com"
#property version   "1.00"
//+-------------------------< Includes >-----------------------------+
#include <Jooya/LogManager.mqh>
#include <Jooya/Trade.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Charts/Chart.mqh>
#include <Jooya/RatesManager.mqh>
#include <Jooya/Range.mqh>
//+------------------------< Inputs >--------------------------------+
static input ulong InpMagicNumber = 3645; //magic number
input int InpBarCount = 6; //bar count
input ENUM_TIMEFRAMES InpLowPeriod = PERIOD_M5;// low period
input ENUM_TIMEFRAMES InpHighPeriod = PERIOD_H4;// high period
//+---------------------< Global variables >------------------------+
CChart chart;
LogManager lm;
Trade trade;
SymbolInfo si;
PositionInfo pi;
PositionManager pm;
TrailingManager tm;
RatesManager rm;
double openM5 = 0; // highest price of last N bar
double closeM5 = 0; // lowest price of last N bar
double highM1 = 0; // highest price of last N bar
double lowM1 = 0; // lowest price of last N bar

double lastGreenMoveClose = 0; // lowest price of last N bar
double lastGreenMoveOpen = 0; // lowest price of last N bar
double lastRedMoveClose = 0; // lowest price of last N bar
double lastRedMoveOpen = 0; // lowest price of last N bar
MqlTick currentTick,previousTick;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   chart.Attach(ChartID());
   chart.ShowLineAsk(true);
   chart.ColorForeground(clrBlack);
   chart.ColorBackground(clrWhite);
   chart.ColorBarUp(clrGreen);
   chart.ColorBarDown(clrRed);
   chart.ColorCandleBull(clrLimeGreen);
   chart.ColorCandleBear(clrHotPink);
//check the user inputs
   if(!inputsAreValid())
   {
      return INIT_PARAMETERS_INCORRECT;
   }
// set magic number
   trade.SetExpertMagicNumber(InpMagicNumber);
// set other inputs to your classes
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   rm.copyRates(false,true,true,false,false,true,false);
   Range firstDiffrentColorMoveAsCandleHighPeriod = rm.getFirstDiffrentColorMoveAsCandle(InpHighPeriod,1);
   Range firstDiffrentColorMoveAsCandleLowPeriod = rm.getFirstDiffrentColorMoveAsCandle(InpLowPeriod,1);
   previousTick = currentTick;
   si.CurrentTick(currentTick);
   int buyCount = pi.buyCount();
   int sellCount = pi.sellCount();

   // calculate high and low in M5 for open position
   
   // calculate high and low in M1 trail stop loss
   //highM1 = iHigh(Symbol(),InpLowPeriod,iHighest(Symbol(),InpLowPeriod,MODE_HIGH,InpBarCount,0));
   //lowM1 = iLow(Symbol(),InpLowPeriod,iLowest(Symbol(),InpLowPeriod,MODE_LOW,InpBarCount,0));
   //Print("highM5 => "+DoubleToString(highM5));
   //Print("lowM5 => "+DoubleToString(lowM5));
   
  // DrawObjectM1();
   DrawObjectM5(firstDiffrentColorMoveAsCandleHighPeriod);
   DrawObjectM1(firstDiffrentColorMoveAsCandleLowPeriod);
   if(firstDiffrentColorMoveAsCandleHighPeriod.up == 0 || firstDiffrentColorMoveAsCandleHighPeriod.down ==0)
   {   
      Print("moves is not correct => so return");
      return;
   }
   if(firstDiffrentColorMoveAsCandleLowPeriod.up == 0 || firstDiffrentColorMoveAsCandleLowPeriod.down ==0)
   {   
      Print("moves is not correct => so return");
      return;
   }
   //===============================[ signals ]=============================
   if(!trade.IsOkForTrade())
   {
      Print("is not ok for trade so return");
      return;
   }
   //buy signal
   //Print("previousTick.ask => "+DoubleToString(previousTick.ask));
   //Print("currentTick.ask => "+DoubleToString(currentTick.ask));
   if(isBuySignla(firstDiffrentColorMoveAsCandleHighPeriod,firstDiffrentColorMoveAsCandleLowPeriod))//previousTick.ask<highM5&&currentTick.ask>=highM5)
   {
      
      Print("is going to open buy position");
      
      Print("calculate stop loss");
      double sl=firstDiffrentColorMoveAsCandleLowPeriod.down;
      double ask = si.Ask();
      if(trade.Buy(pm.newPositionVolume(100),Symbol(),ask,sl))
      {
         Print("buy position opened successfully");        
         return;
      }
      Print("buy position was not succeed");
   }

   //sell signal
   if(isSellSignal(firstDiffrentColorMoveAsCandleHighPeriod,firstDiffrentColorMoveAsCandleLowPeriod))
   {
      Print("is going to open sell position");      
      Print("calculate stop loss");
      double sl=firstDiffrentColorMoveAsCandleLowPeriod.up;
      double bid = si.Bid();
      if(trade.Sell(pm.newPositionVolume(100),Symbol(),bid,sl))
      {
         Print("sell position opened successfully");
         return;
      }
      Print("sell position was not succeed");
   }
   tm.trailWithLowHigh(firstDiffrentColorMoveAsCandleHighPeriod.down,firstDiffrentColorMoveAsCandleHighPeriod.up);
   //Print("buyCount => "+IntegerToString(buyCount));
   //Print("sellCount => "+IntegerToString(sellCount)

}
//+------------------------< functions >-----------------------------+
bool inputsAreValid()
{
   if(InpMagicNumber<=0)
   {
      Alert("Magic number should be 1 or bigger number");
      return false;
   }
   if(InpBarCount<3)
   {
      Alert("Magic number should be 3 or bigger number");
      return false;
   }
   return true;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawObjectM5(Range &range)
{
   datetime time = iTime(Symbol(),InpHighPeriod,InpBarCount);
/// draw highM5 line
   ObjectDelete(NULL,"highM5");
   ObjectCreate(NULL,"highM5",OBJ_TREND,0,time,range.up,TimeCurrent(),range.up);
   ObjectSetInteger(NULL,"highM5",OBJPROP_WIDTH,3);
   ObjectSetInteger(NULL,"highM5",OBJPROP_COLOR,clrDarkBlue);


/// draw lowM5 line
   ObjectDelete(NULL,"lowM5");
   ObjectCreate(NULL,"lowM5",OBJ_TREND,0,time,range.down,TimeCurrent(),range.down);
   ObjectSetInteger(NULL,"lowM5",OBJPROP_WIDTH,3);
   ObjectSetInteger(NULL,"lowM5",OBJPROP_COLOR,clrRed);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawObjectM1(Range &range)
{
   datetime time = iTime(Symbol(),InpLowPeriod,InpBarCount);
/// draw highM1 line
   ObjectDelete(NULL,"highM1");
   ObjectCreate(NULL,"highM1",OBJ_TREND,0,time,range.up,TimeCurrent(),range.up);
   ObjectSetInteger(NULL,"highM1",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"highM1",OBJPROP_COLOR,clrDarkGreen);


/// draw lowM1 line
   ObjectDelete(NULL,"lowM1");
   ObjectCreate(NULL,"lowM1",OBJ_TREND,0,time,range.down,TimeCurrent(),range.down);
   ObjectSetInteger(NULL,"lowM1",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"lowM1",OBJPROP_COLOR,clrRed);
}

bool isSellSignal(Range &highPeriodRange,Range &lowPeriodRange)
{
   if(pi.sellCount()>0)
   {
      Print("there is a sell postion now,return");
      return false;
   }
   if(!(lowPeriodRange.up<highPeriodRange.down&&lowPeriodRange.down<highPeriodRange.down))
   {
      return false;
   }
   MqlRates M5Prices[];
   rm.getPrice(M5Prices,PERIOD_M5);
   
   if(!(M5Prices[1].close<lowPeriodRange.down))
   {
      return false;   
   }
   return true;
}
bool isBuySignla(Range &highPeriodRange,Range &lowPeriodRange)
{
   if(pi.buyCount()>0)
   {
      Print("there is a buy postion now,return");
      return false;
   }
   if(!(lowPeriodRange.up>highPeriodRange.up&&lowPeriodRange.down>highPeriodRange.up))
   {
      return false;
   }
   if(!(si.Ask()>lowPeriodRange.up))
   {
      return false;   
   }
   return true;
}