//+------------------------------------------------------------------+
//|                                                 RatesManager.mqh |
//|                                            Copyright 2022, Jooya |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#include <Jooya/JooyaRates.mqh>

#property copyright "Copyright 2022, Jooya"
#property link      "https://www.mql5.com"
#property version   "1.00"
class RatesManager
{
private:
   JooyaRates        jr;
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
   void getPrice(MqlRates& price[],ENUM_TIMEFRAMES period);

   double             getHigherLow(ENUM_TIMEFRAMES period);
   double             getLowerHigh(ENUM_TIMEFRAMES period);
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
      Print("M5Prices size =>"+ArraySize(M5Prices));
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
