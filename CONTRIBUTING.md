# Contributing to MQL5 EA CICD

Thank you for your interest in contributing to this Expert Advisor project! This document provides guidelines and instructions for developers who want to contribute to the development and improvement of our MQL5-based trading system.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Branching Strategy](#branching-strategy)
- [Making Changes](#making-changes)
- [Testing Requirements](#testing-requirements)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [MQL5 Code Standards](#mql5-code-standards)
- [Documentation](#documentation)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

We are committed to providing a welcoming and inclusive environment for all contributors. Please treat all collaborators with respect and professionalism. Any form of harassment, discrimination, or disruptive behavior will not be tolerated.

## Getting Started

1. **Fork the Repository**: Create a personal fork of the repository to work on your changes.
2. **Clone Your Fork**: Clone the repository to your local development environment.
3. **Set Up Remotes**: Add the original repository as an upstream remote:
   ```bash
   git remote add upstream https://github.com/Garrick852/mql5-ea-cicd.git
   ```

## Development Setup

### Prerequisites

- MetaTrader 5 (MT5) with MQL5 editor installed
- Git for version control
- A basic understanding of MQL5 programming language
- Familiarity with the Expert Advisor concepts and trading logic

### Environment Setup

1. Clone your forked repository locally
2. Create a new branch for your feature or fix
3. Ensure MT5 is properly configured for testing
4. Set up any necessary test data or sandbox trading accounts

## Branching Strategy

We follow a structured branching strategy:

- **main**: Production-ready code. Direct commits are restricted.
- **develop**: Integration branch for features. Used for staging releases.
- **feature/**: Feature branches for new functionality (`feature/your-feature-name`)
- **bugfix/**: Bug fix branches (`bugfix/your-bug-fix`)
- **hotfix/**: Critical production fixes (`hotfix/your-hotfix`)
- **docs/**: Documentation updates (`docs/your-documentation`)

### Creating a New Branch

```bash
git checkout develop
git pull upstream develop
git checkout -b feature/your-feature-name
```

## Making Changes

### Before You Start

1. Check existing issues and pull requests to avoid duplicate work
2. Open an issue to discuss significant changes before implementing
3. Keep your branch up to date with upstream develop branch

### During Development

1. Make logical, atomic commits
2. Write clear commit messages (see [Commit Guidelines](#commit-guidelines))
3. Keep changes focused on the issue or feature being addressed
4. Test thoroughly on a safe trading account or sandbox environment

### Code Quality

- Write clean, readable, and well-documented code
- Follow the MQL5 code standards (see [MQL5 Code Standards](#mql5-code-standards))
- Avoid unnecessary complexity
- Refactor existing code if it improves maintainability

## Testing Requirements

All contributions must include appropriate testing:

- **Unit Tests**: Test individual functions and components
- **Integration Tests**: Test interactions between modules
- **Backtesting**: Run the EA on historical data using MT5's backtester
- **Paper Trading**: Test on a demo/sandbox account before considering it production-ready
- **Documentation of Tests**: Include test results or screenshots in your PR description

### Running Tests

```bash
# Load the EA into MT5 and execute backtests
# Document results in the pull request
```

## Commit Guidelines

Follow these commit message conventions:

### Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation updates
- **style**: Code style changes (formatting, missing semicolons, etc.)
- **refactor**: Code refactoring without feature changes
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **ci**: CI/CD configuration changes
- **chore**: Build process, dependencies, or tools

### Examples

```
feat(signal-detection): add moving average crossover signal
fix(risk-management): correct position sizing calculation
docs: update README with installation instructions
refactor(indicator-calc): simplify volatility calculation
perf(order-execution): optimize order placement logic
```

### Best Practices

- Use present tense ("add feature" not "added feature")
- Be specific and descriptive
- Limit subject line to 50 characters
- Wrap body at 72 characters
- Reference related issues: "Fixes #123"

## Pull Request Process

### Before Submitting

1. Update your branch with the latest develop branch:
   ```bash
   git fetch upstream
   git rebase upstream/develop
   ```

2. Push your changes to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

3. Create a pull request on GitHub

### PR Description Template

```markdown
## Description
Brief description of the changes made.

## Related Issue
Closes #(issue number)

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Changes Made
- List specific changes
- Include technical details
- Reference any relevant code sections

## Testing Performed
- Describe tests executed
- Include backtesting results
- Document environment used

## Screenshots (if applicable)
Add any relevant charts, equity curves, or MT5 screenshots

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] Backtesting performed
- [ ] No new warnings generated
```

### Review Process

1. At least one maintainer will review your PR
2. Address any requested changes promptly
3. Maintain a professional and constructive tone in discussions
4. Once approved, your PR will be merged

## MQL5 Code Standards

### Naming Conventions

- **Variables**: Use camelCase (e.g., `orderTicket`, `riskPercent`)
- **Functions**: Use camelCase (e.g., `calculateRisk()`, `openPosition()`)
- **Constants**: Use UPPER_SNAKE_CASE (e.g., `MAX_SPREAD`, `MIN_BALANCE`)
- **Classes**: Use PascalCase (e.g., `PositionManager`, `RiskCalculator`)

### Code Style

```mql5
// Good: Clear structure with comments
void OnTick()
{
    // Check for trading signals
    if (BuySignal())
    {
        OpenLongPosition();
    }
    else if (SellSignal())
    {
        OpenShortPosition();
    }
    
    // Manage existing positions
    ManagePositions();
}

// Bad: Unclear and poorly formatted
void OnTick(){if(BuySignal()){OpenLongPosition();}else if(SellSignal()){OpenShortPosition();}}
```

### Best Practices

- Use meaningful variable and function names
- Keep functions focused and modular
- Add comments for complex logic
- Handle errors appropriately
- Use proper data types (int, double, string, etc.)
- Avoid global variables when possible
- Use enums for trading modes or states
- Implement proper logging for debugging

### Documentation

Each function should include:

```mql5
//+------------------------------------------------------------------+
//| Description of what the function does                            |
//| Parameters:                                                       |
//|   - param1: Description of first parameter                       |
//|   - param2: Description of second parameter                      |
//| Returns:                                                          |
//|   - Description of return value                                  |
//+------------------------------------------------------------------+
bool MyFunction(int param1, double param2)
{
    // Implementation
    return true;
}
```

## Documentation

- Keep the README.md updated with latest information
- Document new parameters or settings in the appropriate files
- Add comments explaining trading logic and strategies
- Update CHANGELOG.md with significant changes
- Include examples for new features or changes

## Reporting Issues

When reporting bugs or requesting features:

1. Check existing issues to avoid duplicates
2. Use clear, descriptive titles
3. Provide as much context as possible:
   - MT5 version and build number
   - Operating system
   - Exact steps to reproduce (for bugs)
   - Expected vs. actual behavior
4. Include relevant logs, error messages, or screenshots
5. For security vulnerabilities, contact maintainers privately

## Questions?

If you have questions or need clarification:

- Open a discussion in the repository
- Review existing documentation
- Contact the maintainers for complex issues

---

**Thank you for contributing to improving this Expert Advisor!** Your efforts help make the project better for everyone.
