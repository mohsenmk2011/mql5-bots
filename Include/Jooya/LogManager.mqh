//+------------------------------------------------------------------+
//|                                                   LogManager.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include<Jooya/StringHelper.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LogManager {
 private:
   string positionNames[];
   string positionValues[];


 public:
   LogManager();
   ~LogManager();
   void postionType(ENUM_POSITION_TYPE t);
   void comment();
   void addNewPosition(int index, string name);
   void set(string name, string value);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LogManager::LogManager() {
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
LogManager::~LogManager() {
}
//+------------------------------------------------------------------+
void LogManager::postionType(ENUM_POSITION_TYPE t) {
   if(t==POSITION_TYPE_BUY) {
      Print("position type is buy");
   } else if(t==POSITION_TYPE_SELL) {
      Print("position type is sell");
   }
}
//+------------------------------------------------------------------+
void LogManager::comment() {
   string comment = "";
   for (int i = 0; i < ArraySize(positionNames); i++) {
      if (positionNames[i] != "" && positionValues[i] != "") {
         comment += positionNames[i] + " => " + positionValues[i]+"\n";
      }
   }
   Comment(comment);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LogManager::addNewPosition(int index, string name) {
//|| index >= ArraySize(positionNames)
   if (index < 0 ) {
      Print("Invalid position index");
      return;
   }
   ArrayResize(positionNames, index + 1);
   ArrayResize(positionValues, index + 1);
   positionNames[index] = name;
   positionValues[index] = "";
   Print("array size => "+ArraySize(positionNames));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LogManager::set(string name, string value) {
   int index = StringHelper::IndexOf(name,positionNames);
   if (index == -1) {
      Print("Position name not found");
      return;
   }

   positionValues[index] = value;
}
//+------------------------------------------------------------------+
