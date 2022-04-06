//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#include <my_custom_indicator_includes\main_indicator_include.mqh>
#include <my_custom_indicator_includes\draw_objects_include.mqh>
#include <my_custom_indicator_includes\indicator_helper.mqh>
#property indicator_buffers 2
#property indicator_plots   2
//--- plot Pin_bar_down
#property indicator_label1  "Pin_bar_down"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Pin_bar_up
#property indicator_label2  "Pin_bar_up"
#property indicator_type2   DRAW_ARROW
#property indicator_color2  clrChartreuse
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- indicator buffers
double         Pin_bar_downBuffer[];
double         Pin_bar_upBuffer[];

int limit;

double currency_pip_decider;
int RSIPeriod = 10;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   Alert("Indicator activated on " + _Symbol);
//--- indicator buffers mapping
   SetIndexBuffer(0, Pin_bar_downBuffer);
   SetIndexBuffer(1, Pin_bar_upBuffer);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
//Хз для чего эти сет интеджеры, но они не работают для отрисовки объекта на чарте
   PlotIndexSetInteger(0, PLOT_ARROW, 242);
   PlotIndexSetInteger(1, PLOT_ARROW, 241);
//--- setting a code from the Wingdings charset that works (the above PlotIndexSetInt не работает)
//А вот эти работают для установки отрисовки объекта на чарте
   SetIndexArrow(0, 242);
   SetIndexArrow(1, 241);

   if(Point() == 0.0001 || Point() == 0.00001)
      currency_pip_decider = 0.0001;
   if(Point() == 0.01 || Point() == 0.001)
      currency_pip_decider = 0.01;
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
  
//+------------------------------------------------------------------+
   double currentRSI = iRSI(NULL, 0, RSIPeriod, PRICE_CLOSE, 0);
  
   limit = rates_total - Bars;
   
  if(open[1] == close[1])return(rates_total);
  
   //i<5 от числа, с которым сравнивается i зависит количество обрабатываемых баров
   for(int i = 0; i < limit + 1; i++) 
     {
      if(calculate_pin_bar(currency_pip_decider, high[1], low[1], open[1], close[1]) == 1 && scan_for_signals(currentRSI) == "buy_signal")
        {    
           // i+1 == 1 здесь выступает как shift, индикатор проверят со смещением в 1 бар
            order_open = "";
            Pin_bar_upBuffer[i + 1] = close[i + 1]; 
            buffer_arrow_is_drawn = true; 
        }
       
      if(calculate_pin_bar(currency_pip_decider, high[1], low[1], open[1], close[1]) == 0 && scan_for_signals(currentRSI) == "sell_signal")
        {
            order_open = "";
            Pin_bar_downBuffer[i + 1] = close[i + 1];
            buffer_arrow_is_drawn = true; 
            
        }
     }
      signal_confirmation();
return(rates_total);
  }

//+------------------------------------------------------------------+
