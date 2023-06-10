//+------------------------------------------------------------------+
//|                                                        Bot02.mq5 |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Jooya/MaStrategy3.mqh>
#include <Jooya/MaStrategy4.mqh>
#include <Jooya/RsiStrategy01.mqh>
#include <Jooya/CandleStrategy.mqh>
#include <Jooya/JooyaHedgingStrategy.mqh>
#include <Jooya/HedStochMaRsiStrategy04.mqh>
#include <Jooya/StochWithTrailingStop.mqh>
#include <Jooya/StochCombinationOfTfs.mqh>
#include <Jooya/StochTrailingStopPC.mqh>
#include <Jooya/BBandsStrategy.mqh>
#include <Jooya/BBandsMidLineBreakout.mqh>
#include <Jooya/BBandsMidLine02.mqh>
#include <Jooya/BBandsMidLineComplex.mqh>
#include <Jooya/BBandsMidLineTfComplex02.mqh>
#include <Jooya/BBandsMidLineComplex03.mqh>
#include <Jooya/bbAtHighLow.mqh>
#include <Jooya/BBandsTradeMaxs.mqh>
#include <Jooya/BBStochStrategy.mqh>
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "2.00"
#define EXPERT_MAGIC 10000   // MagicNumber of the bot

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
MaStrategy3 mas3;
MaStrategy mas;
RsiStrategy01 rsis;
CandleStrategy cs;
JooyaHedgingStrategy hs;
HedStochMaRsiStrategy hsma;
StochWithTrailingStop stoch;
StochCombinationOfTfs stochCtfs;
StochTrailingStopPC stochTpc;
//====================< Bollinger bands strategy >=====================================
BBandsStrategy bbs;
BBandsMidLineBreakout bbsBreakout;
BBandsMidLine02 bbmid2;
BBandsMidLineComplex bbmidComplex;
BBandsMidLineTfComplex02 bbmidComplex02;
BBandsMidLineComplex03 bbmidComplex03;
BBAtHighLow bbhl;
BBandsTradeMaxs bbtm;
BBStochStrategy bbStoch;
//====================< Bollinger bands strategy >=====================================
input double   InpLots           = 1.0;      // Lots

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
   Print("Is Running Bot");
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("Ending Running Bot");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
//mas.Run();
//mas3.Run();
//rsis.Run();
cs.Run();
//cs.CommentPirceInfo();
//cs.TickVolumeLabel();
//cs.PrintTicks();
//hs.Run();
//hsma.Run();
//stoch.Run();
//stochCtfs.Run();
///stochTpc.Run();

//bbs.Run();
//bbmid.Run();
//bbsBreakout.Run();/////////////////
//bbmid2.Run();
 // bbtm.Run();
//bbmidComplex.Run();
//bbmidComplex02.Run();
  // bbmidComplex03.Run();
   //bbhl.Run();
//bbMaAngle.Run();
//bbStoch.Run();
}
//+------------------------------------------------------------------+
