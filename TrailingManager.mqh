//+------------------------------------------------------------------+
//|                                              TrailingManager.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade/Trade.mqh>
#include <Jooya/PositionInfo.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TrailingManager
  {
private:
   CTrade            trade;
   PositionInfo      pi;

public:
                     TrailingManager();
                    ~TrailingManager();
   void              trail();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TrailingManager::TrailingManager()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TrailingManager::~TrailingManager()
  {
  }
//+------------------------------------------------------------------+
void TrailingManager::trail()
  {
   MqlRates Prices[];
   datetime dt;
   ArraySetAsSeries(Prices,true);
//int count=CopyRates(Symbol(),Period(),0,Bars(Symbol(),Period()),Prices);
   int count = CopyRates(Symbol(),Period(),0,2,Prices);
   string message="";
   message+="Price.time=>"+Prices[0].time+"\n";
   message+="Price.open=>"+Prices[0].open+"\n";
   message+="Price.close=>"+Prices[0].close+"\n";
   message+="Price.High=>"+Prices[0].high+"\n";
   message+="Price.low=>"+Prices[0].low+"\n";
   message+="Price.spread=>"+Prices[0].spread+"\n";
   message+="Price.tick_volume=>"+Prices[0].tick_volume+"\n";
   message+="Price.real_volume=>"+Prices[0].real_volume+"\n";

//MqlTick last_tick;
//SymbolInfoTick(Symbol(),last_tick);
//Comment(last_tick.time,": Bid = ",last_tick.bid," Ask = ",last_tick.ask,"  Volume = ",last_tick.volume);
//double desiredSL=NormalizeDouble(ask-150*Point(),Digits());
   
   for(int i=0; i<pi.count(); i++)

     {
      pi.SelectByIndex(i);
      string symbol = pi.Symbol();
      ulong ticket = pi.Ticket();
      double currentSL=pi.StopLoss();
      double currentPrice=pi.PriceCurrent();
      int type =pi.Type();
      if(pi.isBuy())
        {
         double ask = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_ASK),Digits());
         double lastRateLow=Prices[1].low;
         if(currentPrice>currentSL+10*Digits())
           {
            trade.PositionModify(ticket,lastRateLow,0);
           }

        }
      else
        {
        }
     }
  }
//+------------------------------------------------------------------+
