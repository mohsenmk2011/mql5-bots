//+------------------------------------------------------------------+
//|                                                   LineManager.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LineManager
{
private:
public:
   LineManager();
   ~LineManager();
   double            angle(MqlRates& rates[],double& maBuffer[]);
   double            angleAverage(MqlRates& rates[],double& maBuffer[]);
   bool              IsStraight(double midLine);
   bool              IsGoingDown(double midLine);
   bool              IsGoingUp(double midLine);

   /// first has gone top of two
   bool              CrossOver(double& first[],double& two[]);
   bool              PassedMinDistance(double& first[],double& second[],double minDistance);
   /// first is smaller than two
   bool              SmallerThan(double& first[],double& two[]);
   bool              BiggerThan(double& first[],double& two[]);
   double            Distance(double first,double two);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LineManager::LineManager()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LineManager::~LineManager()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LineManager::angle(MqlRates& rates[],double& maBuffer[])
{
   double adjacent=sqrt((int)rates[0].time-(int)rates[6].time);
   double opposite=(maBuffer[0]-maBuffer[6])/_Point;
   double angle=MathArctan((double)opposite/(double)adjacent) * 180/M_PI;
   double normalangle= NormalizeDouble(angle,2);
   return normalangle;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LineManager::angleAverage(MqlRates& rates[],double& maBuffer[])
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

   double normalangle= NormalizeDouble(av,2);
   return normalangle;
}
//+------------------------------------------------------------------+
//|                  Is MidLine Straight                             |
//+------------------------------------------------------------------+
bool LineManager::IsStraight(double angle)
{
   return angle>=-11.25&&angle<=11.25;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going down                             |
//+------------------------------------------------------------------+
bool LineManager::IsGoingDown(double angle)
{
   return angle<=-11.25;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going up                            |
//+------------------------------------------------------------------+
bool LineManager::IsGoingUp(double angle)
{
   return angle>=11.25;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
bool LineManager::CrossOver(double& first[],double& two[])
{
   if(first[1]<two[1]&&first[0]>two[0])
   {
      return true;
   }
   return false;
}

//===========================================================================
bool LineManager::PassedMinDistance(double& first[],double& second[],double minDistance)
{
   if(first[1]>=second[1]&&first[0]>second[0]&&Distance(first[0],second[0])>minDistance)
   {
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LineManager::SmallerThan(double& first[],double& two[])
{
   if(first[0]<two[0]&&first[1]<two[1])
   {
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LineManager::BiggerThan(double& first[],double& two[])
{
   if(first[0]>two[0]&&first[1]>two[1])
   {
      return true;
   }
   return false;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LineManager::Distance(double first,double two)
{
   double t=first-two;
   if(t<0)
   {
      return -t;
   }
   return t;
}
//+------------------------------------------------------------------+
