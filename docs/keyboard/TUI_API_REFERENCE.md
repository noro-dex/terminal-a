# TUI API Reference

## Overview

This document provides a comprehensive API reference for the Terminal TUI package after the tview to termui migration.

## Package Structure

```
pkg/tui/
├── launcher.go          # Main App struct and initialization
├── events.go            # Event handling
├── render.go            # Rendering system
├── layout.go            # Layout management
├── panel/               # Panel subpackage
│   ├── panel_interfaces.go    # Panel interfaces
│   ├── app_interfaces.go # PanelApp interface
│   └── *.go            # Individual panel implementations
└── ...
```

---

## Core Interfaces

### Panel Interface

All panels must implement the `Panel` interface:

```go
type Panel interface {
    GetDrawable() ui.Drawable
    GetRect() image.Rectangle
    SetRect(x1, y1, x2, y2 int)
    UpdateUser(user *types.User)
    HandleUpdate(update UIUpdate)
}
```

**Methods:**

- `GetDrawable() ui.Drawable` - Returns the termui drawable widget for rendering
- `GetRect() image.Rectangle` - Returns the current rectangle bounds
- `SetRect(x1, y1, x2, y2 int)` - Sets the rectangle bounds (called on resize)
- `UpdateUser(user *types.User)` - Updates panel with selected user data
- `HandleUpdate(update UIUpdate)` - Handles UI update events

### FocusablePanel Interface

Panels that support focus cycling implement this interface:

```go
type FocusablePanel interface {
    Panel
    CycleFocus() // Cycle through focusable elements within the panel
}
```

**Methods:**

- `CycleFocus()` - Cycles through focusable elements (called on Tab key)

**Implementations:**
- `TradingPanel` - Cycles: price → quantity → buy → sell
- `OrderbookPanel` - Cycles: orderbook → markets → precision

### PanelApp Interface

Panels receive a `PanelApp` interface instead of the concrete `App` struct:

```go
type PanelApp interface {
    // Navigation
    SwitchToPage(pageName string)
    
    // Logging
    GetLogger() interfaces.LoggerInterface
    LogToFile(eventType, message string, data map[string]interface{})
    
    // UI Updates (thread-safe)
    GetTUI() interface{}  // Returns nil (termui uses Grid layout)
    QueueUpdateDraw(fn func())
    QueueUpdate(fn func())
    
    // Focus Management
    SetFocus(widget interface{})  // No-op (termui doesn't have built-in focus)
    
    // Context
    GetContext() context.Context
    
    // User Management
    GetSelectedUser() *types.User
    
    // DEX Client
    GetDexClient() *clients.DexClient
    
    // Trading Flow Manager
    GetTradingFlowManager() TradingFlowManagerInterface
}
```

---

## App Struct

### Main Application

```go
type App struct {
    // Termui widgets
    userList  *widgets.List
    statusBar *widgets.Paragraph
    
    // Layout management
    layout      Layout
    layoutMutex sync.RWMutex
    
    // Page management
    currentPage string
    pageMutex   sync.RWMutex
    
    // Focus management
    currentFocusArea string // "userList" or "contentArea"
    focusCycleIndex  int
    
    // Panels
    overviewPanel    *panel.OverviewPanel
    ordersPanel      *panel.OrdersPanel
    positionsPanel   *panel.PositionsPanel
    // ... other panels
    
    // Update channels
    updateChan chan UIUpdate
    ctx        context.Context
    cancel     context.CancelFunc
}
```

### Key Methods

#### Initialization

```go
func NewApp(config *config.SimConfig, logger interfaces.LoggerInterface) (*App, error)
```

Creates a new App instance with the given configuration and logger.

#### Page Navigation

```go
func (app *App) SwitchToPage(pageName string)
```

Switches to the specified page. Available pages:
- `constants.UIPageOverview` - Overview panel
- `constants.UIPageOrders` - Orders panel
- `constants.UIPagePositions` - Positions panel
- `constants.UIPageBuckets` - Buckets panel
- `constants.UIPageOrderbook` - Orderbook panel
- `constants.UIPageCharts` - Charts panel
- `constants.UIPageAuth` - Auth panel
- `constants.UIPageTrading` - Trading panel
- `constants.UIPageAutonomous` - Autonomous trading panel
- `constants.UIPageEndpoints` - Endpoints panel
- `constants.UIPageLogs` - Logs panel

#### UI Updates

```go
func (app *App) QueueUpdateDraw(fn func())
```

Queues a UI update function to be executed in the UI thread. Uses render batching for performance.

```go
func (app *App) QueueUpdate(fn func())
```

Queues a UI update function (without forcing immediate draw).

#### Focus Management

```go
func (app *App) SetFocus(widget interface{})
```

Sets focus to a widget. **Note:** This is a no-op in termui as focus is handled manually via event routing.

#### User Management

```go
func (app *App) GetSelectedUser() *types.User
```

Returns the currently selected user.

#### Layout

```go
func (app *App) setupMainGrid()
```

Sets up the main Grid layout. Called automatically on initialization and resize.

```go
func (app *App) getCurrentPanel() panel.Panel
```

Returns the current panel as a Panel interface.

```go
func (app *App) getCurrentPanelDrawable() ui.Drawable
```

Returns the drawable widget for the current page.

---

## Event Handling

### Event Types

Events are handled in `events.go`:

```go
func (app *App) handleEvent(e ui.Event) bool
```

**Supported Events:**

- `"q"`, `"<C-c>"` - Quit application (with confirmation)
- `"<Resize>"` - Terminal resize
- `"<Tab>"` - Switch focus
- `"1"` - `"7"`, `` "`" `` - Navigate to panels (1-7 for Overview-Auth, backtick for Logs)
- `"x"`, `"z"`, `"e"` - Navigate to special panels (Trading, Autonomous, Endpoints)
- `"<Up>"`, `"k"` - Navigate up in user list
- `"<Down>"`, `"j"` - Navigate down in user list
- `"<Enter>"` - Select user or activate button
- `"<Escape>"` - Close modal
- `"y"`, `"Y"` - Confirm (Yes)
- `"n"`, `"N"` - Cancel (No)

### Focus Switching

```go
func (app *App) switchFocus()
```

Switches focus between UI areas:
- From `userList` → `contentArea`
- From `contentArea` → cycles within panel (if supported) → `userList`

---

## Panel Creation

### Creating a New Panel

```go
// Example: Creating a simple panel
type MyPanel struct {
    grid *ui.Grid
    app  PanelApp
    // ... widgets
}

func NewMyPanel(app PanelApp) *MyPanel {
    panel := &MyPanel{
        app: app,
    }
    panel.createUI()
    return panel
}

func (p *MyPanel) createUI() {
    // Create termui widgets
    widget := widgets.NewParagraph()
    widget.Border = true
    widget.Title = " My Panel "
    
    // Create Grid layout
    p.grid = ui.NewGrid()
    p.grid.Set(
        ui.NewRow(1.0, widget),
    )
}

// Implement Panel interface
func (p *MyPanel) GetDrawable() ui.Drawable {
    return p.grid
}

func (p *MyPanel) GetRect() image.Rectangle {
    if p.grid != nil {
        return p.grid.GetRect()
    }
    return image.Rectangle{}
}

func (p *MyPanel) SetRect(x1, y1, x2, y2 int) {
    if p.grid != nil {
        p.grid.SetRect(x1, y1, x2, y2)
    }
}

func (p *MyPanel) UpdateUser(user *types.User) {
    // Update panel with user data
}

func (p *MyPanel) HandleUpdate(update panel.UIUpdate) {
    // Handle UI updates
}
```

### Adding Focus Support

```go
// Add focus management
type MyPanel struct {
    // ... existing fields
    currentFocus int // Track focus state
}

// Implement FocusablePanel
func (p *MyPanel) CycleFocus() {
    // Cycle through focusable elements
    p.currentFocus = (p.currentFocus + 1) % numFocusableElements
    // Update visual indicators
}
```

---

## Rendering System

### Render Batching

The rendering system uses batching to optimize performance:

- Multiple updates are batched together
- Rendering is throttled to 30 FPS
- Dirty tracking prevents unnecessary renders
- Resize events force full redraw

### Manual Rendering

```go
func (app *App) renderAll()
```

Forces an immediate full render (bypasses batching).

```go
func (app *App) forceFullRender()
```

Forces immediate full render (used on resize).

---

## Layout System

### Grid Layout

The application uses termui's Grid layout for responsive positioning:

```go
func (app *App) setupMainGrid()
```

Creates the main Grid structure:
- Left column (30%): User list
- Right column (70%):
  - Top row (20%): Menu panel
  - Bottom row (80%): Content area (current page)
- Bottom row (full width, ~5%): Status bar

### Panel Layout

Panels receive explicit dimensions via `SetRect()`:

```go
func (app *App) applyAllPanelLayouts(layout Layout)
```

Applies layout to all panels (called on resize).

---

## UIUpdate Type

```go
type UIUpdate struct {
    Type      string
    UserID    string
    Data      interface{}
    Timestamp time.Time
}
```

Used for communicating updates between components.

---

## Constants

### Page Names

Defined in `github.com/morpheum-labs/common/domain/constants`:

- `UIPageOverview`
- `UIPageOrders`
- `UIPagePositions`
- `UIPageBuckets`
- `UIPageOrderbook`
- `UIPageCharts`
- `UIPageAuth`
- `UIPageTrading`
- `UIPageAutonomous`
- `UIPageEndpoints`
- `UIPageLogs`

---

## Thread Safety

### UI Updates

All UI updates should use `QueueUpdateDraw()` or `QueueUpdate()`:

```go
app.QueueUpdateDraw(func() {
    // Update UI widgets here
    // This is thread-safe
})
```

### Mutex Usage

- `layoutMutex` - Protects layout state
- `pageMutex` - Protects page state
- `uiMutex` - Protects UI state (focus, selected user)

---

## Migration Notes

### From tview to termui

Key differences:
- No built-in focus management (handled manually)
- Grid layout instead of Flex
- Different event system
- Different widget APIs

See [Migration Guide](./TUI_MIGRATION_GUIDE.md) for details.

---

*Last Updated: After tview to termui migration completion*

