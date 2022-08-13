//+------------------------------------------------------------------+
//|                                                    MaManager.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class MaManager
  {
private:

public:
                     MaManager();
                    ~MaManager();
                    double angle(MqlRates& rates[],double& maBuffer[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaManager::MaManager()
  {
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
double MaManager::angle(MqlRates& rates[],double& maBuffer[])
  {  
   double adjacent=sqrt((int)rates[1].time-(int)rates[5].time);
   double opposite=(maBuffer[1]-maBuffer[5])/_Point;
   double angle=MathArctan((double)opposite/(double)adjacent) * 180/M_PI;
   return angle;
  }
//+------------------------------------------------------------------+
