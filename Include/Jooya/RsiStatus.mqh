//+------------------------------------------------------------------+
//|                                                    RsiStatus.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

enum RsiStatus
{
   RsiStatus_Unknown,
   RsiStatus_PassedUpUpperLevel,
   RsiStatus_PassedUpLowerLevel,
   RsiStatus_PassedDownUpperLevel,
   RsiStatus_PassedDownLowerLevel,
   RsiStatus_BetweenTwoLevel,
   RsiStatus_SmallerThanLowerLevel,
   RsiStatus_BiggerThanUpperLevel   
};
//+------------------------------------------------------------------+
