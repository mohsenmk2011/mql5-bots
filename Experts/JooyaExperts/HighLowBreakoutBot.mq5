//+------------------------------------------------------------------+
//|                       HighLowBreakoutBot.mq5                     |
//|                        Copyright 2023, Jooya                     |
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
//+------------------------< Inputs >--------------------------------+
static input ulong InpMagicNumber = 5346; //magic number
input int InpBarCount = 18; //bar count
//+---------------------< Global variables >------------------------+
LogManager lm;
Trade trade;
SymbolInfo si;
PositionInfo pi;
PositionManager pm;
double high = 0; // highest price of last N bar
double low = 0; // lowest price of last N bar
MqlTick currentTick,previousTick;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
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
   previousTick = currentTick;
   si.CurrentTick(currentTick);
   int buyCount = pi.buyCount();
   int sellCount = pi.sellCount();

//buy signal

   //Print("previousTick.ask => "+DoubleToString(previousTick.ask));
   //Print("currentTick.ask => "+DoubleToString(currentTick.ask));
   if(buyCount ==0&& high!=0 && previousTick.ask<high&&currentTick.ask>=high)
   {
      Print("open buy position");
      trade.Buy(PERIOD_CURRENT,Symbol());
   }

//sell signal
   if(sellCount ==0&& low!=0 && previousTick.bid>low&&currentTick.bid<=low)
   {
      Print("open sell position");
      trade.Sell(PERIOD_CURRENT,Symbol());
   }

// calculate high and low
   high = iHigh(Symbol(),PERIOD_CURRENT,iHighest(Symbol(),PERIOD_CURRENT,MODE_HIGH,InpBarCount,0));
   low = iLow(Symbol(),PERIOD_CURRENT,iLowest(Symbol(),PERIOD_CURRENT,MODE_LOW,InpBarCount,0));
   //Print("high => "+DoubleToString(high));
   //Print("low => "+DoubleToString(low));
   
   DrawObject();
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
void DrawObject()
{
   datetime time = iTime(Symbol(),PERIOD_CURRENT,InpBarCount);
/// draw high line
   ObjectDelete(NULL,"high");
   ObjectCreate(NULL,"high",OBJ_TREND,0,time,high,TimeCurrent(),high);
   ObjectSetInteger(NULL,"high",OBJPROP_WIDTH,1);
   ObjectSetInteger(NULL,"high",OBJPROP_COLOR,clrAliceBlue);


/// draw low line
   ObjectDelete(NULL,"low");
   ObjectCreate(NULL,"low",OBJ_TREND,0,time,low,TimeCurrent(),low);
   ObjectSetInteger(NULL,"low",OBJPROP_WIDTH,1);
   ObjectSetInteger(NULL,"low",OBJPROP_COLOR,clrAliceBlue);
}
//+------------------------------------------------------------------+
