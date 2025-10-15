# Presentation Flow for Trading System Demo

## Overview
This document outlines the step-by-step flow for demonstrating the trading system using the Terminal Application in TUI mode, showcasing user authentication, account generation, fund injection, order placement, order matching, order cancellation, and real-time data visualization (order placements, price movements, orderbook updates, and matched orders). The demo is designed to be interactive, leveraging the Terminal Application’s TUI mode for real-time monitoring and console mode for setup tasks, with automation via AI to streamline development.

## Prerequisites
- **System Setup**: Terminal Application installed, Moracle and Morphcore redeployed, router access granted.
- **Configuration**: `scripts/config.yaml` updated with `api_base_url: "http://localhost:9855"`, valid mnemonic file (`scripts/test_mnmeonic.txt`), and required binaries (`morm_signer`).
- **Test Data**: Predefined ticker ID (e.g., `BTC/USD`) and test accounts ready.
- **Mode**: TUI mode for the demo, with console mode for initial setup and testing.
- **APIs**: Write APIs for sign-up, sign-in, account generation, fund injection, order placement, and cancellation; read APIs for orderbook and last orders.

## Presentation Flow

### Step 1: Sign In
- **Objective**: Demonstrate user authentication using existing credentials.
- **Command**:
  ```bash
  ./bin/terminal -tui -test-auth
  ```
- **Expected Output** (TUI Logs Panel):
  ```
  [1] 12:34:56 Starting TUI mode with authentication test...
  [1] 12:34:56 Loaded mnemonic from scripts/test_mnmeonic.txt
  [2] 12:34:57 Authentication completed for user: 0x1234...
  [2] 12:34:57 Token generated successfully
  ```
- **Talking Points**:
  - Highlight the security of EIP-712 authentication (as per `TESTING_GUIDE.md`).
  - Explain that the system uses mnemonics for secure user authentication.
  - Note that no validators are required for sign-in (per Morgan.X B).
- **API Required**:
  - **POST /auth/signin**: Authenticates a user using mnemonic-based credentials.
    - Input: `{ "mnemonic": "abandon ... about" }`
    - Output: `{ "token": "jwt_token", "address": "0x1234..." }`

### Step 2: Sign Up
- **Objective**: Show creation of a new user account.
- **Command**:
  ```bash
  ./bin/terminal -tui -test-auth
  ```
- **Expected Output** (TUI Logs Panel):
  ```
  [1] 12:34:58 Running authentication tests...
  [1] 12:34:58 Creating 1 user...
  [2] 12:34:59 User created successfully: 0x5678...
  [2] 12:34:59 Authentication completed for new user
  ```
- **Talking Points**:
  - Emphasize ease of user onboarding without validators (per Morgan.X B).
  - Highlight that the system generates a new address and stores it securely.
  - Show the User Info Panel updating with the new user count.
- **API Required**:
  - **POST /auth/signup**: Creates a new user account and generates a wallet address.
    - Input: `{ "mnemonic": "abandon ... abandon" }`
    - Output: `{ "address": "0x5678...", "status": "created" }`

### Step 3: Generate Accounts
- **Objective**: Create multiple test accounts for simulation.
- **Command**:
  ```bash
  bash scripts/run_console.sh simulation
  ```
- **Expected Output** (Console Output):
  ```
  Running simulation tests...
  [1] 12:34:59 Running Simulation Tests
  [1] 12:34:59 Creating 5 users
  [2] 12:35:00 Successfully created 5 users
  ✅ Tests completed: 1 passed, 0 failed, 1 total
  ```
- **Talking Points**:
  - Explain that simulation tests create multiple users for load testing (per `TESTING_GUIDE.md`).
  - Highlight the system’s ability to handle concurrent user creation.
  - Transition to TUI mode to show updated User Info Panel with 5 users.
- **API Required**:
  - **POST /accounts/generate**: Generates multiple wallet addresses for testing.
    - Input: `{ "count": 5 }`
    - Output: `{ "addresses": ["0x1111...", "0x2222...", ...] }`

### Step 4: Inject Funds
- **Objective**: Add “fake money” to test accounts for trading.
- **Command**:
  ```bash
  bash scripts/run_console.sh simulation
  ```
- **Expected Output** (Console Output):
  ```
  [1] 12:35:01 Injecting funds to 5 accounts...
  [2] 12:35:02 Funds injected: 1000 USDT to 0x1111...
  [2] 12:35:02 Funds injected: 1000 USDT to 0x2222...
  ✅ Tests completed: 1 passed, 0 failed, 1 total
  ```
- **Talking Points**:
  - Discuss how the system supports liquidity injection for testing (per Brady/Morgan.X B).
  - Emphasize that funds are added to multiple accounts for realistic trading scenarios.
  - Show TUI User Info Panel reflecting updated balances.
- **API Required**:
  - **POST /accounts/fund**: Injects test funds into specified accounts.
    - Input: `{ "addresses": ["0x1111...", "0x2222..."], "amount": 1000, "currency": "USDT" }`
    - Output: `{ "status": "funded", "balances": { "0x1111...": 1000, "0x2222...": 1000 } }`

### Step 5: Determine Ticker ID
- **Objective**: Select a trading pair (e.g., `BTC/USD`) for the demo.
- **Command**:
  ```bash
  ./bin/terminal -tui -users 5
  ```
- **Expected Output** (TUI Trading Panel):
  ```
  [1] 12:35:03 Selected ticker: BTC/USD
  [2] 12:35:03 Market data loaded: Price: $45,123.45, Volume: 1.23 BTC
  ```
- **Talking Points**:
  - Explain that the ticker ID (`BTC/USD`) is predefined for the demo.
  - Highlight the Trading Panel’s real-time market data display.
  - Note that the system supports multiple tickers, but one is chosen for simplicity.
- **API Required**:
  - **GET /market/ticker**: Retrieves available tickers and selects one.
    - Input: None
    - Output: `{ "tickers": ["BTC/USD", "ETH/USD"], "selected": "BTC/USD" }`

### Step 6: Submit Orders (Long/Short)
- **Objective**: Place long and short orders on the `BTC/USD` ticker.
- **Command**:
  ```bash
  bash scripts/run_console.sh trading
  ```
- **Expected Output** (Console Output, then switch to TUI):
  ```
  Running trading tests...
  [1] 12:35:04 Running Trading Tests
  [1] 12:35:04 Placing 2 orders (1 long, 1 short)
  [2] 12:35:05 Order placed: Long, 0.1 BTC @ $45,000, User: 0x1111...
  [2] 12:35:05 Order placed: Short, 0.1 BTC @ $45,200, User: 0x2222...
  ✅ Tests completed: 1 passed, 0 failed, 1 total
  ```
- **TUI Output** (Trading Panel):
  ```
  Orders: 2 | Positions: 0 | PnL: $0.00
  Market: BTC/USD | Price: $45,123.45 | Volume: 1.23 BTC
  ```
- **Talking Points**:
  - Showcase order placement for both long and short positions.
  - Highlight the Trading Panel’s real-time order updates.
  - Explain that orders are validated using Moracle and validators (per Morgan.X B).
- **API Required**:
  - **POST /orders/place**: Places a new order (long or short).
    - Input: `{ "address": "0x1111...", "ticker": "BTC/USD", "side": "long", "amount": 0.1, "price": 45000 }`
    - Output: `{ "order_id": "123", "status": "placed" }`

### Step 7: Wait for Order Matching
- **Objective**: Demonstrate order matching in the orderbook.
- **Command**:
  ```bash
  ./bin/terminal -tui -users 5
  ```
- **Expected Output** (TUI Trading Panel):
  ```
  [1] 12:35:06 Waiting for order matching...
  [2] 12:35:07 Orders matched: Long (0x1111...) with Short (0x2222...)
  Orders: 2 | Positions: 2 | PnL: +$10.00
  ```
- **Talking Points**:
  - Explain the self-matching mechanism (per Brady) and how orders are matched in the orderbook.
  - Highlight real-time updates in the Trading Panel showing matched orders and PnL.
  - Discuss how the system ensures fair and accurate matching.
- **API Required**:
  - **GET /orderbook/matches**: Retrieves matched orders.
    - Input: `{ "ticker": "BTC/USD" }`
    - Output: `{ "matches": [{ "order_id1": "123", "order_id2": "124", "price": 45100, "amount": 0.1 }] }`

### Step 8: Cancel Orders
- **Objective**: Cancel an unmatched or partially matched order.
- **Command**:
  ```bash
  bash scripts/run_console.sh trading
  ```
- **Expected Output** (Console Output, then switch to TUI):
  ```
  [1] 12:35:08 Canceling order for user: 0x1111...
  [2] 12:35:09 Order canceled: Order ID 123
  ✅ Tests completed: 1 passed, 0 failed, 1 total
  ```
- **TUI Output** (Trading Panel):
  ```
  Orders: 1 | Positions: 2 | PnL: +$10.00
  ```
- **Talking Points**:
  - Demonstrate the ability to cancel orders, updating the orderbook in real-time.
  - Show the Trading Panel reflecting the reduced order count.
  - Emphasize system reliability in handling cancellations.
- **API Required**:
  - **POST /orders/cancel**: Cancels an existing order.
    - Input: `{ "order_id": "123" }`
    - Output: `{ "status": "canceled" }`

### Step 9: Real-Time Data Display
- **Objective**: Show investors real-time updates for order placements, price movements, orderbook updates, and matched orders.
- **Command**:
  ```bash
  ./bin/terminal -tui -users 5 -interval 500ms
  ```
- **Expected Output** (TUI Panels):
  - **Logs Panel**:
    ```
    [1] 12:35:10 Order placed: Long, 0.2 BTC @ $45,100
    [2] 12:35:11 Orderbook updated
    [2] 12:35:12 Match recorded: 0.1 BTC @ $45,100
    ```
  - **User Info Panel**:
    ```
    Users: 5 | Connected: 5 | Authenticated: 5
    Active Trades: 3 | Total Volume: $2,345.67
    ```
  - **Trading Panel**:
    ```
    Orders: 3 | Positions: 2 | PnL: +$15.00
    Market: BTC/USD | Price: $45,150.00 | Volume: 1.45 BTC
    ```
- **Talking Points**:
  - Highlight the TUI’s real-time panels (Logs, User Info, Trading) for investor visibility.
  - Show how price movements and orderbook updates are reflected instantly.
  - Emphasize the system’s ability to handle live trading data transparently.
- **API Required**:
  - **GET /orderbook**: Retrieves current orderbook state.
    - Input: `{ "ticker": "BTC/USD" }`
    - Output: `{ "bids": [{ "price": 45100, "amount": 0.5 }], "asks": [{ "price": 45200, "amount": 0.3 }] }`
  - **GET /orders/last**: Retrieves recent orders and trades.
    - Input: `{ "ticker": "BTC/USD", "limit": 10 }`
    - Output: `{ "orders": [{ "order_id": "125", "side": "long", "price": 45100, "amount": 0.2, "status": "placed" }] }`

## API Summary
Below is a consolidated list of the APIs required for the demo, as identified from the presentation flow:
1. **POST /auth/signin**: Authenticate user (no validator).
2. **POST /auth/signup**: Create new user (no validator).
3. **POST /accounts/generate**: Generate multiple test accounts.
4. **POST /accounts/fund**: Inject funds into accounts.
5. **GET /market/ticker**: Retrieve and select ticker ID.
6. **POST /orders/place**: Place long/short orders (uses Moracle/validators).
7. **GET /orderbook/matches**: Retrieve matched orders.
8. **POST /orders/cancel**: Cancel orders (uses Moracle/validators).
9. **GET /orderbook**: Retrieve orderbook state.
10. **GET /orders/last**: Retrieve recent orders/trades.

## Setup and Testing
- **Pre-Demo Setup**:
  ```bash
  # Build binaries
  make build-local
  # Ensure configuration
  cp scripts/config.yaml.example scripts/config.yaml
  # Create mnemonic file with test mnemonics
  echo "abandon abandon ... about" > scripts/test_mnmeonic.txt
  # Run initial simulation tests
  bash scripts/run_console.sh simulation
  ```
- **Testing APIs**:
  ```bash
  # Test authentication APIs
  bash scripts/run_console.sh auth
  # Test trading APIs
  bash scripts/run_console.sh trading
  # Verify TUI display
  ./bin/terminal -tui -users 5 -verbose
  ```
- **Troubleshooting** (per `README.md`):
  - If “Binary Not Found” error, run `make build-signers`.
  - If API errors, verify `api_base_url` in `scripts/config.yaml`.
  - Check logs: `tail -f logs/optimized_$(date +%Y%m%d)_*.log`.

## Timeline with AI Assistance
Assuming router access by October 29, 2025, and leveraging AI for code generation, documentation, and testing (per previous response):
- **API Development**: 1-1.5 weeks (AI generates code for 10 APIs, team reviews).
- **Orderbook Setup**: 5-7 days (AI scripts liquidity injection, team integrates).
- **Presentation Flow**: 2-3 days (AI drafts flow, team refines).
- **Terminal/TUI Setup**: 4-5 days (AI generates polling/WebSocket code, team tests).
- **Testing**: 3-4 days (AI generates tests, team validates).
- **Total**: 5-7 weeks (December 3-17, 2025).

## Talking Points for Demo
- **System Reliability**: Highlight successful test outputs and real-time TUI updates.
- **Scalability**: Show multi-user support and orderbook liquidity handling.
- **Ease of Use**: Emphasize TUI’s interactive interface and clear visualizations.
- **Security**: Note EIP-712 authentication and validator integration (except for sign-in/signup).
- **Automation**: Mention AI-driven development to minimize manual effort and technical debt.

## Next Steps
- **API Development**: Use AI to generate API code and tests, with team review.
- **Orderbook Testing**: Run simulation tests to validate liquidity injection.
- **TUI Customization**: Adjust TUI settings (`scripts/config.yaml`) for optimal demo display.
- **Practice Run**: Conduct a dry run using the above commands to ensure smooth execution.