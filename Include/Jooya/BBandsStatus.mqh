//+------------------------------------------------------------------+
//|                                                 BBandsStatus.mqh |
//|                                            Copyright 2022, Jooya |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

enum BBandsStatus
{
   BBands_Status_Unkown,
   BBands_Status_BiggerThan_UpperBand,
   BBands_Status_PassedDown_UpperBand,
   BBands_Status_PassedUp_UpperBand,
   BBands_Status_Between_Upper_MiddleBand,
   BBands_Status_PassedDown_MiddleBand,
   BBands_Status_PassedUp_MiddleBand,
   BBands_Status_Between_Lower_MiddleBand,
   BBands_Status_PassedDown_LowerBand,
   BBands_Status_SmallerThan_LowerBand,
   BBands_Status_PassedUp_LowerBand,
};
//+------------------------------------------------------------------+
