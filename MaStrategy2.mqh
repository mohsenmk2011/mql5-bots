//+------------------------------------------------------------------+
//|                                                   MaStrategy2.mqh |
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

#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

class MaStrategy2:public Strategy{
   private:
      CTrade trade;
      CSymbolInfo symbolInfo;
      PositionInfo positionInfo;
      HistoryOrderInfo orderInfo;
      
      double MaM15Array[];
      int MaM15Handle;
      
      double MaH4Array[];
      int MaH4Handle;
      
      double MaD1Array[];
      int MaD1Handle;
      
      double MaW1Array[];
      int MaW1Handle;      
      
      Step topStep;
      Step downStep;
      
   public:
      MaStrategy2();
      ~MaStrategy2();
      void RunStrategyOne();
      void Run();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaStrategy2::MaStrategy2()
{
   MaM15Handle= iMA(Symbol(),PERIOD_M1,15,0,MODE_SMA,PRICE_CLOSE);  
   MaH4Handle= iMA(Symbol(),PERIOD_M1,240,0,MODE_SMA,PRICE_CLOSE);
   MaD1Handle= iMA(Symbol(),PERIOD_M1,1440,0,MODE_SMA,PRICE_CLOSE);
   MaW1Handle= iMA(Symbol(),PERIOD_M1,7200,0,MODE_SMA,PRICE_CLOSE);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
MaStrategy2::~MaStrategy2()
{
}
//+------------------------------------------------------------------+
void MaStrategy2::RunStrategyOne(){
   
   //positionInfo.SelectLast();
   //Comment("LastProfit= ",positionInfo.Profit());
   CopyBuffer(MaM15Handle,0,1,2,MaM15Array);
   ArraySetAsSeries(MaM15Array,true);
   
   CopyBuffer(MaH4Handle,0,1,2,MaH4Array);
   ArraySetAsSeries(MaH4Array,true);
   
   CopyBuffer(MaD1Handle,0,1,2,MaD1Array);
   ArraySetAsSeries(MaD1Array,true);
   
   CopyBuffer(MaW1Handle,0,1,2,MaW1Array);
   ArraySetAsSeries(MaW1Array,true);
   //==============================================================
   bool M15CrossH4=CrossOver(MaM15Array,MaH4Array);
   bool D1IsUp=BiggerThan(MaM15Array,MaD1Array)&&BiggerThan(MaH4Array,MaD1Array);
   
   bool D1IsGoingUp=true;
   //Comment("ma5[",MaM15Array[0],",",MaM15Array[1],"]\n","ma10[",MaH4Array[0],",",MaH4Array[1],"]\n","ma200[",MaD1Array[0],",",MaD1Array[1],"]");   
   //========================================================================
   
   if(M15CrossH4){
      if(D1IsUp){
         if(D1IsGoingUp){
         //
         }
         else{
            //wait to cross
         }
      }
      else{
         if(D1IsGoingUp){
         }
         else{
         }               
      }
   }
   //------------------------------------------------------------------
   bool H4CrossM15=CrossOver(MaH4Array,MaM15Array);
   if(H4CrossM15){
      if(D1IsUp){
         if(D1IsGoingUp){
         }
         else{
         }
      }
      else{
         if(D1IsGoingUp){
         }
         else{
         }     
      }      
   }  
   //========================================================================      
}

void MaStrategy2::Run(){  
   RunStrategyOne();      
} 