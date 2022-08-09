//+------------------------------------------------------------------+
//|                                                 PositionInfo.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade/PositionInfo.mqh>

class PositionInfo:public CPositionInfo{
   private:

   public:
      PositionInfo();
     ~PositionInfo();
     int count();
     bool SelectLast();
     bool SelectFirst();
     bool isBuy();
     bool isSell();     
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PositionInfo::PositionInfo(){
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PositionInfo::~PositionInfo(){
}
//+------------------------------------------------------------------+
int PositionInfo::count(){
   return PositionsTotal();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PositionInfo::SelectLast(){
   return SelectByIndex(count()-1);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PositionInfo::SelectFirst(){
   return SelectByIndex(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PositionInfo::isBuy(void){
   return Type()==POSITION_TYPE_BUY;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PositionInfo::isSell(void){
   return Type()==POSITION_TYPE_SELL;
}