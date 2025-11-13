# TUI Quick Test Guide

## Quick Start

```bash
cd /Users/hesdx/Documents/b95/swapbiz/terminal
./bin/terminal -tui -users 1 -interval 500ms
```

## 5-Minute Smoke Test

### 1. Startup (30 seconds)
- ✅ Application starts
- ✅ TUI appears
- ✅ No errors/panics
- ✅ Layout looks correct

### 2. Panel Navigation (2 minutes)
Press these keys and verify each panel displays:
- `1` - Overview
- `2` - Orders  
- `3` - Positions
- `4` - Buckets
- `5` - Orderbook
- `6` - Charts
- `7` - Auth
- `` ` `` - Logs (backtick)
- `x` - Trading
- `z` - Autonomous
- `e` - Endpoints

### 3. Focus Testing (1 minute)
- Press `Tab` - Should cycle focus
- In Trading panel (`x`), press `Tab` multiple times - Should cycle through inputs

### 4. Resize Test (30 seconds)
- Resize terminal window
- Verify layout adjusts
- Check for glitches

### 5. Quit (10 seconds)
- Press `q` - Should show confirmation
- Press `y` to quit

## Common Issues

**Application won't start:**
- Check terminal size (minimum 80x24)
- Verify `TERM=xterm-256color`
- Check for config file errors

**Layout broken:**
- Resize terminal window
- Check terminal supports Grid layout

**Focus not working:**
- Verify Tab key works
- Check panel implements `CycleFocus()`

## Report Issues

Document any issues you find:
1. What you were doing
2. What happened
3. What you expected
4. Screenshot (if possible)

---

*Use this guide for quick validation. For comprehensive testing, see `TUI_RUNTIME_TESTING_CHECKLIST.md`*

