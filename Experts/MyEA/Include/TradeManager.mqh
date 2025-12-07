//+------------------------------------------------------------------+
//| TradeManager.mqh                                                 |
//| Trade management functions for opening, closing, and modifying   |
//| trades in MQL5 Expert Advisors                                   |
//| Created: 2025-12-07                                              |
//+------------------------------------------------------------------+

#ifndef __TRADE_MANAGER_MQH__
#define __TRADE_MANAGER_MQH__

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| TradeManager Class                                               |
//| Provides a wrapper around CTrade for enhanced trade management   |
//+------------------------------------------------------------------+
class CTradeManager
{
private:
   CTrade m_trade;
   double m_point;
   int m_slippage;
   bool m_async_mode;

public:
   // Constructor
   CTradeManager(int slippage = 10, bool async = false);
   
   // Trade Opening Functions
   bool OpenBuyMarket(string symbol, double volume, double stop_loss = 0, double take_profit = 0, string comment = "");
   bool OpenSellMarket(string symbol, double volume, double stop_loss = 0, double take_profit = 0, string comment = "");
   bool OpenBuyLimit(string symbol, double volume, double price, double stop_loss = 0, double take_profit = 0, string comment = "");
   bool OpenSellLimit(string symbol, double volume, double price, double stop_loss = 0, double take_profit = 0, string comment = "");
   bool OpenBuyStop(string symbol, double volume, double price, double stop_loss = 0, double take_profit = 0, string comment = "");
   bool OpenSellStop(string symbol, double volume, double price, double stop_loss = 0, double take_profit = 0, string comment = "");
   
   // Trade Closing Functions
   bool CloseTradeByTicket(ulong ticket);
   bool CloseTradeBySymbol(string symbol);
   bool CloseAllTrades();
   bool CloseTradePartially(ulong ticket, double volume);
   
   // Trade Modification Functions
   bool ModifyTradeStopLoss(ulong ticket, double new_stop_loss);
   bool ModifyTradeTakeProfit(ulong ticket, double new_take_profit);
   bool ModifyTradeTP_SL(ulong ticket, double new_take_profit, double new_stop_loss);
   
   // Trade Information Functions
   bool GetTradeInfo(ulong ticket, MqlTradeRequest &request);
   double GetTradeProfit(ulong ticket);
   double GetTradeOpenPrice(ulong ticket);
   double GetTradeVolume(ulong ticket);
   int GetOpenTradesCount();
   int GetOpenTradesCountBySymbol(string symbol);
   
   // Utility Functions
   void SetSlippage(int slippage) { m_slippage = slippage; }
   void SetAsyncMode(bool async) { m_async_mode = async; }
   int GetLastError() { return m_trade.ResultRetcode(); }
   string GetLastErrorDescription() { return m_trade.ResultRetcodeDescription(); }
};

//+------------------------------------------------------------------+
//| Constructor                                                       |
//+------------------------------------------------------------------+
CTradeManager::CTradeManager(int slippage = 10, bool async = false)
{
   m_slippage = slippage;
   m_async_mode = async;
   m_point = _Point;
   
   m_trade.SetAsyncMode(m_async_mode);
   m_trade.SetDeviationInPoints(m_slippage);
}

//+------------------------------------------------------------------+
//| Open Buy Market Order                                            |
//+------------------------------------------------------------------+
bool CTradeManager::OpenBuyMarket(string symbol, double volume, double stop_loss = 0, double take_profit = 0, string comment = "")
{
   MqlTick tick;
   if (!SymbolInfoTick(symbol, tick))
      return false;
   
   double sl = (stop_loss > 0) ? stop_loss : 0;
   double tp = (take_profit > 0) ? take_profit : 0;
   
   return m_trade.Buy(volume, symbol, tick.ask, sl, tp, comment);
}

//+------------------------------------------------------------------+
//| Open Sell Market Order                                           |
//+------------------------------------------------------------------+
bool CTradeManager::OpenSellMarket(string symbol, double volume, double stop_loss = 0, double take_profit = 0, string comment = "")
{
   MqlTick tick;
   if (!SymbolInfoTick(symbol, tick))
      return false;
   
   double sl = (stop_loss > 0) ? stop_loss : 0;
   double tp = (take_profit > 0) ? take_profit : 0;
   
   return m_trade.Sell(volume, symbol, tick.bid, sl, tp, comment);
}

//+------------------------------------------------------------------+
//| Open Buy Limit Order                                             |
//+------------------------------------------------------------------+
bool CTradeManager::OpenBuyLimit(string symbol, double volume, double price, double stop_loss = 0, double take_profit = 0, string comment = "")
{
   double sl = (stop_loss > 0) ? stop_loss : 0;
   double tp = (take_profit > 0) ? take_profit : 0;
   
   return m_trade.BuyLimit(volume, price, symbol, sl, tp, ORDER_TIME_GTC, 0, comment);
}

//+------------------------------------------------------------------+
//| Open Sell Limit Order                                            |
//+------------------------------------------------------------------+
bool CTradeManager::OpenSellLimit(string symbol, double volume, double price, double stop_loss = 0, double take_profit = 0, string comment = "")
{
   double sl = (stop_loss > 0) ? stop_loss : 0;
   double tp = (take_profit > 0) ? take_profit : 0;
   
   return m_trade.SellLimit(volume, price, symbol, sl, tp, ORDER_TIME_GTC, 0, comment);
}

//+------------------------------------------------------------------+
//| Open Buy Stop Order                                              |
//+------------------------------------------------------------------+
bool CTradeManager::OpenBuyStop(string symbol, double volume, double price, double stop_loss = 0, double take_profit = 0, string comment = "")
{
   double sl = (stop_loss > 0) ? stop_loss : 0;
   double tp = (take_profit > 0) ? take_profit : 0;
   
   return m_trade.BuyStop(volume, price, symbol, sl, tp, ORDER_TIME_GTC, 0, comment);
}

//+------------------------------------------------------------------+
//| Open Sell Stop Order                                             |
//+------------------------------------------------------------------+
bool CTradeManager::OpenSellStop(string symbol, double volume, double price, double stop_loss = 0, double take_profit = 0, string comment = "")
{
   double sl = (stop_loss > 0) ? stop_loss : 0;
   double tp = (take_profit > 0) ? take_profit : 0;
   
   return m_trade.SellStop(volume, price, symbol, sl, tp, ORDER_TIME_GTC, 0, comment);
}

//+------------------------------------------------------------------+
//| Close Trade by Ticket                                            |
//+------------------------------------------------------------------+
bool CTradeManager::CloseTradeByTicket(ulong ticket)
{
   return m_trade.PositionClose(ticket);
}

//+------------------------------------------------------------------+
//| Close All Trades of a Symbol                                     |
//+------------------------------------------------------------------+
bool CTradeManager::CloseTradeBySymbol(string symbol)
{
   bool result = true;
   
   for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if (ticket == 0)
         continue;
      
      if (PositionGetString(POSITION_SYMBOL) == symbol)
      {
         if (!m_trade.PositionClose(ticket))
            result = false;
      }
   }
   
   return result;
}

//+------------------------------------------------------------------+
//| Close All Open Trades                                            |
//+------------------------------------------------------------------+
bool CTradeManager::CloseAllTrades()
{
   bool result = true;
   
   for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if (ticket == 0)
         continue;
      
      if (!m_trade.PositionClose(ticket))
         result = false;
   }
   
   return result;
}

//+------------------------------------------------------------------+
//| Close Trade Partially                                            |
//+------------------------------------------------------------------+
bool CTradeManager::CloseTradePartially(ulong ticket, double volume)
{
   if (!PositionSelectByTicket(ticket))
      return false;
   
   double current_volume = PositionGetDouble(POSITION_VOLUME);
   if (volume <= 0 || volume > current_volume)
      return false;
   
   return m_trade.PositionClosePartial(ticket, volume);
}

//+------------------------------------------------------------------+
//| Modify Trade Stop Loss                                           |
//+------------------------------------------------------------------+
bool CTradeManager::ModifyTradeStopLoss(ulong ticket, double new_stop_loss)
{
   if (!PositionSelectByTicket(ticket))
      return false;
   
   double current_tp = PositionGetDouble(POSITION_TP);
   
   return m_trade.PositionModify(ticket, new_stop_loss, current_tp);
}

//+------------------------------------------------------------------+
//| Modify Trade Take Profit                                         |
//+------------------------------------------------------------------+
bool CTradeManager::ModifyTradeTakeProfit(ulong ticket, double new_take_profit)
{
   if (!PositionSelectByTicket(ticket))
      return false;
   
   double current_sl = PositionGetDouble(POSITION_SL);
   
   return m_trade.PositionModify(ticket, current_sl, new_take_profit);
}

//+------------------------------------------------------------------+
//| Modify Trade TP and SL                                           |
//+------------------------------------------------------------------+
bool CTradeManager::ModifyTradeTP_SL(ulong ticket, double new_take_profit, double new_stop_loss)
{
   if (!PositionSelectByTicket(ticket))
      return false;
   
   return m_trade.PositionModify(ticket, new_stop_loss, new_take_profit);
}

//+------------------------------------------------------------------+
//| Get Trade Information                                            |
//+------------------------------------------------------------------+
bool CTradeManager::GetTradeInfo(ulong ticket, MqlTradeRequest &request)
{
   if (!PositionSelectByTicket(ticket))
      return false;
   
   request.symbol = PositionGetString(POSITION_SYMBOL);
   request.volume = PositionGetDouble(POSITION_VOLUME);
   request.price = PositionGetDouble(POSITION_PRICE_OPEN);
   request.sl = PositionGetDouble(POSITION_SL);
   request.tp = PositionGetDouble(POSITION_TP);
   
   return true;
}

//+------------------------------------------------------------------+
//| Get Trade Profit                                                 |
//+------------------------------------------------------------------+
double CTradeManager::GetTradeProfit(ulong ticket)
{
   if (!PositionSelectByTicket(ticket))
      return 0;
   
   return PositionGetDouble(POSITION_PROFIT);
}

//+------------------------------------------------------------------+
//| Get Trade Open Price                                             |
//+------------------------------------------------------------------+
double CTradeManager::GetTradeOpenPrice(ulong ticket)
{
   if (!PositionSelectByTicket(ticket))
      return 0;
   
   return PositionGetDouble(POSITION_PRICE_OPEN);
}

//+------------------------------------------------------------------+
//| Get Trade Volume                                                 |
//+------------------------------------------------------------------+
double CTradeManager::GetTradeVolume(ulong ticket)
{
   if (!PositionSelectByTicket(ticket))
      return 0;
   
   return PositionGetDouble(POSITION_VOLUME);
}

//+------------------------------------------------------------------+
//| Get Open Trades Count                                            |
//+------------------------------------------------------------------+
int CTradeManager::GetOpenTradesCount()
{
   return PositionsTotal();
}

//+------------------------------------------------------------------+
//| Get Open Trades Count by Symbol                                  |
//+------------------------------------------------------------------+
int CTradeManager::GetOpenTradesCountBySymbol(string symbol)
{
   int count = 0;
   
   for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if (ticket == 0)
         continue;
      
      if (PositionGetString(POSITION_SYMBOL) == symbol)
         count++;
   }
   
   return count;
}

#endif // __TRADE_MANAGER_MQH__
