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
   double            AskTick();
   double            BidTick();
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
double SymbolInfo::AskTick()
  {
   return SymbolInfoDouble(Symbol(),SYMBOL_ASK);
  }

//+------------------------------------------------------------------+
double SymbolInfo::BidTick()
  {
   return SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }
//+------------------------------------------------------------------+
