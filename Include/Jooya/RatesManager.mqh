//+------------------------------------------------------------------+
//|                                                 RatesManager.mqh |
//|                                            Copyright 2022, Jooya |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Jooya"
#property link      "https://www.mql5.com"
#property version   "1.00"
class RatesManager
{
private:

public:
   RatesManager();
   ~RatesManager();
   MqlRates M1Prices[];
   MqlRates M5Prices[];
   MqlRates M15Prices[];
   MqlRates M30Prices[];
   MqlRates H1Prices[];
   MqlRates H4Prices[];
   //set the time frames that should be copy
   void setTimeframes();
   void copyRates();
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
   Print("is setting time frames that should be copy");
}

void RatesManager::copyRates()
{
   Print("is setting time frames that should be copy");
   
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

