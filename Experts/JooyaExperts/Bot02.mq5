//+------------------------------------------------------------------+
//|                                                        Bot02.mq5 |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
////#include <Jooya/MaStrategy3.mqh>
////#include <Jooya/MaStrategy4.mqh>
////#include <Jooya/CandleStrategy.mqh>
////#include <Jooya/JooyaHedgingStrategy.mqh>
////#include <Jooya/HedStochMaRsiStrategy04.mqh>
////#include <Jooya/StochCombinationOfTfs.mqh>
#include <Jooya/BBandsStrategy.mqh>
#include <Jooya/TrailingManager.mqh>
#include <Jooya/BBandsMidLineBreakout.mqh>
#include <Jooya/BBandsMidLine02.mqh>
////#include <Jooya/BBandsMidLineComplex.mqh>
////#include <Jooya/BBandsMidLineTfComplex02.mqh>
////#include <Jooya/BBandsMidLineComplex03.mqh>
#include <Jooya/bbAtHighLow.mqh>
////#include <Jooya/BBandsTradeMaxs.mqh>
//#include <Jooya/BBStochStrategy.mqh>
#include <Charts/Chart.mqh>
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "2.00"
#define EXPERT_MAGIC 10000   // MagicNumber of the bot

input int InpBarCount = 6; //bar count
//+---------------------< Global variables >------------------------+
CChart chart;
//MaStrategy3 mas3;
//MaStrategy mas;
//RsiStrategy01 rsis;
//CandleStrategy cs;
//JooyaHedgingStrategy hs;
//HedStochMaRsiStrategy hsma;
//StochCombinationOfTfs stochCtfs;
////====================< Bollinger bands strategy >=====================================
BBandsStrategy bbs;
BBandsMidLineBreakout bbsBreakout;
BBandsMidLine02 bbmid2;
//BBandsMidLineComplex bbmidComplex;
//BBandsMidLineTfComplex02 bbmidComplex02;
//BBandsMidLineComplex03 bbmidComplex03;
BBAtHighLow bbhl;
//BBandsTradeMaxs bbtm;
//BBStochStrategy bbStoch;
double highM1 = 0; // highest price of last N bar
double lowM1 = 0; // lowest price of last N bar
TrailingManager tm;
//====================< Bollinger bands strategy >=====================================
input double   InpLots           = 1.0;      // Lots

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
   Print("Is Running Bot");
   chart.Attach(ChartID());
   chart.ShowLineAsk(true);
   chart.ColorForeground(clrBlack);
   chart.ColorBackground(clrWhite);
   chart.ColorBarUp(clrGreen);
   chart.ColorBarDown(clrRed);
   chart.ColorCandleBull(clrLimeGreen);
   chart.ColorCandleBear(clrHotPink);
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
   highM1 = iHigh(Symbol(),PERIOD_M1,iHighest(Symbol(),PERIOD_M1,MODE_HIGH,InpBarCount,0));
   lowM1 = iLow(Symbol(),PERIOD_M1,iLowest(Symbol(),PERIOD_M1,MODE_LOW,InpBarCount,0));
   DrawObjectM1();
//mas.Run();
//mas3.Run();
//rsis.Run();
//cs.Run();
//cs.CommentPirceInfo();
//cs.TickVolumeLabel();
//cs.PrintTicks();
//hs.Run();
//hsma.Run();
//stochCtfs.Run();

bbsBreakout.Run();
 // bbtm.Run();
//bbmidComplex.Run();
//bbmidComplex02.Run();
  // bbmidComplex03.Run();
//bbMaAngle.Run();
//bbStoch.Run();



//bbmid2.Run();
  // bbhl.Run();
   //bbs.Run();
   tm.trailWithLowHigh(lowM1,highM1);
}
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawObjectM1()
{
   datetime time = iTime(Symbol(),PERIOD_M1,InpBarCount);
/// draw highM1 line
   ObjectDelete(NULL,"highM1");
   ObjectCreate(NULL,"highM1",OBJ_TREND,0,time,highM1,TimeCurrent(),highM1);
   ObjectSetInteger(NULL,"highM1",OBJPROP_WIDTH,1);
   ObjectSetInteger(NULL,"highM1",OBJPROP_COLOR,clrRed);


/// draw lowM1 line
   ObjectDelete(NULL,"lowM1");
   ObjectCreate(NULL,"lowM1",OBJ_TREND,0,time,lowM1,TimeCurrent(),lowM1);
   ObjectSetInteger(NULL,"lowM1",OBJPROP_WIDTH,1);
   ObjectSetInteger(NULL,"lowM1",OBJPROP_COLOR,clrRed);
}
//+------------------------------------------------------------------+