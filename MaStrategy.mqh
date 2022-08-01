//+------------------------------------------------------------------+
//|                                                   MaStrategy.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Jooya/Strategy.mqh>
#include <Trade/Trade.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/DealInfo.mqh>

#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
class MaStrategy:public Strategy{
   private:
      CTrade trade;
      CSymbolInfo symbolInfo;
      double FastMAArray[];
      int FastMAHandle;
      
      double SlowMAArray[];
      int SlowMAHandle;
      
      ulong lastTicket;
      bool buyLock;
      bool sellLock;

   public:
      MaStrategy();
      ~MaStrategy();
      void RunStrategyOne();
      void Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaStrategy::MaStrategy()
{
   FastMAHandle= iMA(Symbol(),PERIOD_M1,20,0,MODE_SMA,PRICE_CLOSE); 
   SlowMAHandle= iMA(Symbol(),PERIOD_M1,200,0,MODE_SMA,PRICE_CLOSE); 
   lastTicket=0;
   buyLock=false;  
   sellLock=false;  
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaStrategy::~MaStrategy()
{
}
//+------------------------------------------------------------------+
void MaStrategy::RunStrategyOne(){
   CopyBuffer(FastMAHandle,0,1,2,FastMAArray);
   ArraySetAsSeries(FastMAArray,true);
   
   CopyBuffer(SlowMAHandle,0,1,2,SlowMAArray);
   ArraySetAsSeries(SlowMAArray,true);
   Comment("Fma[",FastMAArray[0],",",FastMAArray[0],"]\n","Sma[",SlowMAArray[0],",",SlowMAArray[0],"]");
   if(CrossOver(FastMAArray,SlowMAArray)){
      if(buyLock){
         Print("Lock Buy is True ->Return");
         return;
      }
      if(lastTicket>0){
        trade.PositionClose(lastTicket);
      }
      if(trade.Buy(0.01,Symbol(),symbolInfo.Ask())){
         lastTicket=trade.ResultDeal();  
         Print("Successful Buy ->ticket=> ",lastTicket);          
         Print("Fma[",FastMAArray[0],",",FastMAArray[0],"]\n","Sma[",SlowMAArray[0],",",SlowMAArray[0],"]");
         buyLock=true;
         sellLock=false;       
         //CDealInfo dinfo=new CDealInfo(trade.ResultRetcode());
      }
   }
   else if(CrossOver(SlowMAArray,FastMAArray)){
      if(sellLock){
         return;
      }
      if(lastTicket>0){
         trade.PositionClose(lastTicket);
      }
      if(trade.Sell(0.01,Symbol(),symbolInfo.Bid())){
         lastTicket=trade.ResultDeal(); 
         Print("Successful Sell ->ticket=> ",lastTicket);          
         Print("Fma[",FastMAArray[0],",",FastMAArray[0],"]\n","Sma[",SlowMAArray[0],",",SlowMAArray[0],"]");    
         sellLock=true;
         buyLock=false;         
      }
   }         
}

void MaStrategy::Run(){  
   RunStrategyOne();      
}      
      
//
//         static bool HasBuy=false;
//         static bool HasSell=false;
//         double ma15= MA[0];
//         Print("ma15-> ",ma15);
//         double CurrentClosePrice=iClose(Symbol(),PERIOD_M1,1);
//         if(CurrentClosePrice>ma15){
//            if(!HasSell){
//               trader.CloseAllPosition();
//               HasSell=true;
//            }
//            if(HasBuy){
//               Print("CurrentClosePrice-> ",CurrentClosePrice);
//               Print("ma15-> ",ma15);
//               Print("is Selling=>");
//               trader.SendSellOrder();
//               HasBuy=false;            
//            }           
//         }
//         else if(CurrentClosePrice<ma15){         
//            if(!HasBuy){ 
//               Print("CurrentClosePrice-> ",CurrentClosePrice);
//               Print("ma15-> ",ma15);
//               Print("is Buying=>");         
//               trader.SendBuyOrder();
//               HasBuy=true;           
//            }
//            if(HasSell){
//               trader.CloseAllPosition();
//               HasSell=false;
//            }
//         }