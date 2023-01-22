//+------------------------------------------------------------------+
//|                                              TrailingManager.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Trade/Trade.mqh>
#include <Trade/AccountInfo.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <Jooya/PositionInfo.mqh>
#include <Jooya/PositionManager.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TrailingManager
  {
private:
   CTrade            trade;
   PositionInfo      pi;
   SymbolInfo        si;
   CAccountInfo       ai;
   PositionManager   pm;

public:
                     TrailingManager();
                    ~TrailingManager();
   void              trail(ENUM_POSITION_TYPE type);
   void              trailWithAtr();
   void              trailWithBalanceFraction(double fraction);
   string            comment;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TrailingManager::TrailingManager()
  {
   comment="";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
TrailingManager::~TrailingManager()
  {
  }
//+------------------------------------------------------------------+
void TrailingManager::trailWithAtr()
  {
   comment="";
   int atrHandle=iATR(Symbol(),Period(),14);
   double atrArray[];
   ArraySetAsSeries(atrArray,true);
   CopyBuffer(atrHandle,0,0,3,atrArray);
   double atrValue=NormalizeDouble(atrArray[0],5);
   double stoplossPoint=atrValue*100000;
   double newSL=0;

   comment+="Atr => "+atrValue+"\n";
   comment+="si.Bid()       => "+si.BidTick()+"\n";
   comment+="StopLoss(pips) => "+stoplossPoint+"\n";
   comment+="position count => "+pi.count()+"\n";
   comment+="new StopLoss   => "+newSL+"\n";
//---

   for(int i=pi.count()-1; i>=0; i--)
     {
      pi.SelectByIndex(i);
      string symbol = pi.Symbol();
      ulong ticket = pi.Ticket();
      double currentSL=pi.StopLoss();
      double currentPrice=pi.PriceCurrent();

      if(pi.isBuy())
        {
         newSL=si.AskTick()-stoplossPoint*Point();
        }

      if(pi.isSell()&&(newSL<currentSL||currentSL==0))
        {
         newSL=si.BidTick()+stoplossPoint*Point();
        }

      if(pi.isBuy()&&(newSL>currentSL||currentSL==0))
        {
         trade.PositionModify(ticket,newSL,0);
        }

      if(pi.isSell()&&(newSL<currentSL||currentSL==0))
        {
         trade.PositionModify(ticket,newSL,0);
        }
     }

   Comment(comment);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrailingManager::trail(ENUM_POSITION_TYPE type)
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

   for(int i=pi.count()-1; i>=0; i--)
     {
      pi.SelectByIndex(i);
      string symbol = pi.Symbol();
      ulong ticket = pi.Ticket();
      double currentSL=pi.StopLoss();
      double currentPrice=pi.PriceCurrent();
      if(pi.Profit()<=0)
        {
         return;
        }

      if(type==POSITION_TYPE_BUY&& pi.isBuy())
        {
         double lastRateLow=Prices[1].low;
         trade.PositionModify(ticket,lastRateLow,0);

         //double ask = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_ASK),Digits());
         //if(currentPrice>currentSL+10*Digits())
         //{
         //}
        }
      else
         if(type==POSITION_TYPE_SELL&&pi.isSell())
           {
            double lastRateHigh=Prices[1].high;
            trade.PositionModify(ticket,lastRateHigh,0);
           }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TrailingManager::trailWithBalanceFraction(double fraction)
  {
   this.comment="------[ tm ]--------\n";
   if(fraction>0.02)
     {
      Print("max fraction is 0.02");
      return;
     }
   if(fraction<0.001)
     {
      Print("min fraction is 0.001");
      return;
     }
   double newSL=0;
   for(int i=pi.count()-1; i>=0; i--)
     {
      pi.SelectByIndex(i);
      double currentSL =pi.StopLoss();
      ulong ticket = pi.Ticket();
      if(pi.isBuy())
        {
         newSL=pm.buyStopLoss(fraction);
         this.comment+="newSL => "+newSL+"\n";
         if(currentSL==0)
           {
            trade.PositionModify(ticket,newSL,0);
           }
         else
           {
            if(newSL>currentSL)
              {
               trade.PositionModify(ticket,newSL,0);
              }
           }
        }
      else
         if(pi.isSell())
           {
            newSL=pm.sellStopLoss(fraction);
            if(currentSL==0)
              {
               trade.PositionModify(ticket,newSL,0);
              }
            else
              {
               if(newSL<currentSL)
                 {
                  trade.PositionModify(ticket,newSL,0);
                 }
              }
           }

      this.comment+="newSL => "+newSL+"\n";
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
