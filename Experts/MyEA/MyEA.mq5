//+------------------------------------------------------------------+
//|                                                         MyEA.mq5 |
//|                                              Expert Advisor Template|
//|                                                     Garrick852 EA  |
//+------------------------------------------------------------------+
#property strict
#property version   "1.00"
#property description "MyEA - Expert Advisor with CICD Integration"
#property author    "Garrick852"

//+------------------------------------------------------------------+
//| Input Parameters                                                  |
//+------------------------------------------------------------------+
input double RiskPercent = 1.0;           // Risk as % of account
input int MagicNumber = 123456;           // Magic number for trades
input int MaxSpread = 20;                 // Maximum spread in points
input bool UseStopLoss = true;            // Use stop loss
input bool UseTakeProfit = true;          // Use take profit
input int StopLossPoints = 100;           // Stop loss in points
input int TakeProfitPoints = 200;         // Take profit in points

//+------------------------------------------------------------------+
//| Global Variables                                                  |
//+------------------------------------------------------------------+
int HandleMA;                             // Handle for Moving Average
double BufferMA[];                        // Buffer for MA values

//+------------------------------------------------------------------+
//| Expert initialization function                                    |
//+------------------------------------------------------------------+
int OnInit()
{
   // Set array as series
   ArraySetAsSeries(BufferMA, true);
   
   // Create Moving Average indicator handle
   HandleMA = iMA(_Symbol, _Period, 20, 0, MODE_SMA, PRICE_CLOSE);
   
   if(HandleMA == INVALID_HANDLE)
   {
      Print("Error creating MA indicator handle");
      return INIT_FAILED;
   }
   
   Print("Expert Advisor initialized successfully");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   // Release indicator handle
   if(HandleMA != INVALID_HANDLE)
   {
      IndicatorRelease(HandleMA);
   }
   
   Print("Expert Advisor deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                              |
//+------------------------------------------------------------------+
void OnTick()
{
   // Check if we have enough bars
   if(Bars(_Symbol, _Period) < 30)
   {
      return;
   }
   
   // Update indicator data
   if(CopyBuffer(HandleMA, 0, 0, 2, BufferMA) <= 0)
   {
      Print("Error copying MA buffer");
      return;
   }
   
   // Trading logic
   ExecuteTradingLogic();
}

//+------------------------------------------------------------------+
//| Trading Logic Function                                            |
//+------------------------------------------------------------------+
void ExecuteTradingLogic()
{
   // Get current ask/bid prices
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double spread = ask - bid;
   double spreadPoints = spread / _Point;
   
   // Check spread filter
   if(spreadPoints > MaxSpread)
   {
      return;
   }
   
   // Check for existing positions
   if(PositionSelect(_Symbol) == false)
   {
      // No open position - check for trading signals
      CheckForBuySignal(ask, bid);
      CheckForSellSignal(ask, bid);
   }
   else
   {
      // Position already open
      ManageOpenPosition();
   }
}

//+------------------------------------------------------------------+
//| Check for Buy Signal                                              |
//+------------------------------------------------------------------+
void CheckForBuySignal(double ask, double bid)
{
   // Simple trading signal: price above MA
   if(Close[0] > BufferMA[0] && Close[1] <= BufferMA[1])
   {
      OpenBuyPosition(ask, bid);
   }
}

//+------------------------------------------------------------------+
//| Check for Sell Signal                                             |
//+------------------------------------------------------------------+
void CheckForSellSignal(double ask, double bid)
{
   // Simple trading signal: price below MA
   if(Close[0] < BufferMA[0] && Close[1] >= BufferMA[1])
   {
      OpenSellPosition(ask, bid);
   }
}

//+------------------------------------------------------------------+
//| Open Buy Position                                                 |
//+------------------------------------------------------------------+
void OpenBuyPosition(double ask, double bid)
{
   // Calculate position size
   double positionSize = CalculatePositionSize(ask);
   
   if(positionSize <= 0)
   {
      Print("Invalid position size calculated");
      return;
   }
   
   // Calculate stop loss and take profit
   double stopLoss = UseStopLoss ? ask - (StopLossPoints * _Point) : 0;
   double takeProfit = UseTakeProfit ? ask + (TakeProfitPoints * _Point) : 0;
   
   // Create market buy order
   MqlTradeRequest request = {0};
   MqlTradeResult result = {0};
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = positionSize;
   request.type = ORDER_TYPE_BUY;
   request.price = ask;
   request.sl = stopLoss;
   request.tp = takeProfit;
   request.magic = MagicNumber;
   request.comment = "Buy signal from MyEA";
   request.deviation = 10;
   
   if(!OrderSend(request, result))
   {
      Print("OrderSend error: ", GetLastError());
   }
   else
   {
      Print("Buy position opened. Ticket: ", result.order);
   }
}

//+------------------------------------------------------------------+
//| Open Sell Position                                                |
//+------------------------------------------------------------------+
void OpenSellPosition(double ask, double bid)
{
   // Calculate position size
   double positionSize = CalculatePositionSize(bid);
   
   if(positionSize <= 0)
   {
      Print("Invalid position size calculated");
      return;
   }
   
   // Calculate stop loss and take profit
   double stopLoss = UseStopLoss ? bid + (StopLossPoints * _Point) : 0;
   double takeProfit = UseTakeProfit ? bid - (TakeProfitPoints * _Point) : 0;
   
   // Create market sell order
   MqlTradeRequest request = {0};
   MqlTradeResult result = {0};
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = positionSize;
   request.type = ORDER_TYPE_SELL;
   request.price = bid;
   request.sl = stopLoss;
   request.tp = takeProfit;
   request.magic = MagicNumber;
   request.comment = "Sell signal from MyEA";
   request.deviation = 10;
   
   if(!OrderSend(request, result))
   {
      Print("OrderSend error: ", GetLastError());
   }
   else
   {
      Print("Sell position opened. Ticket: ", result.order);
   }
}

//+------------------------------------------------------------------+
//| Manage Open Position                                              |
//+------------------------------------------------------------------+
void ManageOpenPosition()
{
   // Placeholder for position management logic
   // Add trailing stops, breakeven management, etc.
}

//+------------------------------------------------------------------+
//| Calculate Position Size                                           |
//+------------------------------------------------------------------+
double CalculatePositionSize(double entryPrice)
{
   // Get account information
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = accountBalance * (RiskPercent / 100.0);
   
   // Get symbol information
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   // Calculate risk in points
   int riskInPoints = UseStopLoss ? StopLossPoints : 100;
   
   // Calculate position size
   double positionSize = (riskAmount / (riskInPoints * tickSize)) * tickValue;
   
   // Normalize to lot step
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   positionSize = NormalizeDouble(positionSize / lotStep, 0) * lotStep;
   
   // Check limits
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   
   if(positionSize < minLot)
      positionSize = minLot;
   if(positionSize > maxLot)
      positionSize = maxLot;
   
   return positionSize;
}

//+------------------------------------------------------------------+
//| End of Expert Advisor                                             |
//+------------------------------------------------------------------+
