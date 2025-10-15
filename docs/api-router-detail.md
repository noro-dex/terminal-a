# Morpheum RouterDaemon - External Client-Facing API Reference

## Overview

This document provides a comprehensive reference for all external client-facing APIs exposed by the Morpheum RouterDaemon. The RouterDaemon serves as the primary gateway for external clients, providing REST APIs via gRPC-Gateway and WebSocket streaming capabilities with full EIP712 signature support.

## EIP712 Integration

All mutable operations (orders, transfers, deposits, withdrawals) use the standardized EIP712Tx structure for enhanced security and multi-signature support. See the [EIP712 Router Integration Guide](eip712-router-integration.md) for detailed implementation instructions.

### Key Features

- **EIP712Tx Structure**: Universal format for all mutable operations
- **Dual Nonce System**: Transaction-level and payload-level replay protection
- **Multi-Signature Support**: Single-sign and multisign operations
- **Signature Types**: ECDSA_LEGACY, ECDSA_SEGWIT_LIKE, SCHNORR_AGGREGATE
- **Action Field Mapping**: Automatic derivation from endpoint paths
- **Domain Separation**: Protocol isolation for security

## API Endpoints Table

| Service | Method | Path | Parameters | Request Body | Response Body | Description |
|---------|--------|------|------------|--------------|---------------|-------------|
| **UnifiedWriteService** | | | | | | |
| UnifiedWriteService | POST | `/router/v1/write` | - | `WriteTransactionRequest` | `WriteTransactionResponse` | Unified endpoint for all EIP712 write operations |
| **OrderService** | | | | | | |
| OrderService | GET | `/router/v1/orders/user/{user_address}` | `user_address` (path) | - | `GetUserOrdersResponse` | Get user's orders |
| OrderService | GET | `/router/v1/orders/{order_id}` | `order_id` (path) | - | `GetOrderResponse` | Get specific order |
| OrderService | GET | `/router/v1/orders/history/{user_address}` | `user_address` (path) | - | `GetOrderHistoryResponse` | Get order history |
| OrderService | POST | `/router/v1/orders/batch` | - | `BatchPlaceOrdersRequest` | `BatchPlaceOrdersResponse` | Batch place orders |
| **FinanceService** | | | | | | |
| FinanceService | GET | `/router/v1/finance/balance/{address}/{asset_id}` | `address`, `asset_id` (path) | - | `GetBalanceResponse` | Get single asset balance |
| FinanceService | GET | `/router/v1/finance/balances/{address}` | `address` (path) | - | `GetBalancesResponse` | Get all balances |
| FinanceService | GET | `/router/v1/finance/transactions/{address}` | `address` (path) | - | `GetTransactionHistoryResponse` | Get transaction history |
| FinanceService | GET | `/router/v1/finance/deposit-address` | - | - | `GetDepositAddressResponse` | Generate deposit address |
| FinanceService | GET | `/router/v1/finance/withdrawal-info` | - | - | `GetWithdrawalInfoResponse` | Get withdrawal limits/fees |
| **StreamService** | | | | | | |
| StreamService | GET | `/router/v1/stream/orderbook/{market_id}` | `market_id` (path) | - | `stream OrderBookUpdate` | Stream orderbook updates |
| StreamService | GET | `/router/v1/stream/trades/{market_id}` | `market_id` (path) | - | `stream Trade` | Stream trade executions |
| StreamService | GET | `/router/v1/stream/positions/{user_address}` | `user_address` (path) | - | `stream PositionUpdate` | Stream position updates |
| StreamService | GET | `/router/v1/stream/balances/{user_address}` | `user_address` (path) | - | `stream BalanceUpdate` | Stream balance updates |
| StreamService | GET | `/router/v1/stream/liquidations` | - | - | `stream LiquidationUpdate` | Stream liquidation events |
| StreamService | GET | `/router/v1/stream/ticker/{market_id}` | `market_id` (path) | - | `stream TickerUpdate` | Stream ticker data |
| StreamService | POST | `/router/v1/stream/markets` | - | `StreamMultipleMarketsRequest` | `stream MarketDataUpdate` | Stream multiple markets |
| StreamService | GET | `/router/v1/stream/user/{user_address}` | `user_address` (path) | - | `stream UserEvent` | Stream user events |
| StreamService | GET | `/router/v1/query/candles/{market_id}` | `market_id` (path) | - | `GetCandlesResponse` | Get OHLC candles |
| StreamService | GET | `/router/v1/query/funding-rates/{market_id}` | `market_id` (path) | - | `GetFundingRatesResponse` | Get funding rates |
| StreamService | GET | `/router/v1/query/liquidations` | - | - | `GetLiquidationHistoryResponse` | Get liquidation history |
| StreamService | GET | `/router/v1/query/token/{token_id}` | `token_id` (path) | - | `GetTokenInfoResponse` | Get token information |
| StreamService | GET | `/router/v1/query/trades/history` | - | - | `GetTradeHistoryResponse` | Get trade history |
| StreamService | GET | `/router/v1/query/positions/history` | - | - | `GetPositionHistoryResponse` | Get position history |
| StreamService | GET | `/router/v1/stream/migrations` | - | - | `stream MigrationUpdate` | Stream migration events |
| **UserService** | | | | | | |
| UserService | POST | `/router/v1/users/signup` | - | `SignUpRequest` | `SignUpResponse` | User registration |
| UserService | POST | `/router/v1/users/login` | - | `LoginRequest` | `LoginResponse` | User login |
| UserService | POST | `/router/v1/users/bind-account` | - | `BindAccountRequest` | `BindAccountResponse` | Bind blockchain address |
| UserService | GET | `/router/v1/users/{user_id}` | `user_id` (path) | - | `GetProfileResponse` | Get user profile |
| UserService | PUT | `/router/v1/users/{user_id}/settings` | `user_id` (path) | `UpdateSettingsRequest` | `Empty` | Update user settings |
| UserService | GET | `/router/v1/users/by-address/{address}` | `address` (path) | - | `GetUserByAddressResponse` | Get user by address |
| **AuthService** | | | | | | |
| AuthService | POST | `/router/v1/auth/verify-eip712` | - | `VerifyEIP712Request` | `VerifyEIP712Response` | Verify EIP712 signature |
| AuthService | POST | `/router/v1/auth/session/create` | - | `CreateSessionRequest` | `CreateSessionResponse` | Create session |
| AuthService | POST | `/router/v1/auth/token/refresh` | - | `RefreshTokenRequest` | `RefreshTokenResponse` | Refresh token |
| AuthService | POST | `/router/v1/auth/logout` | - | `LogoutRequest` | `Empty` | Logout |
| AuthService | POST | `/router/v1/auth/verify-multisig` | - | `VerifyMultisigRequest` | `VerifyMultisigResponse` | Verify multisig |
| AuthService | POST | `/router/v1/auth/session/validate` | - | `ValidateSessionRequest` | `ValidateSessionResponse` | Validate session |
| AuthService | POST | `/router/v1/auth/api-key/create` | - | `CreateAPIKeyRequest` | `CreateAPIKeyResponse` | Create API key |
| AuthService | POST | `/router/v1/auth/api-key/revoke` | - | `RevokeAPIKeyRequest` | `Empty` | Revoke API key |
| AuthService | POST | `/router/v1/auth/verify-multisig-enhanced` | - | `VerifyMultisigEnhancedRequest` | `VerifyMultisigResponse` | Enhanced multisig verification |
| **SocialService** | | | | | | | |
| SocialService | POST | `/router/v1/social/bind` | - | `BindSocialAccountRequest` | `BindSocialAccountResponse` | Bind social account |
| SocialService | POST | `/router/v1/social/unbind` | - | `UnbindSocialAccountRequest` | `Empty` | Unbind social account |
| SocialService | GET | `/router/v1/social/list/{user_id}` | `user_id` (path) | - | `ListSocialAccountsResponse` | List social accounts |
| SocialService | GET | `/router/v1/social/{user_id}/{platform}` | `user_id`, `platform` (path) | - | `SocialAccountBinding` | Get social account |
| SocialService | PUT | `/router/v1/social/{user_id}/{platform}` | `user_id`, `platform` (path) | `UpdateSocialAccountRequest` | `Empty` | Update social account |
| SocialService | POST | `/router/v1/social/verify` | - | `VerifySocialAccountRequest` | `VerifySocialAccountResponse` | Verify social account |
| SocialService | POST | `/router/v1/social/oauth/initiate` | - | `InitiateOAuthRequest` | `InitiateOAuthResponse` | Initiate OAuth |
| SocialService | POST | `/router/v1/social/oauth/complete` | - | `CompleteOAuthRequest` | `CompleteOAuthResponse` | Complete OAuth |
| **ReferralService** | | | | | | |
| ReferralService | POST | `/router/v1/referral/generate` | - | `GenerateInviteCodeRequest` | `GenerateInviteCodeResponse` | Generate invite code |
| ReferralService | GET | `/router/v1/referral/check/{invite_code}` | `invite_code` (path) | - | `CheckInviteCodeResponse` | Check invite code |
| ReferralService | POST | `/router/v1/referral/claim` | - | `ClaimInviteCodeRequest` | `ClaimInviteCodeResponse` | Claim invite code |
| ReferralService | GET | `/router/v1/referral/stats/{user_id}` | `user_id` (path) | - | `GetReferralStatsResponse` | Get referral stats |
| ReferralService | GET | `/router/v1/referral/my-referrals/{user_id}` | `user_id` (path) | - | `ListMyReferralsResponse` | List my referrals |
| ReferralService | GET | `/router/v1/referral/my-codes/{user_id}` | `user_id` (path) | - | `ListMyInviteCodesResponse` | List my invite codes |
| ReferralService | POST | `/router/v1/referral/revoke` | - | `RevokeInviteCodeRequest` | `Empty` | Revoke invite code |
| **HyperlaneService** | | | | | | |
| HyperlaneService | POST | `/router/v1/hyperlane/submit` | - | `SubmitCrossChainMessageRequest` | `SubmitCrossChainMessageResponse` | Submit cross-chain message |
| HyperlaneService | GET | `/router/v1/hyperlane/status/{message_id}` | `message_id` (path) | - | `GetMessageStatusResponse` | Get message status |
| HyperlaneService | POST | `/router/v1/hyperlane/verify-ism` | - | `VerifyISMRequest` | `VerifyISMResponse` | Verify ISM |
| HyperlaneService | POST | `/router/v1/hyperlane/process` | - | `ProcessIncomingMessageRequest` | `ProcessIncomingMessageResponse` | Process incoming message |
| HyperlaneService | POST | `/router/v1/hyperlane/bridge` | - | `BridgeTokenRequest` | `BridgeTokenResponse` | Bridge tokens |
| HyperlaneService | GET | `/router/v1/hyperlane/bridge/{bridge_id}` | `bridge_id` (path) | - | `GetBridgeStatusResponse` | Get bridge status |
| HyperlaneService | GET | `/router/v1/hyperlane/chains` | - | - | `ListSupportedChainsResponse` | List supported chains |
| HyperlaneService | GET | `/router/v1/hyperlane/stream` | - | - | `stream StreamMessagesResponse` | Stream cross-chain messages |
| **AdminService** | | | | | | |
| AdminService | GET | `/router/v1/admin/status` | - | - | `StatusResponse` | Get router status |
| AdminService | GET | `/router/v1/admin/clients` | - | - | `ListClientsResponse` | List connected clients |
| AdminService | POST | `/router/v1/admin/clients/disconnect` | - | `DisconnectClientRequest` | `Empty` | Disconnect client |
| AdminService | POST | `/router/v1/admin/markets/toggle` | - | `ToggleMarketRequest` | `Empty` | Toggle market |
| AdminService | POST | `/router/v1/admin/debug` | - | `DebugRequest` | `DebugResponse` | Debug operations |
| AdminService | GET | `/router/v1/admin/metrics` | - | - | `GetMetricsResponse` | Get system metrics |
| AdminService | GET | `/router/v1/admin/connection-stats` | - | - | `ConnectionStatsResponse` | Get connection statistics |
|| **MarketService** | | | | | | |
|| MarketService | GET | `/api/v1/markets` | `filter`, `active_only` (query) | - | `MarketsResponse` | Get all markets with comprehensive details |
## EIP712Tx Structure
All mutable operations use the following standardized structure:

```json
{
  "tx_id": "0x...",           // Unique transaction ID (32-byte hex)
  "nonce": 1001,              // Transaction-level nonce for ordering
  "sig_type": "ECDSA_LEGACY", // Signature algorithm type
  "payload": {                // Flattened payload with all fields
    "action": "dex::submit_order",
    "owner": "morph1abc123...",
    "nonce": "1234567890",
    "deadline": "1640998800",
    // ... additional business fields
  },
  "signatures": [             // Array of signatures
    {
      "signer": "morph1abc123...",
      "signature": "MEYCIQD...wE="
    }
  ],
  "threshold": 1,             // Required signature count
  "timestamp": 1730916305000,  // Transaction timestamp
  "domain": {                 // EIP712 domain separator
    "name": "Morpheum",
    "version": "1",
    "chain_id": "1",
    "verifying_contract": "0x..."
  },
  "types": {                  // EIP712 type definitions
    "eip712_domain": [...],
    "primary_type": [...],
    "primary_type_name": "OrderSubmissionMessage"
  }
}
```

## Action Field Mapping

| Router Endpoint | Action Field | Standards Operation Type |
|----------------|--------------|-------------------------|
| `/orders/place` | `"dex::submit_order"` | `OpSubmitOrder` |
| `/orders/cancel` | `"dex::cancel_order"` | `OpCancelOrder` |
| `/orders/{order_id}/modify` | `"dex::modify_order"` | `OpModifyOrder` |
| `/finance/transfer` | `"token::transfer"` | `OpTransferToken` |
| `/finance/deposit` | `"dex::deposit"` | `OpDeposit` |
| `/finance/withdraw` | `"dex::withdraw"` | `OpWithdraw` |

## Signature Types

| Type | Description | Use Case |
|------|-------------|----------|
| `ECDSA_LEGACY` | Standard ECDSA with DER encoding | Single-sign operations |
| `ECDSA_SEGWIT_LIKE` | Compact ECDSA with witness separation | Optimized single-sign |
| `SCHNORR_AGGREGATE` | Schnorr signatures with aggregation | Multi-signature operations |

## Example Request/Response Content

### OrderService Examples

#### Place Order
**Request:**
```json
POST /router/v1/orders/place
{
  "tx_id": "0x1a2b3c4d5e6f7890abcdef1234567890abcdef1234567890abcdef1234567890",
  "nonce": 1001,
  "sig_type": "ECDSA_LEGACY",
  "payload": {
    "action": "dex::submit_order",
    "marketId": "BTC-USD",
    "side": "buy",
    "orderType": "limit",
    "price": "45000",
    "quantity": "1.5",
    "owner": "morph1abc123...",
    "nonce": "1234567890",
    "deadline": "1640998800"
  },
  "signatures": [
    {
      "signer": "morph1abc123...",
      "signature": "MEYCIQD...wE="
    }
  ],
  "threshold": 1,
  "timestamp": 1730916305000,
  "domain": {
    "name": "Morpheum",
    "version": "1",
    "chain_id": "1",
    "verifying_contract": "0x..."
  },
  "types": {
    "eip712_domain": [
      {"name": "name", "type": "string"},
      {"name": "version", "type": "string"},
      {"name": "chainId", "type": "uint256"},
      {"name": "verifyingContract", "type": "address"}
    ],
    "primary_type": [
      {"name": "action", "type": "string"},
      {"name": "owner", "type": "address"},
      {"name": "marketId", "type": "string"},
      {"name": "side", "type": "string"},
      {"name": "orderType", "type": "string"},
      {"name": "price", "type": "uint256"},
      {"name": "quantity", "type": "uint256"},
      {"name": "nonce", "type": "uint256"},
      {"name": "deadline", "type": "uint256"}
    ],
    "primary_type_name": "OrderSubmissionMessage"
  }
}
```

**Response:**
```json
{
  "order_id": "ord_123456789",
  "status": "placed",
  "timestamp": 1640995200,
  "message": "Order placed successfully"
}
```

#### Get User Orders
**Request:**
```
GET /router/v1/orders/user/morph1abc123...
```

**Response:**
```json
{
  "orders": [
    {
      "order_id": "ord_123456789",
      "market_id": "BTC-USD",
      "side": "buy",
      "order_type": "limit",
      "quantity": "1.5",
      "price": "45000.00",
      "status": "open",
      "filled_quantity": "0.0",
      "remaining_quantity": "1.5",
      "created_at": 1640995200
    }
  ],
  "total_count": 1
}
```

### FinanceService Examples

#### Transfer Tokens
**Request:**
```json
POST /router/v1/finance/transfer
{
  "tx_id": "0x2b3c4d5e6f7890abcdef1234567890abcdef1234567890abcdef1234567890",
  "nonce": 1002,
  "sig_type": "ECDSA_LEGACY",
  "payload": {
    "action": "token::transfer",
    "from": "morph1abc123...",
    "to": "morph1def456...",
    "amount": "1000000000000000000",
    "tokenAddress": "0x9876543210fedcba9876543210fedcba98765432",
    "nonce": "1234567890",
    "deadline": "1640998800"
  },
  "signatures": [
    {
      "signer": "morph1abc123...",
      "signature": "MEYCIQD...wE="
    }
  ],
  "threshold": 1,
  "timestamp": 1730916305000,
  "domain": {
    "name": "Morpheum",
    "version": "1",
    "chain_id": "1",
    "verifying_contract": "0x..."
  },
  "types": {
    "eip712_domain": [
      {"name": "name", "type": "string"},
      {"name": "version", "type": "string"},
      {"name": "chainId", "type": "uint256"},
      {"name": "verifyingContract", "type": "address"}
    ],
    "primary_type": [
      {"name": "action", "type": "string"},
      {"name": "from", "type": "address"},
      {"name": "to", "type": "address"},
      {"name": "amount", "type": "uint256"},
      {"name": "tokenAddress", "type": "address"},
      {"name": "nonce", "type": "uint256"},
      {"name": "deadline", "type": "uint256"}
    ],
    "primary_type_name": "TransferMessage"
  }
}
```

**Response:**
```json
{
  "tx_hash": "0xabcdef123456...",
  "success": true,
  "message": "Transfer completed successfully",
  "timestamp": 1640995200
}
```

#### Get Balance
**Request:**
```
GET /router/v1/finance/balance/morph1abc123.../USDC
```

**Response:**
```json
{
  "address": "morph1abc123...",
  "asset_id": "USDC",
  "balance": "5000.00",
  "available_balance": "4500.00",
  "locked_balance": "500.00",
  "timestamp": 1640995200
}
```

### MarketService Examples

#### Get Markets
**Request:**
```
GET /api/v1/markets
```

**Response:**
```json
{
  "markets": [
    {
      "market_id": "market-1",
      "ticker": "BTC-USD-PERP",
      "symbol": "BTC-USD",
      "market_type": "linear_perp",
      "base_asset": "BTC",
      "quote_asset": "USD",
      "orderbook_type": "clob",
      "status": "active",
      "shard_id": "default",
      "base_asset_precision": 8,
      "quote_asset_precision": 6,
      "active": true,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T01:00:00Z",
      "perp_config": {
        "funding_method": "continuous",
        "funding_interval": 28800,
        "max_funding_rate": "100",
        "base_funding_rate": "10",
        "max_leverage": "100"
      }
    }
  ]
}
```

#### Get Active Markets Only
**Request:**
```
GET /api/v1/markets?active_only=true
```

**Response:**
```json
{
  "markets": [
    {
      "market_id": "market-1",
      "ticker": "BTC-USD-PERP",
      "symbol": "BTC-USD",
      "market_type": "linear_perp",
      "base_asset": "BTC",
      "quote_asset": "USD",
      "status": "active",
      "active": true
    }
  ]
}
```

#### Filter Markets by Symbol
**Request:**
```
GET /api/v1/markets?filter=BTC
```

**Response:**
```json
{
  "markets": [
    {
      "market_id": "market-1",
      "ticker": "BTC-USD-PERP",
      "symbol": "BTC-USD",
      "market_type": "linear_perp",
      "base_asset": "BTC",
      "quote_asset": "USD",
      "status": "active"
    }
  ]
}
```

### StreamService Examples

#### Stream Orderbook
**Request:**
```
GET /router/v1/stream/orderbook/BTC-USD?depth=10
```

**Response (Stream):**
```json
{
  "market_id": "BTC-USD",
  "bids": [
    {"price": "44950.00", "quantity": "2.5"},
    {"price": "44900.00", "quantity": "1.8"}
  ],
  "asks": [
    {"price": "45050.00", "quantity": "3.2"},
    {"price": "45100.00", "quantity": "2.1"}
  ],
  "timestamp": 1640995200
}
```

### UserService Examples

#### User Signup
**Request:**
```json
POST /router/v1/users/signup
{
  "email": "user@example.com",
  "username": "trader123",
  "password_hash": "$2a$10$...",
  "referral_code": "FRIEND123"
}
```

**Response:**
```json
{
  "user_id": "user_123456789",
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "expires_at": 1640995200
}
```

### AuthService Examples

#### Verify EIP712 Signature
**Request:**
```json
POST /router/v1/auth/verify-eip712
{
  "message": "Sign this message to authenticate",
  "signature": "0x1234...",
  "address": "morph1abc123...",
  "domain": {
    "name": "Morpheum",
    "version": "1",
    "chainId": "1"
  },
  "types": {
    "EIP712Domain": [
      {"name": "name", "type": "string"},
      {"name": "version", "type": "string"},
      {"name": "chainId", "type": "uint256"}
    ]
  }
}
```

**Response:**
```json
{
  "valid": true,
  "error_message": "",
  "recovered_address": "morph1abc123..."
}
```

### SocialService Examples

#### Bind Social Account
**Request:**
```json
POST /router/v1/social/bind
{
  "user_id": "user_123456789",
  "platform": "PLATFORM_X",
  "platform_user_id": "twitter_user_123",
  "username": "crypto_trader",
  "display_name": "Crypto Trader",
  "access_token": "twitter_access_token_123",
  "refresh_token": "twitter_refresh_token_123",
  "token_expires_at": 1640995200,
  "scopes": ["read", "write"]
}
```

**Response:**
```json
{
  "binding_id": "bind_123456789",
  "success": true,
  "message": "Account bound successfully",
  "binding": {
    "binding_id": "bind_123456789",
    "user_id": "user_123456789",
    "platform": "PLATFORM_X",
    "account_type": "ACCOUNT_TYPE_SOCIAL",
    "platform_user_id": "twitter_user_123",
    "username": "crypto_trader",
    "display_name": "Crypto Trader",
    "verified": true,
    "active": true,
    "bound_at": 1640995200,
    "permissions": ["read", "write"]
  }
}
```

### HyperlaneService Examples

#### Submit Cross-Chain Message
**Request:**
```json
POST /router/v1/hyperlane/submit
{
  "destination_domain": 2,
  "recipient": "0x1234567890abcdef...",
  "message_body": "0xabcdef123456...",
  "metadata": "0x...",
  "user_address": "morph1abc123...",
  "signature": "0x1234..."
}
```

**Response:**
```json
{
  "message_id": "msg_123456789",
  "nonce": 12345,
  "status": "submitted",
  "estimated_cost": 0.001,
  "submitted_at": "2023-12-31T23:59:59Z"
}
```

## Multi-Signature Examples

### Single-Sign Operation (threshold: 1)
```json
{
  "tx_id": "0x1a2b3c4d5e6f7890abcdef1234567890abcdef1234567890abcdef1234567890",
  "nonce": 1001,
  "sig_type": "ECDSA_LEGACY",
  "payload": {
    "action": "dex::submit_order",
    "marketId": "BTC-USD",
    "side": "buy",
    "orderType": "limit",
    "price": "45000",
    "quantity": "1.5",
    "owner": "morph1abc123...",
    "nonce": "1234567890",
    "deadline": "1640998800"
  },
  "signatures": [
    {
      "signer": "morph1abc123...",
      "signature": "MEYCIQD...wE="
    }
  ],
  "threshold": 1
}
```

### Multi-Sign Operation (threshold: 2)
```json
{
  "tx_id": "0x2b3c4d5e6f7890abcdef1234567890abcdef1234567890abcdef1234567890",
  "nonce": 1002,
  "sig_type": "SCHNORR_AGGREGATE",
  "payload": {
    "action": "dex::withdraw",
    "userAddress": "morph1abc123...",
    "assetId": "USDC",
    "amount": "500.00",
    "destinationChain": "ethereum",
    "destinationAddress": "0x1234567890123456789012345678901234567890",
    "fastWithdrawal": "true",
    "nonce": "1234567890",
    "deadline": "1640998800"
  },
  "signatures": [
    {
      "signer": "morph1abc123...",
      "signature": "MEYCIQD...wE="
    },
    {
      "signer": "morph1def456...",
      "signature": "MEYCIQD...wE="
    }
  ],
  "threshold": 2,
  "witness": [
    {
      "signer": "morph1abc123...",
      "witness_data": "MEYCIQD...wE="
    },
    {
      "signer": "morph1def456...",
      "witness_data": "MEYCIQD...wE="
    }
  ],
  "agg_pub_key": "0x..."
}
```

## Authentication

All API endpoints require authentication using one of the following methods:

1. **API Key**: Include `X-API-Key` header
2. **JWT Token**: Include `Authorization: Bearer <token>` header
3. **EIP712 Signature**: For mutable operations, include EIP712Tx structure in request body

### EIP712 Authentication

For mutable operations, the EIP712Tx structure provides comprehensive authentication:

- **Signature Verification**: EIP712-compliant signature verification
- **Replay Protection**: Dual nonce system prevents replay attacks
- **Multi-Signature Support**: Threshold-based signature requirements
- **Domain Separation**: Protocol isolation for security
- **Temporal Validation**: Deadline fields prevent expired message execution

## Rate Limiting

- **Spiral Admission**: PoW-based rate limiting for surge protection
- **Per-User Limits**: 1000 requests/minute for authenticated users
- **Per-IP Limits**: 100 requests/minute for unauthenticated requests
- **WebSocket Connections**: 10 concurrent connections per user

## Error Handling

All endpoints return standard HTTP status codes with JSON error responses:

```json
{
  "error": "INVALID_REQUEST",
  "message": "Invalid request parameters",
  "code": 400,
  "details": {
    "field": "amount",
    "reason": "must be greater than 0"
  }
}
```

### EIP712-Specific Errors

For EIP712 operations, additional error codes are available:

```json
{
  "error": "INVALID_SIGNATURE",
  "message": "Signature verification failed",
  "code": 400,
  "details": {
    "field": "signatures[0].signature",
    "expected": "ECDSA_LEGACY",
    "received": "INVALID_FORMAT"
  }
}
```

| Error Code | Description | Resolution |
|------------|-------------|------------|
| `INVALID_SIGNATURE` | Signature verification failed | Check signature format and signer |
| `INVALID_NONCE` | Nonce already used or out of sequence | Use next available nonce |
| `EXPIRED_DEADLINE` | Message deadline has passed | Generate new request with future deadline |
| `INSUFFICIENT_SIGNATURES` | Not enough signatures for threshold | Provide required number of signatures |
| `INVALID_ACTION` | Action field doesn't match endpoint | Use correct action for endpoint |
| `INVALID_DOMAIN` | EIP712 domain verification failed | Use correct domain parameters |
| `INVALID_TYPES` | EIP712 type definitions invalid | Use correct type definitions |

## WebSocket Streaming

WebSocket endpoints use the following URL pattern:
- **Base URL**: `wss://router.morpheum.network/ws/v1/`
- **Authentication**: Include API key in query parameters
- **Message Format**: JSON messages with type field

Example WebSocket connection:
```
wss://router.morpheum.network/ws/v1/stream/orderbook/BTC-USD?api_key=your_api_key
```

## Client Integration

### JavaScript Example

```javascript
// Example client code for placing an order
async function placeOrder(orderParams) {
  const txId = generateTxId();  // 32-byte hex
  const nonce = await getTxNonce();  // Incremental counter
  
  const payload = {
    action: "dex::submit_order",
    marketId: orderParams.marketId,
    side: orderParams.side,
    orderType: orderParams.orderType,
    price: orderParams.price,
    quantity: orderParams.quantity,
    owner: await getWalletAddress(),
    nonce: generatePayloadNonce(),
    deadline: Date.now() + 3600000  // 1 hour
  };
  
  const domain = {
    name: "Morpheum",
    version: "1",
    chain_id: "1",
    verifying_contract: MORPHEUM_CONTRACT
  };
  
  const types = getOrderSubmissionTypes();
  const signature = await signEIP712(domain, types, payload);
  
  return await fetch('/router/v1/orders/place', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      tx_id: txId,
      nonce: nonce,
      sig_type: "ECDSA_LEGACY",
      payload: payload,
      signatures: [{
        signer: await getWalletAddress(),
        signature: signature
      }],
      threshold: 1,
      timestamp: Date.now(),
      domain: domain,
      types: types
    })
  });
}
```

### Python Example

```python
import json
import time
from eth_account import Account
from eth_account.messages import encode_structured_data

class MorpheumClient:
    def __init__(self, private_key, base_url="https://api.morpheum.com"):
        self.private_key = private_key
        self.base_url = base_url
        self.account = Account.from_key(private_key)
    
    def place_order(self, market_id, side, order_type, price, quantity):
        tx_id = self.generate_tx_id()
        nonce = self.get_tx_nonce()
        
        payload = {
            "action": "dex::submit_order",
            "marketId": market_id,
            "side": side,
            "orderType": order_type,
            "price": str(price),
            "quantity": str(quantity),
            "owner": self.account.address,
            "nonce": str(int(time.time() * 1000)),
            "deadline": str(int(time.time()) + 3600)
        }
        
        domain = {
            "name": "Morpheum",
            "version": "1",
            "chain_id": "1",
            "verifying_contract": "0x..."
        }
        
        types = self.get_order_submission_types()
        signature = self.sign_eip712(domain, types, payload)
        
        request_data = {
            "tx_id": tx_id,
            "nonce": nonce,
            "sig_type": "ECDSA_LEGACY",
            "payload": payload,
            "signatures": [{
                "signer": self.account.address,
                "signature": signature
            }],
            "threshold": 1,
            "timestamp": int(time.time() * 1000),
            "domain": domain,
            "types": types
        }
        
        return self.make_request("POST", "/router/v1/orders/place", request_data)
```

## Best Practices

### Security
- **Nonce Management**: Use incremental nonces for transaction ordering
- **Deadline Validation**: Set appropriate deadlines for message expiration
- **Signature Verification**: Always verify signatures before processing
- **Domain Separation**: Use correct domain parameters for protocol isolation

### Performance
- **Caching**: Cache domain and type definitions to reduce request size
- **Batch Operations**: Use batch endpoints for multiple operations
- **Connection Pooling**: Reuse HTTP connections for better performance
- **Error Handling**: Implement proper retry logic for transient failures

### Development
- **Testing**: Use testnet endpoints for development
- **Monitoring**: Implement proper logging and monitoring
- **Documentation**: Keep client libraries updated with API changes
- **Versioning**: Use API versioning for backward compatibility

## Migration Guide

### From Legacy API

If migrating from the legacy API format:

1. **Update Request Structure**: Replace individual fields with EIP712Tx structure
2. **Add Payload Field**: Move business fields into the payload map
3. **Update Signature Handling**: Use EIP712 signing instead of simple message signing
4. **Add Domain and Types**: Include EIP712 domain separator and type definitions
5. **Handle Dual Nonces**: Use both transaction-level and payload-level nonces

### Backward Compatibility

The Router API maintains backward compatibility through versioning:

- **v1**: Legacy format (deprecated)
- **v2**: EIP712Tx format (current)

## Resources

- **EIP712 Integration Guide**: [EIP712 Router Integration](eip712-router-integration.md)
- **Standards Documentation**: [Standards](standards.md)
- **Multi-Signature Design**: [Multi-Signature Design](multisigndesign.md)
- **API Router Overview**: [API Router](api-router.md)
- **Integration Test Results**: [EIP712 Integration Test Results](eip712-integration-test-results.md)
