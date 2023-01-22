//+------------------------------------------------------------------+
//|                                         JooyaHedgingStrategy.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Jooya/Strategy.mqh>
#include <Trade/Trade.mqh>
#include <Trade/DealInfo.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/SymbolInfo.mqh>

class JooyaHedgingStrategy : public Strategy{
   private:
      CTrade trade;
      SymbolInfo symbolInfo;
      PositionInfo positionInfo;
      int PriceZone;
      int TPSL_Pips;
   
   public:
      JooyaHedgingStrategy();
      ~JooyaHedgingStrategy();
      void Run();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JooyaHedgingStrategy::JooyaHedgingStrategy(){
   PriceZone=5;
   TPSL_Pips=20;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
JooyaHedgingStrategy::~JooyaHedgingStrategy(){
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
void JooyaHedgingStrategy::Run(){
   string commment=""; 
   double AskPrice= symbolInfo.AskTick();
   double BidPrice= symbolInfo.BidTick();
   double Spread=AskPrice-BidPrice;
   commment+="AskPrice= "+DoubleToString(AskPrice,Digits())+"\n";
   double SellPirce=BidPrice-(PriceZone*Point());
   commment+="BidPrice= "+DoubleToString(BidPrice,Digits())+"\n";
   commment+="OrdersTotal=> "+IntegerToString(OrdersTotal())+"\n";
   commment+="SellPirce=> "+SellPirce+"\n";
   if(positionInfo.count()>0){
     //trade.PositionClose(Symbol());
     ClosePositiveTrades(10);
   }
   else{
      if(OrdersTotal()>0){
         return;
      }
      double Spread=AskPrice-BidPrice;
      commment+="AskPrice= "+DoubleToString(AskPrice,Digits())+"\n";
      commment+="BidPrice= "+DoubleToString(BidPrice,Digits())+"\n";
      
      
      double BuyPirce=AskPrice+(PriceZone*Point());
      double BuyStopLoss=BuyPirce-(TPSL_Pips*Point());
      double BuyTakeProfit=BuyPirce+(TPSL_Pips*Point());      
      trade.BuyStop(1.0,BuyPirce,Symbol(),0,BuyTakeProfit);
      
      double SellPirce=BidPrice-(PriceZone*Point());
      double SellStopLoss=SellPirce-(TPSL_Pips*Point());
      double SellTakeProfit=SellPirce+(TPSL_Pips*Point());  
      trade.SellStop(1.0,SellPirce,Symbol(),0,SellTakeProfit);
   }  
   Comment(commment);   
}
