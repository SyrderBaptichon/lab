#!/bin/bash

# Script to update Claude Desktop MCP configuration when Docker Desktop MCP Toolkit is updated
# Usage: ./update-claude-mcp.sh [servers...]
# Example: ./update-claude-mcp.sh jetbrains obsidian
# Example: ./update-claude-mcp.sh jetbrains obsidian firecrawl grafana

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CLAUDE_CONFIG_DIR="$HOME/.config/Claude"
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"
BACKUP_DIR="$HOME/.config/Claude/backups"

# Default servers if none specified
DEFAULT_SERVERS=("jetbrains" "obsidian")

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker MCP is available
check_docker_mcp() {
    print_status "Checking Docker MCP Toolkit availability..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed or not in PATH"
        exit 1
    fi
    
    if ! docker mcp --help &> /dev/null; then
        print_error "Docker MCP Toolkit is not available. Make sure Docker Desktop is running and MCP Toolkit is enabled."
        exit 1
    fi
    
    print_success "Docker MCP Toolkit is available"
}

# Function to get available servers
get_available_servers() {
    print_status "Fetching available MCP servers..."
    docker mcp server list 2>/dev/null || {
        print_error "Failed to get available servers. Make sure Docker MCP Toolkit is properly configured."
        exit 1
    }
}

# Function to validate servers
validate_servers() {
    local servers=("$@")
    local available_servers
    available_servers=$(docker mcp server list 2>/dev/null | tr ',' ' ')
    
    for server in "${servers[@]}"; do
        if ! echo "$available_servers" | grep -q "\b$server\b"; then
            print_warning "Server '$server' not found in available servers:"
            echo "$available_servers"
            return 1
        fi
    done
    return 0
}

# Function to create backup
create_backup() {
    if [[ -f "$CLAUDE_CONFIG_FILE" ]]; then
        print_status "Creating backup of current configuration..."
        
        mkdir -p "$BACKUP_DIR"
        local backup_file="$BACKUP_DIR/claude_desktop_config_$(date +%Y%m%d_%H%M%S).json"
        cp "$CLAUDE_CONFIG_FILE" "$backup_file"
        print_success "Backup created: $backup_file"
    fi
}

# Function to generate configuration
generate_config() {
    local servers=("$@")
    
    # Generate the configuration JSON
    cat > "$CLAUDE_CONFIG_FILE" << EOF
{
  "mcpServers": {
    "docker": {
      "command": "docker",
      "args": ["mcp", "gateway", "run", "--transport", "stdio"$(printf ', "--servers", "%s"' "${servers[@]}")]
    }
  }
}
EOF
}

# Function to test configuration
test_configuration() {
    local servers=("$@")
    print_status "Testing MCP configuration..."
    
    # Build test arguments
    local test_args=("--transport" "stdio")
    for server in "${servers[@]}"; do
        test_args+=("--servers" "$server")
    done
    test_args+=("--dry-run")
    
    # Test with dry run
    if timeout 30 docker mcp gateway run "${test_args[@]}" &> /dev/null; then
        print_success "Configuration test passed"
        return 0
    else
        print_error "Configuration test failed"
        return 1
    fi
}

# Function to show configuration summary
show_summary() {
    local servers=("$@")
    echo
    print_success "Claude Desktop MCP configuration updated successfully!"
    echo
    echo -e "${BLUE}Configuration Summary:${NC}"
    echo -e "  Config file: $CLAUDE_CONFIG_FILE"
    echo -e "  Servers enabled: ${servers[*]}"
    echo
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "  1. Restart Claude Desktop to apply the changes"
    echo -e "  2. Test the MCP tools in Claude Desktop"
    echo
    echo -e "${BLUE}Available tools:${NC}"
    local summary_args=("--transport" "stdio")
    for server in "${servers[@]}"; do
        summary_args+=("--servers" "$server")
    done
    summary_args+=("--dry-run")
    timeout 30 docker mcp gateway run "${summary_args[@]}" 2>/dev/null | grep -E "^\s*>" || true
    echo
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTIONS] [SERVERS...]"
    echo
    echo "Update Claude Desktop MCP configuration with Docker Desktop MCP Toolkit servers"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -l, --list     List available servers and exit"
    echo "  -t, --test     Test configuration without updating"
    echo "  --default      Use default servers (jetbrains, obsidian)"
    echo
    echo "Examples:"
    echo "  $0                                    # Use default servers"
    echo "  $0 --default                          # Use default servers"
    echo "  $0 jetbrains                          # Use only jetbrains"
    echo "  $0 jetbrains obsidian                 # Use jetbrains and obsidian"
    echo "  $0 jetbrains obsidian firecrawl       # Use multiple servers"
    echo "  $0 -l                                 # List available servers"
    echo "  $0 --test jetbrains obsidian          # Test configuration"
    echo
    echo "Available servers:"
    docker mcp server list 2>/dev/null | sed 's/^/  /' || echo "  (Unable to fetch servers)"
}

# Main function
main() {
    local servers=()
    local list_only=false
    local test_only=false
    local use_default=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -l|--list)
                list_only=true
                shift
                ;;
            -t|--test)
                test_only=true
                shift
                ;;
            --default)
                use_default=true
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                servers+=("$1")
                shift
                ;;
        esac
    done
    
    # Check Docker MCP availability
    check_docker_mcp
    
    # Handle list option
    if [[ "$list_only" == true ]]; then
        echo -e "${BLUE}Available MCP servers:${NC}"
        get_available_servers
        exit 0
    fi
    
    # Determine servers to use
    if [[ ${#servers[@]} -eq 0 ]]; then
        if [[ "$use_default" == true ]]; then
            servers=("${DEFAULT_SERVERS[@]}")
        else
            print_status "No servers specified. Using default servers: ${DEFAULT_SERVERS[*]}"
            servers=("${DEFAULT_SERVERS[@]}")
        fi
    fi
    
    # Validate servers
    if ! validate_servers "${servers[@]}"; then
        print_error "Invalid server(s) specified"
        exit 1
    fi
    
    # Test configuration if requested
    if [[ "$test_only" == true ]]; then
        if test_configuration "${servers[@]}"; then
            print_success "Configuration test passed!"
            exit 0
        else
            print_error "Configuration test failed!"
            exit 1
        fi
    fi
    
    # Create backup
    create_backup
    
    # Ensure config directory exists
    mkdir -p "$CLAUDE_CONFIG_DIR"
    
    # Generate new configuration
    print_status "Generating new configuration..."
    generate_config "${servers[@]}"
    
    # Test the configuration
    if test_configuration "${servers[@]}"; then
        print_success "Configuration generated and tested successfully"
        show_summary "${servers[@]}"
    else
        print_error "Configuration test failed. Rolling back..."
        # Restore from backup if available
        local latest_backup
        latest_backup=$(ls -t "$BACKUP_DIR"/claude_desktop_config_*.json 2>/dev/null | head -n1)
        if [[ -n "$latest_backup" ]]; then
            cp "$latest_backup" "$CLAUDE_CONFIG_FILE"
            print_success "Configuration restored from backup"
        fi
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
