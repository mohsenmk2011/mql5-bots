//+------------------------------------------------------------------+
//|                                                   RsiManager.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Jooya/RsiStatus.mqh>
#include <Jooya/RatesManager.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RsiManager
{
private:
   int MagicNumber;
   RatesManager rm;
   //-------< Buffers >-----------
   double            M1Array[];
   double            M5Array[];
   double            M15Array[];
   double            M30Array[];
   double            H1Array[];
   double            H4Array[];
   //-------< Handles >-----------
   int M1Handle;
   int M5Handle;
   int M15Handle;
   int M30Handle;
   int H1Handle;
   int H4Handle;
   //----< Private methods >-------
   RsiStatus getStatus(double& buffer[]);
public:
   RsiManager();
   ~RsiManager();
   void checkSignal();
   void checkCloseCondition();
   void readIndicotor();
   void updateStatus();

   ///------------------------------
   RsiStatus M1Status;
   RsiStatus M5Status;
   RsiStatus M15Status;
   RsiStatus M30Status;
   RsiStatus H1Status;
   RsiStatus H4Status;
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RsiManager::RsiManager()
{
   M1Handle = iRSI(Symbol(),PERIOD_M1,21,PRICE_CLOSE);
   ArraySetAsSeries(M1Array,true);
   M5Handle = iRSI(Symbol(),PERIOD_M5,21,PRICE_CLOSE);
   ArraySetAsSeries(M5Array,true);
   M15Handle = iRSI(Symbol(),PERIOD_M15,21,PRICE_CLOSE);
   ArraySetAsSeries(M15Array,true);
   M30Handle = iRSI(Symbol(),PERIOD_M30,21,PRICE_CLOSE);
   ArraySetAsSeries(M30Array,true);
   H1Handle = iRSI(Symbol(),PERIOD_H1,21,PRICE_CLOSE);
   ArraySetAsSeries(H1Array,true);
   H4Handle = iRSI(Symbol(),PERIOD_H4,21,PRICE_CLOSE);
   ArraySetAsSeries(H4Array,true);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RsiManager::~RsiManager()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RsiManager::checkSignal()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RsiManager::checkCloseCondition()
{
   Print("StochManager::checkCloseCondition");
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RsiManager::readIndicotor()
{
   CopyBuffer(M1Handle,0,0,2,M1Array);
   CopyBuffer(M5Handle,0,0,2,M5Array);
   CopyBuffer(M15Handle,0,0,2,M15Array);
   CopyBuffer(M30Handle,0,0,2,M30Array);
   CopyBuffer(H1Handle,0,0,2,H1Array);
   CopyBuffer(H4Handle,0,0,2,H4Array);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RsiManager::updateStatus()
{
   rm.copyRates();
   readIndicotor();

   M1Status = getStatus(M1Array);
   M5Status = getStatus(M5Array);
   M15Status = getStatus(M15Array);
   M30Status = getStatus(M30Array);
   H1Status = getStatus(H1Array);
   H4Status = getStatus(H4Array);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RsiStatus RsiManager::getStatus(double& buffer[])
{
   if(buffer[1]<30)
   {
      if(buffer[0]<30)
      {
         return RsiStatus_SmallerThanLowerLevel;
      }
      else if(buffer[0]>30)
      {
         return RsiStatus_PassedUpLowerLevel;
      }
   }
   else if(buffer[1]>30)
   {
      if(buffer[0]<30)
      {
         return RsiStatus_PassedDownLowerLevel;
      }
      else if(buffer[0]>30)
      {
         return RsiStatus_BetweenTwoLevel;
      }
   }
   else if(buffer[1]<70)
   {
      if(buffer[0]>70)
      {
         return RsiStatus_PassedUpUpperLevel;
      }
      else if(buffer[0]<70)
      {
         return RsiStatus_BetweenTwoLevel;
      }
   }
   else if(buffer[1]>70)
   {
      if(buffer[0]<70)
      {
         return RsiStatus_PassedDownUpperLevel;
      }
      else if(buffer[0]>70)
      {
         return RsiStatus_BiggerThanUpperLevel;
      }
   }
   return RsiStatus_Unknown;
}
//+------------------------------------------------------------------+
