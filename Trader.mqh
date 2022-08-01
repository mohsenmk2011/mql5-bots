//+------------------------------------------------------------------+
//|                                                       Trader.mqh |
//|                             Copyright 2021, Jooya Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Jooya Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

class Trader{
   //+-------------------------------private-----------------------------------+
   private:
      int ExpertMagicNumber;      
      double CurrentVolume;
   //+-------------------------------public-----------------------------------+
   public:
      Trader(){
      }  
      Trader(int magicNumber){                
         //MqlTick LatestTick;    
         //SymbolInfoTick(Symbol() ,LatestTick);
         ////---------------------------
         //static double BidPrice=LatestTick.bid;
         //static double AskPrice=LatestTick.ask; 
         //Print("Bid Price-> ",BidPrice);
         //Print("Ask Price-> ",AskPrice);
         ////---------------------------
         //double TakeProfitLevel=BidPrice+(Point()*TakeProfit);
         //double StopLossLevel=BidPrice-(Point()*StopLoss);
         //Print("Take Profit Level-> ",TakeProfitLevel);
         //Print("Stop Loss Level-> ",StopLossLevel);
         ExpertMagicNumber=magicNumber;
         CurrentVolume=0.01;
      }
      ~Trader(){
      }     
   //+------------------------------------------------------------------+
   //| Select Positions
   //+------------------------------------------------------------------+      
      bool SelectPosition(ulong ticket){
         if(ticket==0){
            Print("Can not select order with tiket->0");
            return false;
         }
         int total=PositionsTotal();   
         for(int i=total-1; i>=0; i--)
         {
            ulong  currentTicket=PositionGetTicket(i);
            if(currentTicket==ticket){
               Print("Selecting was Successful"); 
               return true;
            }
         }
         return false;
      }
   //+------------------------------------------------------------------+
   //| Sending Order                              |
   //+------------------------------------------------------------------+
   void SendBuyOrder(){
   SendOrder(ORDER_TYPE_BUY);
   }
   void SendSellOrder(){
   SendOrder(ORDER_TYPE_SELL);
   }
   void SendOrder(ENUM_ORDER_TYPE type,double takeProfitLevel=0,double stopLossLevel=0){
      MqlTradeRequest request={0};
      MqlTradeResult  result={0};
   //--- parameters of request
      request.action   =TRADE_ACTION_DEAL;                     // type of trade operation
      request.symbol   =Symbol();                              // symbol
      request.volume   =CurrentVolume;   
      if(type==ORDER_TYPE_BUY){
      request.type     =ORDER_TYPE_BUY;
      request.price    =SymbolInfoDouble(Symbol(),SYMBOL_ASK);
      }
      else{
      request.type     =ORDER_TYPE_SELL;
      request.price    =SymbolInfoDouble(Symbol(),SYMBOL_BID);
      }                        // order type
      request.deviation=5;                                     // allowed deviation from the price
      request.magic    =ExpertMagicNumber;                          // MagicNumber of the order
   //--- send the request
      if(!OrderSend(request,result))
         PrintFormat("OrderSend error %d",GetLastError());     // if unable to send the request, output the error code
   //--- information about the operation
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
   }
   //+------------------------------------------------------------------+
   //|                              Modify Orders
   //+------------------------------------------------------------------+
   void ModifyPosition(ulong ticket){
      MqlTradeRequest request;
      MqlTradeResult  result;
      string position_symbol=PositionGetString(POSITION_SYMBOL);
      int digits=(int)SymbolInfoInteger(position_symbol,SYMBOL_DIGITS); // number of decimal places
      ulong magic=PositionGetInteger(POSITION_MAGIC); // MagicNumber of the position
      double volume=PositionGetDouble(POSITION_VOLUME);    // volume of the position
      double sl=PositionGetDouble(POSITION_SL);  // Stop Loss of the position
      double tp=PositionGetDouble(POSITION_TP);  // Take Profit of the position
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);  // type of the position
      //--- output information about the position
      PrintFormat("#%I64u %s  %s  %.2f  %s  sl: %s  tp: %s  [%I64d]",
                  ticket,
                  position_symbol,
                  EnumToString(type),
                  volume,
                  DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),digits),
                  DoubleToString(sl,digits),
                  DoubleToString(tp,digits),
                  magic);
      //--- if the MagicNumber matches, Stop Loss and Take Profit are not defined
      if(magic==ExpertMagicNumber && sl==0 && tp==0)
        {
         //--- calculate the current price levels
         double price=PositionGetDouble(POSITION_PRICE_OPEN);
         double bid=SymbolInfoDouble(position_symbol,SYMBOL_BID);
         double ask=SymbolInfoDouble(position_symbol,SYMBOL_ASK);
         int    stop_level=(int)SymbolInfoInteger(position_symbol,SYMBOL_TRADE_STOPS_LEVEL);
         double price_level;
         //--- if the minimum allowed offset distance in points from the current close price is not set
         if(stop_level<=0)
            stop_level=150; // set the offset distance of 150 points from the current close price
         else
            stop_level+=50; // set the offset distance to (SYMBOL_TRADE_STOPS_LEVEL + 50) points for reliability
   
         //--- calculation and rounding of the Stop Loss and Take Profit values
         price_level=stop_level*SymbolInfoDouble(position_symbol,SYMBOL_POINT);
         if(type==POSITION_TYPE_BUY)
           {
            sl=NormalizeDouble(bid-price_level,digits);
            tp=NormalizeDouble(ask+price_level,digits);
           }
         else
           {
            sl=NormalizeDouble(ask+price_level,digits);
            tp=NormalizeDouble(bid-price_level,digits);
           }
         //--- zeroing the request and result values
         ZeroMemory(request);
         ZeroMemory(result);
         //--- setting the operation parameters
         request.action  =TRADE_ACTION_SLTP; // type of trade operation
         request.position=ticket;   // ticket of the position
         request.symbol=position_symbol;     // symbol 
         request.sl      =sl;                // Stop Loss of the position
         request.tp      =tp;                // Take Profit of the position
         request.magic=ExpertMagicNumber;         // MagicNumber of the position
         //--- output information about the modification
         PrintFormat("Modify #%I64d %s %s",ticket,position_symbol,EnumToString(type));
         //--- send the request
         if(!OrderSend(request,result))
            PrintFormat("OrderSend error %d",GetLastError());  // if unable to send the request, output the error code
         //--- information about the operation   
         PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
        }
      
   }
   void ModifyAllPositions(){
      int total=PositionsTotal(); 
      for(int i=0; i<total; i++)
      {     
         ulong  position_ticket=PositionGetTicket(i);// ticket of the position
         if(!SelectPosition(position_ticket)){
            return;
         }
         ModifyPosition(position_ticket);
      }
   } 
   //+------------------------------------------------------------------+
   //| Closing Orders
   //+------------------------------------------------------------------+ 
   void ClosePosition(ulong ticket=0){
      MqlTradeRequest request;
      MqlTradeResult  result;
      if(!SelectPosition(ticket)){
         Print("Position not found! => ticket->",ticket);
         return;
      }
      Print("Is Closing => ticket->",ticket);   
      string position_symbol=PositionGetString(POSITION_SYMBOL);                        // symbol 
      int    digits=(int)SymbolInfoInteger(position_symbol,SYMBOL_DIGITS);              // number of decimal places
      ulong  magic=PositionGetInteger(POSITION_MAGIC);                                  // MagicNumber of the position
      double volume=PositionGetDouble(POSITION_VOLUME);                                 // volume of the position
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);  
      if(magic==ExpertMagicNumber){
         //--- zeroing the request and result values
         ZeroMemory(request);
         ZeroMemory(result);
         request.action   =TRADE_ACTION_DEAL;        // type of trade operation
         request.position =ticket;          // ticket of the position
         request.symbol   =position_symbol;          // symbol 
         request.volume   =volume;                   // volume of the position
         request.deviation=5;                        // allowed deviation from the price
         request.magic    =ExpertMagicNumber;             // MagicNumber of the position
         //--- set the price and order type depending on the position type
         if(type==POSITION_TYPE_BUY)
           {
            request.price=SymbolInfoDouble(position_symbol,SYMBOL_BID);
            request.type =ORDER_TYPE_SELL;
           }
         else
           {
            request.price=SymbolInfoDouble(position_symbol,SYMBOL_ASK);
            request.type =ORDER_TYPE_BUY;
           }
         //--- output information about the closure
         PrintFormat("Close #%I64d %s %s",ticket,position_symbol,EnumToString(type));
         //--- send the request
         if(!OrderSend(request,result))
            PrintFormat("OrderSend error %d",GetLastError());  // if unable to send the request, output the error code
         //--- information about the operation   
         PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      //---
     }
   }
   void CloseAllPosition(){
      int total=PositionsTotal();
      Print("Total Positions=>",total);
      
      for(int i=total-1; i>=0; i--)
      {
         ulong  currentTicket=PositionGetTicket(i);
         ClosePosition(currentTicket);
      }
   }
  };