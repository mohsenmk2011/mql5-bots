//+------------------------------------------------------------------+
//|                       HighLowBreakoutBot.mq5                     |
//|                        Copyright 2023, Jooya                     |
//|                         https://jooyabash.com                    |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

//+-------------------------< Includes >-----------------------------+
#include <Jooya/LogManager.mqh>

//+------------------------< Inputs >--------------------------------+
static input ulong InpMagicNumber = 5346; //magic number

//+---------------------< Global variables >------------------------+
LogManager lm;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //check the user inputs
   if(!inputsAreValid())
   {
      return INIT_PARAMETERS_INCORRECT;
   }
   // set magic number
   // set other inputs to your classes
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{

}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{

}
//+------------------------< functions >-----------------------------+
bool inputsAreValid()
{
   if(InpMagicNumber<=0)
   {
      Alert("Magic number should be 1 or bigger number");
      return false;
   }
   return true;
}

//+------------------------------------------------------------------+
