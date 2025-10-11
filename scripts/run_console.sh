#!/bin/bash

# Terminal Console Run Script
# Launches the terminal application in console/command-line mode (non-TUI)

# Colors for output
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
RESET='\033[0m'

# Variables
WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BINARY_PATH="$WORKSPACE_ROOT/bin/terminal"
CONFIG_FILE="$WORKSPACE_ROOT/scripts/config.yaml"
MNEMONIC_FILE="$WORKSPACE_ROOT/scripts/test_mnmeonic.txt"
MORM_SIGNER_BIN="$WORKSPACE_ROOT/build/morm_signer"

# Default values
CATEGORY="simulation"
TIMEOUT="5m"
VERBOSE=false
REBUILD=false
HELP=false
TEST_AUTH=false

# Function to show help
show_help() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}║                    Terminal Console Run Script                                ║${RESET}"
    echo -e "${BLUE}║                           Usage Guide                                        ║${RESET}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${GREEN}USAGE:${RESET}"
    echo "  bash scripts/run_console.sh [OPTIONS] [CATEGORY]"
    echo ""
    echo -e "${GREEN}ARGUMENTS:${RESET}"
    echo "  CATEGORY               Test category to run (default: simulation)"
    echo "                        Available: simulation, auth, trading, performance, all"
    echo ""
    echo -e "${GREEN}OPTIONS:${RESET}"
    echo "  -r, --rebuild          Force rebuild of binary before running"
    echo "  -t, --timeout TIME     Set test timeout (default: 5m)"
    echo "  -v, --verbose          Enable verbose logging"
    echo "  -a, --test-auth        Test EIP-712 authentication only"
    echo "  -h, --help             Show this help message"
    echo ""
    echo -e "${GREEN}EXAMPLES:${RESET}"
    echo "  bash scripts/run_console.sh                    # Run simulation tests"
    echo "  bash scripts/run_console.sh trading             # Run trading tests"
    echo "  bash scripts/run_console.sh --verbose all       # Run all tests with verbose logging"
    echo "  bash scripts/run_console.sh --timeout 10m auth  # Run auth tests with 10min timeout"
    echo "  bash scripts/run_console.sh --test-auth         # Test authentication only"
    echo "  bash scripts/run_console.sh --rebuild performance # Rebuild and run performance tests"
    echo ""
    echo -e "${GREEN}CONFIGURATION:${RESET}"
    echo "  Config file: scripts/config.yaml"
    echo "  Mnemonic file: scripts/test_mnmeonic.txt"
    echo "  Binary: bin/terminal"
    echo "  Signer binary: build/morm_signer"
    echo ""
    echo -e "${GREEN}TEST CATEGORIES:${RESET}"
    echo "  ${YELLOW}simulation${RESET}     - Run simulation tests (default)"
    echo "  ${YELLOW}auth${RESET}           - Run authentication tests"
    echo "  ${YELLOW}trading${RESET}        - Run trading system tests"
    echo "  ${YELLOW}performance${RESET}    - Run performance tests"
    echo "  ${YELLOW}all${RESET}            - Run all test categories"
    echo ""
    echo -e "${BLUE}💡 TIP:${RESET} Use Ctrl+C to interrupt running tests"
}

# Function to parse YAML config file
parse_config() {
    print_info "Parsing configuration from $CONFIG_FILE..."
    
    # Extract values from YAML config using simple grep and sed
    if [[ -f "$CONFIG_FILE" ]]; then
        # Extract mnemonics_file path
        MNEMONIC_FILE_FROM_CONFIG=$(grep "mnemonics_file:" "$CONFIG_FILE" | sed 's/.*: *"\(.*\)".*/\1/' | sed 's/^\.\///' | xargs)
        if [[ -n "$MNEMONIC_FILE_FROM_CONFIG" ]]; then
            MNEMONIC_FILE="$WORKSPACE_ROOT/$MNEMONIC_FILE_FROM_CONFIG"
        fi
        
        # Extract morm_signer_bin path
        MORM_SIGNER_FROM_CONFIG=$(grep "morm_signer_bin:" "$CONFIG_FILE" | sed 's/.*: *"\(.*\)".*/\1/' | sed 's/^\.\///' | xargs)
        if [[ -n "$MORM_SIGNER_FROM_CONFIG" ]]; then
            MORM_SIGNER_BIN="$WORKSPACE_ROOT/$MORM_SIGNER_FROM_CONFIG"
        fi
        
        # Extract keys_dir path
        KEYS_DIR_FROM_CONFIG=$(grep "keys_dir:" "$CONFIG_FILE" | sed 's/.*: *"\(.*\)".*/\1/' | sed 's/^\.\///' | xargs)
        if [[ -n "$KEYS_DIR_FROM_CONFIG" ]]; then
            KEYS_DIR="$WORKSPACE_ROOT/$KEYS_DIR_FROM_CONFIG"
        else
            KEYS_DIR="$WORKSPACE_ROOT/scripts/keys"
        fi
        
        # Extract log_dir path
        LOG_DIR_FROM_CONFIG=$(grep "log_dir:" "$CONFIG_FILE" | sed 's/.*: *"\(.*\)".*/\1/' | sed 's/^\.\///' | xargs)
        if [[ -n "$LOG_DIR_FROM_CONFIG" ]]; then
            LOG_DIR="$WORKSPACE_ROOT/$LOG_DIR_FROM_CONFIG"
        else
            LOG_DIR="$WORKSPACE_ROOT/logs"
        fi
        
        # Extract reports_dir path
        REPORTS_DIR_FROM_CONFIG=$(grep "reports_dir:" "$CONFIG_FILE" | sed 's/.*: *"\(.*\)".*/\1/' | sed 's/^\.\///' | xargs)
        if [[ -n "$REPORTS_DIR_FROM_CONFIG" ]]; then
            REPORTS_DIR="$WORKSPACE_ROOT/$REPORTS_DIR_FROM_CONFIG"
        else
            REPORTS_DIR="$WORKSPACE_ROOT/test-results"
        fi
        
        print_success "Configuration loaded successfully"
        print_info "  Mnemonic file: $MNEMONIC_FILE"
        print_info "  Morm signer: $MORM_SIGNER_BIN"
        print_info "  Keys dir: $KEYS_DIR"
        print_info "  Log dir: $LOG_DIR"
        print_info "  Reports dir: $REPORTS_DIR"
    else
        print_warning "Config file not found, using default values"
    fi
}

# Function to print colored messages
print_info() {
    echo -e "${BLUE}ℹ️  $1${RESET}"
}

print_success() {
    echo -e "${GREEN}✅ $1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${RESET}"
}

print_error() {
    echo -e "${RED}❌ $1${RESET}"
}

# Function to validate environment
validate_environment() {
    print_info "Validating environment..."
    
    # Check if we're in the right directory
    if [[ ! -f "$WORKSPACE_ROOT/go.mod" ]]; then
        print_error "Not in terminal project directory. Please run from project root."
        exit 1
    fi
    
    # Check if config file exists
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_error "Configuration file not found: $CONFIG_FILE"
        exit 1
    fi
    
    # Check if mnemonic file exists
    if [[ ! -f "$MNEMONIC_FILE" ]]; then
        print_error "Mnemonic file not found: $MNEMONIC_FILE"
        exit 1
    fi
    
    # Validate category
    case "$CATEGORY" in
        simulation|auth|trading|performance|all)
            print_success "Valid test category: $CATEGORY"
            ;;
        *)
            print_error "Invalid test category: $CATEGORY"
            print_info "Available categories: simulation, auth, trading, performance, all"
            exit 1
            ;;
    esac
    
    print_success "Environment validation completed"
}

# Function to build binary if needed
build_binary() {
    if [[ $REBUILD == true ]] || [[ ! -f "$BINARY_PATH" ]]; then
        print_info "Building terminal binary for console mode..."
        
        # Change to workspace root
        cd "$WORKSPACE_ROOT" || exit 1
        
        # Build for console mode (no TUI dependencies)
        if make build-local; then
            print_success "Binary built successfully: $BINARY_PATH"
        else
            print_error "Failed to build binary"
            exit 1
        fi
    else
        print_info "Binary already exists: $BINARY_PATH"
    fi
}

# Function to check required binaries
check_required_binaries() {
    print_info "Checking required binaries..."
    
    # Check morm_signer (primary signer)
    if [[ ! -f "$MORM_SIGNER_BIN" ]]; then
        print_warning "morm_signer binary not found at $MORM_SIGNER_BIN"
        print_warning "Some tests may fail without morm_signer"
    fi
    
    print_success "Binary check completed"
}

# Function to launch console mode
launch_console() {
    print_info "Launching Terminal Console mode..."
    print_info "Category: $CATEGORY, Timeout: $TIMEOUT"
    
    # Change to workspace root
    cd "$WORKSPACE_ROOT" || exit 1
    
    # Prepare command arguments
    CMD_ARGS=("-category" "$CATEGORY" "-timeout" "$TIMEOUT")
    
    # Add verbose flag if requested
    if [[ $VERBOSE == true ]]; then
        CMD_ARGS+=("-verbose")
    fi
    
    # Add test-auth flag if requested
    if [[ $TEST_AUTH == true ]]; then
        CMD_ARGS+=("-test-auth")
    fi
    
    # Set environment variables for configuration
    export MNEMONICS_FILE="$MNEMONIC_FILE"
    export KEYS_DIR="$KEYS_DIR"
    export LOG_DIR="$LOG_DIR"
    export REPORTS_DIR="$REPORTS_DIR"
    export MORM_SIGNER_BIN="$MORM_SIGNER_BIN"
    
    print_info "Command: $BINARY_PATH ${CMD_ARGS[*]}"
    echo ""
    
    # Launch the application
    exec "$BINARY_PATH" "${CMD_ARGS[@]}"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--rebuild)
            REBUILD=true
            shift
            ;;
        -t|--timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -a|--test-auth)
            TEST_AUTH=true
            shift
            ;;
        -h|--help)
            HELP=true
            shift
            ;;
        -*)
            print_error "Unknown option: $1"
            echo ""
            show_help
            exit 1
            ;;
        *)
            # Check if it's a valid category
            case "$1" in
                simulation|auth|trading|performance|all)
                    CATEGORY="$1"
                    ;;
                *)
                    print_error "Invalid category: $1"
                    echo ""
                    show_help
                    exit 1
                    ;;
            esac
            shift
            ;;
    esac
done

# Show help if requested
if [[ $HELP == true ]]; then
    show_help
    exit 0
fi

# Main execution
echo -e "${BLUE}🚀 Starting Terminal Console Mode${RESET}"
echo ""

# Parse configuration from YAML file
parse_config

# Validate environment
validate_environment

# Check required binaries
check_required_binaries

# Build binary if needed
build_binary

# Launch console mode
launch_console
