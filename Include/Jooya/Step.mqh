//+------------------------------------------------------------------+
//|                                                         Step.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Arrays/List.mqh>
#include <Trade/PositionInfo.mqh>

class Step{
   private:
      int value;      
      CList *positions;
   public:
      Step();
     ~Step();
     int getValue();
     void setValue(int v);
     bool addPsition(CPositionInfo *p);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Step::Step(){
   value=0;
   
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Step::~Step(){
}
//+------------------------------------------------------------------+

int Step::getValue(){
   return value;
}
void Step::setValue(int v){
   value=v;
}
bool Step::addPsition(CPositionInfo *p){
   return positions.Add(p)!= -1;
}