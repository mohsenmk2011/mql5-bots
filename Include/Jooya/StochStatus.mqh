//+------------------------------------------------------------------+
//|                                              StochStatus.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

enum StochStatus
{
   StochStatus_NotCrossed=0,
   StochStatus_KCrossedD=1,
   StochStatus_DCrossedK=2,
   //two line K and D are below of 80 for first time
   StochStatus_PassedDownUpperLevel =3,
   //two line K and D are above of 20 for first time
   StochStatus_PassedUpLowerLevel=4,
   //two line K and D are below of 80
   StochStatus_IsGoingDown =5,
   //two line K and D are above of 20
   StochStatus_IsGoingUp=6,
};