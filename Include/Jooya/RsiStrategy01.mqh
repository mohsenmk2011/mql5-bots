//+------------------------------------------------------------------+
//|                                                RsiStrategy01.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Jooya/Strategy.mqh>
#include <Trade/Trade.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Jooya/PositionInfo.mqh>

class RsiStrategy01 : public Strategy{
   private:
      CTrade trade;
      double RsiArray[];
      int RsiHandl;
      CSymbolInfo symbolInfo;
      PositionInfo positionInfo;
   public:
     RsiStrategy01();
     ~RsiStrategy01();
     void Run();     
     
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RsiStrategy01::RsiStrategy01(){
   RsiHandl= iRSI(Symbol(),PERIOD_M1,15,PRICE_CLOSE);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
RsiStrategy01::~RsiStrategy01(){
}
//+------------------------------------------------------------------+
void RsiStrategy01::Run(){
   CopyBuffer(RsiHandl,0,0,3,RsiArray);
   ArraySetAsSeries(RsiArray,true);
   double rsiValue=NormalizeDouble(RsiArray[0],2);
   string message="rsi "+rsiValue+"\n";
   if(rsiValue>70){
      //sell
      message+="upper than 70\n";      
      Print("Position count=> ",positionInfo.count());
      if(positionInfo.count()>0){
         positionInfo.SelectLast();
         if(positionInfo.Type()==POSITION_TYPE_SELL){
            Print("Sell Position Exsists-> return");            
         }
         else{
            Print("Closing Current Buy Position");
            trade.PositionClose(positionInfo.Ticket());
         }
      }
      else{
         Print("Is Selling ...");
         trade.Sell(20,Symbol(),symbolInfo.Bid());
      }
   }
   else if(rsiValue<30){
      //buy
      message+="lower than 30\n";
      Print("Position count=> ",positionInfo.count());
      if(positionInfo.count()>0){
         positionInfo.SelectLast();
         if(positionInfo.Type()==POSITION_TYPE_BUY){
            Print("Buy Position Exsists-> return");  
         }
         else{
            Print("Closing Current Sell Position");
            trade.PositionClose(positionInfo.Ticket());
         }
      }
      else{
         Print("Is Buying ...");
         trade.Buy(20,Symbol(),symbolInfo.Ask());
      }
   }
   else{
      message+="Is Waiting\n";
   }
   Comment(message);
} 