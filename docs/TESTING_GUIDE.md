# Testing Guide

## Overview

This guide provides comprehensive information about testing the Terminal Application, including different test categories, execution modes, and result interpretation.

## Test Categories

### 1. Simulation Tests

**Purpose**: Multi-user simulation and load testing

**What it tests**:
- User creation and management
- Authentication workflows
- System behavior under load
- Resource utilization
- Concurrent operations

**Usage**:
```bash
# Console mode
bash scripts/run_console.sh simulation

# Direct binary
./bin/terminal -category simulation -verbose
```

**Expected Behavior**:
- Creates 5 users
- Tests user authentication
- Collects bucket information
- Validates system performance

**Success Criteria**:
- All users created successfully
- Authentication completed
- No system errors
- Performance within acceptable limits

### 2. Authentication Tests

**Purpose**: User authentication and security testing

**What it tests**:
- EIP-712 signature generation
- User authentication workflows
- Token management
- Security validations
- Error handling

**Usage**:
```bash
# Console mode
bash scripts/run_console.sh auth

# Direct binary
./bin/terminal -category auth -verbose
```

**Expected Behavior**:
- Creates 1 user
- Tests EIP-712 authentication
- Validates signature generation
- Tests token management

**Success Criteria**:
- User created successfully
- Authentication completed
- Signature validation passed
- Token generated correctly

### 3. Trading Tests

**Purpose**: Trading system functionality testing

**What it tests**:
- Order placement and management
- Order matching algorithms
- Position management
- Risk calculations
- Market data handling

**Usage**:
```bash
# Console mode
bash scripts/run_console.sh trading

# Direct binary
./bin/terminal -category trading -verbose
```

**Expected Behavior**:
- Tests order placement
- Validates order matching
- Tests position management
- Tests risk calculations

**Success Criteria**:
- Orders placed successfully
- Matching algorithm works
- Positions calculated correctly
- Risk metrics accurate

### 4. Performance Tests

**Purpose**: System performance and load testing

**What it tests**:
- System performance under load
- Response times
- Memory usage
- CPU utilization
- Network performance

**Usage**:
```bash
# Console mode
bash scripts/run_console.sh performance

# Direct binary
./bin/terminal -category performance -verbose
```

**Expected Behavior**:
- Measures system performance
- Tests under load conditions
- Benchmarks response times
- Memory usage analysis

**Success Criteria**:
- Performance within acceptable limits
- No memory leaks
- Response times acceptable
- System stable under load

### 5. All Tests

**Purpose**: Comprehensive system testing

**What it tests**:
- All test categories sequentially
- System integration
- End-to-end workflows
- Comprehensive validation

**Usage**:
```bash
# Console mode
bash scripts/run_console.sh all

# Direct binary
./bin/terminal -category all -verbose
```

**Expected Behavior**:
- Runs all test categories
- Comprehensive system validation
- Aggregates results
- Full system testing

**Success Criteria**:
- All categories pass
- System integration works
- End-to-end workflows complete
- No critical errors

## Test Execution Modes

### Console Mode

**Best for**: Automated testing, CI/CD, batch operations

**Features**:
- Command-line interface
- Automated execution
- Comprehensive logging
- Result reporting
- Environment validation

**Usage**:
```bash
# Basic usage
bash scripts/run_console.sh simulation

# With options
bash scripts/run_console.sh --verbose --timeout 10m all
```

### TUI Mode

**Best for**: Interactive testing, real-time monitoring, development

**Features**:
- Interactive interface
- Real-time updates
- Visual monitoring
- Live debugging
- Panel-based display

**Usage**:
```bash
# Basic TUI
./bin/terminal -tui -users 10

# Advanced TUI
./bin/terminal -tui -users 20 -interval 1s -verbose
```

### Direct Binary Mode

**Best for**: Custom testing, integration, scripting

**Features**:
- Direct control
- Custom parameters
- Script integration
- Flexible execution
- Programmatic control

**Usage**:
```bash
# Basic usage
./bin/terminal -category simulation

# Advanced usage
./bin/terminal -category all -timeout 10m -verbose
```

## Test Configuration

### Configuration File

Edit `scripts/config.yaml` for test configuration:

```yaml
# API Configuration
api_base_url: "http://localhost:9855"
max_retries: 3

# SSH Configuration
use_ssh: false
ssh_host: "staging.example.com"
ssh_port: 22
ssh_user: "deploy"

# File Paths
mnemonics_file: "scripts/test_mnmeonic.txt"
morm_signer_bin: "build/morm_signer"
eth_signer_bin: "build/eth_signer"
keys_dir: "scripts/keys"
log_dir: "logs"
reports_dir: "test-results"

# Logging
verbose: false
console_output: true
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `MNEMONICS_FILE` | Path to mnemonic file | `scripts/test_mnmeonic.txt` |
| `KEYS_DIR` | Directory for keys | `scripts/keys` |
| `LOG_DIR` | Directory for logs | `logs` |
| `REPORTS_DIR` | Directory for reports | `test-results` |
| `MORM_SIGNER_BIN` | Path to morm_signer | `build/morm_signer` |

### Test Data Setup

#### 1. Mnemonic File

Create `scripts/test_mnmeonic.txt` with test mnemonics:

```
abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about
abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon
abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon
```

#### 2. Required Binaries

Ensure required binaries are built:

```bash
# Build all signers
make build-signers

# Or manually
go build -o build/eth_signer cmd/eth_signer/main.go
go build -o build/morm_signer cmd/morm_signer/main.go
```

#### 3. API Server

Ensure API server is running:

```bash
# Check if server is running
curl http://localhost:9855/api/infra/daemons

# Start server if needed
# (depends on your setup)
```

## Test Execution

### Basic Test Execution

```bash
# Run simulation tests
bash scripts/run_console.sh simulation

# Run all tests
bash scripts/run_console.sh all

# Run with verbose logging
bash scripts/run_console.sh --verbose all
```

### Advanced Test Execution

```bash
# Custom timeout
bash scripts/run_console.sh --timeout 30m all

# Rebuild and test
bash scripts/run_console.sh --rebuild all

# Authentication only
bash scripts/run_console.sh --test-auth
```

### TUI Testing

```bash
# Basic TUI
make run-tui

# Custom settings
./bin/terminal -tui -users 20 -interval 1s

# With verbose logging
./bin/terminal -tui -users 10 -verbose
```

## Result Interpretation

### Success Indicators

✅ **Green checkmarks**: Successful operations
- Test counts: `X passed, Y failed, Z total`
- Duration: Execution time
- No error messages
- Exit code 0

### Error Indicators

❌ **Red X marks**: Failures
- Error messages in output
- Non-zero exit codes
- Failed test counts
- Exception traces

### Example Output Analysis

#### Successful Test
```
Running simulation tests...
[1] 12:34:56 Running Simulation Tests
[1] 12:34:56 Creating 5 users
[2] 12:34:57 Successfully created 5 users
✅ Tests completed: 1 passed, 0 failed, 1 total
✅ All tests completed successfully
```

**Analysis**:
- Test executed successfully
- 1 test passed
- No failures
- System working correctly

#### Failed Test
```
Running simulation tests...
[1] 12:34:56 Running Simulation Tests
[1] 12:34:56 Creating 5 users
[4] 12:34:57 User creation failed: eth_signer not found
✅ Tests completed: 0 passed, 1 failed, 1 total
❌ Test execution failed: user creation failed
```

**Analysis**:
- Test failed
- 1 test failed
- Missing `eth_signer` binary
- System not properly configured

#### Partial Success
```
Running all tests...
[1] 12:34:56 Running All Tests
[1] 12:34:56 Running health tests
[2] 12:34:57 Health check passed
[1] 12:34:57 Running auth tests
[4] 12:34:58 Auth test failed: eth_signer not found
[1] 12:34:58 Running trading tests
[2] 12:34:59 Trading tests completed
✅ Tests completed: 5 passed, 1 failed, 6 total
Errors encountered:
  - auth: authentication test failed: eth_signer not found
✅ All tests completed successfully
```

**Analysis**:
- 5 tests passed
- 1 test failed (auth)
- Overall success despite auth failure
- Missing `eth_signer` binary

## Troubleshooting

### Common Issues

#### 1. Binary Not Found
```
eth_signer failed to generate address: fork/exec /path/to/eth_signer: no such file or directory
```

**Solution**:
```bash
# Build required binaries
make build-signers

# Or manually
go build -o build/eth_signer cmd/eth_signer/main.go
go build -o build/morm_signer cmd/morm_signer/main.go
```

#### 2. Configuration File Not Found
```
Configuration file not found: scripts/config.yaml
```

**Solution**:
```bash
# Create configuration file
cp scripts/config.yaml.example scripts/config.yaml
# Edit as needed
```

#### 3. Mnemonic File Not Found
```
Mnemonic file not found: scripts/test_mnmeonic.txt
```

**Solution**:
```bash
# Create mnemonic file
touch scripts/test_mnmeonic.txt
# Add test mnemonics (one per line)
```

#### 4. API Connection Issues
```
API request failed: HTTP 404: Not Found
```

**Solution**:
- Check if API server is running
- Verify API base URL in configuration
- Check network connectivity
- Validate server endpoints

#### 5. SSH Tunnel Issues
```
SSH tunnel failed to establish
```

**Solution**:
- Verify SSH credentials
- Check SSH server accessibility
- Validate SSH configuration
- Test SSH connection manually

### Debug Mode

Enable verbose logging for debugging:

```bash
# Console mode
bash scripts/run_console.sh --verbose all

# Direct binary
./bin/terminal -category all -verbose

# TUI mode
./bin/terminal -tui -users 10 -verbose
```

### Log Analysis

Check logs for detailed error information:

```bash
# View latest log
tail -f logs/optimized_$(date +%Y%m%d)_*.log

# Search for errors
grep "ERROR" logs/*.log

# Search for specific test
grep "simulation" logs/*.log

# Monitor in real-time
tail -f logs/*.log | grep "ERROR\|WARNING"
```

## Performance Testing

### Load Testing

```bash
# High user count
./bin/terminal -tui -users 100 -interval 100ms

# Monitor performance
top -p $(pgrep terminal)
```

### Stress Testing

```bash
# Extended timeout
bash scripts/run_console.sh --timeout 30m all

# Monitor resources
htop
```

### Memory Testing

```bash
# Monitor memory usage
ps aux | grep terminal

# Check for leaks
valgrind --leak-check=full ./bin/terminal -category simulation
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Terminal Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-go@v2
        with:
          go-version: '1.19'
      - name: Install dependencies
        run: go mod tidy
      - name: Build binaries
        run: make build-local
      - name: Run tests
        run: bash scripts/run_console.sh all
      - name: Upload logs
        uses: actions/upload-artifact@v2
        with:
          name: test-logs
          path: logs/
```

### Jenkins Pipeline

```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'make build-local'
            }
        }
        stage('Test') {
            steps {
                sh 'bash scripts/run_console.sh all'
            }
        }
        stage('Report') {
            steps {
                archiveArtifacts artifacts: 'logs/*.log', fingerprint: true
                publishTestResults testResultsPattern: 'test-results/*.xml'
            }
        }
    }
}
```

### Docker Integration

```dockerfile
FROM golang:1.19-alpine AS builder
WORKDIR /app
COPY . .
RUN go mod tidy
RUN make build-local

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/bin/terminal .
COPY --from=builder /app/scripts/ .
CMD ["./terminal", "-category", "all"]
```

## Best Practices

### 1. Test Organization
- Use appropriate test categories
- Set reasonable timeouts
- Enable verbose logging for debugging
- Monitor resource usage

### 2. Environment Management
- Keep configuration files updated
- Maintain test data files
- Regular binary updates
- Clean log files regularly

### 3. Error Handling
- Monitor test results
- Check logs for errors
- Handle timeout scenarios
- Validate prerequisites

### 4. Performance Optimization
- Use appropriate user counts
- Set reasonable timeouts
- Monitor system resources
- Optimize test execution

### 5. Continuous Integration
- Automate test execution
- Monitor test results
- Alert on failures
- Maintain test data

---

## Quick Reference

### Essential Commands
```bash
# Basic testing
bash scripts/run_console.sh simulation

# Verbose testing
bash scripts/run_console.sh --verbose all

# TUI testing
make run-tui

# Direct binary
./bin/terminal -category all -verbose
```

### Configuration
- Edit `scripts/config.yaml`
- Set file paths and API URLs
- Configure SSH settings
- Set logging options

### Troubleshooting
- Check logs for errors
- Verify prerequisites
- Use debug mode
- Monitor resources
