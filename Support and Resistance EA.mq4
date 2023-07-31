//+------------------------------------------------------------------+
//|                                    Support and Resistance EA.mq4 |
//|                                          Copyright 2023,JBlanked |
//|                                         https://www.jblanked.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023,JBlanked"
#property link      "https://www.jblanked.com"
#property strict

#include <CustomFunctionsFix.mqh>


input    string         orderSeng         = "======= ORDER SETTINGS 订单设置 ======";  //--------------------------->
input    double         StopLoss          = 10; // Stop Loss 止损
input    double         TakeProfit        = 600; // Take Profit 止盈
input    bool           usepercentrisk    = true; // Use risk per trade? 每笔交易使用风险
input    double         percentrisk       = 0.10; // Percent risk  风险百分比
input    bool           uselotsize        = false; // Use lot size?   使用手数
input    double         lotsizee          = 0.10; // Lot size   手数

input    string         orderSeting       = "======= TREND SETTINGS 趋势设置 ======";  //--------------------------->
input    int            MA_Period         = 160; // Period for moving average 移动均线周期
input    int            RSI_Period        = 8; // Period for RSI  RSI 周期
input    int            rsibuylevel       = 20; // RSI under which level to buy  RSI 在什么水平下买入
input    int            rsiselllevel      = 80; // RSI above which level to sell  RSI 高于该水平即可卖出
input    bool           reverseorder      = false; // Reverse trend?  逆转趋势
input    bool           HODL              = false; // HODL til opposite setup?  HODL 到相反的设置


input    string         BreakEvenSettings = "--------TAKE PARTIAL SETTINGS 进行部分设置 -------";  //--------------------------->
input    bool           UseBreakEvenStop  = true;  //Use take partials?   使用截取部分
input    double         BEclosePercent    = 50.0;   //Close how much percent?   收盘百分之多少关闭
input    double         breakstart        = 200; // Take partials after how many pips in profit (1)  获利多少点后取部分 (1)
input    double         breakstart2       = 300; // Take partials after how many pips in profit (2)
input    double         breakstart3       = 400; // Take partials after how many pips in profit (3)
input    double         breakstart4       = 500; // Take partials after how many pips in profit (4)

input    double         breakstop         = 20; // Move stop loss in profit X pips   移动止损利润 X 点

input    string         BkEvnSettings     = "======= MARTINGALE SETTINGS 马丁格尔设置 =======";  //--------------------------->
input    bool           useMartingale     = false; // Use martingale?   使用马丁？
input    double         martinPips        = 78; // Pips in between martingales  马丁间的点位
input    double         martinMULTI       = 5; // Martingale multiplier  乘数


input    string         timeSettings      = "======= TIME SETTINGS 时间设置 ======";  //--------------------
input    bool           UseTimer          = false;    // Custom trading hours (true/false)  自定义交易时间
input    string         StartTime1        = "16:30";  //1 Trading start time (hh:mm)   交易开始时间
input    string         StopTime1         = "16:31";  //1 Trading stop time (hh:mm)    交易停止时间

input    string         DAILY_TARGETS     = "======= Gain/Loss 收益/损失 =======";  //---------------
input    double         dailyTargetP      = 10.0;        // Daily Profit Target (%)  每日利润目标
input    double         dailyLossP        = 0.4;        // Daily Max DD (%)   每日最大损失


input    string         orderSettins      = "======= OTHER SETTINGS 其他设置 ======";    //---------------
input    string         orderComments     = "Support/Resistance EA"; // Order Comment   
input    int            magicnumb         = 918119; // Magic Number


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

JBlankedInitCEO(magicnumb,918119,"Support/Resistance EA");
JBlankedBranding("Support/Resistance EA",magicnumb,string(expiryDateVIP));
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   JBlankedDeinit();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

if(ApplyDailyTarget(dailyTargetP,dailyLossP,)) return;

if(useMartingale) { martingale(_Symbol,,OrderStopLoss(),martinMULTI,martinPips); }

//////////////////// Start Take Partials Tempalte

if(UseBreakEvenStop)DoBreak2(,breakstart,BEclosePercent,breakstop,breakstart2,breakstart3,breakstart4);



//////////////////// End Take Partials Tempalte


   
  
//+------------------------------------------------------------------+


    double MA = iMA(NULL,0,MA_Period,0,MODE_SMA,PRICE_CLOSE,0);
    double RSI = iRSI(NULL,0,RSI_Period,PRICE_CLOSE,0);
    double currentPrice = Close[0];

   if(allowTime(UseTimer,StartTime1,StopTime1))
   {
   if(!CheckIfOpenOrdersByMagicNB(,orderComments) && StopLoss != 0 && !HODL)
   {
   if(!reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
      int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,Ask-StopLoss*GetPipValue(),Ask+TakeProfit*GetPipValue(),orderComments,,0,Green);
           
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
      int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,Bid+StopLoss*GetPipValue(),Bid-TakeProfit*GetPipValue(),orderComments,,0,Red);
     
    }
      }
      
   
     if(reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
       int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,Bid+StopLoss*GetPipValue(),Bid-TakeProfit*GetPipValue(),orderComments,,0,Red);
          
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
         int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,Ask-StopLoss*GetPipValue(),Ask+TakeProfit*GetPipValue(),orderComments,,0,Green);
 
     
    }
   } 
   } 
   
   
    if(!CheckIfOpenOrdersByMagicNB(,orderComments) && StopLoss == 0)
   {
   if(!reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
      int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,0,Ask+TakeProfit*GetPipValue(),orderComments,,0,Green);
           
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
      int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,0,Bid-TakeProfit*GetPipValue(),orderComments,,0,Red);
     
    }
      }
         
      
     if(reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
       int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,0,Bid-TakeProfit*GetPipValue(),orderComments,magicnumb,0,Red);
          
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
         int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,0,Ask+TakeProfit*GetPipValue(),orderComments,magicnumb,0,Green);
 
     
    }
   } 
   }   
   
   
   
   
   
  
  
  
  
  
  
  
  
  
  
  
  
  
   if(!CheckIfOpenOrdersByMagicNB(magicnumb,orderComments) && StopLoss != 0 && HODL)
   {
   if(!reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
      int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,Ask-StopLoss*GetPipValue(),0,orderComments,magicnumb,0,Green);
           
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
      int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,Bid+StopLoss*GetPipValue(),0,orderComments,magicnumb,0,Red);
     
    }
      }
      
   
     if(reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
       int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,Bid+StopLoss*GetPipValue(),0,orderComments,magicnumb,0,Red);
          
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
         int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,Ask-StopLoss*GetPipValue(),0,orderComments,magicnumb,0,Green);
 
     
    }
   } 
   } 
   
   
    if(!CheckIfOpenOrdersByMagicNB(magicnumb,orderComments) && StopLoss == 0)
   {
   if(!reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
      int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,0,0,orderComments,magicnumb,0,Green);
           
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
      int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,0,0,orderComments,magicnumb,0,Red);
     
    }
      }
         
      
     if(reverseorder)
   {
    if (currentPrice > MA && RSI < rsibuylevel) 
    {
        //price is above moving average and RSI is below 30, indicating oversold
        //enter long position
       int orderr=   OrderSend(Symbol(),OP_SELL,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Bid,3,0,0,orderComments,magicnumb,0,Red);
          
    } 

    
    else if (currentPrice < MA && RSI > rsiselllevel) 
    {
        //price is below moving average and RSI is above 70, indicating overbought
        //enter short position
         int orderr=  OrderSend(Symbol(),OP_BUY,GetRisk(usepercentrisk,uselotsize,percentrisk,StopLoss,lotsizee),Ask,3,0,0,orderComments,magicnumb,0,Green);
 
     
    }
   } 
   }    
   
   
   }
   
      
}
