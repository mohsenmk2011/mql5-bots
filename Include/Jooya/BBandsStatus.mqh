//+------------------------------------------------------------------+
//|                                                 BBandsStatus.mqh |
//|                                            Copyright 2022, Jooya |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

enum BBandsStatus
{
   BBands_Status_Unkown =0,
   BBands_Status_Buy_UpperBand=1,
   BBands_Status_UpperBand=1,
   BBands_Status_Sell_UpperBand=2,
   BBands_Status_Buy_MiddleBand=3,
   BBands_Status_Sell_MiddleBand=4,
   BBands_Status_Between_Upper_MiddleBand=5,
   BBands_Status_Between_Lower_MiddleBand=6,
   BBands_Status_Sell_LowerBand=7,
   BBands_Status_LowerBand=7,
   BBands_Status_Buy_LowerBand=8,
};
//+------------------------------------------------------------------+
