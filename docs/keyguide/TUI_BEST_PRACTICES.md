# TUI Best Practices Guide

## Overview

This guide provides best practices for developing and maintaining the Terminal TUI application after the tview to termui migration.

---

## Panel Development

### 1. Use PanelApp Interface

**✅ DO:**
```go
type MyPanel struct {
    app PanelApp  // Use interface, not concrete App
    // ...
}

func NewMyPanel(app PanelApp) *MyPanel {
    return &MyPanel{app: app}
}
```

**❌ DON'T:**
```go
type MyPanel struct {
    app *App  // Don't use concrete type
    // ...
}
```

**Why:** Interface segregation principle - panels only get what they need, easier to test.

---

### 2. Implement Panel Interface Correctly

**✅ DO:**
```go
func (p *MyPanel) GetDrawable() ui.Drawable {
    return p.grid  // Return the root Grid
}

func (p *MyPanel) SetRect(x1, y1, x2, y2 int) {
    if p.grid != nil {
        p.grid.SetRect(x1, y1, x2, y2)
    }
}
```

**❌ DON'T:**
```go
func (p *MyPanel) GetDrawable() ui.Drawable {
    return p.someWidget  // Don't return individual widgets
}
```

**Why:** Grid layout handles positioning automatically.

---

### 3. Use Grid Layout for Complex Panels

**✅ DO:**
```go
p.grid = ui.NewGrid()
p.grid.Set(
    ui.NewRow(0.7,
        ui.NewCol(0.5, widget1),
        ui.NewCol(0.5, widget2),
    ),
    ui.NewRow(0.3, widget3),
)
```

**❌ DON'T:**
```go
// Don't manually calculate positions
widget1.SetRect(x1, y1, x2, y2)
widget2.SetRect(x3, y3, x4, y4)
```

**Why:** Grid layout is responsive and handles resizing automatically.

---

### 4. Handle Nil Checks

**✅ DO:**
```go
func (p *MyPanel) UpdateUser(user *types.User) {
    if user == nil {
        return
    }
    // Update panel
}

func (p *MyPanel) GetDrawable() ui.Drawable {
    if p.grid != nil {
        return p.grid
    }
    return nil
}
```

**Why:** Prevents panics and makes code more robust.

---

## Thread Safety

### 5. Use QueueUpdateDraw for UI Updates

**✅ DO:**
```go
// From background goroutine
app.QueueUpdateDraw(func() {
    // Update UI widgets here
    widget.Text = "Updated"
})
```

**❌ DON'T:**
```go
// Don't update UI directly from background goroutines
widget.Text = "Updated"  // Race condition!
```

**Why:** UI updates must happen on the main thread.

---

### 6. Protect Shared State with Mutexes

**✅ DO:**
```go
type MyPanel struct {
    mu     sync.RWMutex
    data   []string
}

func (p *MyPanel) UpdateData(data []string) {
    p.mu.Lock()
    defer p.mu.Unlock()
    p.data = data
}

func (p *MyPanel) GetData() []string {
    p.mu.RLock()
    defer p.mu.RUnlock()
    return p.data
}
```

**Why:** Prevents race conditions when accessing shared data.

---

## Focus Management

### 7. Implement FocusablePanel for Interactive Panels

**✅ DO:**
```go
type MyPanel struct {
    currentFocus int
    // ...
}

func (p *MyPanel) CycleFocus() {
    // Cycle through focusable elements
    p.currentFocus = (p.currentFocus + 1) % numElements
    // Update visual indicators
    p.updateFocusIndicators()
}
```

**Why:** Enables Tab key navigation within panels.

---

### 8. Update Visual Focus Indicators

**✅ DO:**
```go
func (p *MyPanel) updateFocusIndicators() {
    switch p.currentFocus {
    case 0:
        p.inputField.BorderStyle = ui.NewStyle(ui.ColorYellow)
    case 1:
        p.inputField.BorderStyle = ui.NewStyle(ui.ColorWhite)
        p.button.BorderStyle = ui.NewStyle(ui.ColorYellow)
    }
}
```

**Why:** Users need visual feedback for focus state.

---

## Event Handling

### 9. Handle Events in Main Event Loop

**✅ DO:**
```go
// In events.go
case "<Enter>":
    if app.currentFocusArea == "userList" {
        app.handleEnter()
    } else if app.currentPage == constants.UIPageTrading {
        // Handle panel-specific events
        if app.tradingPanel != nil {
            app.tradingPanel.HandleEnter()
        }
    }
```

**Why:** Centralized event handling is easier to maintain.

---

### 10. Delegate Panel-Specific Events

**✅ DO:**
```go
// In panel
func (p *TradingPanel) HandleEnter() {
    switch p.currentFocus {
    case 0: // Price field
        // Activate price input
    case 2: // Buy button
        p.placeBuyOrder()
    }
}
```

**Why:** Keeps panel logic encapsulated.

---

## Performance

### 11. Batch UI Updates

**✅ DO:**
```go
// Multiple updates batched together
app.QueueUpdateDraw(func() {
    widget1.Text = "Update 1"
    widget2.Text = "Update 2"
    widget3.Text = "Update 3"
})
```

**❌ DON'T:**
```go
// Don't queue multiple separate updates
app.QueueUpdateDraw(func() { widget1.Text = "Update 1" })
app.QueueUpdateDraw(func() { widget2.Text = "Update 2" })
app.QueueUpdateDraw(func() { widget3.Text = "Update 3" })
```

**Why:** Batching reduces render calls and improves performance.

---

### 12. Use Selective Rendering

**✅ DO:**
```go
// Only update what changed
if dataChanged {
    app.QueueUpdateDraw(func() {
        p.updateTable(data)
    })
}
```

**Why:** Prevents unnecessary renders.

---

### 13. Handle Resize Efficiently

**✅ DO:**
```go
func (app *App) handleResize(resize ui.Resize) {
    // Force full redraw on resize
    ui.Clear()
    app.markAllWidgetsDirty()
    app.setupMainGrid()
    app.applyAllPanelLayouts(layout)
    app.forceFullRender()
}
```

**Why:** Resize invalidates all layouts, full redraw is necessary.

---

## Error Handling

### 14. Handle Errors Gracefully

**✅ DO:**
```go
func (p *MyPanel) UpdateUser(user *types.User) {
    if user == nil {
        p.statusWidget.Text = "[red]No user selected[white]"
        return
    }
    
    if err := p.loadData(user); err != nil {
        p.statusWidget.Text = fmt.Sprintf("[red]Error: %v[white]", err)
        return
    }
    
    // Update panel
}
```

**Why:** Prevents panics and provides user feedback.

---

### 15. Log Errors Appropriately

**✅ DO:**
```go
if err != nil {
    if p.app != nil && p.app.GetLogger() != nil {
        p.app.GetLogger().Error("Failed to update panel: %v", err)
    }
    // Update UI to show error
}
```

**Why:** Errors should be logged and visible to users.

---

## Code Organization

### 16. Keep Panels Focused

**✅ DO:**
```go
// Each panel has a single responsibility
type OrdersPanel struct {
    // Only order-related functionality
}
```

**❌ DON'T:**
```go
// Don't mix responsibilities
type OrdersPanel struct {
    // Orders + Positions + Trading + ...
}
```

**Why:** Single responsibility principle makes code maintainable.

---

### 17. Use Helper Functions

**✅ DO:**
```go
// In panel/helpers.go
func FormatPrice(price float64) string {
    return fmt.Sprintf("%.2f", price)
}

// In panel
priceText := FormatPrice(order.Price)
```

**Why:** Reusable code reduces duplication.

---

### 18. Document Public APIs

**✅ DO:**
```go
// CycleFocus cycles through focusable elements in the panel
// Focus order: priceField -> quantityField -> buyButton -> sellButton
func (p *TradingPanel) CycleFocus() {
    // ...
}
```

**Why:** Documentation helps other developers understand the code.

---

## Testing

### 19. Make Panels Testable

**✅ DO:**
```go
// Use interfaces for dependencies
type MyPanel struct {
    app PanelApp  // Interface, easy to mock
}

// Test with mock
func TestMyPanel(t *testing.T) {
    mockApp := &MockPanelApp{}
    panel := NewMyPanel(mockApp)
    // Test panel
}
```

**Why:** Interfaces enable unit testing.

---

### 20. Test Focus Management

**✅ DO:**
```go
func TestTradingPanelFocus(t *testing.T) {
    panel := NewTradingPanel(mockApp)
    
    // Test initial focus
    assert.Equal(t, 0, panel.currentFocus)
    
    // Test cycling
    panel.CycleFocus()
    assert.Equal(t, 1, panel.currentFocus)
}
```

**Why:** Focus management is critical for usability.

---

## Migration from tview

### 21. Remove tview Dependencies

**✅ DO:**
- Remove all `tview` imports
- Remove `tview` widget fields
- Use `termui` widgets instead

**Why:** Clean migration reduces technical debt.

---

### 22. Update Event Handling

**✅ DO:**
```go
// termui event handling
func (app *App) handleEvent(e ui.Event) bool {
    switch e.ID {
    case "<Tab>":
        app.switchFocus()
    }
}
```

**Why:** termui uses different event system.

---

### 23. Use Grid Instead of Flex

**✅ DO:**
```go
// termui Grid
grid := ui.NewGrid()
grid.Set(
    ui.NewRow(0.5, widget1),
    ui.NewRow(0.5, widget2),
)
```

**Why:** Grid is the termui equivalent of tview Flex.

---

## Common Pitfalls

### 24. Don't Update UI from Background Goroutines

**❌ DON'T:**
```go
go func() {
    widget.Text = "Updated"  // Race condition!
}()
```

**✅ DO:**
```go
go func() {
    app.QueueUpdateDraw(func() {
        widget.Text = "Updated"
    })
}()
```

---

### 25. Don't Forget Nil Checks

**❌ DON'T:**
```go
func (p *MyPanel) UpdateUser(user *types.User) {
    p.data = user.Data  // Panic if user is nil!
}
```

**✅ DO:**
```go
func (p *MyPanel) UpdateUser(user *types.User) {
    if user == nil {
        return
    }
    p.data = user.Data
}
```

---

### 26. Don't Block the UI Thread

**❌ DON'T:**
```go
app.QueueUpdateDraw(func() {
    time.Sleep(5 * time.Second)  // Blocks UI!
    widget.Text = "Done"
})
```

**✅ DO:**
```go
go func() {
    time.Sleep(5 * time.Second)
    app.QueueUpdateDraw(func() {
        widget.Text = "Done"
    })
}()
```

---

## Summary

Key principles:
1. **Use interfaces** - PanelApp instead of concrete App
2. **Thread safety** - QueueUpdateDraw for UI updates
3. **Grid layout** - Use termui Grid for responsive layouts
4. **Error handling** - Graceful degradation
5. **Focus management** - Implement FocusablePanel for interactive panels
6. **Performance** - Batch updates, selective rendering
7. **Testing** - Make panels testable with interfaces

---

*Last Updated: After tview to termui migration completion*

