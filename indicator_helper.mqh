#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <my_custom_indicator_includes\main_indicator_include.mqh>
#include <my_custom_indicator_includes\draw_objects_include.mqh>

double StartPrice, OverPrice;
double pair_winrate = 0;

int winWhenBuy =0;
int lossWhenBuy=0;
int winWhenSell = 0;
int lossWhenSell = 0;
int NameNumber = 0;
int openMinute, closeMinute;
int totalSignals = 0;


bool touched_rsi_lvl = false;
bool isGreen = false;
bool isRed = false;
bool touch_lvl_toggle = false;
bool buffer_arrow_is_drawn = false;

color TrueColor;

string typeAction;
string pin_bar_decider;
string signal_confirmation_check = "";

datetime OpenTime;

//+------------------------------------------------------------------+  
void toggle_reset(){
order_open = "";
typeAction = "";
buffer_arrow_is_drawn = false;
isGreen = false;
isRed = false;
pin_bar_decider = "";
signal_confirmation_check = "";
order_open = "order_is_NOT_open";
//Print("reseted");
}
