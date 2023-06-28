//+------------------------------------------------------------------+
//|                                              DateTimeUtility.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class DateTimeUtility
{
private:

public:
   DateTimeUtility();
   ~DateTimeUtility();

   datetime TimeRound(datetime dt,ENUM_TIMEFRAMES period);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DateTimeUtility::DateTimeUtility()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
DateTimeUtility::~DateTimeUtility()
{
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime DateTimeUtility::TimeRound(datetime dt,ENUM_TIMEFRAMES period)
{
   int secondsInPeriod = PeriodSeconds(period);
   datetime roundedTime = (dt / secondsInPeriod) * secondsInPeriod;
   return roundedTime;
}
//+------------------------------------------------------------------+
