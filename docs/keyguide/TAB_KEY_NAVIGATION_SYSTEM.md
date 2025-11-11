# Tab Key Navigation System Documentation

## Overview

The Tab key navigation system provides a hierarchical focus management system that allows users to navigate between panels and within panels. The system uses a priority-based handler chain that checks modals first, then panel handlers, and finally global handlers.

## Navigation Flow Hierarchy

### Priority Order (Highest to Lowest)

1. **Modal Dialogs** (Highest Priority)
   - When a modal is open, Tab cycles through modal buttons
   - Wraps around (cycles back to first button after last)

2. **Panel Internal Handlers**
   - Each panel can handle Tab internally for cycling through its own focusable elements
   - Returns `true` if handled (stays in panel)
   - Returns `false` if not handled (propagates to global handler)

3. **Global Panel Navigation** (Lowest Priority)
   - Switches focus between major UI areas: UserList → MenuPanel → ContentArea → UserList
   - Does not wrap around - cycles through panels in sequence

## Main Area Panel Summary

### Modal Dialogs Summary

| Property | Value |
|----------|-------|
| **Priority** | Highest (intercepts all Tab keys when open) |
| **Tab Behavior** | Cycles through modal buttons |
| **Wraps Around** | Yes (wraps to first button after last) |
| **Handler Location** | `events.go:50-56` |
| **Propagation** | Stops at modal level (doesn't reach panels) |

### UserList Panel Summary

| Property | Value |
|----------|-------|
| **Priority** | Global navigation level |
| **Tab Behavior** | Moves to MenuPanel (or ContentArea if MenuPanel nil) |
| **Internal Focus** | No internal Tab handling |
| **Handler Location** | `events.go:214-241` |
| **Next Focus** | MenuPanel → ContentArea → UserList (cycle) |

### MenuPanel Summary

| Property | Value |
|----------|-------|
| **Priority** | Global navigation level |
| **Tab Behavior** | Moves to current ContentArea panel |
| **Internal Focus** | No internal focusable elements |
| **Handler Location** | `panel/menu.go:248-252`, `events.go:242-254` |
| **Returns** | Always `false` (propagates to global handler) |
| **Next Focus** | ContentArea → UserList (cycle) |

### ContentArea Panels Summary

| Panel Type | Internal Tab Handling | Focus Elements | Last Element Behavior | Next Focus |
|------------|----------------------|----------------|---------------------|------------|
| **TradingPanel** | Yes | price → quantity → buy → sell | Returns `false` at sell | UserList |
| **AutonomousTradingPanel** | Yes | start → stop | Returns `false` at stop | UserList |
| **OrderbookPanel** | Yes | markets → precision | Returns `false` at precision | UserList |
| **OverviewPanel** | No | None | Relies on global handler | UserList |
| **OrdersPanel** | No | None | Relies on global handler | UserList |
| **PositionsPanel** | No | None | Relies on global handler | UserList |
| **BucketPanel** | No | None | Relies on global handler | UserList |
| **ChartsPanel** | No | None | Relies on global handler | UserList |
| **AuthPanel** | No | None | Relies on global handler | UserList |
| **EndpointsPanel** | No | None | Relies on global handler | UserList |
| **LogsPanel** | No | None | Relies on global handler | UserList |
| **UserInfoPanel** | No | None | Relies on global handler | UserList |

## Tab Key Flow Table

| Current Focus | Tab Action | Next Focus | Handler Location | Notes |
|--------------|------------|------------|------------------|-------|
| **Modal Open** | Cycle button | Next modal button (wraps) | `events.go:50-56` | Highest priority, wraps around |
| **UserList Panel** | Global handler | MenuPanel (or ContentArea if MenuPanel nil) | `events.go:214-241` | Global navigation |
| **MenuPanel** | Global handler | Current ContentArea panel | `events.go:242-254` | Global navigation |
| **ContentArea Panel** | Global handler | UserList | `events.go:255-268` | Global navigation |

## Panel-Level Tab Handlers

### Panels with Internal Tab Handling

| Panel | Internal Focus Elements | Tab Behavior | Last Element Behavior | File Location |
|-------|------------------------|--------------|----------------------|---------------|
| **TradingPanel** | price → quantity → buy → sell | Cycles internally | Returns `false` at sell (propagates to global) | `panel/trading.go:477-514` |
| **AutonomousTradingPanel** | start → stop | Cycles internally | Returns `false` at stop (propagates to global) | `panel/autonomous_trading.go:380-403` |
| **OrderbookPanel** | markets → precision | Cycles internally | Returns `false` at precision (propagates to global) | `panel/orderbook.go:1264-1281` |
| **MenuPanel** | None | No internal focus | Always returns `false` (propagates to global) | `panel/menu.go:248-252` |

### Panels Without Tab Handlers

These panels return empty key handler maps and rely on global Tab handler:

- OverviewPanel
- OrdersPanel
- PositionsPanel
- BucketPanel
- ChartsPanel
- AuthPanel
- EndpointsPanel
- LogsPanel
- UserInfoPanel

## Detailed Panel Tab Behavior

### TradingPanel Tab Flow

| Current Focus | Tab Press | Action | Returns | Next State |
|--------------|-----------|--------|---------|------------|
| price (0) | Tab | FocusQuantity() | `true` | quantity (1) |
| quantity (1) | Tab | FocusBuy() | `true` | buy (2) |
| buy (2) | Tab | FocusSell() | `true` | sell (3) |
| sell (3) | Tab | Return false | `false` | Global handler moves to next panel |

**File**: `panel/trading.go:477-514`

### AutonomousTradingPanel Tab Flow

| Current Focus | Tab Press | Action | Returns | Next State |
|--------------|-----------|--------|---------|------------|
| start (0) | Tab | FocusStop() | `true` | stop (1) |
| stop (1) | Tab | Return false | `false` | Global handler moves to next panel |

**File**: `panel/autonomous_trading.go:380-403`

### OrderbookPanel Tab Flow

| Current Focus | Tab Press | Action | Returns | Next State |
|--------------|-----------|--------|---------|------------|
| markets | Tab | FocusPrecision() | `true` | precision |
| precision | Tab | Return false | `false` | Global handler moves to next panel |

**File**: `panel/orderbook.go:1264-1281`

### MenuPanel Tab Flow

| Current Focus | Tab Press | Action | Returns | Next State |
|--------------|-----------|--------|---------|------------|
| (any) | Tab | Return false | `false` | Global handler moves to ContentArea |

**File**: `panel/menu.go:248-252`

## Global Tab Navigation Sequence

The global Tab handler (`switchFocusNew()`) cycles through major UI areas:

```
UserList → MenuPanel → ContentArea → UserList
```

### Content Area Panels

The ContentArea panel depends on the current page:

| Page | Content Panel ID | Panel Type |
|------|------------------|------------|
| Overview | `PanelIDOverview` | OverviewPanel |
| Orders | `PanelIDOrders` | OrdersPanel |
| Positions | `PanelIDPositions` | PositionsPanel |
| Buckets | `PanelIDBuckets` | BucketPanel |
| Orderbook | `PanelIDOrderbook` | OrderbookPanel |
| Charts | `PanelIDCharts` | ChartsPanel |
| Auth | `PanelIDAuth` | AuthPanel |
| Trading | `PanelIDTrading` | TradingPanel |
| Autonomous | `PanelIDAutonomous` | AutonomousTradingPanel |
| Endpoints | `PanelIDEndpoints` | EndpointsPanel |
| Logs | `PanelIDLogs` | LogsPanel |

**File**: `events.go:271-277`, `focus_key_manager.go:221-250`

## Tab Key Handler Chain

### Event Processing Flow

```
1. events.go:handleEvent()
   ├─ Check if modal is open
   │  └─ YES: Handle Tab for modal (cycle buttons, wrap around)
   │  └─ NO: Continue to FocusKeyManager
   │
2. FocusKeyManager.HandleEvent()
   ├─ Check focused panel's Tab handler
   │  ├─ Handler exists and returns true: STOP (handled)
   │  └─ Handler returns false or doesn't exist: Continue
   │
3. Global Tab handler (switchFocusNew())
   └─ Switch focus: UserList → MenuPanel → ContentArea → UserList
```

**Files**: 
- `events.go:43-64` (modal check)
- `focus_key_manager.go:154-178` (handler chain)
- `events.go:214-269` (global navigation)

## Modal Tab Behavior

When a modal dialog is open, Tab key behavior changes:

| State | Tab Action | Behavior | Wraps? |
|-------|------------|----------|--------|
| Modal Open | Tab | Cycle through modal buttons | Yes (wraps around) |
| Modal Closed | Tab | Normal panel navigation | No (doesn't wrap) |

**File**: `events.go:50-56`, `launcher.go:1070-1082`

## Implementation Details

### Handler Return Values

- **`true`**: Event was handled, stop propagation
- **`false`**: Event not handled, continue to next handler in chain

### Focus Initialization

When a panel gains focus:
- TradingPanel: Starts at `price` field (focus 0)
- AutonomousTradingPanel: Starts at `start` button (focus 0)
- OrderbookPanel: Starts at `markets` list
- MenuPanel: No internal focus

**Files**: 
- `panel/trading.go:420` (OnGainFocus)
- `panel/autonomous_trading.go:332` (OnGainFocus)
- `panel/orderbook.go` (FocusMarkets on activation)

## Key Files Reference

| File | Purpose | Key Functions |
|------|---------|---------------|
| `events.go` | Event routing and modal handling | `handleEvent()`, `switchFocusNew()` |
| `focus_key_manager.go` | Handler chain management | `HandleEvent()`, `FocusPanel()` |
| `launcher.go` | Global key registration | `RegisterGlobal("<Tab>", ...)` |
| `panel/trading.go` | Trading panel Tab handler | `GetKeyHandlers()` |
| `panel/autonomous_trading.go` | Autonomous trading Tab handler | `GetKeyHandlers()` |
| `panel/orderbook.go` | Orderbook panel Tab handler | `GetKeyHandlers()` |
| `panel/menu.go` | Menu panel Tab handler | `GetKeyHandlers()` |

## Summary

The Tab key navigation system provides:

1. **Modal Priority**: Modals intercept Tab key when open
2. **Panel Internal Cycling**: Panels can cycle through internal focusable elements
3. **Global Navigation**: Tab cycles through major UI areas (UserList → MenuPanel → ContentArea)
4. **No Wrapping**: Global navigation doesn't wrap (except modals)
5. **Propagation**: Panels can return `false` to let global handler take over

This design allows for both fine-grained control within panels and consistent global navigation between major UI areas.

