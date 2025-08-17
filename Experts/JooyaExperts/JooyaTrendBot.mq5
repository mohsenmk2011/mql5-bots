//+------------------------------------------------------------------+
//|                                                JooyaTrendBot.mq5 |
//|                                            Copyright 2024, Jooya |
//|                             https://www.tradertool.jooyabash.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Jooya"
#property link      "https://www.tradertool.jooyabash.com"
#property version   "1.00"
input int period = 14;

//+------------------------------------------------------------------+
//| includes                                                         |
//+------------------------------------------------------------------+
#include <Jooya/RatesManager.mqh>
#include <Jooya/SymbolInfo.mqh>
#include <ChartObjects/ChartObjectsLines.mqh>
//+------------------------------------------------------------------+
//| global variables                                                 |
//+------------------------------------------------------------------+
RatesManager rm;
SymbolInfo si;
CChartObjectHLine higherlow;

double lowestLow;
double highestHigh;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //if(higherlow.Create(NULL,"higherlow",0,si.Bid()))
   //{
   //   Print("was succceed");
   //   higherlow.Color(clrWhite);
   //}
   //else
   //{
   //   Print("was not succceed");
   //}
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
 // Array to store historical prices
    double prices[];

    // Copy the price data into the array
    ArraySetAsSeries(prices, true);
    CopyHigh(Symbol(), Period(), 0, period, prices);

    // Initialize the lowest low and highest high with the first price
    lowestLow = prices[0];
    highestHigh = prices[0];

    // Loop through the price data to find the lowest low and highest high
    for(int i = 1; i < period; i++)
    {
        if(prices[i] < lowestLow)
        {
            lowestLow = prices[i];
        }
        else if(prices[i] > highestHigh)
        {
            highestHigh = prices[i];
        }
    }
    
   //rm.copyRates();
   //double t = rm.getHigherLow(PERIOD_M5);
   //double t2 = rm.getLowerHigh(PERIOD_M5);
   Print("Current Higher Low => "+highestHigh);
   Print("Current getLowerHigh Low => "+lowestLow);
   si.Refresh();
   si.RefreshRates();
   DrawLow(lowestLow);
   DrawHigh(highestHigh);
   Print("Bid => "+si.Bid());
   Print("Bid => "+si.Name());
   //higherlow.SetDouble(OBJPROP_PRICE,si.Bid());
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{

}
//+------------------------------------------------------------------+
void DrawHigh(double price)
{
   ObjectDelete(NULL,"higherlow");
   ObjectCreate(NULL,"higherlow",OBJ_HLINE,0,0,price);
   ObjectSetInteger(NULL,"higherlow",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"higherlow",OBJPROP_COLOR,clrGreen);
}
void DrawLow(double price)
{
   ObjectDelete(NULL,"lowerlow");
   ObjectCreate(NULL,"lowerlow",OBJ_HLINE,0,0,price);
   ObjectSetInteger(NULL,"lowerlow",OBJPROP_WIDTH,2);
   ObjectSetInteger(NULL,"lowerlow",OBJPROP_COLOR,clrRed);
}