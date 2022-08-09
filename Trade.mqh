//+------------------------------------------------------------------+
//|                                                        Trade.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/LogManager.mqh>

#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Trade : public CTrade
  {
private:
   LogManager        lm;
   PositionInfo      pi;
   SymbolInfo        si;

public:
                     Trade();
                    ~Trade();
   void              PositionCloseAll(ENUM_POSITION_TYPE type);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Trade::Trade()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Trade::~Trade()
  {
  }
//+------------------------------------------------------------------+
void Trade::PositionCloseAll(ENUM_POSITION_TYPE type)
  {
   Print("Close positions of type => "+type);
   Print("Open position count => "+pi.count());
   for(int i=pi.count()-1; i>=0; i--)
     {
      pi.SelectByIndex(i);
      Print("Current position type => "+pi.PositionType());
      if(pi.PositionType()==type)
        {
         ulong ticket = pi.Ticket();
         lm.postionType(pi.PositionType());
         Print("founded one position by ticket => "+ticket);
         PositionClose(ticket);
        }
     }
  }
//+------------------------------------------------------------------+
