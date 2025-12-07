//+------------------------------------------------------------------+
//|                                              RiskManager.mqh      |
//|                           Risk Management Module for Trading EA   |
//|                                                   Version 1.0      |
//+------------------------------------------------------------------+

#ifndef __RISK_MANAGER_H__
#define __RISK_MANAGER_H__

//+------------------------------------------------------------------+
//| Risk Management Configuration Structure                           |
//+------------------------------------------------------------------+
struct RiskConfig
{
    double riskPercent;           // Risk as percentage of account (0.1 - 5.0%)
    double maxDrawdownPercent;    // Maximum allowed drawdown (5.0 - 50.0%)
    double rewardRiskRatio;       // Reward to Risk ratio (1.0 - 5.0)
    int maxOpenPositions;         // Maximum concurrent open positions
    double maxPositionSize;       // Maximum position size as % of account
    bool useEquityStop;           // Stop trading if equity drops below threshold
    double minEquityPercent;      // Minimum equity level (50-100% of initial)
};

//+------------------------------------------------------------------+
//| RiskManager Class                                                 |
//+------------------------------------------------------------------+
class RiskManager
{
private:
    RiskConfig config;
    double initialBalance;
    double highestEquity;
    double peakEquity;
    
public:
    // Constructor
    RiskManager() : initialBalance(0), highestEquity(0), peakEquity(0)
    {
        // Default configuration
        config.riskPercent = 1.0;
        config.maxDrawdownPercent = 20.0;
        config.rewardRiskRatio = 2.0;
        config.maxOpenPositions = 5;
        config.maxPositionSize = 5.0;
        config.useEquityStop = true;
        config.minEquityPercent = 80.0;
    }
    
    // Destructor
    ~RiskManager() {}
    
    //+------------------------------------------------------------------+
    //| Configuration Methods                                            |
    //+------------------------------------------------------------------+
    
    /**
     * Set Risk Configuration
     * @param newConfig - RiskConfig structure with all parameters
     * @return true if configuration is valid, false otherwise
     */
    bool SetConfig(const RiskConfig &newConfig)
    {
        // Validate configuration parameters
        if (newConfig.riskPercent <= 0 || newConfig.riskPercent > 5.0)
        {
            Print("Error: Risk percent must be between 0.01% and 5.0%");
            return false;
        }
        
        if (newConfig.maxDrawdownPercent <= 0 || newConfig.maxDrawdownPercent > 100.0)
        {
            Print("Error: Max drawdown must be between 0.1% and 100%");
            return false;
        }
        
        if (newConfig.rewardRiskRatio < 0.5 || newConfig.rewardRiskRatio > 10.0)
        {
            Print("Error: Reward/Risk ratio must be between 0.5 and 10.0");
            return false;
        }
        
        if (newConfig.maxOpenPositions < 1 || newConfig.maxOpenPositions > 100)
        {
            Print("Error: Max open positions must be between 1 and 100");
            return false;
        }
        
        if (newConfig.maxPositionSize <= 0 || newConfig.maxPositionSize > 100.0)
        {
            Print("Error: Max position size must be between 0.01% and 100%");
            return false;
        }
        
        if (newConfig.minEquityPercent < 10.0 || newConfig.minEquityPercent > 100.0)
        {
            Print("Error: Min equity percent must be between 10% and 100%");
            return false;
        }
        
        config = newConfig;
        return true;
    }
    
    /**
     * Initialize Risk Manager with current account balance
     */
    void Initialize()
    {
        initialBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        highestEquity = AccountInfoDouble(ACCOUNT_EQUITY);
        peakEquity = highestEquity;
        
        Print("RiskManager initialized. Initial Balance: ", DoubleToString(initialBalance, 2),
              " USD, Current Equity: ", DoubleToString(highestEquity, 2), " USD");
    }
    
    //+------------------------------------------------------------------+
    //| Position Sizing Methods                                          |
    //+------------------------------------------------------------------+
    
    /**
     * Calculate Position Size based on Risk Management Rules
     * @param stopLossPoints - Stop loss distance in points
     * @param symbol - Trading symbol
     * @return Lot size (0 if cannot calculate or exceeds limits)
     */
    double CalculatePositionSize(double stopLossPoints, const string symbol)
    {
        if (stopLossPoints <= 0)
        {
            Print("Error: Stop loss points must be positive");
            return 0;
        }
        
        // Check if we can open more positions
        if (GetOpenPositionsCount() >= config.maxOpenPositions)
        {
            Print("Warning: Maximum open positions reached (", config.maxOpenPositions, ")");
            return 0;
        }
        
        // Check equity stop
        if (!IsEquityHealthy())
        {
            Print("Warning: Equity below minimum threshold");
            return 0;
        }
        
        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
        double riskAmount = currentEquity * (config.riskPercent / 100.0);
        
        // Get symbol info
        SymbolInfoTick(symbol, MqlTick tick);
        double tickSize = SymbolInfoDouble(symbol, SYMBOL_POINT);
        double tickValue = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
        
        if (tickValue == 0)
        {
            Print("Error: Cannot retrieve tick value for symbol ", symbol);
            return 0;
        }
        
        // Calculate lot size
        // Lot Size = Risk Amount / (Stop Loss Points * Tick Value * Contract Size)
        double contractSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_CONTRACT_SIZE);
        double lotSize = riskAmount / (stopLossPoints * tickValue * contractSize / tickSize);
        
        // Apply minimum and maximum lot limits
        double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
        double maxLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
        double stepLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
        
        // Round to step
        lotSize = MathFloor(lotSize / stepLot) * stepLot;
        
        if (lotSize < minLot)
        {
            Print("Warning: Calculated lot size (", DoubleToString(lotSize, 2),
                  ") is below minimum (", DoubleToString(minLot, 2), ")");
            return 0;
        }
        
        if (lotSize > maxLot)
        {
            lotSize = maxLot;
            Print("Warning: Calculated lot size capped to maximum (", DoubleToString(maxLot, 2), ")");
        }
        
        // Check against max position size percentage
        double maxLotByPercent = (currentEquity * config.maxPositionSize / 100.0) / 
                                 (stopLossPoints * tickValue * contractSize / tickSize);
        
        if (lotSize > maxLotByPercent)
        {
            lotSize = MathFloor(maxLotByPercent / stepLot) * stepLot;
            Print("Warning: Lot size capped to max position size percentage");
        }
        
        return lotSize;
    }
    
    /**
     * Calculate Take Profit based on Risk/Reward Ratio
     * @param entryPrice - Entry price
     * @param stopLossPrice - Stop loss price
     * @param isLong - true for long, false for short
     * @return Take profit price
     */
    double CalculateTakeProfit(double entryPrice, double stopLossPrice, bool isLong)
    {
        if (config.rewardRiskRatio <= 0)
        {
            Print("Error: Reward/Risk ratio must be positive");
            return 0;
        }
        
        double riskDistance = MathAbs(entryPrice - stopLossPrice);
        double profitDistance = riskDistance * config.rewardRiskRatio;
        
        if (isLong)
            return entryPrice + profitDistance;
        else
            return entryPrice - profitDistance;
    }
    
    /**
     * Calculate Stop Loss based on Volatility
     * @param currentPrice - Current market price
     * @param atr - Average True Range value
     * @param atrMultiplier - Multiplier for ATR (typically 1.5 to 3.0)
     * @param isLong - true for long, false for short
     * @return Stop loss price
     */
    double CalculateATRBasedStopLoss(double currentPrice, double atr, double atrMultiplier, bool isLong)
    {
        if (atr <= 0 || atrMultiplier <= 0)
        {
            Print("Error: ATR and multiplier must be positive");
            return 0;
        }
        
        double stopDistance = atr * atrMultiplier;
        
        if (isLong)
            return currentPrice - stopDistance;
        else
            return currentPrice + stopDistance;
    }
    
    //+------------------------------------------------------------------+
    //| Monitoring and Status Methods                                    |
    //+------------------------------------------------------------------+
    
    /**
     * Get Current Drawdown Percentage
     * @return Current drawdown as percentage (0 to 100)
     */
    double GetCurrentDrawdown()
    {
        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
        
        if (peakEquity <= 0)
            return 0;
        
        double drawdown = ((peakEquity - currentEquity) / peakEquity) * 100.0;
        return MathMax(0, drawdown);
    }
    
    /**
     * Check if Equity is Healthy
     * @return true if equity is above minimum threshold, false otherwise
     */
    bool IsEquityHealthy()
    {
        if (!config.useEquityStop)
            return true;
        
        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
        double minAllowedEquity = initialBalance * (config.minEquityPercent / 100.0);
        
        return currentEquity >= minAllowedEquity;
    }
    
    /**
     * Check if Drawdown Exceeded Maximum
     * @return true if max drawdown exceeded, false otherwise
     */
    bool IsMaxDrawdownExceeded()
    {
        return GetCurrentDrawdown() >= config.maxDrawdownPercent;
    }
    
    /**
     * Get Number of Open Positions
     * @return Count of open positions
     */
    int GetOpenPositionsCount()
    {
        int count = 0;
        int totalPositions = PositionsTotal();
        
        for (int i = 0; i < totalPositions; i++)
        {
            if (PositionGetSymbol(i) != NULL)
                count++;
        }
        
        return count;
    }
    
    /**
     * Update Peak Equity for Drawdown Calculation
     */
    void UpdatePeakEquity()
    {
        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
        
        if (currentEquity > peakEquity)
        {
            peakEquity = currentEquity;
            highestEquity = currentEquity;
        }
    }
    
    //+------------------------------------------------------------------+
    //| Money Management Methods                                         |
    //+------------------------------------------------------------------+
    
    /**
     * Calculate Daily Profit Loss
     * @return Daily P&L in account currency
     */
    double GetDailyProfitLoss()
    {
        double balance = AccountInfoDouble(ACCOUNT_BALANCE);
        double equity = AccountInfoDouble(ACCOUNT_EQUITY);
        
        return equity - balance;
    }
    
    /**
     * Get Account Statistics
     * @return Account statistics as string
     */
    string GetAccountStats()
    {
        double balance = AccountInfoDouble(ACCOUNT_BALANCE);
        double equity = AccountInfoDouble(ACCOUNT_EQUITY);
        double margin = AccountInfoDouble(ACCOUNT_MARGIN);
        double freeMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
        double marginLevel = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
        
        string stats = "=== Account Statistics ===\n";
        stats += "Balance: " + DoubleToString(balance, 2) + "\n";
        stats += "Equity: " + DoubleToString(equity, 2) + "\n";
        stats += "Margin Used: " + DoubleToString(margin, 2) + "\n";
        stats += "Margin Free: " + DoubleToString(freeMargin, 2) + "\n";
        stats += "Margin Level: " + DoubleToString(marginLevel, 2) + "%\n";
        stats += "Drawdown: " + DoubleToString(GetCurrentDrawdown(), 2) + "%\n";
        stats += "Open Positions: " + IntegerToString(GetOpenPositionsCount()) + "\n";
        
        return stats;
    }
    
    /**
     * Get Risk Configuration as String
     * @return Configuration details as string
     */
    string GetConfigInfo()
    {
        string info = "=== Risk Configuration ===\n";
        info += "Risk per Trade: " + DoubleToString(config.riskPercent, 2) + "%\n";
        info += "Max Drawdown: " + DoubleToString(config.maxDrawdownPercent, 2) + "%\n";
        info += "Reward/Risk Ratio: " + DoubleToString(config.rewardRiskRatio, 2) + "\n";
        info += "Max Open Positions: " + IntegerToString(config.maxOpenPositions) + "\n";
        info += "Max Position Size: " + DoubleToString(config.maxPositionSize, 2) + "%\n";
        info += "Use Equity Stop: " + (config.useEquityStop ? "Yes" : "No") + "\n";
        info += "Min Equity Level: " + DoubleToString(config.minEquityPercent, 2) + "%\n";
        
        return info;
    }
};

#endif
//+------------------------------------------------------------------+
//| End of RiskManager.mqh                                            |
//+------------------------------------------------------------------+
