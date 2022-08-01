//+------------------------------------------------------------------+
//|                                                   MaStrategy4.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Jooya/Strategy.mqh>
#include <Trade/Trade.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/DealInfo.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/HistoryOrderInfo.mqh>
#include <Arrays/List.mqh>
#include <Jooya/Step.mqh>
#include <Jooya/CrossStates.mqh>
#include <Jooya/MaTypes.mqh>
#include <Jooya/MaLine.mqh>
#include <Jooya/TradeStates.mqh>

#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Jooya/MaLine.mqh>

class MaStrategy:public Strategy{
   private:
      CTrade trade;
      CSymbolInfo symbolInfo;
      double DistanceAtCross_H4_D1;
      double CurrentDistance_H4_D1;
                  
      Step topStep;
      Step downStep;
      double PriceAverageDistanceFromD1;
      bool D1IsAboveH4;
      bool H4IsAboveD1;
      
      MaLine MaSlow;
      MaLine MaFast;
      MaLine MaVeryFast;
      TradeStates TradeState;
      
   public:
      MaStrategy();
      ~MaStrategy();
      void Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaStrategy::MaStrategy()
{
   PriceAverageDistanceFromD1=20.0;
   //MaVeryFastHandle= iMA(Symbol(),PERIOD_M1,30,0,MODE_EMA,PRICE_CLOSE);
   //MaFastHandle= iMA(Symbol(),PERIOD_M1,240,0,MODE_EMA,PRICE_CLOSE);
   //MaSlowHandle= iMA(Symbol(),PERIOD_M1,1440,0,MODE_EMA,PRICE_CLOSE);
   MaFast=MaLine(240,MaTypeFast);
   MaSlow=MaLine(1440,MaTypeSlow);
   
   //MaVeryFastCrossingState= NotCrossed;
   //MaFastCrossingState=NotCrossed;
   //MaSlowCrossingState=NotCrossed;
   
   DistanceAtCross_H4_D1=0.0;
   CurrentDistance_H4_D1=0.0;   
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaStrategy::~MaStrategy()
{
}

//+------------------------------------------------------------------+
void MaStrategy::Run(){
   string commment="";   
   MaFast.CopyBufferToArray();
   MaSlow.CopyBufferToArray();
   
   //double CurrentDistance_H4_D1=NormalizeDouble(Distance(MaFastArray[0],MaSlowArray[0]),Digits());
   
   commment+="Current Distance H4 & D1: "+DoubleToString(CurrentDistance_H4_D1,Digits())+"\n";
   //D1IsAboveH4=BiggerThan(MaSlowArray,MaFastArray);
   
   bool D1IsGoingUp=true;
   
   //========================================================================    
  
      commment+="H4 Is Above \n";
      commment+="BuyPrice= "+DoubleToString(symbolInfo.Ask(),Digits());
      if(MaFast.CrossState==NotCrossed){
         CrossOver(MaFast,MaSlow);         
      }
      if(MaFast.CrossState==CrossedSlow){
         MaSlow.CrossState==NotCrossed;
         if(TradeState==TradeStateHaNoOpenPosition){
            Print("Is Buying ...");
            trade.Buy(0.5,Symbol(),symbolInfo.Ask());
         }
         if(TradeState==TradeStateHasSellPosition){
            if(positionInfo.count()>0){
              trade.PositionClose(Symbol());
              TradeState=TradeStateHasSellPosition;
            }
         }
      }      
      if(MaSlow.CrossState==NotCrossed)
      {
         CrossOver(MaSlow,MaFast);
      }
      if(MaSlow.CrossState==CrossedFast){
         MaFast.CrossState=NotCrossed;
         if(TradeState==TradeStateHaNoOpenPosition){
            Print("Is Selling ...");
            trade.Sell(0.5,Symbol(),symbolInfo.Bid());
         }
         if(TradeState==TradeStateHasSellPosition){
            if(positionInfo.count()>0){
              trade.PositionClose(Symbol());
              TradeState=TradeStateHasSellPosition;
            }
         }
      }
   //------------------------------------------------------------------
   Comment(commment);
   //========================================================================      
}