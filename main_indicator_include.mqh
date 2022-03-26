#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <my_custom_indicator_includes\draw_objects_include.mqh>
#include <my_custom_indicator_includes\indicator_helper.mqh>


//+----------------------------------------------------------------------------------------------------------------+ 
string scan_for_signals(double current_rsi_value, double min15_TF_RSI){
string scan_for_signals_decider;
if(current_rsi_value < 30  &&  is_there_an_order_open == 0 ) //&& touched_rsi_lvl == true && min15_TF_RSI < 30
     {
      is_there_an_order_open = 1;
      typeAction = "buy";
      StartPrice = Bid;
      OpenTime = TimeLocal();
      //Alert("indicator buy triggered at ", _Symbol," object should appear in 1 minute, OPENTIME is "+ OpenTime+" CONTROL TIME IS "+ (OpenTime+60));
      scan_for_signals_decider =  "buy_signal";
     
     }

   else
      if(current_rsi_value > 70 && is_there_an_order_open == 0 ) //&& touched_rsi_lvl == true && min15_TF_RSI > 70
        {
         is_there_an_order_open = 1;
         typeAction = "sell";
         StartPrice = Bid;
         OpenTime = TimeLocal();
         //Alert("indicator sell triggered at ", _Symbol," object should appear in 1 minute, OPENTIME is "+ OpenTime+" CONTROL TIME IS "+ (OpenTime+60));
         scan_for_signals_decider =  "sell_signal";
        
        }
return scan_for_signals_decider;
}
//+------------------------------------------------------------------------------------------------------------------+ 
// 300 = 5 minutes
// 600 = 10 minutes
// 900 = 15 minutes
// 1200 = 20 minutes
// 1500 = 25 minutes
// 1800 = 30 minutes
int signal_confirmation(){
if(TimeLocal() > OpenTime+3600 && is_there_an_order_open == 1 && buffer_arrow_is_drawn == true)
  {
   OverPrice = Bid;
   updateStats(StartPrice,OverPrice);  
   string nameNumber = assignName(NameNumber++);                                                                   
   CreateLine(OpenTime,StartPrice,DecideColor(),nameNumber);   
   totalSignals++;                                                                       
   toggle_reset();
   Print("Всего сигналов ",totalSignals, "  Прибыльных сигналов ",winWhenBuy+winWhenSell,"  Убыточных сигналов ",lossWhenBuy+lossWhenSell); //, "  %Побед ",((winWhenBuy+winWhenSell)/totalSignals)*100
  }else if(TimeLocal() > OpenTime+3600 && is_there_an_order_open == 1 && buffer_arrow_is_drawn == true)
          {
           OverPrice = Bid;
           updateStats(StartPrice,OverPrice); 
           string nameNumber = assignName(NameNumber++);
           CreateLine(OpenTime,StartPrice,DecideColor(),nameNumber); 
           totalSignals++;                                                            
           toggle_reset();
           Print("Всего сигналов ",totalSignals, "  Прибыльных сигналов ",winWhenBuy+winWhenSell,"  Убыточных сигналов ",lossWhenBuy+lossWhenSell); //, "  %Побед ",((winWhenBuy+winWhenSell)/totalSignals)*100
          }
return totalSignals;
}
//+------------------------------------------------------------------+
void updateStats(double PassedStartPrice, double PassedOverPrice)
  {

   if(typeAction == "buy")
     {
      if(PassedStartPrice < PassedOverPrice)
        {
         winWhenBuy++;
         isGreen = true;
        }
      else
        {
         lossWhenBuy++;
         isRed = true;
         
        }
     }


   if(typeAction == "sell")
     {
      if(PassedStartPrice > PassedOverPrice)
        {
         winWhenSell++;
         isGreen = true;
         
        }
      else
        {
         lossWhenSell++;
         isRed = true;
         
        }
     }
    
  }