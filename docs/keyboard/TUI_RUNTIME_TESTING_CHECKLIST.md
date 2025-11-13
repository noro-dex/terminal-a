# TUI Runtime Testing Checklist

## Overview

This checklist is for testing the TUI application after the tview to termui migration. Use this guide to systematically verify all functionality works correctly.

## Pre-Testing Setup

### Prerequisites
- [ ] Terminal application compiled successfully (`make mac` or `go build`)
- [ ] Binary exists at `./bin/terminal`
- [ ] Terminal supports 256 colors (`TERM=xterm-256color`)
- [ ] Terminal window is large enough (minimum 80x24, recommended 120x40)
- [ ] Router/API server is running (if required for testing)

### Build Verification
```bash
# Verify build
cd /Users/hesdx/Documents/b95/swapbiz/terminal
go build -o bin/terminal ./cmd/terminal

# Check binary exists
ls -lh bin/terminal
```

## Test Execution

### 1. Application Startup

**Command:**
```bash
./bin/terminal -tui -users 1 -interval 500ms
```

**Checklist:**
- [ ] Application starts without errors
- [ ] No panic messages
- [ ] TUI interface appears
- [ ] Initial screen renders correctly
- [ ] Status bar displays at bottom
- [ ] User list appears on left side
- [ ] Content area appears on right side
- [ ] Menu panel appears (if applicable)

**Expected Behavior:**
- Terminal clears and shows TUI interface
- All panels render in correct positions
- No error messages in terminal
- Application responds to keyboard input

**Common Issues:**
- If application hangs: Check PTY allocation (macOS may need `script` command)
- If colors wrong: Verify `TERM=xterm-256color`
- If layout broken: Check terminal size (resize window)

---

### 2. Panel Rendering

**Test Each Panel:**

#### 2.1 Overview Panel
- [ ] Navigate to Overview (press `1`)
- [ ] Panel displays correctly
- [ ] All widgets render
- [ ] Text is readable
- [ ] Borders display correctly
- [ ] No visual glitches

#### 2.2 Orders Panel
- [ ] Navigate to Orders (press `2`)
- [ ] Table displays correctly
- [ ] Headers visible
- [ ] Data rows render
- [ ] Scrolling works (if applicable)

#### 2.3 Positions Panel
- [ ] Navigate to Positions (press `3`)
- [ ] Table displays correctly
- [ ] Position data visible
- [ ] Formatting correct

#### 2.4 Buckets Panel
- [ ] Navigate to Buckets (press `4`)
- [ ] Table displays correctly
- [ ] Bucket data visible
- [ ] Status indicators work

#### 2.5 Orderbook Panel
- [ ] Navigate to Orderbook (press `5`)
- [ ] Bids table displays
- [ ] Asks table displays
- [ ] Market list visible
- [ ] Precision list visible
- [ ] Real-time updates work (if connected)

#### 2.6 Charts Panel
- [ ] Navigate to Charts (press `6`)
- [ ] Chart displays correctly
- [ ] Data visualization works
- [ ] Updates correctly

#### 2.7 Auth Panel
- [ ] Navigate to Auth (press `7`)
- [ ] Authentication form displays
- [ ] Input fields work
- [ ] Buttons render correctly

#### 2.8 Logs Panel
- [ ] Navigate to Logs (press `` ` `` - backtick)
- [ ] Log viewer displays
- [ ] Log entries visible
- [ ] Scrolling works
- [ ] New logs appear

#### 2.9 Trading Panel
- [ ] Navigate to Trading (press `x`)
- [ ] Price input field visible
- [ ] Quantity input field visible
- [ ] Buy button visible
- [ ] Sell button visible
- [ ] Status panel visible
- [ ] Log panel visible

#### 2.10 Autonomous Trading Panel
- [ ] Navigate to Autonomous (press `z`)
- [ ] Start button visible
- [ ] Stop button visible
- [ ] Status panel visible
- [ ] Log panel visible

#### 2.11 Endpoints Panel
- [ ] Navigate to Endpoints (press `e`)
- [ ] Endpoint list displays
- [ ] Status indicators work
- [ ] Information is readable

---

### 3. User Interaction

#### 3.1 Keyboard Navigation
- [ ] Tab key cycles focus (userList ↔ contentArea)
- [ ] Tab key cycles within panels (Trading, Orderbook)
- [ ] Arrow keys work in user list (Up/Down)
- [ ] Arrow keys work in panels (if applicable)
- [ ] Enter key selects user
- [ ] Enter key activates buttons
- [ ] Number keys (1-7) and backtick (`` ` ``) switch panels
- [ ] Letter keys (x, z, e) switch panels
- [ ] Escape key closes modals
- [ ] 'q' key quits (with confirmation)

#### 3.2 User Selection
- [ ] Select "New User" option (first item)
- [ ] Modal opens for adding user
- [ ] Select existing user
- [ ] User data updates in panels
- [ ] All panels reflect selected user

#### 3.3 Focus Management
- [ ] Focus indicator visible in user list
- [ ] Focus cycles correctly with Tab
- [ ] Focus works in Trading panel (price → quantity → buy → sell)
- [ ] Focus works in Orderbook panel (orderbook → markets → precision)

---

### 4. Modal Dialogs

#### 4.1 Add User Modal
- [ ] Modal opens when selecting "New User"
- [ ] Modal displays correctly
- [ ] Input fields work
- [ ] Buttons render
- [ ] Escape closes modal
- [ ] Modal doesn't break layout

#### 4.2 Confirmation Modal
- [ ] Quit confirmation appears when pressing 'q'
- [ ] Modal displays correctly
- [ ] 'y' confirms quit
- [ ] 'n' cancels quit
- [ ] Escape cancels quit

#### 4.3 Help Modal
- [ ] Help modal opens (if 'h' key implemented)
- [ ] Help text displays correctly
- [ ] Modal closes with Escape

---

### 5. Window Resizing

**Test Steps:**
1. Start application
2. Resize terminal window
3. Verify layout updates

**Checklist:**
- [ ] Application detects resize
- [ ] Layout recalculates correctly
- [ ] All panels resize appropriately
- [ ] Text doesn't overflow
- [ ] Borders remain correct
- [ ] No visual glitches
- [ ] Grid layout maintains proportions

**Test Different Sizes:**
- [ ] Small window (80x24)
- [ ] Medium window (120x40)
- [ ] Large window (160x50)
- [ ] Very wide window (200x30)
- [ ] Very tall window (80x60)

---

### 6. Real-Time Updates

**Test Steps:**
1. Start application with real-time data
2. Monitor panels for updates

**Checklist:**
- [ ] Orderbook updates in real-time
- [ ] Positions update correctly
- [ ] Orders update correctly
- [ ] Logs update correctly
- [ ] No flickering during updates
- [ ] Updates don't break layout
- [ ] Performance is acceptable

---

### 7. Error Handling

**Test Scenarios:**
- [ ] Network errors handled gracefully
- [ ] Invalid input handled correctly
- [ ] Missing data displays appropriately
- [ ] Error messages don't break UI
- [ ] Application recovers from errors

---

### 8. Performance

**Checklist:**
- [ ] Application starts quickly (< 2 seconds)
- [ ] Panel switching is responsive (< 100ms)
- [ ] Updates don't cause lag
- [ ] Memory usage is reasonable
- [ ] CPU usage is reasonable
- [ ] No memory leaks (run for extended period)

---

### 9. Visual Quality

**Checklist:**
- [ ] Colors display correctly
- [ ] Borders render properly
- [ ] Text is readable
- [ ] Alignment is correct
- [ ] Spacing is appropriate
- [ ] No visual artifacts
- [ ] Consistent styling across panels

---

### 10. Integration Testing

**Test Full Workflow:**
1. [ ] Start application
2. [ ] Add new user
3. [ ] Select user
4. [ ] Navigate through all panels
5. [ ] Place test order (if applicable)
6. [ ] View order in Orders panel
7. [ ] Check position in Positions panel
8. [ ] View logs
9. [ ] Resize window
10. [ ] Quit application

---

## Known Issues to Verify Fixed

### Migration-Specific
- [ ] No tview dependencies in runtime
- [ ] All panels use termui widgets
- [ ] Grid layout works correctly
- [ ] Focus management works
- [ ] Event handling works

### Previous Issues
- [ ] PTY allocation works (macOS)
- [ ] QueueUpdateDraw doesn't block
- [ ] Resize handling works
- [ ] Modal rendering works

---

## Test Results Template

```
Date: ___________
Tester: ___________
Environment: ___________

### Results Summary
- Application Startup: [ ] Pass [ ] Fail
- Panel Rendering: [ ] Pass [ ] Fail
- User Interaction: [ ] Pass [ ] Fail
- Modal Dialogs: [ ] Pass [ ] Fail
- Window Resizing: [ ] Pass [ ] Fail
- Real-Time Updates: [ ] Pass [ ] Fail
- Error Handling: [ ] Pass [ ] Fail
- Performance: [ ] Pass [ ] Fail
- Visual Quality: [ ] Pass [ ] Fail
- Integration: [ ] Pass [ ] Fail

### Issues Found
1. ___________
2. ___________
3. ___________

### Notes
___________
```

---

## Quick Test Command

For a quick smoke test:
```bash
# Start TUI
./bin/terminal -tui -users 1 -interval 500ms

# Quick checks:
# 1. Press 1-7, ` (backtick), x, z, e to test all panels
# 2. Press Tab to test focus
# 3. Resize window
# 4. Press q to quit
```

---

## Troubleshooting

### Application Won't Start
- Check terminal size
- Verify TERM environment variable
- Check for compilation errors
- Verify binary exists

### Layout Issues
- Resize terminal window
- Check terminal supports Grid layout
- Verify termui version

### Focus Issues
- Verify Tab key works
- Check panel implements CycleFocus()
- Test in different terminals

### Performance Issues
- Check update interval
- Monitor CPU/memory usage
- Reduce number of users
- Check for memory leaks

---

*Last Updated: After tview to termui migration completion*

