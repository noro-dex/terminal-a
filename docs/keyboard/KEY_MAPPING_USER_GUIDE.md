# Key Mapping User Guide

This guide explains all available keyboard shortcuts and how to customize them to suit your preferences.

## Page Navigation Keys

These keys switch between different panels in the application. **You can customize these keys** (see [Customizing Keys](#customizing-keys) below).

| Default Key | Panel | What It Shows |
|-------------|-------|---------------|
| `1` | **Overview** | User summary and statistics |
| `2` | **Orders** | Active and historical orders |
| `3` | **Positions** | Open trading positions |
| `4` | **Buckets** | User bucket balances |
| `5` | **Orderbook** | Market depth and order book |
| `6` | **Charts** | Trading volume and price charts |
| `7` | **Auth** | Authentication status and JWT tokens |
| `` ` `` (backtick) | **Logs** | Application logs and events |
| `x` | **Trading** | Panel for placing orders |
| `z` | **Autonomous** | Automated trading panel |
| `e` | **Endpoints** | API endpoint information |

**Tip:** These keys work from anywhere in the application - you don't need to be on a specific panel to use them.

## Application Control Keys

These keys control the application itself. **These keys cannot be customized.**

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+C` | **Quit** | Exit the application (shows confirmation during normal use) |
| `Escape` | **Close / Quit** | Close an open dialog, or quit if no dialog is open |
| `Tab` | **Switch Focus** | Move focus between UI areas (User List → Menu → Content → User List) |
| `Enter` | **Activate** | Confirm selection or activate the current button |

## User Management Keys

| Key | Action | Description |
|-----|--------|-------------|
| `a` | **Add User** | Open dialog to add a new user |
| `n` | **Add User** | Alternative key for adding a new user |

## Modal Dialog Keys

These keys only work when a dialog or modal is open:

| Key | Action | Description |
|-----|--------|-------------|
| `y` or `Y` | **Yes** | Confirm the action |
| `n` or `N` | **No** | Cancel the action |
| `o` or `O` | **OK** | Activate OK button (if available) |
| `c` or `C` | **Cancel** | Activate Cancel button (if available) |
| `s` or `S` | **Save** | Activate Save button (if available) |
| `d` or `D` | **Delete** | Activate Delete button (if available) |

## Panel-Specific Keys

Some panels have their own keyboard shortcuts that only work when that panel has focus:

| Panel | Keys | Action |
|-------|------|--------|
| **User List** | `j` / `k` or `↑` / `↓` | Navigate up/down in the user list |
| **User List** | `Enter` | Select the highlighted user |
| **Orderbook** | `↑` / `↓` or `k` / `j` | Navigate through order book entries |
| **Orderbook** | `Enter` | Select an order book entry |
| **Orderbook** | `Tab` | Switch between order book sections |

**Note:** Press `Tab` to move focus to a panel before using its panel-specific keys.

## Customizing Keys

You can customize the page navigation keys (1-7, `, x, z, e) to use different keys that you prefer.

### How to Customize

1. Open your configuration file (`config.yaml`)
2. Add a `key_mappings` section
3. Specify which key you want for each panel

### Example: Using Default Keys

If you want to use the default keys, you don't need to add anything to your config file. The defaults will be used automatically.

### Example: Custom Key Mappings

Here's how to customize keys to your preference:

```yaml
key_mappings:
  overview: "o"      # Press 'o' to open Overview (instead of '1')
  orders: "2"        # Keep '2' for Orders
  positions: "p"     # Press 'p' to open Positions (instead of '3')
  buckets: "b"       # Press 'b' to open Buckets (instead of '4')
  orderbook: "5"     # Keep '5' for Orderbook
  charts: "c"        # Press 'c' to open Charts (instead of '6')
  auth: "a"          # Press 'a' to open Auth (instead of '7')
  logs: "l"          # Press 'l' to open Logs (instead of '`')
  trading: "t"       # Press 't' to open Trading (instead of 'x')
  autonomous: "z"    # Keep 'z' for Autonomous
  endpoints: "e"     # Keep 'e' for Endpoints
```

### Complete Configuration Example

```yaml
key_mappings:
  overview: "1"
  orders: "2"
  positions: "3"
  buckets: "4"
  orderbook: "5"
  charts: "6"
  auth: "7"
  logs: "`"
  trading: "x"
  autonomous: "z"
  endpoints: "e"
```

### Important Notes

- **Only page navigation keys can be customized** - Application control keys (Ctrl+C, Tab, Enter, Escape) and modal keys cannot be changed
- **Use single characters** - Each key should be a single character (e.g., `"a"`, `"1"`, `"x"`)
- **Special keys** - For the backtick key, use `` "`" `` in your config file
- **Restart required** - After changing key mappings, restart the application for changes to take effect
- **Menu updates** - The menu panel will automatically show your custom keys

## Quick Reference

### Navigation
- **Switch panels:** `1-7`, `` ` ``, `x`, `z`, `e` (or your custom keys)
- **Switch focus:** `Tab` (cycles through UI areas)
- **Select/Activate:** `Enter`

### User Management
- **Add user:** `a` or `n`

### Application
- **Quit:** `Ctrl+C` or `Escape`
- **Close dialog:** `Escape`

### In Dialogs
- **Confirm:** `y` or `Enter`
- **Cancel:** `n` or `Escape`

## Tips

1. **Focus matters** - Some keys only work when a specific panel has focus. Use `Tab` to move focus between areas.

2. **Visual feedback** - When a panel has focus, its border will change color (green by default) to show it's active.

3. **Menu highlights** - The menu panel shows which key to press for each panel, and it updates automatically if you customize your keys.

4. **Startup behavior** - During startup, `Ctrl+C` or `Escape` will quit immediately without confirmation. After startup, a confirmation dialog will appear.

5. **Customization flexibility** - You can customize only the keys you want to change. Keys you don't specify will use their defaults.

