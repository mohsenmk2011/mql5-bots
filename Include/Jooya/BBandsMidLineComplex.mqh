//+------------------------------------------------------------------+
//|                                         BBandsMidLineComplexComplex.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Jooya/Strategy.mqh>
#include <Jooya/PositionManager.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/DealInfo.mqh>
#include <Jooya/MaManager.mqh>

#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BBandsMidLineComplex : public Strategy
{
private:
   bool              buyLock;
   bool              sellLock;

   bool              canSell;
   bool              canBuy;

   bool              trailBuy;
   bool              trailSell;

   TrailingManager   tm;
   PositionManager   pm;
   MaManager         mam;
   string            comment;
   int conditions[5];

   void              CheckCloseConditions();

   bool              IsMidLineStraight(double midLine);
   bool              IsMidLineGoingDown(double midLine);
   bool              IsMidLineGoingUp(double midLine);

   bool              IsPriceTouchedTop(MqlRates& H1Prices[],double& line[]);
   bool              IsPriceTouchedDown(MqlRates& H1Prices[],double& line[]);
   bool              IsPricePassedUp(MqlRates& H1Prices[],double& line[]);
   bool              IsPricePassedDown(MqlRates& H1Prices[],double& line[]);


   MqlRates M1Prices[];
   MqlRates M5Prices[];
   MqlRates M15Prices[];
   MqlRates M30Prices[];
   MqlRates H1Prices[];
   MqlRates H4Prices[];
   double M1MidBandArray[];
   double M1UpperBandArray[];
   double M1LowerBandArray[];
   double M5MidBandArray[];
   double M5UpperBandArray[];
   double M5LowerBandArray[];
   double M15MidBandArray[];
   double M15UpperBandArray[];
   double M15LowerBandArray[];
   double M30MidBandArray[];
   double M30UpperBandArray[];
   double M30LowerBandArray[];
   double h1MidBandArray[];
   double h1UpperBandArray[];
   double h1LowerBandArray[];
   double h4MidBandArray[];
   double h4UpperBandArray[];
   double h4LlowerBandArray[];
public:
   BBandsMidLineComplex();
   ~BBandsMidLineComplex();
   void              Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsMidLineComplex::BBandsMidLineComplex()
{
   buyLock=false;
   sellLock=false;
   canBuy=false;
   canSell=false;

   this.comment="";
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BBandsMidLineComplex::~BBandsMidLineComplex()
{
}
//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBandsMidLineComplex::CheckCloseConditions()
{
   string t="";
   for(int i=positionInfo.count()-1; i>=0; i--)
   {
      positionInfo.SelectByIndex(i);
      ulong ticket = positionInfo.Ticket();
      string comment =positionInfo.Comment();
      if(comment.Find("c#3"))
      {
         t+="position opend with c#3,";
         if(IsPricePassedUp(H1Prices,h1MidBandArray))
         {
            t+="H1 Price is passed up,";
            t+="is closing";
            if(positionInfo.sellCount()>0)
            {
               Print(t);
               trade.PositionClose(ticket);
            }
         }
      }
      else if(comment.Find("c#4"))
      {
         t+="position opend with c#4,";
         if(IsPricePassedDown(H1Prices,h1MidBandArray))
         {
            t+="H1 Price is passed down,";
            t+="Close all buy positions";
            if(positionInfo.buyCount()>0)
            {
               Print(t);
               trade.PositionClose(ticket);
            }
         }
      }
      else if(comment.Find("c#2"))
      {
         if(IsPricePassedUp(H1Prices,h1MidBandArray))
         {
            t+="H1 Price is passed up,";
            t+="is closing";
            if(positionInfo.sellCount()>0)
            {
               Print(t);
               trade.PositionClose(ticket);
            }
         }
      }
      else if(comment.Find("c#1"))
      {
         t+="position opend with c#1,";
         if(IsPricePassedDown(M1Prices,M1LowerBandArray))
         {
            t+="M1 Price is passed down,";
            t+="Is closing";
            if(positionInfo.buyCount()>0)
            {
               Print(t);
               trade.PositionClose(ticket);
            }
         }
         else if(IsPricePassedDown(M1Prices,M1LowerBandArray))
         {
            t+="M1 Price is passed down,";
            t+="Is closing";
            if(positionInfo.buyCount()>0)
            {
               Print(t);
               trade.PositionClose(ticket);
            }
         }
      }
      else if(comment.Find("c#5"))
      {
         t+="position opend with c#5,";
         if(IsPricePassedUp(H1Prices,h1MidBandArray)||IsPriceTouchedDown(H1Prices,h1LowerBandArray))
         {
            t+="H1 Price is passed up,";
            t+="Is closing";
            if(positionInfo.buyCount()>0)
            {
               Print(t);
               trade.PositionClose(ticket);
            }
         }
      }
      else if(comment.Find("c#6"))
      {
         t+="position opend with c#6,";
         if(IsPricePassedDown(H1Prices,h1MidBandArray))
         {
            t+="H1 Price is passed down,";
            t+="Is Closing";
            if(positionInfo.buyCount()>0)
            {
               Print(t);
               trade.PositionClose(ticket);
            }
         }
         else if(IsPriceTouchedTop(H1Prices,h1UpperBandArray))
         {
            t+="H1 Price is touched up,";
            t+="Is Closing ";
            if(positionInfo.buyCount()>0)
            {
               Print(t);
               trade.PositionClose(ticket);
            }
         }
      }
   }
}
//+------------------------------------------------------------------+
//|                          Run                                     |
//+------------------------------------------------------------------+
void BBandsMidLineComplex::Run()
{
   bool c1=false;
   bool c2=false;
   bool c3=false;
   bool c4=false;
   bool c5=false;
   bool c6=false;
   bool c7=true;

   this.comment="";
   string t="";

//+----------------------------[ M1 copy rates ]-----------------------------+
   ArraySetAsSeries(M1Prices,true);
   CopyRates(Symbol(),PERIOD_M1,0,10,M1Prices);
   //+----------------------------[ M5 copy rates ]-----------------------------+
   ArraySetAsSeries(M5Prices,true);
   CopyRates(Symbol(),PERIOD_M5,0,10,M5Prices);
   //+----------------------------[ M15 copy rates ]-----------------------------+
   ArraySetAsSeries(M15Prices,true);
   CopyRates(Symbol(),PERIOD_M15,0,10,M15Prices);
   //+----------------------------[ M30 copy rates ]-----------------------------+
   ArraySetAsSeries(M30Prices,true);
   CopyRates(Symbol(),PERIOD_M30,0,10,M30Prices);
//+----------------------------[ H1 copy rates ]-----------------------------+
   ArraySetAsSeries(H1Prices,true);
   CopyRates(Symbol(),PERIOD_H1,0,10,H1Prices);
//+----------------------------[ H4 copy rates ]-----------------------------+
   ArraySetAsSeries(H4Prices,true);
   CopyRates(Symbol(),PERIOD_H4,0,10,H4Prices);
   //+--------------------------[ M1 bbands indicator ]-------------------------+

   ArraySetAsSeries(M1MidBandArray,true);
   ArraySetAsSeries(M1UpperBandArray,true);
   ArraySetAsSeries(M1LowerBandArray,true);

   int M1BBHandl=iBands(Symbol(),PERIOD_M1,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M1BBHandl,0,0,10,M1MidBandArray);
   CopyBuffer(M1BBHandl,1,0,10,M1UpperBandArray);
   CopyBuffer(M1BBHandl,2,0,10,M1LowerBandArray);
   //+--------------------------[ M5 bbands indicator ]-------------------------+

   ArraySetAsSeries(M5MidBandArray,true);
   ArraySetAsSeries(M5UpperBandArray,true);
   ArraySetAsSeries(M5LowerBandArray,true);

   int M5BBHandl=iBands(Symbol(),PERIOD_M5,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M5BBHandl,0,0,10,M5MidBandArray);
   CopyBuffer(M5BBHandl,1,0,10,M5UpperBandArray);
   CopyBuffer(M5BBHandl,2,0,10,M5LowerBandArray);
   //+--------------------------[ M15 bbands indicator ]-------------------------+

   ArraySetAsSeries(M15MidBandArray,true);
   ArraySetAsSeries(M15UpperBandArray,true);
   ArraySetAsSeries(M15LowerBandArray,true);

   int M15BBHandl=iBands(Symbol(),PERIOD_M15,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M15BBHandl,0,0,10,M15MidBandArray);
   CopyBuffer(M15BBHandl,1,0,10,M15UpperBandArray);
   CopyBuffer(M15BBHandl,2,0,10,M15LowerBandArray);
   //+--------------------------[ M30 bbands indicator ]-------------------------+

   ArraySetAsSeries(M30MidBandArray,true);
   ArraySetAsSeries(M30UpperBandArray,true);
   ArraySetAsSeries(M30LowerBandArray,true);

   int M30BBHandl=iBands(Symbol(),PERIOD_M30,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(M30BBHandl,0,0,10,M30MidBandArray);
   CopyBuffer(M30BBHandl,1,0,10,M30UpperBandArray);
   CopyBuffer(M30BBHandl,2,0,10,M30LowerBandArray);
//+--------------------------[ H1 bbands indicator ]-------------------------+

   ArraySetAsSeries(h1MidBandArray,true);
   ArraySetAsSeries(h1UpperBandArray,true);
   ArraySetAsSeries(h1LowerBandArray,true);

   int h1BBHandl=iBands(Symbol(),PERIOD_H1,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(h1BBHandl,0,0,10,h1MidBandArray);
   CopyBuffer(h1BBHandl,1,0,10,h1UpperBandArray);
   CopyBuffer(h1BBHandl,2,0,10,h1LowerBandArray);
//+--------------------------[ H4 bbands indicator ]-------------------------+

   ArraySetAsSeries(h4MidBandArray,true);
   ArraySetAsSeries(h4UpperBandArray,true);
   ArraySetAsSeries(h4LlowerBandArray,true);

   int h4BBHandl=iBands(Symbol(),PERIOD_H4,20,0,2.0,PRICE_CLOSE);

   CopyBuffer(h4BBHandl,0,0,10,h4MidBandArray);
   CopyBuffer(h4BBHandl,1,0,10,h4UpperBandArray);
   CopyBuffer(h4BBHandl,2,0,10,h4LlowerBandArray);
   //+--------------------[ M1 bband mide line Angle ]--------------------------------+
   double M1BBMidLineAngle= NormalizeDouble(mam.angle(M1Prices,M1MidBandArray),2);
   comment+="M1 BBMidLineAngle => "+M1BBMidLineAngle+"\n";
   //+--------------------[ M5 bband mide line Angle ]--------------------------------+
   double M5BBMidLineAngle= NormalizeDouble(mam.angle(M5Prices,M5MidBandArray),2);
   comment+="M5 BBMidLineAngle => "+M5BBMidLineAngle+"\n";
   //+--------------------[ M15 bband mide line Angle ]--------------------------------+
   double M15BBMidLineAngle= NormalizeDouble(mam.angle(M15Prices,M15MidBandArray),2);
   comment+="M15 BBMidLineAngle => "+M15BBMidLineAngle+"\n";
   //+--------------------[ M30 bband mide line Angle ]--------------------------------+
   double M30BBMidLineAngle= NormalizeDouble(mam.angle(M30Prices,M30MidBandArray),2);
   comment+="M30 BBMidLineAngle => "+M30BBMidLineAngle+"\n";
//+--------------------[ H1 bband mide line Angle ]--------------------------------+
   double h1BBMidLineAngle= NormalizeDouble(mam.angle(H1Prices,h1MidBandArray),2);
   comment+="h1 BBMidLineAngle => "+h1BBMidLineAngle+"\n";
//+--------------------[ H4 bband mide line Angle ]--------------------------------+
   double h4BBMidLineAngle= NormalizeDouble(mam.angle(H4Prices,h4MidBandArray),2);
   comment+="h4 BBMidLineAngle => "+h4BBMidLineAngle+"\n";
//+--------------------[  bbands height ]--------------------------------+
   double M1BBandsHeight= (M1UpperBandArray[0]-M1LowerBandArray[0])*(1/Point());
   bool CanTradeInM1=(symbolInfo.Spread()<=18)&&((M1BBandsHeight/symbolInfo.Spread())>=0.9);
   comment+="M1BBandsHeight => "+M1BBandsHeight+"\n";
   comment+="si.Spread() => "+symbolInfo.Spread()+"\n";
   comment+="CanTradeInM1 => "+CanTradeInM1+"\n";
//+--------------------------[ signals ]-------------------------+

   if(IsPriceTouchedDown(M1Prices,M1LowerBandArray))// condition   #1
   {
      t+="m1 Price touched down,";
      if(positionInfo.buyCount()==0)
      {
         conditions[1]+=1;
         t+="Is going to buy c#1=> "+IntegerToString(conditions[1]);
         Print(t);
         trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),0,0,t);
      }
   }

   //1111111111111111111111111111111111111111111
   if(IsPriceTouchedTop(H1Prices,h1UpperBandArray))// condition   #2
   {
      t+="H1 Price touched top,";
      if(positionInfo.sellCount()==0)
      {
         conditions[2]+=1;
         t+="Is going to sell c#2=> "+DoubleToString(conditions[2]);
         Print(t);
         trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),0,0,t);
      }
   }////////////////////////////////////////////////////
   else if(IsMidLineGoingDown(h1BBMidLineAngle)&&c3)
   {
      t+="H1 bbMidLine is going down,";
      //close condition is check close conditions method
      if(IsPricePassedDown(H1Prices,h1MidBandArray))// condition   #3
      {
         t+="H1 Price is passed down,";
         if(positionInfo.sellCount()==0)
         {
            conditions[3]+=1;
            t+="Is going to sell c#3=> "+DoubleToString(conditions[3]);
            Print(t);
            trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),0,0,t);
         }
      }
   }
   else if(IsMidLineGoingUp(h1BBMidLineAngle)&&c4)
   {
      t+="H1 bbMidLine is going up,";
      if(IsPricePassedUp(H1Prices,h1MidBandArray)) // condition   #4
      {
         t+="H1 Price is passed up,";
         if(positionInfo.buyCount()==0)
         {
            conditions[4]+=1;
            t+="Is going to buy c#4=> "+DoubleToString(conditions[4]);
            Print(t);
            trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),0,0,t);
         }
      }
   }
   else if(c5)
   {
      if(IsPricePassedUp(H4Prices,h4MidBandArray)) // condition   #6
      {
         t+="H1 Price is passed up,";
         if(positionInfo.buyCount()==0)
         {
            conditions[4]+=1;
            t+="so buy c#6 => "+IntegerToString(conditions[4]);
            Print(t);
            trade.Buy(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),0,0,t);
         }
      }
      if(IsPricePassedDown(H4Prices,h4MidBandArray)) // condition   #5
      {
         t+="H1 Price is passed down,";
         if(positionInfo.sellCount()==0)
         {
            conditions[4]+=1;
            t+="so sell c#5 => "+IntegerToString(conditions[4]);
            Print(t);
            trade.Sell(pm.newPositionVolume(),Symbol(),symbolInfo.Ask(),0,0,t);
         }
      }
   }
   else if(c7)
   {
   
   }
   CheckCloseConditions();
   Comment(this.comment+tm.comment);
}
//+------------------------------------------------------------------+
//|                  Is MidLine Straight                             |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex::IsMidLineStraight(double angle)
{
   return angle>=-11.25&&angle<=11.25;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going down                             |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex::IsMidLineGoingDown(double angle)
{
   return angle<=-11.25;
}
//+------------------------------------------------------------------+
//|                   Is MidLine going up                            |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex::IsMidLineGoingUp(double angle)
{
   return angle>=11.25;
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Top                             |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex::IsPriceTouchedTop(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close>=line[2]&&H1Prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
//|                 Is Price Touched Down                            |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex::IsPriceTouchedDown(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close<=line[2]&&H1Prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Up                              |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex::IsPricePassedUp(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close<=line[2]&&H1Prices[1].close>=line[1];
}
//+------------------------------------------------------------------+
//|                  Is Price Passed Down                            |
//+------------------------------------------------------------------+
bool BBandsMidLineComplex::IsPricePassedDown(MqlRates& H1Prices[],double& line[])
{
   return H1Prices[2].close>=line[2]&&H1Prices[1].close<=line[1];
}
//+------------------------------------------------------------------+
