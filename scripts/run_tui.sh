#!/bin/bash

# Terminal TUI Run Script
# Launches the terminal application in TUI mode with proper configuration

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
USERS=14  # All users from mnemonic file
INTERVAL="500ms"
REBUILD=false
VERBOSE=false
HELP=false

# Function to show help
show_help() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════════════════╗${RESET}"
    echo -e "${BLUE}║                    Terminal TUI Run Script                                   ║${RESET}"
    echo -e "${BLUE}║                           Usage Guide                                    ║${RESET}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════════════════╝${RESET}"
    echo ""
    echo -e "${GREEN}USAGE:${RESET}"
    echo "  bash scripts/run_tui.sh [OPTIONS] [USERS]"
    echo ""
    echo -e "${GREEN}ARGUMENTS:${RESET}"
    echo "  USERS                 Number of users to create (default: 14, max: 14)"
    echo ""
    echo -e "${GREEN}OPTIONS:${RESET}"
    echo "  -r, --rebuild         Force rebuild of binary before running"
    echo "  -i, --interval TIME   Set update interval (default: 500ms)"
    echo "  -v, --verbose          Enable verbose logging"
    echo "  -h, --help             Show this help message"
    echo ""
    echo -e "${GREEN}EXAMPLES:${RESET}"
    echo "  bash scripts/run_tui.sh                    # Run with all 14 users"
    echo "  bash scripts/run_tui.sh 5                 # Run with 5 users"
    echo "  bash scripts/run_tui.sh --interval 1s     # Run with 1 second interval"
    echo "  bash scripts/run_tui.sh --rebuild          # Force rebuild and run"
    echo "  bash scripts/run_tui.sh --verbose 10       # Run with verbose logging and 10 users"
    echo ""
    echo -e "${GREEN}CONFIGURATION:${RESET}"
    echo "  Config file: scripts/config.yaml"
    echo "  Mnemonic file: scripts/test_mnmeonic.txt"
    echo "  Binary: bin/terminal"
    echo "  Signer binary: build/morm_signer"
    echo ""
    echo -e "${BLUE}💡 TIP:${RESET} Use 'q' to quit the TUI, 'h' for help within the application"
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
    
    # Count available mnemonics
    # Check if file has content (handles files without trailing newline)
    if [[ ! -s "$MNEMONIC_FILE" ]]; then
        print_error "No mnemonics found in $MNEMONIC_FILE"
        exit 1
    fi
    # Count lines, but ensure we count at least 1 if file has content
    MNEMONIC_COUNT=$(wc -l < "$MNEMONIC_FILE" 2>/dev/null || echo "0")
    # If wc -l returns 0 but file has content, count it as 1 line
    if [[ $MNEMONIC_COUNT -eq 0 ]] && [[ -s "$MNEMONIC_FILE" ]]; then
        MNEMONIC_COUNT=1
    fi
    if [[ $MNEMONIC_COUNT -eq 0 ]]; then
        print_error "No mnemonics found in $MNEMONIC_FILE"
        exit 1
    fi
    
    # Validate user count
    if [[ $USERS -gt $MNEMONIC_COUNT ]]; then
        print_warning "Requested $USERS users, but only $MNEMONIC_COUNT mnemonics available. Using $MNEMONIC_COUNT users."
        USERS=$MNEMONIC_COUNT
    fi
    
    print_success "Environment validation completed"
}

# Function to build binary if needed
build_binary() {
    if [[ $REBUILD == true ]] || [[ ! -f "$BINARY_PATH" ]]; then
        print_info "Building terminal binary with TUI support..."
        
        # Change to workspace root
        cd "$WORKSPACE_ROOT" || exit 1
        
        # Build with TUI support
        if make build-tui; then
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
        print_warning "User generation may fail without morm_signer"
    fi
    
    print_success "Binary check completed"
}

# Function to launch TUI
launch_tui() {
    print_info "Launching Terminal TUI mode..."
    print_info "Users: $USERS, Interval: $INTERVAL"
    
    # Change to workspace root
    cd "$WORKSPACE_ROOT" || exit 1
    
    # Prepare command arguments (trim whitespace to prevent parse errors)
    USERS=$(echo "$USERS" | xargs)
    INTERVAL=$(echo "$INTERVAL" | xargs)
    # Convert absolute path to relative path from workspace root for config file
    CONFIG_RELATIVE="${CONFIG_FILE#$WORKSPACE_ROOT/}"
    CMD_ARGS=("-config" "$CONFIG_RELATIVE" "-tui" "-users" "$USERS" "-interval" "$INTERVAL")
    
    # Add verbose flag if requested
    if [[ $VERBOSE == true ]]; then
        CMD_ARGS+=("-verbose")
    fi
    
    # Set environment variables for configuration
    export MNEMONICS_FILE="$MNEMONIC_FILE"
    export KEYS_DIR="$KEYS_DIR"
    export LOG_DIR="$LOG_DIR"
    export REPORTS_DIR="$REPORTS_DIR"
    export MORM_SIGNER_BIN="$MORM_SIGNER_BIN"
    
    # Set TERM for TUI compatibility (required for termui)
    export TERM=xterm-256color
    
    print_info "Command: $BINARY_PATH ${CMD_ARGS[*]}"
    echo ""
    
    # TUI implementation is now fully integrated
    print_info "YAML config file loaded from: $CONFIG_FILE"
    print_info "TUI implementation is ready and integrated"
    print_info "Terminal type: $TERM"
    echo ""
    
    # CRITICAL FIX: Force PTY allocation for termui event polling on macOS
    # termui's PollEvents() requires a fully interactive pseudo-terminal (PTY)
    # macOS Terminal.app may appear interactive but still have PTY issues
    # Research shows macOS 'script' command is more reliable for Go TUIs
    # Always use 'script' on macOS for consistent PTY allocation
    
    # Check OS type
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS: Always use script for reliable PTY allocation
        # This ensures termui event polling works correctly regardless of shell context
        print_warning "macOS detected - forcing PTY allocation with 'script' for termui compatibility"
        print_info "This ensures reliable event polling (keyboard input, resizes) on macOS"
        
        # Check if 'script' command is available
        if ! command -v script &> /dev/null; then
            print_error "'script' command not found on macOS."
            print_error "This is unusual - 'script' should be available by default."
            print_error "Try running directly in Terminal.app:"
            print_error "  export TERM=xterm-256color"
            print_error "  $BINARY_PATH ${CMD_ARGS[*]}"
            exit 1
        fi
        
        # macOS script syntax: script -q /dev/null command args
        # -q: quiet mode (suppress script's own output)
        # /dev/null: suppress typescript file creation
        # Note: macOS script doesn't support -c option like Linux
        # This forces clean PTY allocation for termui's PollEvents()
        print_info "Using: script -q /dev/null $BINARY_PATH ${CMD_ARGS[*]}"
        exec script -q /dev/null "$BINARY_PATH" "${CMD_ARGS[@]}"
    else
        # Linux/Other: Check interactivity, use script if needed
        if [[ -t 0 ]] && [[ -t 1 ]] && [[ -t 2 ]]; then
            # Interactive terminal - run directly
            print_info "Running in interactive terminal - launching directly"
            exec "$BINARY_PATH" "${CMD_ARGS[@]}"
        else
            # Non-interactive - use script to allocate PTY
            print_warning "Not in fully interactive terminal - using 'script' to allocate PTY"
            print_info "This ensures termui event polling works correctly"
            
            if ! command -v script &> /dev/null; then
                print_error "'script' command not found."
                print_error "Please run in an interactive terminal:"
                print_error "  export TERM=xterm-256color"
                print_error "  $BINARY_PATH ${CMD_ARGS[*]}"
                exit 1
            fi
            
            # Linux script syntax: script -q -c "command args" /dev/null
            exec script -q -c "$BINARY_PATH ${CMD_ARGS[*]}" /dev/null
        fi
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -r|--rebuild)
            REBUILD=true
            shift
            ;;
        -i|--interval)
            INTERVAL="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
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
            # Check if it's a number (user count)
            if [[ $1 =~ ^[0-9]+$ ]]; then
                USERS=$(echo "$1" | xargs)  # Trim whitespace
            else
                print_error "Invalid argument: $1"
                echo ""
                show_help
                exit 1
            fi
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
echo -e "${BLUE}🚀 Starting Terminal TUI Mode${RESET}"
echo ""

# Parse configuration from YAML file
parse_config

# Validate environment
validate_environment

# Check required binaries
check_required_binaries

# Build binary if needed
build_binary

# Launch TUI
launch_tui
