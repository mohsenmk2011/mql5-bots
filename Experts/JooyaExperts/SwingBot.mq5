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
   rm.copyRates(false,true,false,false,false,true,true);
   MqlRates firstDiffrentColorMoveAsCandle = rm.getFirstDiffrentColorMoveAsCandle(InpHighPeriod,0);
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
   DrawObjectM5(firstDiffrentColorMoveAsCandle);
//buy signal
return;
   //Print("previousTick.ask => "+DoubleToString(previousTick.ask));
   //Print("currentTick.ask => "+DoubleToString(currentTick.ask));
   if(buyCount ==0&& openM5!=0 && highM1>closeM5)//previousTick.ask<highM5&&currentTick.ask>=highM5)
   {
      Print("is going to open buy position");
      
      if(!trade.IsOkForTrade())
      {
         Print("is not ok for trade so return");
         return;
      }
      Print("calculate stop loss");
      double sl=closeM5;
      double ask = si.Ask();
      if(pi.buyCount()>0)
      {
         Print("there is a buy postion now,return");
         return;
      }
      if(trade.Buy(pm.newPositionVolume(10),Symbol(),ask,sl))
      {
         Print("buy position opened successfully");        
         return;
      }
      Print("buy position was not succeed");
   }

//sell signal
   if(sellCount ==0&& closeM5!=0 && lowM1<closeM5)//previousTick.bid>lowM5&&currentTick.bid<=lowM5)
   {
      Print("is going to open sell position");
      
      if(!trade.IsOkForTrade())
      {
         Print("is not ok for trade so return");
         return;
      }
      Print("calculate stop loss");
      double sl=closeM5;
      double bid = si.Bid();
      if(pi.sellCount()>0)
      {
         Print("there is a buy postion now,return");
         return;
      }
      if(trade.Sell(pm.newPositionVolume(10),Symbol(),bid,sl))
      {
         Print("sell position opened successfully");
         return;
      }
      Print("sell position was not succeed");
   }
   tm.trailWithLowHigh(lowM1,highM1);
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
void DrawObjectM5(MqlRates &candle)
{
   datetime time = iTime(Symbol(),InpHighPeriod,InpBarCount);
/// draw highM5 line
   ObjectDelete(NULL,"highM5");
   ObjectCreate(NULL,"highM5",OBJ_TREND,0,time,candle.open,TimeCurrent(),candle.open);
   ObjectSetInteger(NULL,"highM5",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"highM5",OBJPROP_COLOR,clrBlack);


/// draw lowM5 line
   ObjectDelete(NULL,"lowM5");
   ObjectCreate(NULL,"lowM5",OBJ_TREND,0,time,candle.close,TimeCurrent(),candle.close);
   ObjectSetInteger(NULL,"lowM5",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"lowM5",OBJPROP_COLOR,clrBlack);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawObjectM1()
{
   datetime time = iTime(Symbol(),InpLowPeriod,InpBarCount);
/// draw highM1 line
   ObjectDelete(NULL,"highM1");
   ObjectCreate(NULL,"highM1",OBJ_TREND,0,time,highM1,TimeCurrent(),highM1);
   ObjectSetInteger(NULL,"highM1",OBJPROP_WIDTH,1);
   ObjectSetInteger(NULL,"highM1",OBJPROP_COLOR,clrRed);


/// draw lowM1 line
   ObjectDelete(NULL,"lowM1");
   ObjectCreate(NULL,"lowM1",OBJ_TREND,0,time,lowM1,TimeCurrent(),lowM1);
   ObjectSetInteger(NULL,"lowM1",OBJPROP_WIDTH,1);
   ObjectSetInteger(NULL,"lowM1",OBJPROP_COLOR,clrRed);
}
//+------------------------------------------------------------------+
//| Returns index of the first candle with different color           |
//| from the current candle. Returns -1 if none found.               |
//+------------------------------------------------------------------+
int FindFirstDifferentColorCandle(string symbol=NULL, ENUM_TIMEFRAMES tf=PERIOD_CURRENT)
{
   if(symbol==NULL) symbol = _Symbol;

   // Get current candle values (index 0 is the current forming candle)
   double open0  = iOpen(symbol, tf, 0);
   double close0 = iClose(symbol, tf, 0);

   bool currentBull = (close0 > open0);   // true = bullish, false = bearish

   // Loop over previous candles
   for(int i=1; i<Bars(symbol, tf); i++)
   {
      double open  = iOpen(symbol, tf, i);
      double close = iClose(symbol, tf, i);

      bool bull = (close > open);

      if(bull != currentBull)  // found different color
         return i;
   }

   return -1; // not found
}
