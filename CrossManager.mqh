//+------------------------------------------------------------------+
//|                                                 CrossManager.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#include <Jooya/MaLine.mqh>

class CrossManager
{
   private:
      MaLine* FastMaLine;
      MaLine* SlowMALine;
   public:
      CrossManager(MaLine* fastMaLine, MaLine* slowMALine);
     ~CrossManager();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CrossManager::CrossManager(MaLine* fastMaLine, MaLine* slowMALine)
{
   FastMaLine=fastMaLine;
   SlowMALine=slowMALine;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CrossManager::~CrossManager()
{
}
//+------------------------------------------------------------------+
