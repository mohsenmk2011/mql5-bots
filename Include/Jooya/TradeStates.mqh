//+------------------------------------------------------------------+
//|                                                  TradeStates.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

enum TradeStates
{
   TradeStateUnknown=0,
   TradeStateHasBuyPosition=1,
   TradeStateHasSellPosition=2,
   TradeStateHaNoOpenPosition=3,   
}; 