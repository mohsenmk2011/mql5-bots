//+------------------------------------------------------------------+
//|                                                       MaLine.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Jooya/MaTypes.mqh>
#include <Jooya/CrossStates.mqh>

class MaLine
{
   private:
      int Length;
      
      int Handle;
   public:
      MaLine();
      MaLine(int lenght,MaTypes t);
     ~MaLine();
     
     CrossStates CrossState;
     double BufferArray[];
     MaTypes Type;
     void CopyBufferToArray();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaLine::MaLine()
{
   Type= MaTypeUnknown;
   Length=0;
   CrossState=NotCrossed;
}
MaLine::MaLine(int lenght,MaTypes t)
{
   Type= t;
   Length=lenght;
   
   Handle= iMA(Symbol(),PERIOD_M1,Length,0,MODE_EMA,PRICE_CLOSE);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaLine::~MaLine()
{
}
//+------------------------------------------------------------------+

void MaLine::CopyBufferToArray()
{
   CopyBuffer(Handle,0,1,2,BufferArray);
   ArraySetAsSeries(BufferArray,true);
}