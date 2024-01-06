//+------------------------------------------------------------------+
//|                                                    MaManager.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Jooya/RsiStatus.mqh>
#include <Jooya/Strategy.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MaManager: public Strategy
{
private:
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
   RsiStatus getStatus(double& buffer[]);///////////////////////

public:
   MaManager();
   ~MaManager();
   void checkSignal() override;
   void checkCloseCondition() override;
   void readIndicotor() override;
   void updateStatus() override;
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
MaManager::MaManager()
{
   M1Handle = iMA(Symbol(),PERIOD_M1,maPeriod,0,MODE_SMA,appliedPrice);
   ArraySetAsSeries(M1Array,true);
   M5Handle = iMA(Symbol(),PERIOD_M5,maPeriod,0,MODE_SMA,appliedPrice);
   ArraySetAsSeries(M5Array,true);
   M15Handle = iMA(Symbol(),PERIOD_M15,maPeriod,0,MODE_SMA,appliedPrice);
   ArraySetAsSeries(M15Array,true);
   M30Handle = iMA(Symbol(),PERIOD_M30,maPeriod,0,MODE_SMA,appliedPrice);
   ArraySetAsSeries(M30Array,true);
   H1Handle = iMA(Symbol(),PERIOD_H1,maPeriod,0,MODE_SMA,appliedPrice);
   ArraySetAsSeries(H1Array,true);
   H4Handle = iMA(Symbol(),PERIOD_H4,maPeriod,0,MODE_SMA,appliedPrice);
   ArraySetAsSeries(H4Array,true);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaManager::~MaManager()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MaManager::checkSignal()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MaManager::checkCloseCondition()
{
   Print("StochManager::checkCloseCondition");
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MaManager::readIndicotor()
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
void MaManager::updateStatus()
{
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
RsiStatus MaManager::getStatus(double& buffer[])
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

//+------------------------------------------------------------------+
