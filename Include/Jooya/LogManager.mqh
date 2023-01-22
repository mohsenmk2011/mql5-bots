//+------------------------------------------------------------------+
//|                                                   LogManager.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class LogManager
  {
private:

public:
                     LogManager();
                    ~LogManager();
                     void postionType(ENUM_POSITION_TYPE t);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LogManager::LogManager()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LogManager::~LogManager()
  {
  }
//+------------------------------------------------------------------+
void LogManager::postionType(ENUM_POSITION_TYPE t)
  {
   if(t==POSITION_TYPE_BUY)
     {
      Print("position type is buy");
     }
   else
      if(t==POSITION_TYPE_SELL)
        {
         Print("position type is sell");
        }
  }
//+------------------------------------------------------------------+
