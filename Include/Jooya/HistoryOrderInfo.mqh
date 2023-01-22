//+------------------------------------------------------------------+
//|                                             HistoryOrderInfo.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade/HistoryOrderInfo.mqh>

class HistoryOrderInfo:CHistoryOrderInfo{
   private:
      CHistoryOrderInfo orderInfo;
   public:
      HistoryOrderInfo();
      ~HistoryOrderInfo();
      int count();
      ulong lastTicket();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HistoryOrderInfo::HistoryOrderInfo(){
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
HistoryOrderInfo::~HistoryOrderInfo(){
}
//+------------------------------------------------------------------+
int HistoryOrderInfo::count(){
   return HistoryOrdersTotal();
}

ulong HistoryOrderInfo::lastTicket(){
   return HistoryOrderGetTicket(count()-1);
}