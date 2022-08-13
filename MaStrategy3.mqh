//+------------------------------------------------------------------+
//|                                                   MaStrategy3.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Jooya/Strategy.mqh>
#include <Jooya/MaManager.mqh>
#include <Trade/Trade.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/DealInfo.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/HistoryOrderInfo.mqh>
#include <Arrays/List.mqh>
#include <Jooya/Step.mqh>

#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class MaStrategy3:public Strategy
  {
private:
   CTrade            trade;
   CSymbolInfo       symbolInfo;
   double            DistanceAtCross_H4_D1;
   double            CurrentDistance_H4_D1;
   double            MaH4Array[];
   int               MaH4Handle;

   MaManager         mam;

   double            MaD1Array[];
   int               MaD1Handle;

   Step              topStep;
   Step              downStep;
   double            PriceAverageDistanceFromD1;
   bool              D1IsAboveH4;
   bool              H4IsAboveD1;
   bool              D1CrossedH4;
   bool              H4CrossedD1;

public:
                     MaStrategy3();
                    ~MaStrategy3();
   void              Run();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaStrategy3::MaStrategy3()
  {
   PriceAverageDistanceFromD1=20.0;
   MaH4Handle= iMA(Symbol(),PERIOD_M1,240,0,MODE_EMA,PRICE_CLOSE);
   MaD1Handle= iMA(Symbol(),PERIOD_M1,1440,0,MODE_EMA,PRICE_CLOSE);
   DistanceAtCross_H4_D1=0.0;
   CurrentDistance_H4_D1=0.0;
   D1CrossedH4=false;
   H4CrossedD1=false;

   int subwindow=(int)ChartGetInteger(0,CHART_WINDOWS_TOTAL);
   ChartIndicatorAdd(0,subwindow,MaH4Handle);
   ChartIndicatorAdd(0,subwindow,MaD1Handle);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaStrategy3::~MaStrategy3()
  {
  }

//+------------------------------------------------------------------+
void MaStrategy3::Run()
  {
   Print("Strategy 03 is startd");
   string commment="";
   CopyBuffer(MaH4Handle,0,1,10,MaH4Array);
   ArraySetAsSeries(MaH4Array,true);
   CopyBuffer(MaD1Handle,0,1,2,MaD1Array);
   ArraySetAsSeries(MaD1Array,true);

   double CurrentDistance_H4_D1=NormalizeDouble(Distance(MaH4Array[0],MaD1Array[0]),Digits());

   commment+="Current Distance H4 & D1: "+DoubleToString(CurrentDistance_H4_D1,Digits())+"\n";

   MqlRates Prices[];
   ArraySetAsSeries(Prices,true);
   int count = CopyRates(Symbol(),Period(),0,10,Prices);

   double angle=mam.angle(Prices,MaH4Array);

   commment+="angle => "+angle+"\n";

   D1IsAboveH4=BiggerThan(MaD1Array,MaH4Array);

   bool D1IsGoingUp=true;
//Comment("ma5[",MaM15Array[0],",",MaM15Array[1],"]\n","ma10[",MaH4Array[0],",",MaH4Array[1],"]\n","ma200[",MaD1Array[0],",",MaD1Array[1],"]");
//========================================================================

   commment+="H4 Is Above \n";
   commment+="BuyPrice= "+DoubleToString(symbolInfo.Ask(),Digits());
   if(H4CrossedD1)
     {
      commment+="H4 Cross Over D1("+DoubleToString(DistanceAtCross_H4_D1,Digits())+")\n";
      positionInfo.SelectLast();
      commment+="LastTicket="+IntegerToString(positionInfo.Ticket())+")\n";
     }
   else
     {
      commment+="H4 Not Crossed D1\n";
      H4CrossedD1=CrossOver(MaH4Array,MaD1Array);
      if(H4CrossedD1)
        {
         Print("H4 Cross Over D1");
         DistanceAtCross_H4_D1=CurrentDistance_H4_D1;
         D1CrossedH4=false;
         if(positionInfo.count()>0)
           {
            //positionInfo.SelectLast();
            //if(positionInfo.Type()==POSITION_TYPE_BUY){
            //   Print("Buy Position Exsists-> return");
            //}
            //else{
            //   Print("Closing Current Sell Position");
            //   trade.PositionClose(positionInfo.Ticket());
            //}
            //trade.PositionClose(positionInfo.Ticket());
            trade.PositionClose(Symbol());
           }
         Print("Is Buying ...");
         trade.Buy(0.5,Symbol(),symbolInfo.Ask());
        }
     }
//-------------------------------------------------
   commment+="D1 Is Above \n";
   if(D1CrossedH4)
     {
      commment+="D1 Cross Over H4("+DoubleToString(DistanceAtCross_H4_D1,Digits())+")\n";
      positionInfo.SelectLast();
      commment+="LastTicket="+IntegerToString(positionInfo.Ticket())+")\n";
     }
   else
     {
      commment+="D1 Not Crossed H4\n";
      D1CrossedH4=CrossOver(MaD1Array,MaH4Array);
      if(D1CrossedH4)
        {
         Print("D1 Cross Over H4");
         DistanceAtCross_H4_D1=CurrentDistance_H4_D1;
         H4CrossedD1=false;
         if(positionInfo.count()>0)
           {
            //positionInfo.SelectLast();
            //if(positionInfo.Type()==POSITION_TYPE_SELL){
            //   Print("Sell Position Exsists-> return");
            //}
            //else{
            //   Print("Closing Current Buy Position");
            //   trade.PositionClose(positionInfo.Ticket());
            //}
            //trade.PositionClose(positionInfo.Ticket());
            trade.PositionClose(Symbol());
           }
         Print("Is Selling ...");
         trade.Sell(0.5,Symbol(),symbolInfo.Bid());
        }
     }
//------------------------------------------------------------------
   Comment(commment);
//========================================================================
  }
//+------------------------------------------------------------------+
