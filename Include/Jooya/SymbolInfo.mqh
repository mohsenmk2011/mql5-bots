//+------------------------------------------------------------------+
//|                                                   SymbolInfo.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade/SymbolInfo.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SymbolInfo : public CSymbolInfo
{
private:

public:
   SymbolInfo();
   ~SymbolInfo();
   bool CurrentTick(MqlTick& tick,ENUM_TIMEFRAMES period=PERIOD_CURRENT,string symbol ="");
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SymbolInfo::SymbolInfo()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SymbolInfo::~SymbolInfo()
{
}
//+------------------------------------------------------------------+
bool SymbolInfo::CurrentTick(MqlTick& tick,ENUM_TIMEFRAMES period,string symbol)
{
   if(symbol=="")
   {
      symbol = Symbol();
   }
   return SymbolInfoTick(symbol,tick);
}
//+------------------------------------------------------------------+
