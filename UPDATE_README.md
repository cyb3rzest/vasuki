# Vasuki Update Script

## Overview
The `vasuki_update.sh` script automatically updates all tools and dependencies used in the Vasuki reconnaissance suite. This ensures you always have the latest versions of all security tools for optimal performance and security.

## Features
- ✅ Updates all Go-based tools to latest versions
- ✅ Updates Python packages
- ✅ Updates system packages
- ✅ Updates Go language itself
- ✅ Updates GitHub-based tools (findomain, aquatone, massdns, masscan, gospider)
- ✅ Updates Nuclei templates
- ✅ Updates GF patterns
- ✅ Updates wordlists
- ✅ Version checking and reporting
- ✅ Colorized output with progress indicators

## Usage

### Basic Usage
```bash
sudo ./vasuki_update.sh
```

### Prerequisites
- Root/sudo access (required for system package updates and global tool installation)
- Internet connection
- Go language installed (will be installed/updated automatically)

## What Gets Updated

### Go-based Tools
- subfinder
- nuclei
- httpx
- naabu
- dnsx
- notify
- assetfinder
- anew
- gau
- waybackurls
- gobuster
- gf
- httprobe
- ffuf
- dalfox
- crlfuzz
- kxss
- gxss
- qsreplace
- amass

### Python Packages
- bhedak
- uro
- tldextract
- agnee

### GitHub-based Tools
- findomain
- aquatone
- massdns
- masscan
- gospider

### Additional Updates
- Nuclei templates
- GF patterns
- Wordlists (subdomains, resolvers, fuzz)
- System packages

## Output
The script provides colorized output showing:
- Current versions of installed tools
- Update progress for each tool
- Success/failure status
- New versions after updates

## Example Output
```
[VASUKI UPDATE] == Updating all tools in Vasuki reconnaissance suite (@CyberZest)

UPDATING SYSTEM PACKAGES
✓ System packages updated

Checking Go installation
Current Go version: go1.19.5
Latest Go version: go1.21.0
Updating Go to go1.21.0...
✓ Go updated to go1.21.0

UPDATING GO-BASED TOOLS

Updating subfinder
Current version: v2.5.3
Installing latest version...
✓ subfinder updated successfully
New version: v2.5.4

Updating nuclei
Current version: v2.9.6
Installing latest version...
✓ nuclei updated successfully
New version: v2.9.7

...

🎉 Vasuki tools update completed!
Please run 'source ~/.bashrc' or restart your terminal to use updated tools

Happy Hunting! 🐛
```

## Troubleshooting

### Permission Issues
Make sure to run with sudo:
```bash
sudo ./vasuki_update.sh
```

### Network Issues
Ensure you have a stable internet connection as the script downloads updates from various sources.

### Go Installation Issues
If Go installation fails, you can install it manually:
```bash
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```

### Tool Not Found After Update
After running the update script, run:
```bash
source ~/.bashrc
```
Or restart your terminal to refresh the PATH.

## Safety Notes
- The script updates tools globally, which may affect other projects
- Always backup your system before running major updates
- Test tools after updates to ensure compatibility
- Some tools may have breaking changes in major version updates

## Contributing
If you find issues or want to add support for additional tools, please:
1. Check the tool's update mechanism
2. Add appropriate update logic to the script
3. Test thoroughly before submitting

## License
Same as Vasuki project - Boost Software License
