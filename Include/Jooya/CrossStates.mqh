//+------------------------------------------------------------------+
//|                                                  CrossStates.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

enum CrossStates
{
   NotCrossed=0,
   CrossedSlow=1,
   CrossedFast=2,
   CrossedVeryFast=3,   
}; 