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
#include<Jooya/RsiStatus.mqh>
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
   void set(string name, RsiStatus value);
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
   Print("positionNames size => "+IntegerToString(count));
   ArrayResize(positionNames, count+1);
   ArrayResize(positionValues, count+1);
   count = ArraySize(positionNames);
   Print("positionNames size => "+IntegerToString(count));
   int index =count -1;
   positionNames[index] = name;
   positionValues[index] = "";
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
void LogManager::set(string name, RsiStatus value)
{
   string status = "";
   //convert rsi status to string
   switch(value)
   {
   case RsiStatus_PassedDownLowerLevel:
      status = "Passed Down LowerLevel ";
      break;
   case RsiStatus_PassedUpLowerLevel:
      status = "Passed Up LowerLevel";
      break;
   case RsiStatus_PassedDownUpperLevel:
      status = "Passed Down UpperLevel";
      break;
   case RsiStatus_PassedUpUpperLevel:
      status = "Passed Up UpperLevel";
      break;
   case RsiStatus_BetweenTwoLevel:
      status = "Between TwoLevel";
      break;
   case RsiStatus_SmallerThanLowerLevel:
      status = "Smaller Than LowerLevel";
      break;
   case RsiStatus_BiggerThanUpperLevel:
      status = "Bigger Than UpperLevel:";
      break;
   default:
      status = "Unknown";
      break;
   }
   set(name,status);
}
//+------------------------------------------------------------------+
