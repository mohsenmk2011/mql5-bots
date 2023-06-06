//+------------------------------------------------------------------+
//|                                                   JooyaRates.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class JooyaRates
{
private:
   int               m_Score;
public:
   JooyaRates();
   ~JooyaRates();
   int               score();
   bool              IsDownCandle(MqlRates &rate);
   bool              IsUpCandle(MqlRates &rate);
   //===============================================================================
   double            BodyLength(MqlRates &rate);
   double            BottomShadow(MqlRates &rate);
   double            UpShadow(MqlRates &rate);
   //===============================================================================
   bool              IsHammerCandle(MqlRates &rate);
   bool              IsPriceTouchedTop(MqlRates& prices[],double& line[]);
   bool              IsPriceTouchedDown(MqlRates& prices[],double& line[]);
   bool              IsPricePassedUp(MqlRates& prices[],double& line[]);
   bool              IsPricePassedDown(MqlRates& prices[],double& line[]);
   //===============================================================================
   double            angle(MqlRates& rates[],double& maBuffer[]);
   double            angleAverage(MqlRates& rates[],double& maBuffer[]);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JooyaRates::JooyaRates()
{
   m_Score=0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JooyaRates::~JooyaRates()
{
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int JooyaRates::score()
{
   return m_Score;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JooyaRates::IsDownCandle(MqlRates &rate)
{
   return rate.close<rate.open;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JooyaRates::IsUpCandle(MqlRates &rate)
{
   return !IsDownCandle(rate);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JooyaRates::BodyLength(MqlRates &rate)
{
   double t=rate.close-rate.open;
   if(t<0)
   {
      return -t;
   }
   return t;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JooyaRates::BottomShadow(MqlRates &rate)
{
   if(IsDownCandle(rate))
   {
      return rate.close-rate.low;
   }
   else
   {
      return rate.open-rate.low;
   }
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JooyaRates::UpShadow(MqlRates &rate)
{
   if(IsDownCandle(rate))
   {
      return rate.close-rate.low;
   }
   else
   {
      return rate.open-rate.low;
   }
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool JooyaRates::IsHammerCandle(MqlRates &rate)
{
   if(!IsDownCandle(rate))
   {
      return false;
   }
   double bl=BodyLength(rate);
   double bsh=BottomShadow(rate);
   if(bsh<bl)
   {
      return false;
   }
   if(!((bsh/bl)>2))
   {
      return false;
   }
   double tsh=UpShadow(rate);
   if(tsh>bl)
   {
      return false;
   }
   if((bl/tsh)>3)
   {
      return false;
   }
   return true;
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                 Is Price Touched Top                             |
//+------------------------------------------------------------------+
bool JooyaRates::IsPriceTouchedTop(MqlRates& prices[],double& line[])
{
   return prices[2].close>=line[2]&&prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Down                            |
//+------------------------------------------------------------------+
bool JooyaRates::IsPriceTouchedDown(MqlRates& prices[],double& line[])
{
   return prices[2].close<=line[2]&&prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Up                              |
//+------------------------------------------------------------------+
bool JooyaRates::IsPricePassedUp(MqlRates& prices[],double& line[])
{
   return prices[2].close<=line[2]&&prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Down                            |
//+------------------------------------------------------------------+
bool JooyaRates::IsPricePassedDown(MqlRates& prices[],double& line[])
{
   return prices[2].close>=line[2]&&prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JooyaRates::angle(MqlRates& rates[],double& maBuffer[])
{
   double adjacent=sqrt((int)rates[0].time-(int)rates[6].time);
   double opposite=(maBuffer[0]-maBuffer[6])/_Point;
   double angle=MathArctan((double)opposite/(double)adjacent) * 180/M_PI;
   return angle;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double JooyaRates::angleAverage(MqlRates& rates[],double& maBuffer[])
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
