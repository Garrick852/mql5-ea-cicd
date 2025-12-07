//+------------------------------------------------------------------+
//|                                             SignalGenerator.mqh |
//|                                   Copyright 2025, Garrick852     |
//|                                                                  |
//| Signal generation functions for trading strategy logic          |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Garrick852"
#property link      ""
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Signal type definitions                                          |
//+------------------------------------------------------------------+
enum SIGNAL_TYPE
{
   SIGNAL_BUY = 1,      // Buy signal
   SIGNAL_SELL = -1,    // Sell signal
   SIGNAL_NEUTRAL = 0   // No signal
};

//+------------------------------------------------------------------+
//| Structure for signal parameters                                 |
//+------------------------------------------------------------------+
struct SignalParams
{
   double      rsi_value;           // RSI indicator value
   double      macd_main;           // MACD main line
   double      macd_signal;         // MACD signal line
   double      moving_avg_fast;     // Fast moving average
   double      moving_avg_slow;     // Slow moving average
   double      current_price;       // Current price
   int         signal_strength;     // Signal strength (0-100)
   bool        trend_up;            // True if uptrend
};

//+------------------------------------------------------------------+
//| RSI-based signal generation                                      |
//+------------------------------------------------------------------+
SIGNAL_TYPE SignalFromRSI(double rsi_value, double overbought = 70.0, 
                          double oversold = 30.0)
{
   if (rsi_value > overbought)
      return SIGNAL_SELL;
   
   if (rsi_value < oversold)
      return SIGNAL_BUY;
   
   return SIGNAL_NEUTRAL;
}

//+------------------------------------------------------------------+
//| MACD-based signal generation                                     |
//+------------------------------------------------------------------+
SIGNAL_TYPE SignalFromMACD(double macd_main, double macd_signal)
{
   if (macd_main > macd_signal)
      return SIGNAL_BUY;
   
   if (macd_main < macd_signal)
      return SIGNAL_SELL;
   
   return SIGNAL_NEUTRAL;
}

//+------------------------------------------------------------------+
//| Moving Average Crossover signal generation                       |
//+------------------------------------------------------------------+
SIGNAL_TYPE SignalFromMovingAverageCrossover(double fast_ma, double slow_ma)
{
   if (fast_ma > slow_ma)
      return SIGNAL_BUY;
   
   if (fast_ma < slow_ma)
      return SIGNAL_SELL;
   
   return SIGNAL_NEUTRAL;
}

//+------------------------------------------------------------------+
//| Combined signal generation                                       |
//+------------------------------------------------------------------+
SIGNAL_TYPE GenerateCombinedSignal(const SignalParams &params)
{
   SIGNAL_TYPE rsi_signal = SignalFromRSI(params.rsi_value);
   SIGNAL_TYPE macd_signal = SignalFromMACD(params.macd_main, params.macd_signal);
   SIGNAL_TYPE ma_signal = SignalFromMovingAverageCrossover(
                              params.moving_avg_fast, 
                              params.moving_avg_slow);
   
   // Count signals for consensus
   int buy_count = 0;
   int sell_count = 0;
   
   if (rsi_signal == SIGNAL_BUY) buy_count++;
   else if (rsi_signal == SIGNAL_SELL) sell_count++;
   
   if (macd_signal == SIGNAL_BUY) buy_count++;
   else if (macd_signal == SIGNAL_SELL) sell_count++;
   
   if (ma_signal == SIGNAL_BUY) buy_count++;
   else if (ma_signal == SIGNAL_SELL) sell_count++;
   
   // Return signal based on majority
   if (buy_count > sell_count)
      return SIGNAL_BUY;
   
   if (sell_count > buy_count)
      return SIGNAL_SELL;
   
   return SIGNAL_NEUTRAL;
}

//+------------------------------------------------------------------+
//| Confirm signal with trend analysis                              |
//+------------------------------------------------------------------+
bool ConfirmSignalWithTrend(SIGNAL_TYPE signal, bool is_uptrend)
{
   if (signal == SIGNAL_BUY && is_uptrend)
      return true;
   
   if (signal == SIGNAL_SELL && !is_uptrend)
      return true;
   
   return false;
}

//+------------------------------------------------------------------+
//| Calculate signal strength (0-100)                               |
//+------------------------------------------------------------------+
int CalculateSignalStrength(double rsi_value, double macd_histogram)
{
   int strength = 0;
   
   // RSI contribution (0-33)
   if (rsi_value < 30 || rsi_value > 70)
      strength += 33;
   else if (rsi_value < 40 || rsi_value > 60)
      strength += 20;
   else
      strength += 10;
   
   // MACD contribution (0-33)
   if (MathAbs(macd_histogram) > 0.01)
      strength += 33;
   else if (MathAbs(macd_histogram) > 0.005)
      strength += 20;
   else
      strength += 10;
   
   // Price action contribution (0-34)
   strength += 34;
   
   // Ensure strength is within 0-100 range
   if (strength > 100) strength = 100;
   if (strength < 0) strength = 0;
   
   return strength;
}

//+------------------------------------------------------------------+
//| Get signal description                                           |
//+------------------------------------------------------------------+
string GetSignalDescription(SIGNAL_TYPE signal)
{
   switch (signal)
   {
      case SIGNAL_BUY:
         return "BUY Signal";
      case SIGNAL_SELL:
         return "SELL Signal";
      case SIGNAL_NEUTRAL:
         return "NEUTRAL - No Clear Signal";
      default:
         return "UNKNOWN Signal";
   }
}

//+------------------------------------------------------------------+
//| End of SignalGenerator.mqh                                       |
//+------------------------------------------------------------------+
