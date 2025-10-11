# TUI Mode User Guide

## Overview

The Terminal User Interface (TUI) mode provides an interactive, real-time interface for testing and monitoring the trading system. It features multiple panels, live updates, and keyboard navigation.

## Starting TUI Mode

### Basic Usage

```bash
# Start with default settings (10 users, 500ms interval)
make run-tui

# Or directly
./bin/terminal -tui
```

### Advanced Usage

```bash
# Custom user count and update interval
./bin/terminal -tui -users 20 -interval 1s

# With verbose logging
./bin/terminal -tui -users 15 -interval 250ms -verbose
```

## TUI Interface Layout

```
┌─────────────────────────────────────────────────────────────────┐
│ Terminal Application - TUI Mode                                │
├─────────────────────────────────────────────────────────────────┤
│ [Logs Panel]                                                   │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ [1] 12:34:56 Starting TUI mode with 10 users...           │ │
│ │ [2] 12:34:56 User 1 created successfully                  │ │
│ │ [3] 12:34:57 API connection established                    │ │
│ │ [4] 12:34:57 Authentication completed for user 1           │ │
│ └─────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│ [User Info Panel]                                              │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ Users: 10 | Connected: 8 | Authenticated: 6               │ │
│ │ Active Trades: 15 | Total Volume: $1,234.56               │ │
│ └─────────────────────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│ [Trading Panel]                                                │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ Orders: 25 | Positions: 12 | PnL: +$123.45              │ │
│ │ Market: BTC/USD | Price: $45,123.45 | Volume: 1.23 BTC    │ │
│ └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Panel Descriptions

### 1. Logs Panel
- **Purpose**: Real-time log display
- **Content**: System logs, API calls, user activities
- **Log Levels**: 
  - `[1]` - Info (blue)
  - `[2]` - Success (green)
  - `[3]` - Warning (yellow)
  - `[4]` - Error (red)

### 2. User Info Panel
- **Purpose**: User statistics and status
- **Content**: User count, connection status, authentication status
- **Updates**: Real-time user activity

### 3. Trading Panel
- **Purpose**: Trading activity overview
- **Content**: Orders, positions, PnL, market data
- **Updates**: Live trading data

## Keyboard Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `q` | Quit | Exit TUI mode |
| `h` | Help | Show help panel |
| `r` | Refresh | Refresh all panels |
| `c` | Clear | Clear logs panel |
| `s` | Status | Show system status |
| `u` | Users | Focus user panel |
| `t` | Trading | Focus trading panel |
| `l` | Logs | Focus logs panel |

## TUI Features

### Real-time Updates
- Live log streaming
- Automatic panel refresh
- Real-time statistics
- Live market data

### Interactive Controls
- Keyboard shortcuts
- Panel switching
- Data filtering
- Status monitoring

### Visual Indicators
- Color-coded log levels
- Status indicators
- Progress bars
- Error highlighting

## Configuration

### TUI Settings

```yaml
# In scripts/config.yaml
tui:
  default_users: 10
  update_interval: "500ms"
  log_buffer_size: 1000
  panel_refresh_rate: "100ms"
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TUI_USERS` | Default user count | `10` |
| `TUI_INTERVAL` | Update interval | `500ms` |
| `TUI_VERBOSE` | Verbose logging | `false` |

## Usage Examples

### 1. Basic Testing
```bash
# Start TUI with default settings
make run-tui

# Navigate using keyboard shortcuts
# Press 'h' for help
# Press 'q' to quit
```

### 2. Load Testing
```bash
# Start with many users
./bin/terminal -tui -users 50 -interval 100ms

# Monitor system performance
# Watch for memory usage and response times
```

### 3. Development Testing
```bash
# Start with verbose logging
./bin/terminal -tui -users 5 -verbose

# Monitor detailed logs
# Debug authentication issues
```

### 4. Production Monitoring
```bash
# Start with production-like settings
./bin/terminal -tui -users 100 -interval 1s

# Monitor system health
# Watch for errors and performance
```

## Monitoring and Debugging

### Real-time Monitoring
- Watch log levels for errors
- Monitor user creation success rate
- Track authentication failures
- Observe API response times

### Debugging Tips
- Use verbose mode for detailed logs
- Watch for error patterns
- Monitor resource usage
- Check network connectivity

### Performance Monitoring
- User creation rate
- Authentication success rate
- API response times
- Memory usage patterns

## Troubleshooting TUI Mode

### Common Issues

#### 1. TUI Not Starting
```
Failed to create TUI application
```

**Solution:**
- Check terminal compatibility
- Verify CGO is enabled
- Check dependencies

#### 2. Panel Not Updating
```
Panels not refreshing
```

**Solution:**
- Check update interval
- Verify panel refresh rate
- Restart TUI mode

#### 3. Users Not Creating
```
User creation failing
```

**Solution:**
- Check mnemonic file
- Verify signer binaries
- Check API connectivity

#### 4. Performance Issues
```
TUI running slowly
```

**Solution:**
- Reduce user count
- Increase update interval
- Check system resources

### Debug Mode

Enable debug mode for troubleshooting:

```bash
# Start with debug logging
./bin/terminal -tui -users 5 -verbose

# Monitor detailed logs
# Check for specific errors
```

### Log Analysis

Check logs for TUI-specific issues:

```bash
# View TUI logs
tail -f logs/optimized_$(date +%Y%m%d)_*.log | grep TUI

# Search for errors
grep "TUI" logs/*.log | grep ERROR
```

## Advanced TUI Usage

### Custom Panel Layout
- Modify panel sizes
- Add custom panels
- Configure refresh rates
- Set color schemes

### Integration with External Tools
- Export logs to files
- Send metrics to monitoring
- Integrate with CI/CD
- Connect to external APIs

### Performance Optimization
- Adjust update intervals
- Optimize panel refresh
- Manage memory usage
- Scale user counts

## Best Practices

### 1. User Count Management
- Start with small user counts (5-10)
- Gradually increase for load testing
- Monitor system resources
- Use appropriate intervals

### 2. Update Interval Tuning
- Use 500ms for normal testing
- Use 100ms for high-frequency monitoring
- Use 1s for production monitoring
- Adjust based on system performance

### 3. Log Management
- Enable verbose mode for debugging
- Monitor log file sizes
- Rotate logs regularly
- Archive old logs

### 4. Resource Monitoring
- Watch memory usage
- Monitor CPU usage
- Check network bandwidth
- Track disk I/O

## Integration Examples

### CI/CD Integration
```yaml
# GitHub Actions
- name: Run TUI Tests
  run: |
    ./bin/terminal -tui -users 10 -interval 500ms &
    sleep 30
    pkill terminal
```

### Monitoring Integration
```bash
# Start TUI with monitoring
./bin/terminal -tui -users 20 -verbose > tui_output.log 2>&1 &

# Monitor logs
tail -f tui_output.log | grep "ERROR\|WARNING"
```

### Development Workflow
```bash
# Start TUI for development
./bin/terminal -tui -users 5 -verbose

# Make changes to code
# Restart TUI to test changes
# Monitor results in real-time
```

---

## Quick Reference

### Essential Commands
```bash
# Start TUI
make run-tui

# Custom settings
./bin/terminal -tui -users 20 -interval 1s

# With verbose logging
./bin/terminal -tui -users 10 -verbose
```

### Keyboard Shortcuts
- `q` - Quit
- `h` - Help
- `r` - Refresh
- `c` - Clear logs

### Configuration
- Edit `scripts/config.yaml`
- Set TUI-specific settings
- Configure update intervals
- Set user defaults

### Troubleshooting
- Check logs for errors
- Verify dependencies
- Monitor resources
- Use debug mode
