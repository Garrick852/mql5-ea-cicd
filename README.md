# MQL5 EA CI/CD

A comprehensive CI/CD framework for developing, testing, and deploying MetaTrader 5 Expert Advisors (EAs) with automated quality assurance and continuous integration pipelines.

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [CI/CD Pipeline](#cicd-pipeline)
- [Modules Documentation](#modules-documentation)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Support](#support)

## Project Overview

MQL5 EA CI/CD is a professional-grade development framework designed to streamline the creation and deployment of MetaTrader 5 Expert Advisors. It combines modern software development practices with specialized tools for automated trading strategy development, enabling developers to maintain high code quality while accelerating time-to-market.

The project implements continuous integration and continuous deployment (CI/CD) practices specifically tailored for MQL5 development, including automated testing, code quality checks, backtesting, and deployment workflows.

### Key Objectives

- **Automate Quality Assurance**: Implement automated testing and code quality validation
- **Accelerate Development**: Reduce manual testing and deployment overhead
- **Ensure Reliability**: Catch issues early through continuous integration
- **Maintain Code Standards**: Enforce consistent coding practices across the project
- **Facilitate Collaboration**: Enable team-based development with clear workflows

## Features

### Core Features

- **Automated Testing Framework**: Comprehensive unit and integration testing infrastructure
- **Code Quality Analysis**: Static code analysis and linting for MQL5 code
- **Backtesting Integration**: Automated backtesting pipeline with performance metrics
- **Continuous Integration**: Automated builds and tests on code commits
- **Continuous Deployment**: Streamlined deployment to MetaTrader 5 environments
- **Version Control**: Git-based version management with semantic versioning
- **Documentation Generation**: Automatic API documentation and change logs
- **Performance Monitoring**: Track EA performance metrics across deployments

### Advanced Features

- **Multi-Environment Support**: Development, staging, and production environments
- **Configurable Pipelines**: Customizable CI/CD workflows for different use cases
- **Artifact Management**: Organized build artifact storage and versioning
- **Rollback Capabilities**: Quick rollback to previous versions if needed
- **Webhook Integration**: Event-driven automation with custom triggers
- **Reporting Dashboard**: Comprehensive reports on build status, tests, and metrics

## Repository Structure

```
mql5-ea-cicd/
├── .github/
│   ├── workflows/              # GitHub Actions CI/CD workflows
│   │   ├── build.yml          # Build and compile workflow
│   │   ├── test.yml           # Testing workflow
│   │   ├── backtest.yml       # Backtesting workflow
│   │   └── deploy.yml         # Deployment workflow
│   └── ISSUE_TEMPLATE/         # Issue templates
├── src/
│   ├── ea/                     # Expert Advisor source code
│   │   ├── main.mq5           # Main EA file
│   │   ├── constants.mq5      # Constants and configuration
│   │   └── utils/             # Utility functions
│   ���── indicators/             # Custom indicators
│   └── libraries/              # Reusable MQL5 libraries
├── tests/
│   ├── unit/                   # Unit tests
│   ├── integration/            # Integration tests
│   └── fixtures/               # Test data and fixtures
├── config/
│   ├── dev.config            # Development configuration
│   ├── staging.config         # Staging configuration
│   ├── prod.config            # Production configuration
│   └── backtest.config        # Backtesting configuration
├── scripts/
│   ├── build.sh               # Build script
│   ├── test.sh                # Test script
│   ├── deploy.sh              # Deployment script
│   └── backtest.sh            # Backtesting script
├── docs/
│   ├── api.md                 # API documentation
│   ├── architecture.md        # System architecture
│   ├── trading-logic.md       # Trading strategy documentation
│   └── deployment-guide.md    # Deployment procedures
├── backtest/
│   ├── data/                  # Historical market data
│   ├── results/               # Backtesting results
│   └── reports/               # Performance reports
├── build/                      # Build artifacts (generated)
├── dist/                       # Distribution packages (generated)
├── .gitignore                 # Git ignore rules
├── docker-compose.yml         # Docker composition (if applicable)
├── package.json               # Node dependencies (if applicable)
└── README.md                  # This file
```

## Prerequisites

### System Requirements

- **Operating System**: Windows, macOS, or Linux
- **RAM**: Minimum 4GB (8GB recommended for backtesting)
- **Disk Space**: 2GB minimum for development environment

### Software Requirements

- **Git**: v2.25 or higher
- **Node.js**: v14 or higher (for CI/CD scripting)
- **Python**: v3.8 or higher (for analysis scripts)
- **MetaTrader 5**: v5.0 or higher
- **MQL5 Compiler**: Included with MetaTrader 5

### Development Tools

- **Code Editor**: Visual Studio Code (recommended) or any MQL5-compatible editor
- **Version Control**: GitHub account with access to the repository
- **Testing Framework**: MQL5 Unit Testing Framework (included)
- **Git Client**: Command-line git or GitHub Desktop

### Optional Tools

- **Docker**: For containerized development and testing
- **Jenkins**: For on-premises CI/CD pipelines
- **SonarQube**: For advanced code quality analysis

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/Garrick852/mql5-ea-cicd.git
cd mql5-ea-cicd
```

### Step 2: Install Dependencies

```bash
# Install Node.js dependencies
npm install

# Install Python dependencies
pip install -r requirements.txt
```

### Step 3: Configure Development Environment

```bash
# Create a copy of the development config
cp config/dev.config.example config/dev.config

# Edit configuration for your environment
nano config/dev.config
```

### Step 4: Setup MetaTrader 5 Integration

1. Open MetaTrader 5
2. Navigate to `File > Open Data Folder`
3. Copy the Expert Advisors from `src/ea/` to `MQL5/Experts/`
4. Compile the EA in MetaTrader 5: `File > Compile`

### Step 5: Verify Installation

```bash
# Run tests to verify setup
npm test

# Run build
npm run build
```

## Configuration

### Environment Configuration Files

Configuration files are located in the `config/` directory and follow the pattern:

```
[setting_name]=value
```

### Development Configuration (config/dev.config)

```properties
# MetaTrader Connection
MT5_TERMINAL_PATH=C:\Program Files\MetaTrader 5\terminal64.exe
MT5_ACCOUNT_NUMBER=your_account_number
MT5_PASSWORD=your_password
MT5_SERVER=your_broker_server

# Logging
LOG_LEVEL=DEBUG
LOG_OUTPUT=./logs

# Testing
TEST_MODE=true
TEST_TIMEOUT=30000
MAX_CONCURRENT_TESTS=4

# Backtesting
BACKTEST_FROM=2023-01-01
BACKTEST_TO=2024-12-31
BACKTEST_TIMEFRAME=H1
BACKTEST_SYMBOL=EURUSD
```

### Staging Configuration (config/staging.config)

```properties
MT5_TERMINAL_PATH=/var/mt5/terminal
MT5_ACCOUNT_NUMBER=staging_account
LOG_LEVEL=INFO
TEST_MODE=true
```

### Production Configuration (config/prod.config)

```properties
MT5_TERMINAL_PATH=/var/mt5/terminal
MT5_ACCOUNT_NUMBER=production_account
LOG_LEVEL=WARNING
TEST_MODE=false
ENABLE_ALERTS=true
```

### Backtesting Configuration (config/backtest.config)

```properties
BACKTEST_MODE=true
SPREAD=2
COMMISSION=0.0001
SLIPPAGE=0.5
RISK_PERCENTAGE=2
INITIAL_DEPOSIT=10000
```

## Usage

### Building the Project

```bash
# Build the EA
npm run build

# Build with specific configuration
npm run build:dev
npm run build:staging
npm run build:prod
```

### Running Tests

```bash
# Run all tests
npm test

# Run specific test suite
npm test -- tests/unit

# Run tests with coverage
npm run test:coverage

# Run integration tests
npm run test:integration
```

### Running Backtests

```bash
# Run backtest with default configuration
npm run backtest

# Run backtest with custom date range
npm run backtest -- --from=2023-01-01 --to=2024-12-31

# Run backtest with optimization
npm run backtest:optimize
```

### Deploying to MetaTrader 5

```bash
# Deploy to development environment
npm run deploy:dev

# Deploy to staging environment
npm run deploy:staging

# Deploy to production environment (requires confirmation)
npm run deploy:prod
```

### Monitoring and Logging

```bash
# View recent logs
npm run logs

# View logs with filtering
npm run logs -- --level=ERROR

# Monitor EA in real-time
npm run monitor
```

## CI/CD Pipeline

### Pipeline Stages

The CI/CD pipeline consists of the following stages:

```
1. Trigger (on push to main/develop)
   ↓
2. Build
   - Compile MQL5 code
   - Generate artifacts
   ↓
3. Test
   - Run unit tests
   - Run integration tests
   - Check code quality
   ↓
4. Backtest
   - Execute backtests
   - Generate performance reports
   ↓
5. Review
   - Analyze metrics
   - Approve/reject deployment
   ↓
6. Deploy
   - Deploy to target environment
   - Verify deployment
   - Send notifications
```

### GitHub Actions Workflows

#### build.yml
Compiles MQL5 source code and generates build artifacts.
- Triggered on: push to main/develop
- Artifacts: Compiled .ex5 files

#### test.yml
Runs automated test suites including unit and integration tests.
- Triggered on: build completion
- Tests: Unit tests, integration tests, code quality checks
- Reports: Coverage reports, test results

#### backtest.yml
Executes backtesting with historical market data.
- Triggered on: test completion
- Duration: 30-60 minutes (configurable)
- Output: Performance metrics, equity curves, trade reports

#### deploy.yml
Handles deployment to target environments.
- Triggered on: backtest approval
- Environments: Dev, Staging, Production
- Validation: Pre-deployment checks, post-deployment verification

### Monitoring and Alerts

- **Slack Integration**: Notifications on pipeline events
- **Email Alerts**: Test failures and deployment status
- **GitHub Checks**: Inline code review comments
- **Custom Webhooks**: Integration with external systems

## Modules Documentation

### Expert Advisor Module (src/ea/)

The Expert Advisor module contains the core trading logic.

**Main Files:**
- `main.mq5`: Entry point and main trading logic
- `constants.mq5`: Configuration constants and parameters
- `utils/`: Helper functions and utilities

**Key Functions:**

```mql5
// Initialize EA
int OnInit();

// Main EA logic
void OnTick();

// Handle trade signals
void ProcessSignal(TradeSignal signal);

// Risk management
double CalculateRiskAmount();
```

### Indicators Module (src/indicators/)

Custom indicators used by the EA for signal generation.

**Available Indicators:**
- `MovingAverageIndicator`: Multi-timeframe moving average
- `RSIIndicator`: Relative Strength Index
- `MACDIndicator`: MACD indicator with customizable parameters

**Usage Example:**

```mql5
MovingAverageIndicator ma(50, PRICE_CLOSE);
double value = ma.GetValue(0);
```

### Libraries Module (src/libraries/)

Reusable MQL5 libraries for common functionality.

**Available Libraries:**
- `trade.mqh`: Trade management utilities
- `signal.mqh`: Signal generation framework
- `risk.mqh`: Risk management calculations
- `utils.mqh`: General utility functions

## Best Practices

### Code Quality Standards

1. **Naming Conventions**
   - Functions: camelCase (e.g., `calculateProfit`)
   - Constants: UPPER_SNAKE_CASE (e.g., `MAX_SPREAD`)
   - Variables: camelCase (e.g., `orderTicket`)

2. **Documentation**
   - Add comments for complex logic
   - Document all public functions with parameter descriptions
   - Include usage examples for libraries

3. **Error Handling**
   - Always check function return values
   - Use appropriate error codes
   - Log errors with context information

### Development Workflow

1. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes and Commit**
   ```bash
   git add .
   git commit -m "feat: description of changes"
   ```

3. **Push and Create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```

4. **Run Tests Locally**
   ```bash
   npm test
   npm run backtest
   ```

5. **Review and Merge**
   - Address code review comments
   - Ensure all CI/CD checks pass
   - Merge when approved

### Testing Best Practices

- Write unit tests for new functions
- Maintain >80% code coverage
- Test edge cases and error conditions
- Run backtests before production deployment
- Document test cases and expected outcomes

### Performance Optimization

- Monitor EA latency and execution time
- Optimize indicator calculations
- Reduce unnecessary database queries
- Cache frequently accessed data
- Profile code for bottlenecks

## Troubleshooting

### Build Issues

**Problem: Compilation errors in MQL5 code**
- Solution: Check syntax and ensure all includes are correct
- Verify: Run `npm run build` with verbose output
- Debug: Check `build/logs/compiler.log` for detailed errors

**Problem: Missing dependencies**
- Solution: Run `npm install` to reinstall dependencies
- Verify: Check `package.json` for required versions
- Debug: Clear node_modules and reinstall: `rm -rf node_modules && npm install`

### Test Failures

**Problem: Unit tests failing locally but passing in CI**
- Solution: Check for environment-specific configurations
- Verify: Ensure config files are correctly set up
- Debug: Run tests with verbose output: `npm test -- --verbose`

**Problem: Backtesting produces inconsistent results**
- Solution: Verify market data integrity
- Check: Data source and timeframe settings
- Debug: Review `backtest/logs/` for detailed information

### Deployment Issues

**Problem: Deployment to MetaTrader 5 fails**
- Solution: Verify MetaTrader 5 is running and accessible
- Check: Account credentials and permissions
- Debug: Review deployment logs in `.github/workflows/`

**Problem: EA not executing trades after deployment**
- Solution: Verify account has sufficient balance
- Check: Trading hours and market conditions
- Debug: Enable detailed logging and review EA logs

### Performance Issues

**Problem: EA running slowly on certain timeframes**
- Solution: Optimize indicator calculations
- Check: CPU and memory usage
- Debug: Profile EA with MetaTrader 5 profiler

**Problem: High latency on trade execution**
- Solution: Reduce EA logic complexity
- Check: Network connectivity
- Debug: Monitor latency metrics in logs

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| `ERR_INVALID_ACCOUNT` | Wrong account number | Verify account in config file |
| `ERR_NO_RESULT` | Trade request failed | Check account balance and trading hours |
| `ERR_TRADE_DISABLED` | Trading disabled | Enable trading in account settings |
| `ERR_INVALID_SYMBOL` | Symbol not available | Verify symbol is available on broker |

## Support

### Getting Help

1. **Documentation**: Review this README and docs/ folder
2. **FAQ**: Check Discussions section on GitHub
3. **Issues**: Create an issue for bugs or feature requests
4. **Community**: Join the trading development community

### Reporting Issues

When reporting issues, please include:

1. **Environment Information**
   - Operating System and version
   - MetaTrader 5 version
   - Node.js/Python versions

2. **Steps to Reproduce**
   - Exact commands run
   - Configuration settings
   - Expected vs. actual behavior

3. **Logs and Output**
   - Error messages and stack traces
   - Relevant log files
   - Build/test output

4. **Screenshots/Videos**
   - Visual representation of the issue (if applicable)

### Feature Requests

To request new features:

1. Open an issue with the label "enhancement"
2. Clearly describe the feature and use case
3. Provide examples of how it would be used
4. Discuss implementation approach

### Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Submit a pull request
5. Ensure all CI/CD checks pass

### Resources

- **MetaTrader 5 Documentation**: https://www.mql5.com/en/docs
- **MQL5 Reference**: https://www.mql5.com/en/reference
- **Trading Strategy Development**: https://www.mql5.com/en/articles
- **Community Forum**: https://www.mql5.com/en/forum

### Contact

- **Issues**: Use GitHub Issues for bug reports and feature requests
- **Discussions**: Use GitHub Discussions for general questions
- **Email**: For security issues, email directly to the repository owner

### License

This project is licensed under the MIT License. See LICENSE file for details.

### Changelog

All changes are documented in CHANGELOG.md. See that file for version history and major updates.

---

**Last Updated**: 2025-12-07  
**Maintained By**: Garrick852  
**Repository**: https://github.com/Garrick852/mql5-ea-cicd
