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
