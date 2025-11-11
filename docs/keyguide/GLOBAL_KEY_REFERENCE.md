# Global Key Press Reference

This document lists all global key presses registered in the TUI application and their corresponding actions. Global keys are always active regardless of which panel has focus.

## Page Navigation Keys

These keys switch between different panels/pages in the application. **These keys can be remapped via configuration file** (see [Configuration](#configuration) section below).

| Key (Default) | Panel | Description | Constant |
|---------------|-------|-------------|----------|
| `1` | **Overview** | Overview panel showing user summary and statistics | `UIPageOverview` |
| `2` | **Orders** | Orders panel showing active and historical orders | `UIPageOrders` |
| `3` | **Positions** | Positions panel showing open trading positions | `UIPagePositions` |
| `4` | **Buckets** | Buckets panel showing user bucket balances | `UIPageBuckets` |
| `5` | **Orderbook** | Orderbook panel showing market depth and order book | `UIPageOrderbook` |
| `6` | **Charts** | Charts panel showing trading volume and price charts | `UIPageCharts` |
| `7` | **Auth** | Auth panel showing authentication status and JWT tokens | `UIPageAuth` |
| `` ` `` | **Logs** | Logs panel showing application logs and events | `UIPageLogs` |
| `x` | **Trading** | Trading panel for placing orders | `UIPageTrading` |
| `z` | **Autonomous** | Autonomous trading panel for automated trading | `UIPageAutonomous` |
| `e` | **Endpoints** | Endpoints panel showing API endpoint information | `UIPageEndpoints` |

## Application Control Keys

These keys control application behavior:

| Key | Action | Description |
|-----|--------|-------------|
| `<C-c>` | **Quit** | Quit application (shows confirmation modal, except during startup) |
| `<Escape>` | **Close Modal / Quit** | Close open modal, or if no modal open, quit application |
| `<Tab>` | **Switch Focus** | Switch focus between UI areas (UserList → MenuPanel → ContentArea → UserList) |
| `<Enter>` | **Activate** | Activate selected button in modal, or let current panel handle Enter |
| `<Resize>` | **Handle Resize** | Handle terminal resize events (automatic) |

## User Management Keys

| Key | Action | Description |
|-----|--------|-------------|
| `a` | **Add User** | Open add new user dialog/modal |
| `n` | **Add User** | Alternative key for adding new user (handled in events.go) |

## Modal Interaction Keys

These keys are only active when a modal dialog is open:

| Key | Action | Description |
|-----|--------|-------------|
| `y`, `Y` | **Yes** | Confirm action (Yes button) |
| `n`, `N` | **No** | Cancel action (No button) |
| `o`, `O` | **OK** | Activate OK button (if present) |
| `c`, `C` | **Cancel** | Activate Cancel button (if present) |
| `s`, `S` | **Save** | Activate Save button (if present) |
| `d`, `D` | **Delete** | Activate Delete button (if present) |

## Implementation Details

### Registration Location

All global keys are registered in `pkg/tui/launcher.go` in the `setupFocusKeyManager()` function:

```go
func (app *App) setupFocusKeyManager() {
    // Page navigation keys
    app.focusKeyManager.RegisterGlobal("1", ...)
    app.focusKeyManager.RegisterGlobal("2", ...)
    // ... etc
    
    // App-level keys
    app.focusKeyManager.RegisterGlobal("<C-c>", ...)
    app.focusKeyManager.RegisterGlobal("<Tab>", ...)
    // ... etc
}
```

### Key Handler Priority

1. **Modal Dialogs** (Highest Priority)
   - When a modal is open, modal-specific keys take precedence
   - Tab cycles through modal buttons
   - Enter activates selected modal button

2. **Panel-Specific Keys** (Medium Priority)
   - Each panel can register its own key handlers
   - Only active when that panel has focus

3. **Global Keys** (Lowest Priority)
   - Always active regardless of focus
   - Page navigation keys (1-7, `, x, z, e) work from any panel
   - Application control keys work from any panel

### Status Bar Display

The status bar shows available keys:
```
Press Ctrl+C to quit, 'h' for help, 'n' to add user, 'r' to refresh | Use menu (1-7, `, x, z, e) for panels
```

## Notes

- **Page Navigation Keys**: These keys work from any panel and immediately switch to the target panel
- **Modal Keys**: Modal-specific keys (`y`, `n`, `o`, `c`, `s`, `d`) only work when a modal is open
- **Focus Switching**: Tab key cycles focus between major UI areas (UserList → MenuPanel → ContentArea → UserList)
- **Quit Behavior**: 
  - During startup: Ctrl+C or Escape quits immediately
  - Normal mode: Shows confirmation modal before quitting
- **Logs Panel**: Changed from `8` to `` ` `` (backtick) key

## Configuration

Page navigation keys can be remapped via the configuration file. If no key mappings are specified, the default mappings shown above will be used.

### Example Configuration

Add a `key_mappings` section to your `config.yaml`:

```yaml
# Key Mappings Configuration (optional - uses defaults if not specified)
key_mappings:
  overview: "1"      # Default: "1"
  orders: "2"        # Default: "2"
  positions: "3"     # Default: "3"
  buckets: "4"       # Default: "4"
  orderbook: "5"     # Default: "5"
  charts: "6"        # Default: "6"
  auth: "7"         # Default: "7"
  logs: "`"          # Default: "`" (backtick)
  trading: "x"       # Default: "x"
  autonomous: "z"    # Default: "z"
  endpoints: "e"     # Default: "e"
```

### Custom Key Mapping Example

To remap keys to different values:

```yaml
key_mappings:
  overview: "o"      # Use 'o' instead of '1' for Overview
  logs: "l"          # Use 'l' instead of '`' for Logs
  trading: "t"       # Use 't' instead of 'x' for Trading
```

**Note:** Only the page navigation keys (1-7, `, x, z, e) can be remapped. Application control keys (Ctrl+C, Tab, Enter, Escape) and modal keys cannot be remapped.

## Related Documentation

- [Tab Key Navigation System](./TAB_KEY_NAVIGATION_SYSTEM.md)
- [Focus Key Manager Implementation](../implementation_summaries/FOCUS_KEY_MANAGER_IMPLEMENTATION.md)
- [TUI API Reference](./TUI_API_REFERENCE.md)

