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
   double            angle(MqlRates& rates[],double& maBuffer[]);
   double            angleAverage(MqlRates& rates[],double& maBuffer[]);
   double            average(MqlRates& rates[],double& maBuffer[]);
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
   double adjacent=sqrt((int)rates[0].time-(int)rates[6].time);
   double opposite=(maBuffer[0]-maBuffer[6])/_Point;
   double angle=MathArctan((double)opposite/(double)adjacent) * 180/M_PI;
   return angle;
  }
  
  double MaManager::angleAverage(MqlRates& rates[],double& maBuffer[])
  {      
   double adjacent1=sqrt((int)rates[0].time-(int)rates[1].time);
   double opposite1=(maBuffer[0]-maBuffer[1])/_Point;
   double angle1=MathArctan((double)opposite1/(double)adjacent1) * 180/M_PI;  
   
   double adjacent2=sqrt((int)rates[0].time-(int)rates[2].time);
   double opposite2=(maBuffer[0]-maBuffer[2])/_Point;
   double angle2=MathArctan((double)opposite2/(double)adjacent2) * 180/M_PI;   
    
   // ------------------------------
   double adjacent3=sqrt((int)rates[1].time-(int)rates[2].time);
   double opposite3=(maBuffer[1]-maBuffer[2])/_Point;
   double angle3=MathArctan((double)opposite3/(double)adjacent3) * 180/M_PI;   
   
   double av=(angle1+angle1+angle1+angle2+angle2+angle3)/6;
   return av;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MaManager::average(MqlRates& rates[],double& maBuffer[])
  {
   return 0;
  }
//+------------------------------------------------------------------+
