//+------------------------------------------------------------------+
//|                                                     Strategy.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Jooya/PositionInfo.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/Trade.mqh>
#include <Trade/OrderInfo.mqh>
#include <Jooya/CrossStates.mqh>
#include <Jooya/MaLine.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Strategy
  {
private:

public:
                     Strategy();
                    ~Strategy();
   /// first has gone top of two
   bool              CrossOver(double& first[],double& two[]);
   void              CrossOver(MaLine &firstLine,MaLine &secondLine);
   bool              PassedMinDistance(double& first[],double& second[],double minDistance);
   PositionInfo      positionInfo;
   SymbolInfo        symbolInfo;
   Trade            trade;
   COrderInfo        orderInfo;
   /// first is smaller than two
   bool              SmallerThan(double& first[],double& two[]);
   bool              BiggerThan(double& first[],double& two[]);
   double            Distance(double first,double two);
   bool              ClosePositiveTrades(double minProfit);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Strategy::Strategy()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Strategy::~Strategy()
  {
  }
//+------------------------------------------------------------------+
bool Strategy::CrossOver(double& first[],double& two[])
  {

   if(first[1]<two[1]&&first[0]>two[0])
     {
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Strategy::CrossOver(MaLine& firstLine,MaLine& secondLine)
  {

   Print("firstLine.BufferArray[0]",firstLine.BufferArray[0]);
   Print("firstLine.BufferArray[1]",firstLine.BufferArray[1]);
   Print("secondLine.BufferArray[0]",secondLine.BufferArray[0]);
   Print("secondLine.BufferArray[1]",secondLine.BufferArray[1]);
   if(firstLine.BufferArray[1]<secondLine.BufferArray[1]&&firstLine.BufferArray[0]>secondLine.BufferArray[0])
     {
      Print("@@@@@@@@@@ Crossed over @@@@@@@@@@ ");

      if(firstLine.Type==MaTypeFast)
        {
         firstLine.CrossState=CrossedSlow;
        }
      else
         if(firstLine.Type==MaTypeSlow)
           {
            firstLine.CrossState=CrossedFast;
           }

     }
   else
     {
      Print("@@@------ Not Cross over yet-------@@@ ");
     }

  }
//===========================================================================
bool Strategy::PassedMinDistance(double& first[],double& second[],double minDistance)
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
bool Strategy::SmallerThan(double& first[],double& two[])
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
bool Strategy::BiggerThan(double& first[],double& two[])
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
double Strategy::Distance(double first,double two)
  {
   double t=first-two;
   if(t<0)
     {
      return -t;
     }
   return t;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Strategy::ClosePositiveTrades(double minProfit)
  {
   int count=positionInfo.count();
   positionInfo.SelectFirst();
   for(int i=0; i<count; i++)
     {
      if(positionInfo.Profit()>minProfit)
        {
         trade.PositionClose(positionInfo.Ticket());
         positionInfo.Next();
        }
     }
   return positionInfo.count()>0;
  }
//+------------------------------------------------------------------+
