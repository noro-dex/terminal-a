# TermUI Examples Quick Reference

## Quick Navigation

| Example | File | Purpose | Key Feature |
|---------|------|---------|-------------|
| Hello World | `hello_world.go` | Simplest example | Basic setup |
| Paragraph | `paragraph.go` | Text display | Formatting |
| List | `list.go` | Scrollable list | Navigation |
| Gauge | `gauge.go` | Progress bar | Progress display |
| Bar Chart | `barchart.go` | Bar visualization | Data charts |
| Plot | `plot.go` | Line charts | Time series |
| Sparkline | `sparkline.go` | Mini charts | Compact display |
| Pie Chart | `piechart.go` | Pie visualization | Proportions |
| Stacked Bar | `stacked_barchart.go` | Stacked bars | Multi-series |
| Grid | `grid.go` | Layout system | Responsive layout |
| Tabs | `tabs.go` | Tabbed interface | Content switching |
| Tree | `tree.go` | Tree view | Hierarchical data |
| Modal | `modal.go` | Modal dialogs | Layer system |
| Canvas | `canvas.go` | Custom drawing | Low-level |
| Image | `image.go` | Image display | File rendering |
| Demo | `demo.go` | Full dashboard | Complete example |

---

## Running Examples

```bash
# From examples directory
cd pkg/termi/_examples
go run <example>.go

# From project root
go run ./pkg/termi/_examples/<example>.go
```

---

## Widget Quick Reference

### Paragraph
```go
p := widgets.NewParagraph()
p.Text = "Hello World"
p.SetRect(0, 0, 25, 5)
ui.Render(p)
```

### List
```go
l := widgets.NewList()
l.Rows = []string{"Item 1", "Item 2"}
l.SetRect(0, 0, 25, 10)
ui.Render(l)
```

### Gauge
```go
g := widgets.NewGauge()
g.Percent = 50
g.SetRect(0, 0, 50, 3)
ui.Render(g)
```

### Bar Chart
```go
bc := widgets.NewBarChart()
bc.Data = []float64{1, 2, 3}
bc.Labels = []string{"A", "B", "C"}
bc.SetRect(0, 0, 50, 10)
ui.Render(bc)
```

### Plot
```go
p := widgets.NewPlot()
p.Data = [][]float64{[]float64{1, 2, 3, 4, 5}}
p.SetRect(0, 0, 50, 15)
ui.Render(p)
```

### Modal
```go
content := widgets.NewParagraph()
content.Text = "Modal content"
modal := widgets.ShowModal(content, 50, 15)
lm.AddLayer(ui.LayerModal, modal)
ui.RenderLayers(lm)
```

### Grid
```go
grid := ui.NewGrid()
grid.Set(
    ui.NewRow(1.0/2,
        ui.NewCol(1.0/2, widget1),
        ui.NewCol(1.0/2, widget2),
    ),
)
ui.Render(grid)
```

---

## Keyboard Controls

### Common
- `q` / `<C-c>` - Quit

### List/Tree Navigation
- `j` / `<Down>` - Down
- `k` / `<Up>` - Up
- `<C-d>` - Half page down
- `<C-u>` - Half page up
- `gg` - Top
- `G` - Bottom

### Tabs
- `h` - Previous tab
- `l` - Next tab

### Modal
- `m` - Show modal
- `Esc` - Close modal

---

## Common Patterns

### Initialization
```go
if err := ui.Init(); err != nil {
    log.Fatalf("failed to initialize: %v", err)
}
defer ui.Close()
```

### Event Loop
```go
uiEvents := ui.PollEvents()
for {
    e := <-uiEvents
    switch e.ID {
    case "q", "<C-c>":
        return
    }
}
```

### Resize Handling
```go
case "<Resize>":
    if resize, ok := e.Payload.(ui.Resize); ok {
        widget.SetRect(0, 0, resize.Width, resize.Height)
        ui.Render(widget)
    }
```

---

## Color Constants

```go
ui.ColorBlack
ui.ColorRed
ui.ColorGreen
ui.ColorYellow
ui.ColorBlue
ui.ColorMagenta
ui.ColorCyan
ui.ColorWhite
```

---

## See Also

- [TermUI Examples Guide](./termi_examples_guide.md) - Complete guide
- [Modal System Guide](./modal_system_guide.md) - Modal dialogs
- [TUI Guide](../user_manual/TUI_GUIDE.md) - Application guide

