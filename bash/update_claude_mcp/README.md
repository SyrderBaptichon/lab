# Claude Desktop MCP Update Script

A comprehensive script to automatically update your Claude Desktop MCP (Model Context Protocol) configuration when you update your Docker Desktop MCP Toolkit.

## Features

- 🔄 **Automatic configuration updates** for Claude Desktop MCP servers
- 💾 **Automatic backup** of existing configurations
- ✅ **Server validation** ensures only valid servers are used
- 🧪 **Configuration testing** before applying changes
- 🔒 **Error handling** with automatic rollback capability
- 🎨 **Colored output** for better readability
- 🔧 **Flexible server selection** with multiple options
- 📋 **Comprehensive logging** and status reporting

## Prerequisites

- Docker Desktop installed and running
- Docker MCP Toolkit enabled in Docker Desktop
- Claude Desktop installed
- Bash shell environment

## Installation

1. Download the script:
```bash
curl -o update-claude-mcp.sh https://raw.github.com/SyrderBaptichon/lab/main/bash/update_claude_mcp/update-claude-mcp.sh
```

2. Make it executable:
```bash
chmod +x update-claude-mcp.sh
```

3. (Optional) Add to your PATH or create an alias:
```bash
# Add to ~/.bashrc or ~/.zshrc
alias update-mcp='./path/to/update-claude-mcp.sh'
```

## Quick Start

```bash
# Update with default servers (jetbrains, obsidian)
./update-claude-mcp.sh

# Update with specific servers
./update-claude-mcp.sh jetbrains obsidian firecrawl

# List available servers
./update-claude-mcp.sh --list

# Test configuration without updating
./update-claude-mcp.sh --test jetbrains obsidian
```

## Usage

### Basic Commands

```bash
# Use default servers (jetbrains + obsidian)
./update-claude-mcp.sh

# Use multiple servers
./update-claude-mcp.sh jetbrains obsidian firecrawl grafana

# Use all available servers
./update-claude-mcp.sh $(docker mcp server list | tr ',' ' ')
```

### Advanced Options

```bash
# List all available servers
./update-claude-mcp.sh --list

# Test configuration without applying changes
./update-claude-mcp.sh --test jetbrains obsidian

# Show detailed help
./update-claude-mcp.sh --help

# Force use of default servers
./update-claude-mcp.sh --default
```

### Command Line Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help message |
| `-l, --list` | List available servers and exit |
| `-t, --test` | Test configuration without updating |
| `--default` | Use default servers (jetbrains, obsidian) |

## Configuration Files

- **Claude Desktop Config**: `~/.config/Claude/claude_desktop_config.json`
- **Backups Directory**: `~/.config/Claude/backups/`
- **Logs Directory**: `~/.config/Claude/logs/`

## Workflow

1. **Validation**: Checks Docker MCP Toolkit availability
2. **Server Check**: Validates specified servers exist
3. **Backup**: Creates timestamped backup of current config
4. **Generation**: Creates new configuration with specified servers
5. **Testing**: Tests configuration before applying
6. **Application**: Applies configuration if tests pass
7. **Summary**: Shows changes and next steps

## Example Output

```bash
$ ./update-claude-mcp.sh jetbrains obsidian

[INFO] Checking Docker MCP Toolkit availability...
[SUCCESS] Docker MCP Toolkit is available
[INFO] Creating backup of current configuration...
[SUCCESS] Backup created: ~/.config/Claude/backups/claude_desktop_config_20241015_014835.json
[INFO] Generating new configuration...
[INFO] Testing MCP configuration...
[SUCCESS] Configuration test passed
[SUCCESS] Configuration generated and tested successfully

[SUCCESS] Claude Desktop MCP configuration updated successfully!

Configuration Summary:
  Config file: ~/.config/Claude/claude_desktop_config.json
  Servers enabled: jetbrains obsidian

Next steps:
  1. Restart Claude Desktop to apply the changes
  2. Test the MCP tools in Claude Desktop

Available tools:
  > jetbrains: (30 tools)
  > obsidian: (12 tools)
```

## Troubleshooting

### Common Issues

#### Docker MCP Toolkit Not Available
```bash
Error: Docker MCP Toolkit is not available
```
**Solution**: 
- Ensure Docker Desktop is running
- Enable MCP Toolkit in Docker Desktop settings
- Check Docker Desktop version compatibility

#### Server Validation Fails
```bash
Warning: Server 'invalid-server' not found in available servers
```
**Solution**:
- Check available servers: `./update-claude-mcp.sh --list`
- Verify server names are spelled correctly
- Ensure servers are properly installed in Docker MCP Toolkit

#### Configuration Test Fails
```bash
Error: Configuration test failed
```
**Solution**:
- Some servers require API keys (firecrawl, grafana, etc.)
- Try with basic servers first: `./update-claude-mcp.sh jetbrains`
- Check Docker Desktop logs for detailed errors

#### Claude Desktop Not Recognizing Changes
**Solution**:
1. Completely restart Claude Desktop (not just reload)
2. Check Claude Desktop logs: `~/.config/Claude/logs/`
3. Verify configuration file syntax with JSON validator

### Getting Help

```bash
# Show detailed help
./update-claude-mcp.sh --help

# List available servers
./update-claude-mcp.sh --list

# Test specific configuration
./update-claude-mcp.sh --test <servers>

# Check Docker MCP status
docker mcp status
```

## Automation & Integration

### Shell Aliases

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Quick aliases
alias mcp-update='./path/to/update-claude-mcp.sh'
alias mcp-jetbrains='./path/to/update-claude-mcp.sh jetbrains'
alias mcp-obsidian='./path/to/update-claude-mcp.sh obsidian'
alias mcp-default='./path/to/update-claude-mcp.sh --default'
alias mcp-list='./path/to/update-claude-mcp.sh --list'

# Function to update and notify
mcp-restart() {
    echo "Updating MCP configuration..."
    ./path/to/update-claude-mcp.sh "$@"
    echo "✅ MCP configuration updated! Please restart Claude Desktop."
}
```

### Cron Job (Optional)

For automatic updates:

```bash
# Add to crontab (runs every hour)
0 * * * * /path/to/update-claude-mcp.sh --default >/dev/null 2>&1
```

## API Keys Setup

Some servers require API keys for full functionality:

### Firecrawl
```bash
# In Docker Desktop secrets or environment
FIRECRAWL_API_KEY=your_api_key_here
```

### Grafana
```bash
# In Docker Desktop secrets or environment
GRAFANA_API_KEY=your_api_key_here
```

### Obsidian
```bash
# In Docker Desktop secrets or environment
OBSIDIAN_API_KEY=your_api_key_here
OBSIDIAN_HOST=your_obsidian_host
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and test thoroughly
4. Commit your changes: `git commit -m 'Add feature'`
5. Push to the branch: `git push origin feature-name`
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 **Documentation**: Check this README and script help
- 🐛 **Issues**: Report bugs via GitHub Issues
- 💬 **Discussions**: Use GitHub Discussions for questions

## Changelog

### v1.0.0
- Initial release
- Support for all major Docker MCP Toolkit servers
- Automatic backup and rollback functionality
- Comprehensive error handling and validation
