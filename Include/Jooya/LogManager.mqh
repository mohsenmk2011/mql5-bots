//+------------------------------------------------------------------+
//|                                                   LogManager.mqh |
//|                                  Copyright 2022, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include<Jooya/StringHelper.mqh>
#include<Jooya/StochStatus.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LogManager
{
private:
   string positionNames[];
   string positionValues[];


public:
   LogManager();
   ~LogManager();
   void postionType(ENUM_POSITION_TYPE t);
   void comment();
   void addNewPosition(string name);
   void set(string name, string value);
   void set(string name, StochStatus value);
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
   else if(t==POSITION_TYPE_SELL)
   {
      Print("position type is sell");
   }
}
//+------------------------------------------------------------------+
void LogManager::comment()
{
   int count = ArraySize(positionNames);
   if (count <= 0 )
   {
      return;
   }
   string comment = "";
   for (int i = 0; i < count; i++)
   {
      if (positionNames[i] != "" && positionValues[i] != "")
      {
         comment += positionNames[i] + " => " + positionValues[i]+"\n";
      }
   }
   Comment(comment);
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LogManager::addNewPosition(string name)
{
   int count = ArraySize(positionNames) ;
   ArrayResize(positionNames, count+1);
   ArrayResize(positionValues, count+1);
   count = ArraySize(positionNames) ;
   int index =count -1;
   positionNames[index] = name;
   positionValues[index] = "";
   Print("array size => "+ArraySize(positionNames));
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LogManager::set(string name, string value)
{
   int index = StringHelper::IndexOf(name,positionNames);
   if (index == -1)
   {
      Print("Position name not found");
      return;
   }

   positionValues[index] = value;
}
//+------------------------------------------------------------------+
void LogManager::set(string name, StochStatus value)
{
   string status = "";
//convert stoch status to string
   switch(value)
   {
   case StochStatus_DCrossedK:
      status = "D Crossed K -> Sell";
      break;
   case StochStatus_KCrossedD:
      status = "K Crossed D -> Buy";
      break;
   case StochStatus_PassedDownUpperLevel:
      status = "PassedDownUpperLevel -> Sell";
      break;
   case StochStatus_PassedUpLowerLevel:
      status = "PassedUpLowerLevel -> Buy";
      break;
   case StochStatus_IsGoingDown:
      status = "Is Going Down";
      break;
   case StochStatus_IsGoingUp:
      status = "Is Going Up";
      break;
   default:
      status = "Not Crossed";
      break;
   }
   set(name,status);
}
//+------------------------------------------------------------------+
