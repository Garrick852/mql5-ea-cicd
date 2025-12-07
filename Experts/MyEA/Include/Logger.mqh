//+------------------------------------------------------------------+
//| Logger.mqh                                                       |
//| Logging utility for debugging and monitoring Expert Advisor      |
//| Created: 2025-12-07 13:02:47 UTC                                 |
//+------------------------------------------------------------------+

#ifndef __LOGGER_MQH__
#define __LOGGER_MQH__

//+------------------------------------------------------------------+
//| Enumeration for log levels                                       |
//+------------------------------------------------------------------+
enum LOGLEVEL {
   LOG_DEBUG = 0,
   LOG_INFO = 1,
   LOG_WARNING = 2,
   LOG_ERROR = 3,
   LOG_CRITICAL = 4
};

//+------------------------------------------------------------------+
//| Logger class for managing debug and monitoring operations        |
//+------------------------------------------------------------------+
class Logger {
private:
   string m_logFile;
   LOGLEVEL m_minLevel;
   bool m_useFileLogging;
   bool m_useConsoleLogging;

public:
   //--- Constructor
   Logger(const string logFileName = "EA_Log.txt", LOGLEVEL minLevel = LOG_INFO, 
          bool useFile = true, bool useConsole = true) {
      m_logFile = logFileName;
      m_minLevel = minLevel;
      m_useFileLogging = useFile;
      m_useConsoleLogging = useConsole;
      
      // Create log file with header if using file logging
      if (m_useFileLogging) {
         InitializeLogFile();
      }
   }

   //--- Destructor
   ~Logger() {
      // Cleanup if needed
   }

   //+------------------------------------------------------------------+
   //| Initialize log file with header information                      |
   //+------------------------------------------------------------------+
   void InitializeLogFile() {
      if (!m_useFileLogging) return;
      
      int handle = FileOpen(m_logFile, FILE_WRITE | FILE_TXT);
      if (handle != INVALID_HANDLE) {
         FileWrite(handle, "========================================");
         FileWrite(handle, "Expert Advisor Logger Initialized");
         FileWrite(handle, "Start Time: " + TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES));
         FileWrite(handle, "Symbol: " + Symbol());
         FileWrite(handle, "Timeframe: " + EnumToString(Period()));
         FileWrite(handle, "========================================");
         FileClose(handle);
      }
   }

   //+------------------------------------------------------------------+
   //| Log Debug message                                               |
   //+------------------------------------------------------------------+
   void Debug(const string message) {
      LogMessage(LOG_DEBUG, "[DEBUG] " + message);
   }

   //+------------------------------------------------------------------+
   //| Log Info message                                                |
   //+------------------------------------------------------------------+
   void Info(const string message) {
      LogMessage(LOG_INFO, "[INFO] " + message);
   }

   //+------------------------------------------------------------------+
   //| Log Warning message                                             |
   //+------------------------------------------------------------------+
   void Warning(const string message) {
      LogMessage(LOG_WARNING, "[WARNING] " + message);
   }

   //+------------------------------------------------------------------+
   //| Log Error message                                               |
   //+------------------------------------------------------------------+
   void Error(const string message) {
      LogMessage(LOG_ERROR, "[ERROR] " + message);
   }

   //+------------------------------------------------------------------+
   //| Log Critical message                                            |
   //+------------------------------------------------------------------+
   void Critical(const string message) {
      LogMessage(LOG_CRITICAL, "[CRITICAL] " + message);
   }

   //+------------------------------------------------------------------+
   //| Core logging function                                           |
   //+------------------------------------------------------------------+
   void LogMessage(LOGLEVEL level, const string message) {
      if (level < m_minLevel) return;
      
      string timestamp = TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES | TIME_SECONDS);
      string formattedMessage = timestamp + " | " + message;
      
      // Log to console (terminal)
      if (m_useConsoleLogging) {
         Print(formattedMessage);
      }
      
      // Log to file
      if (m_useFileLogging) {
         WriteToFile(formattedMessage);
      }
   }

   //+------------------------------------------------------------------+
   //| Write message to log file                                        |
   //+------------------------------------------------------------------+
   void WriteToFile(const string message) {
      int handle = FileOpen(m_logFile, FILE_WRITE | FILE_TXT | FILE_ANSI);
      if (handle != INVALID_HANDLE) {
         FileSeek(handle, 0, SEEK_END);
         FileWrite(handle, message);
         FileClose(handle);
      } else {
         Print("Failed to open log file: " + m_logFile);
      }
   }

   //+------------------------------------------------------------------+
   //| Set minimum log level                                           |
   //+------------------------------------------------------------------+
   void SetMinLevel(LOGLEVEL level) {
      m_minLevel = level;
   }

   //+------------------------------------------------------------------+
   //| Set file logging state                                          |
   //+------------------------------------------------------------------+
   void SetFileLogging(bool enabled) {
      m_useFileLogging = enabled;
   }

   //+------------------------------------------------------------------+
   //| Set console logging state                                       |
   //+------------------------------------------------------------------+
   void SetConsoleLogging(bool enabled) {
      m_useConsoleLogging = enabled;
   }

   //+------------------------------------------------------------------+
   //| Get log file name                                               |
   //+------------------------------------------------------------------+
   string GetLogFile() {
      return m_logFile;
   }

   //+------------------------------------------------------------------+
   //| Log market data snapshot                                        |
   //+------------------------------------------------------------------+
   void LogMarketSnapshot() {
      if (LOG_DEBUG < m_minLevel) return;
      
      string snapshot = StringFormat("Market Snapshot - Bid: %.5f, Ask: %.5f, Spread: %.1f pips, Time: %s",
         Bid, Ask, (Ask - Bid) / Point, TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES | TIME_SECONDS));
      Debug(snapshot);
   }

   //+------------------------------------------------------------------+
   //| Log account information                                         |
   //+------------------------------------------------------------------+
   void LogAccountInfo() {
      if (LOG_INFO < m_minLevel) return;
      
      string accountInfo = StringFormat("Account - Balance: %.2f, Equity: %.2f, Margin: %.2f%%",
         AccountBalance(), AccountEquity(), AccountFreeMarginPercent());
      Info(accountInfo);
   }

   //+------------------------------------------------------------------+
   //| Log trade operation                                             |
   //+------------------------------------------------------------------+
   void LogTradeOperation(const string operationType, const string symbol, 
                         const double price, const double volume, const string comment = "") {
      string tradeLog = StringFormat("Trade - Operation: %s, Symbol: %s, Price: %.5f, Volume: %.2f",
         operationType, symbol, price, volume);
      if (comment != "") {
         tradeLog += ", Comment: " + comment;
      }
      Info(tradeLog);
   }

   //+------------------------------------------------------------------+
   //| Log indicator values                                            |
   //+------------------------------------------------------------------+
   void LogIndicatorValue(const string indicatorName, const double value) {
      string indLog = StringFormat("Indicator - %s: %.5f", indicatorName, value);
      Debug(indLog);
   }

   //+------------------------------------------------------------------+
   //| Log performance metrics                                         |
   //+------------------------------------------------------------------+
   void LogPerformance(const string metricName, const double value, const string unit = "") {
      string perfLog = StringFormat("Performance - %s: %.4f%s", metricName, value, unit);
      Info(perfLog);
   }

   //+------------------------------------------------------------------+
   //| Log and return last error                                       |
   //+------------------------------------------------------------------+
   int LogLastError(const string context = "") {
      int errorCode = GetLastError();
      if (errorCode != 0) {
         string errorMsg = StringFormat("Error %d: %s", errorCode, ErrorDescription(errorCode));
         if (context != "") {
            errorMsg = context + " | " + errorMsg;
         }
         Error(errorMsg);
      }
      return errorCode;
   }

   //+------------------------------------------------------------------+
   //| Get error description                                           |
   //+------------------------------------------------------------------+
   string ErrorDescription(int errorCode) {
      switch (errorCode) {
         case 0: return "No error";
         case 1: return "No error returned";
         case 2: return "Common error";
         case 3: return "Invalid trade parameters";
         case 4: return "Trade server is busy";
         case 5: return "Old version of the client terminal";
         case 6: return "No connection with trade server";
         case 7: return "Not enough rights";
         case 8: return "Too frequent requests";
         case 9: return "Malfunctional trade operation";
         case 64: return "Account disabled";
         case 65: return "Invalid account";
         case 128: return "Trade timeout";
         case 129: return "Invalid price";
         case 130: return "Invalid stops";
         case 131: return "Invalid trade volume";
         case 132: return "Market is closed";
         case 133: return "Trade is disabled";
         case 134: return "Not enough money";
         case 135: return "Price changed";
         case 136: return "Off quotes";
         case 137: return "Broker is busy";
         case 138: return "Requote";
         case 139: return "Order is locked";
         case 140: return "Long positions only allowed";
         case 141: return "Too many requests";
         case 145: return "Modification denied because order is too close to market";
         case 146: return "Trade context is busy";
         case 147: return "Excessively high levels";
         case 148: return "Pending order working in process";
         default: return "Unknown error code: " + IntToString(errorCode);
      }
   }

   //+------------------------------------------------------------------+
   //| Log separator for readability                                   |
   //+------------------------------------------------------------------+
   void LogSeparator() {
      LogMessage(LOG_INFO, "====================================");
   }

};

#endif
