//+------------------------------------------------------------------+
//|                                                 RatesManager.mqh |
//|                                            Copyright 2022, Jooya |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#include <Jooya/JooyaRates.mqh>
#include <Jooya/PositionInfo.mqh>

#property copyright "Copyright 2022, Jooya"
#property link      "https://www.mql5.com"
#property version   "1.00"
class RatesManager
{
private:
   JooyaRates        jr;
   PositionInfo      pi;
   datetime previousCandleTime;
   MqlTick lastCandleTicks[];
public:
   RatesManager();
   ~RatesManager();
   MqlRates          M1Prices[];
   MqlRates          M5Prices[];
   MqlRates          M15Prices[];
   MqlRates          M30Prices[];
   MqlRates          H1Prices[];
   MqlRates          H4Prices[];
   //set the time frames that should be copy
   void              setTimeframes();
   void              copyRates();
   double              getScore(int candleNumber);
   void getPrice(MqlRates& price[],ENUM_TIMEFRAMES period);

   double             getHigherLow(ENUM_TIMEFRAMES period);
   double             getLowerHigh(ENUM_TIMEFRAMES period);
   int             getFirstDiffrentColorCandleIndex(ENUM_TIMEFRAMES period,int index =0);

   datetime getCurrentCandleTime(ENUM_TIMEFRAMES period=PERIOD_CURRENT,string symbol ="current symbol");
   bool currentCandleHasAnyPosition(ENUM_TIMEFRAMES period=PERIOD_CURRENT,string symbol ="current symbol");
   /// is this candle is created recently and this is first tick of this candle?
   bool isNewCandle(ENUM_TIMEFRAMES period=PERIOD_CURRENT,string symbol ="current symbol");
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RatesManager::RatesManager()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RatesManager::~RatesManager()
{
}
//+------------------------------------------------------------------
void RatesManager::setTimeframes()
{
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RatesManager::copyRates()
{
//+----------------------------[ M1 copy rates ]-----------------------------+
   ArraySetAsSeries(M1Prices,true);
   CopyRates(Symbol(),PERIOD_M1,0,10,M1Prices);
//+----------------------------[ M5 copy rates ]-----------------------------+
   ArraySetAsSeries(M5Prices,true);
   CopyRates(Symbol(),PERIOD_M5,0,10,M5Prices);
//+----------------------------[ M15 copy rates ]-----------------------------+
   ArraySetAsSeries(M15Prices,true);
   CopyRates(Symbol(),PERIOD_M15,0,10,M15Prices);
//+----------------------------[ M30 copy rates ]-----------------------------+
   ArraySetAsSeries(M30Prices,true);
   CopyRates(Symbol(),PERIOD_M30,0,10,M30Prices);
//+----------------------------[ H1 copy rates ]-----------------------------+
   ArraySetAsSeries(H1Prices,true);
   CopyRates(Symbol(),PERIOD_H1,0,10,H1Prices);
//+----------------------------[ H4 copy rates ]-----------------------------+
   ArraySetAsSeries(H4Prices,true);
   CopyRates(Symbol(),PERIOD_H4,0,10,H4Prices);
}

//+------------------------------------------------------------------+
//| 
//+------------------------------------------------------------------+
int RatesManager::getFirstDiffrentColorCandleIndex(ENUM_TIMEFRAMES period,int index)
{
   MqlRates candles[];
   getPrice(candles,period);   
   int candlesCount = ArraySize(candles);
   bool isCurrentCandleGreen = jr.IsUpCandle(candles[index]);

   for(int i = index +1; i<candlesCount; i++)
   {
      if(jr.IsUpCandle(candles[i])!=isCurrentCandleGreen)
      {
         return i;
      }
   }
   return -1;
}
//+------------------------------------------------------------------+
//|                This method will be used in down trend
//+------------------------------------------------------------------+
double RatesManager::getLowerHigh(ENUM_TIMEFRAMES period)
{
   int index =0;
   MqlRates price[];
   getPrice(price,period);
   double high = price[index].high;
   int priceCount = ArraySize(price);

   while(index+1<priceCount&& jr.IsDownCandle(price[index+1]))
   {
      index++;
      if(price[index+1].high>high)
      {
         high = price[index].high;
      }
   }
   return high;
}

//+------------------------------------------------------------------+
//|               This method will be used in up trend
//+------------------------------------------------------------------+
double RatesManager::getHigherLow(ENUM_TIMEFRAMES period)
{
   int index =0;
   MqlRates price[];
   getPrice(price,period);
   double low = price[index].low;
   int priceCount = ArraySize(price);

   while(index+1<priceCount&& jr.IsUpCandle(price[index+1]))
   {
      index++;
      if(price[index+1].low<low)
      {
         low = price[index].low;
      }
   }
   return low;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RatesManager::getPrice(MqlRates& price[], ENUM_TIMEFRAMES period)
{
   if(period == PERIOD_M1)
   {
      ArrayResize(price,ArraySize(M1Prices));
      ArrayCopy(price,M1Prices);
   }
   else if(period == PERIOD_M5)
   {
      Print("M5Prices size =>"+IntegerToString(ArraySize(M5Prices)));
      ArrayResize(price,ArraySize(M5Prices));
      ArrayCopy(price,M5Prices);
   }
   else if(period == PERIOD_M15)
   {
      ArrayResize(price,ArraySize(M15Prices));
      ArrayCopy(price,M15Prices);
   }
   else if(period == PERIOD_M30)
   {
      ArrayResize(price,ArraySize(M30Prices));
      ArrayCopy(price,M30Prices);
   }
   else if(period == PERIOD_H1)
   {
      ArrayResize(price,ArraySize(H1Prices));
      ArrayCopy(price,H1Prices);
   }
   else if(period == PERIOD_H4)
   {
      ArrayResize(price,ArraySize(H4Prices));
      ArrayCopy(price,H4Prices);
   }
   ArraySetAsSeries(price,true);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime RatesManager::getCurrentCandleTime(ENUM_TIMEFRAMES period,string symbol)
{
   if(symbol == "current symbol")
   {
      symbol = Symbol();
   }
   return iTime(symbol,period,0);
}
//+------------------------------------------------------------------+
//|              does current candle has any open position           |
//+------------------------------------------------------------------+
bool RatesManager::currentCandleHasAnyPosition(ENUM_TIMEFRAMES period,string symbol)
{
   if(symbol == "current symbol")
   {
      symbol = Symbol();
   }
   datetime dt = getCurrentCandleTime(period,symbol);

   int count=pi.count();
   for(int i=0; i<count; i++)
   {
      pi.SelectByIndex(i);
      if(pi.timeOfCandle(period)==dt)
      {
         return true;
      }
   }
   return false;
}
//+------------------------------------------------------------------+
//|               is this candle opened recently ?                   |
//+------------------------------------------------------------------+
bool RatesManager::isNewCandle(ENUM_TIMEFRAMES period=PERIOD_CURRENT,string symbol ="current symbol")
{
   datetime currentCandleTime = getCurrentCandleTime(period,symbol);
   if(previousCandleTime != currentCandleTime)
   {
      previousCandleTime = currentCandleTime;
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
double RatesManager::getScore(int candleNumber)
{

   // Determine the start and end times of the candle
   datetime candle_start = iTime(Symbol(), Period(), candleNumber);
   datetime candle_end = iTime(Symbol(), Period(), candleNumber-1);
   ulong start = ulong(candle_start)*1000;
   ulong end = ulong(candle_end)*1000;
   Print("candle_start => ",candle_start);
   Print("start => ",start);
   Print("candle_end => ",candle_end);
   Print("end => ",end);
   ///ArraySetAsSeries(lastCandleTicks,true);
   int count = CopyTicksRange(Symbol(),lastCandleTicks, COPY_TICKS_ALL, start,end);
   Print("last Candle Ticks count => ",lastCandleTicks.Size());
   double s = 0;
   //for(int i = 1;i<lastCandleTicks.Size(); i++)
   //{
   //   Print("tick" , i-1 ," => ",lastCandleTicks[i-1].ask);
   //   double d = lastCandleTicks[i].ask - lastCandleTicks[i-1].ask;
   //   s = s + d;
   //}
   for(int i = lastCandleTicks.Size()-1;i>0; i--)
   {
      //Print("tick" , i-1 ," => ",lastCandleTicks[i-1].ask);
      double d = lastCandleTicks[i].ask - lastCandleTicks[i-1].ask;
      s = s + d;
   }
   //for(int i = 0;i<lastCandleTicksMannauly.Size(); i++)
   //{
   //   Print("tick" , i ," => ",lastCandleTicksMannauly[i].ask);
   //}
   Print("score => ",s);
   return s;
}
//+------------------------------------------------------------------+
