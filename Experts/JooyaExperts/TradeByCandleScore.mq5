//+------------------------------------------------------------------+
//|                       TradeByCandleScore.mq5                     |
//|                        Copyright 2024, Jooya                     |
//|                         https://jooyabash.com                    |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+-------------------------< Includes >-----------------------------+
#include <Jooya/LogManager.mqh>
#include <Jooya/Trade.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Charts/Chart.mqh>
#include <Jooya/JooyaRates.mqh>
#include <Jooya/RatesManager.mqh>
//+------------------------< Inputs >--------------------------------+
static input ulong InpMagicNumber = 5346; //magic number
input int InpBarCount = 6; //bar count
//+---------------------< Global variables >------------------------+
CChart chart;
LogManager lm;
Trade trade;
SymbolInfo si;
PositionInfo pi;
PositionManager pm;
TrailingManager tm;
JooyaRates jr;
RatesManager rm;
double highM5 = 0; // highest price of last N bar
double lowM5 = 0; // lowest price of last N bar
double highM1 = 0; // highest price of last N bar
double lowM1 = 0; // lowest price of last N bar
double currentCandleScore = 0; // current Candle Score
double midleOfCurrentCanlde = 0; // midle O fCurrent Canlde for drawing currentCandleScore


double currentOpen = 0;
double currentClose = 0;
double currentHigh = 0;
double currentLow = 0;
double highlowDiff = 0;
double closeopendiff = 0;
int ticksCount = 0;

MqlTick currentTick,previousTick;
MqlTick lastCandleTicksMannauly[];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   midleOfCurrentCanlde = 0;
   ticksCount = 0 ;
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
   lm.addNewPosition("high - low => ");
   lm.addNewPosition("close - open => ");
   lm.addNewPosition("score => ");
   lm.addNewPosition("diff => ");
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
   rm.copyRates();
   previousTick = currentTick;
   si.CurrentTick(currentTick);
   if(rm.isNewCandle(Period()))
   {
      Print("highlowDiff => " + highlowDiff);
      Print("closeopendiff => " + closeopendiff);
      Print("currentCandleScore => " + currentCandleScore);
      Print("current Candle ticks Count => " + ticksCount);
      double t = rm.getScore(1);
      Print("score => " + t);
      
      currentCandleScore = 0;
      ticksCount = 0;
      ArrayFree(lastCandleTicksMannauly);
   }
   
   ticksCount++;
   ArrayResize(lastCandleTicksMannauly,ticksCount);
   if(ticksCount >0)
   {   
      double diff = currentTick.ask - previousTick.ask;
      lm.set("diff => ",diff);
      currentCandleScore = currentCandleScore + diff;
      lastCandleTicksMannauly[ticksCount-1] = currentTick;
   }
   
   currentOpen = iOpen(Symbol(),Period(),0);
   currentClose = iClose(Symbol(),Period(),0);
   currentHigh = iHigh(Symbol(),Period(),0);
   currentLow = iLow(Symbol(),Period(),0);
   highlowDiff = currentHigh - currentLow;
   closeopendiff = currentClose - currentOpen;
   midleOfCurrentCanlde = closeopendiff;
   lm.set("high - low => ",highlowDiff);
   lm.set("close - open => ",closeopendiff);
   lm.set("score => ",currentCandleScore);
   lowM5 = iLow(Symbol(),PERIOD_M5,iLowest(Symbol(),PERIOD_M5,MODE_LOW,InpBarCount,1));
   int buyCount = pi.buyCount();
   int sellCount = pi.sellCount();

   // calculate high and low in M5 for open position
   highM5 = iHigh(Symbol(),PERIOD_M5,iHighest(Symbol(),PERIOD_M5,MODE_HIGH,InpBarCount,1));
   lowM5 = iLow(Symbol(),PERIOD_M5,iLowest(Symbol(),PERIOD_M5,MODE_LOW,InpBarCount,1));
   // calculate high and low in M1 trail stop loss
   highM1 = iHigh(Symbol(),PERIOD_M1,iHighest(Symbol(),PERIOD_M1,MODE_HIGH,InpBarCount,0));
   lowM1 = iLow(Symbol(),PERIOD_M1,iLowest(Symbol(),PERIOD_M1,MODE_LOW,InpBarCount,0));
   //Print("highM5 => "+DoubleToString(highM5));
   //Print("lowM5 => "+DoubleToString(lowM5));

   DrawObjectM5();
//buy signal

   //Print("previousTick.ask => "+DoubleToString(previousTick.ask));
   //Print("currentTick.ask => "+DoubleToString(currentTick.ask));
   if(buyCount ==0&& highM5!=0 && highM1>highM5)//previousTick.ask<highM5&&currentTick.ask>=highM5)
   {
      Print("is going to open buy position");

      if(!trade.IsOkForTrade())
      {
         Print("is not ok for trade so return");
         return;
      }
      Print("calculate stop loss");
      double sl=lowM5;
      double ask = si.Ask();
      if(trade.Buy(pm.newPositionVolume(10),Symbol(),ask,sl))
      {
         Print("buy position opened successfully");
         return;
      }
      Print("buy position was not succeed");
   }

//sell signal
   if(sellCount ==0&& lowM5!=0 && lowM1<lowM5)//previousTick.bid>lowM5&&currentTick.bid<=lowM5)
   {
      Print("is going to open sell position");

      if(!trade.IsOkForTrade())
      {
         Print("is not ok for trade so return");
         return;
      }
      Print("calculate stop loss");
      double sl=highM5;
      double bid = si.Bid();
      if(trade.Sell(pm.newPositionVolume(10),Symbol(),bid,sl))
      {
         Print("sell position opened successfully");
         return;
      }
      Print("sell position was not succeed");
   }
   tm.trailWithLowHigh(lowM1,highM1);
   lm.comment();
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
void DrawObjectM5()
{
   datetime time = iTime(Symbol(),PERIOD_M5,InpBarCount);
/// draw highM5 line
   ObjectDelete(NULL,"highM5");
   ObjectCreate(NULL,"highM5",OBJ_TREND,0,time,highM5,TimeCurrent(),highM5);
   ObjectSetInteger(NULL,"highM5",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"highM5",OBJPROP_COLOR,clrBlack);
   //draw text of score
   ObjectDelete(NULL,"scoreText");
   ObjectCreate(NULL,"scoreText",OBJ_TEXT,0,TimeCurrent(),midleOfCurrentCanlde);
   ObjectSetInteger(NULL,"scoreText",OBJPROP_ANCHOR,ANCHOR_LOWER);
   ObjectSetInteger(NULL,"scoreText",OBJPROP_COLOR,clrBlack);
   ObjectSetString(NULL,"scoreText",OBJPROP_TEXT,(string)currentCandleScore);


/// draw lowM5 line
   ObjectDelete(NULL,"lowM5");
   ObjectCreate(NULL,"lowM5",OBJ_TREND,0,time,lowM5,TimeCurrent(),lowM5);
   ObjectSetInteger(NULL,"lowM5",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"lowM5",OBJPROP_COLOR,clrBlack);
}
//+------------------------------------------------------------------+
