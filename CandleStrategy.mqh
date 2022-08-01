//+------------------------------------------------------------------+
//|                                               CandleStrategy.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Jooya/Strategy.mqh>
#include <Jooya/JooyaRates.mqh>

class CandleStrategy:public Strategy {
   private:
      MqlRates Prices[];
      JooyaRates jr;
      int ArrowIndex;
   public:
     CandleStrategy();
     ~CandleStrategy();
     void Run();
     void CommentPirceInfo();
     void TickVolumeLabel();
     void PrintTicks();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleStrategy::CandleStrategy(){
   ArrowIndex=1;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleStrategy::~CandleStrategy(){

}
void CandleStrategy::Run(){

      MqlRates Prices[];
      ArraySetAsSeries(Prices,true);
      //int count=CopyRates(Symbol(),Period(),0,Bars(Symbol(),Period()),Prices);
      int count=CopyRates(Symbol(),Period(),0,2,Prices);
      if(Prices[1].close>Prices[2].close){
         Comment("Is Going Up");
      }
      else{      
         Comment("Is Going Down");
      }
      string name=IntegerToString(ArrowIndex);
      if(jr.IsHammerCandle(Prices[1])){
         ObjectCreate(Symbol(),name,OBJ_ARROW_BUY,0,TimeCurrent(),Prices[0].low);
         ArrowIndex++;
      }
      else{      
         
      }
}

void CandleStrategy::CommentPirceInfo(){
      MqlRates Prices[];
      ArraySetAsSeries(Prices,true);
      //int count=CopyRates(Symbol(),Period(),0,Bars(Symbol(),Period()),Prices);
      int count=CopyRates(Symbol(),Period(),0,2,Prices);
      string message="";
      message+="Price.time=>"+Prices[0].time+"\n";
      message+="Price.open=>"+Prices[0].open+"\n";
      message+="Price.close=>"+Prices[0].close+"\n";
      message+="Price.High=>"+Prices[0].high+"\n";
      message+="Price.low=>"+Prices[0].low+"\n";
      message+="Price.spread=>"+Prices[0].spread+"\n";
      message+="Price.tick_volume=>"+Prices[0].tick_volume+"\n";
      message+="Price.real_volume=>"+Prices[0].real_volume+"\n";
      Comment(message);
//      Prices[0].
//      if(Prices[1].close>Prices[2].close){
//         Comment("Is Going Up");
//      }
//      else{      
//         Comment("Is Going Down");
//      }
//      string name=IntegerToString(ArrowIndex);
//      if(jr.IsHammerCandle(Prices[1])){
//         ObjectCreate(Symbol(),name,OBJ_ARROW_BUY,0,TimeCurrent(),Prices[0].low);
//         ArrowIndex++;
//      }
//      else{      
//         
//      }
}
//+------------------------------------------------------------------+
void CandleStrategy::TickVolumeLabel(){
   MqlRates Prices[];
   ArraySetAsSeries(Prices,true);
   int count=CopyRates(Symbol(),Period(),0,10,Prices);
   Print("Count=>",count);
   for(int i=count-1;i>-1;i--){   
      string lblName=IntegerToString(i);
      string lblContent=IntegerToString(Prices[i].tick_volume);
      ObjectCreate(Symbol(),lblName,OBJ_TEXT,0,TimeCurrent(),0);
      ObjectSetString(Symbol(),lblName,OBJPROP_TEXT,lblContent);
      //ObjectSetInteger(i,lblName,OBJPROP_XDISTANCE,Prices[i].low-1);
      //ObjectSetInteger(i,lblName,OBJPROP_YDISTANCE,Prices[i].low-1);
      ObjectSetInteger(i,lblName,OBJPROP_ANCHOR,ANCHOR_LEFT_LOWER);
      
      ObjectSetDouble(i,lblName,OBJPROP_ANGLE,90.0);
      ObjectMove(i,lblName,0,Prices[i].time,Prices[i].low);
   }
}
void CandleStrategy::PrintTicks(){
   MqlTick Ticks[];
   ArraySetAsSeries(Ticks,true);
   int count=CopyTicks(Symbol(),Ticks);
   Print("count=",count);
}
//+------------------------------------------------------------------+