//+------------------------------------------------------------------+
//|                                                 StringHelper.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class StringHelper {
 private:

 public:
   StringHelper();
   ~StringHelper();
   static int IndexOf(const string& target, const string& array[]);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StringHelper::StringHelper() {
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
StringHelper::~StringHelper() {
}
//+------------------------------------------------------------------+
static int StringHelper::IndexOf(const string& target, const string& array[]) {
   int arraySize = ArraySize(array);
   if(arraySize<=0) {
      Print("Array is empty");
      return -1;
   }
   for (int i = 0; i < arraySize; i++) {
      if (array[i] == target)
         return i; // Found the target string, return its index
   }
   return -1; // Target string not found in the array
}
//+------------------------------------------------------------------+
