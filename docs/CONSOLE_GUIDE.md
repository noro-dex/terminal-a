# Console Mode User Guide

## Overview

Console mode is designed for automated testing, CI/CD pipelines, and batch operations. It provides a command-line interface with comprehensive logging and result reporting.

## Starting Console Mode

### Using the Console Script (Recommended)

```bash
# Basic usage
bash scripts/run_console.sh [OPTIONS] [CATEGORY]

# Examples
bash scripts/run_console.sh simulation
bash scripts/run_console.sh --verbose all
bash scripts/run_console.sh --timeout 10m auth
```

### Direct Binary Usage

```bash
# Build first
make build-local

# Run tests
./bin/terminal -category simulation -verbose
./bin/terminal -category all -timeout 10m
```

## Console Script Options

### Command Line Options

| Option | Short | Description | Example |
|--------|-------|-------------|---------|
| `--rebuild` | `-r` | Force rebuild before running | `--rebuild` |
| `--timeout` | `-t` | Set test timeout | `--timeout 10m` |
| `--verbose` | `-v` | Enable verbose logging | `--verbose` |
| `--test-auth` | `-a` | Test authentication only | `--test-auth` |
| `--help` | `-h` | Show help message | `--help` |

### Test Categories

| Category | Description | Use Case |
|----------|-------------|----------|
| `simulation` | Multi-user simulation tests | Load testing, user behavior |
| `auth` | Authentication tests | Security testing, user management |
| `trading` | Trading system tests | Order matching, positions |
| `performance` | Performance benchmarks | System performance, load testing |
| `all` | All test categories | Comprehensive testing |

## Usage Examples

### 1. Basic Testing

```bash
# Run simulation tests
bash scripts/run_console.sh simulation

# Run authentication tests
bash scripts/run_console.sh auth

# Run all tests
bash scripts/run_console.sh all
```

### 2. Verbose Testing

```bash
# Run with detailed logging
bash scripts/run_console.sh --verbose simulation

# Run all tests with verbose output
bash scripts/run_console.sh --verbose all
```

### 3. Timeout Management

```bash
# Quick tests (1 minute timeout)
bash scripts/run_console.sh --timeout 1m simulation

# Long-running tests (30 minutes timeout)
bash scripts/run_console.sh --timeout 30m all

# Performance tests with extended timeout
bash scripts/run_console.sh --timeout 15m performance
```

### 4. Authentication Testing

```bash
# Test only authentication
bash scripts/run_console.sh --test-auth

# Run auth tests with verbose logging
bash scripts/run_console.sh --verbose auth
```

### 5. Rebuild and Test

```bash
# Force rebuild before testing
bash scripts/run_console.sh --rebuild simulation

# Rebuild and run all tests
bash scripts/run_console.sh --rebuild --verbose all
```

## Direct Binary Usage

### Command Line Flags

| Flag | Description | Default | Example |
|------|-------------|---------|---------|
| `-category` | Test category to run | `simulation` | `-category auth` |
| `-verbose` | Enable verbose logging | `false` | `-verbose` |
| `-timeout` | Test timeout | `5m` | `-timeout 10m` |
| `-tui` | Enable TUI mode | `false` | `-tui` |
| `-users` | Number of users (TUI mode) | `10` | `-users 20` |
| `-interval` | Update interval (TUI mode) | `500ms` | `-interval 1s` |
| `-test-auth` | Test authentication only | `false` | `-test-auth` |

### Examples

```bash
# Basic usage
./bin/terminal -category simulation

# With verbose logging
./bin/terminal -category auth -verbose

# With custom timeout
./bin/terminal -category all -timeout 10m

# Test authentication only
./bin/terminal -test-auth

# TUI mode
./bin/terminal -tui -users 10
```

## Test Execution Flow

### 1. Environment Validation
```
🚀 Starting Terminal Console Mode

ℹ️  Parsing configuration from scripts/config.yaml...
✅ Configuration loaded successfully
ℹ️    Mnemonic file: scripts/test_mnmeonic.txt
ℹ️    Morm signer: build/morm_signer
ℹ️    Keys dir: scripts/keys
ℹ️    Log dir: logs
ℹ️    Reports dir: test-results
ℹ️  Validating environment...
✅ Valid test category: simulation
✅ Environment validation completed
```

### 2. Binary Check and Build
```
ℹ️  Checking required binaries...
✅ Binary check completed
ℹ️  Binary already exists: bin/terminal
```

### 3. Test Execution
```
ℹ️  Launching Terminal Console mode...
ℹ️  Category: simulation, Timeout: 5m
ℹ️  Command: bin/terminal -category simulation -timeout 5m

Running simulation tests...
[1] 12:34:56 Running Simulation Tests
[1] 12:34:56 Creating 5 users
[2] 12:34:57 User 1 created successfully
[2] 12:34:57 User 2 created successfully
```

### 4. Result Reporting
```
✅ Tests completed: 5 passed, 0 failed, 5 total
✅ All tests completed successfully
```

## Configuration

### Configuration File (scripts/config.yaml)

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

## Test Categories Detailed

### Simulation Tests

**Purpose**: Multi-user simulation and load testing

**What it does**:
- Creates 5 users
- Tests user creation and authentication
- Collects bucket information
- Validates system behavior under load

**Usage**:
```bash
bash scripts/run_console.sh simulation
```

**Expected Output**:
```
Running simulation tests...
[1] 12:34:56 Running Simulation Tests
[1] 12:34:56 Creating 5 users
[2] 12:34:57 Successfully created 5 users
✅ Tests completed: 1 passed, 0 failed, 1 total
```

### Authentication Tests

**Purpose**: User authentication and security testing

**What it does**:
- Creates 1 user
- Tests EIP-712 authentication
- Validates signature generation
- Tests token management

**Usage**:
```bash
bash scripts/run_console.sh auth
```

**Expected Output**:
```
Running authentication tests...
[1] 12:34:56 Running Authentication Tests
[1] 12:34:56 Loaded 14 mnemonics from scripts/test_mnmeonic.txt
[2] 12:34:57 Authentication test completed for user: 0x1234...
✅ Tests completed: 1 passed, 0 failed, 1 total
```

### Trading Tests

**Purpose**: Trading system functionality testing

**What it does**:
- Tests order placement
- Validates order matching
- Tests position management
- Tests risk calculations

**Usage**:
```bash
bash scripts/run_console.sh trading
```

**Expected Output**:
```
Running trading tests...
[1] 12:34:56 Running Trading Tests
[2] 12:34:57 Trading tests completed
✅ Tests completed: 1 passed, 0 failed, 1 total
```

### Performance Tests

**Purpose**: System performance and load testing

**What it does**:
- Measures system performance
- Tests under load conditions
- Benchmarks response times
- Memory usage analysis

**Usage**:
```bash
bash scripts/run_console.sh performance
```

**Expected Output**:
```
Running performance tests...
[1] 12:34:56 Running Performance Tests
[2] 12:34:57 Performance tests completed
✅ Tests completed: 1 passed, 0 failed, 1 total
```

### All Tests

**Purpose**: Comprehensive system testing

**What it does**:
- Runs all test categories sequentially
- Comprehensive system validation
- Aggregates results
- Full system testing

**Usage**:
```bash
bash scripts/run_console.sh all
```

**Expected Output**:
```
Running all tests...
Running all test categories...
[1] 12:34:56 Running All Tests
[1] 12:34:56 Running health tests
[1] 12:34:56 Running auth tests
[1] 12:34:56 Running trading tests
[1] 12:34:56 Running enhanced tests
[1] 12:34:56 Running sequential tests
[1] 12:34:56 Running performance tests
[1] 12:34:56 Running bucket tests
✅ Tests completed: 6 passed, 0 failed, 6 total
```

## Result Interpretation

### Success Indicators

✅ **Green checkmarks**: Successful operations
- Test counts: `X passed, Y failed, Z total`
- Duration: Execution time
- No error messages

### Error Indicators

❌ **Red X marks**: Failures
- Error messages in output
- Non-zero exit codes
- Failed test counts

### Example Output Analysis

```
✅ Tests completed: 6 passed, 0 failed, 6 total
Errors encountered:
  - auth: authentication test failed: failed to create user: failed to generate address: eth_signer failed to generate address: fork/exec /path/to/eth_signer: no such file or directory
✅ All tests completed successfully
```

**Analysis**:
- 6 tests passed overall
- 1 error in auth category
- Missing `eth_signer` binary
- Overall success despite auth error

## Logging and Monitoring

### Log Files

Logs are stored in the `logs/` directory:

```
logs/
├── optimized_20250112_120000.log
├── optimized_20250112_120500.log
└── ...
```

### Log Levels

- `[1]` - Info (blue)
- `[2]` - Success (green)
- `[3]` - Warning (yellow)
- `[4]` - Error (red)

### Log Analysis

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

### Debug Mode

Enable verbose logging for debugging:

```bash
# Console mode
bash scripts/run_console.sh --verbose all

# Direct binary
./bin/terminal -category all -verbose
```

### Environment Validation

The console script performs comprehensive environment validation:

1. **Project Directory Check**: Verifies `go.mod` exists
2. **Configuration Check**: Validates `scripts/config.yaml` exists
3. **Mnemonic File Check**: Verifies `scripts/test_mnmeonic.txt` exists
4. **Category Validation**: Ensures test category is valid
5. **Binary Check**: Verifies required binaries exist

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

---

## Quick Reference

### Essential Commands
```bash
# Basic testing
bash scripts/run_console.sh simulation

# Verbose testing
bash scripts/run_console.sh --verbose all

# Timeout management
bash scripts/run_console.sh --timeout 10m auth

# Rebuild and test
bash scripts/run_console.sh --rebuild all
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
