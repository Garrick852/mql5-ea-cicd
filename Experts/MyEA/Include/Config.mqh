//+------------------------------------------------------------------+
//| Config.mqh                                                       |
//| Configuration constants and parameters for Expert Advisor        |
//| Created: 2025-12-07 13:01:48 UTC                                |
//+------------------------------------------------------------------+

#ifndef __CONFIG_MQH__
#define __CONFIG_MQH__

//--- Expert Advisor Identification
#define EA_NAME              "MyEA"
#define EA_VERSION           "1.0.0"
#define EA_AUTHOR            "Garrick852"
#define EA_DESCRIPTION       "Expert Advisor with Risk Management"

//--- Trading Parameters
#define DEFAULT_SYMBOL       "EURUSD"
#define DEFAULT_TIMEFRAME    PERIOD_H1

//--- Risk Management Configuration
#define RISK_PERCENT         2.0              // Risk as percentage of account balance
#define MAX_DRAWDOWN_PERCENT 10.0             // Maximum allowed drawdown in percentage
#define MAX_POSITIONS        5                // Maximum number of concurrent positions
#define POSITION_VOLUME      0.1              // Default lot size
#define STOP_LOSS_PIPS       50               // Stop loss in pips
#define TAKE_PROFIT_PIPS     100              // Take profit in pips

//--- Trading Hours Configuration
#define TRADING_ENABLED      true             // Enable/disable trading
#define START_HOUR           8                // Trading start hour (UTC)
#define END_HOUR             16               // Trading end hour (UTC)
#define ALLOW_TRADING_WEEKENDS false          // Allow trading on weekends

//--- Technical Indicators Configuration
#define MA_FAST_PERIOD       9                // Fast moving average period
#define MA_SLOW_PERIOD       21               // Slow moving average period
#define RSI_PERIOD           14               // RSI indicator period
#define RSI_OVERBOUGHT       70               // RSI overbought level
#define RSI_OVERSOLD         30               // RSI oversold level

//--- Slippage and Commission Configuration
#define MAX_SLIPPAGE         10               // Maximum allowed slippage in pips
#define COMMISSION_MODE      0                // Commission calculation mode

//--- Logging and Debugging
#define ENABLE_LOGGING       true             // Enable trade logging
#define LOG_LEVEL            2                // Log level (0=Error, 1=Warning, 2=Info, 3=Debug)
#define PRINT_DEBUG_INFO     true             // Print debug information to journal

//--- Connection and Retry Configuration
#define MAX_RETRIES          3                // Maximum number of retry attempts
#define RETRY_DELAY          100              // Delay between retries in milliseconds
#define REQUEST_TIMEOUT      5000             // Request timeout in milliseconds

//--- Performance Tuning
#define OPTIMIZATION_MODE    false            // Enable optimization mode
#define BACKTEST_MODE        false            // Enable backtest mode
#define UPDATE_INTERVAL      60               // Update interval in seconds

//--- Account Configuration
#define ACCOUNT_CURRENCY     "USD"            // Account base currency
#define MIN_ACCOUNT_BALANCE  1000.0           // Minimum account balance to trade

//--- Data Configuration
#define HISTORY_BARS         500              // Number of historical bars to load
#define MIN_BARS_TO_TRADE    50               // Minimum bars required before trading

#endif // __CONFIG_MQH__
