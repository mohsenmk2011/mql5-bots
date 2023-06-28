//+------------------------------------------------------------------+
//|                                                 PositionInfo.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade/PositionInfo.mqh>
#include <Jooya/DateTimeUtility.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PositionInfo:public CPositionInfo
{
private:
   DateTimeUtility dtu;

public:
   PositionInfo();
   ~PositionInfo();
   int               count();
   int               sellCount();
   int               buyCount();
   bool              SelectLast();
   bool              SelectFirst();
   bool              isBuy();
   bool              isSell();
   datetime timeOfCandle(ENUM_TIMEFRAMES period);

};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PositionInfo::PositionInfo()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
PositionInfo::~PositionInfo()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PositionInfo::count()
{
   return PositionsTotal();
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PositionInfo::sellCount()
{
   int c=0;
   for(int i=0; i<PositionsTotal(); i++)
   {
      SelectByIndex(i);
      if(isSell())
      {
         c++;
      }
   }
   return c;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int PositionInfo::buyCount()
{
   int c=0;
   for(int i=0; i<PositionsTotal(); i++)
   {
      SelectByIndex(i);
      if(isBuy())
      {
         c++;
      }
   }
   return c;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PositionInfo::SelectFirst()
{
   return SelectByIndex(0);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PositionInfo::SelectLast()
{
   return SelectByIndex(count()-1);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PositionInfo::isBuy(void)
{
   return PositionType()==POSITION_TYPE_BUY;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PositionInfo::isSell(void)
{
   return PositionType()==POSITION_TYPE_SELL;
}
//+------------------------------------------------------------------+
//|     returns a time that this positon has opend on that candle
//+------------------------------------------------------------------+
datetime PositionInfo::timeOfCandle(ENUM_TIMEFRAMES period)
{
   return dtu.TimeRound(Time(),period);
}
//+------------------------------------------------------------------+
