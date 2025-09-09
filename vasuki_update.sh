#!/bin/bash
# Vasuki Update Script
# coded by CyberZest
# Updates all tools used in Vasuki reconnaissance suite

#### COLORS ####
BK="\e[38;5;166m" #Blink
GR="\e[32m"
YW="\e[93m"
NORMAL='\e[0m'
RED='\e[31m'
ORANGE='\e[38;5;202m'
LIGHT_GREEN='\e[92m'
LIGHT_YELLOW='\e[93m'
MAGENTA='\e[35m'
LIGHT_MAGENTA='\e[96m'
LIGHT_GREY='\e[90m'
BOLD='\e[1m'
UNDERLINE='\e[4m'
#############################################

# Banner
echo -e "${ORANGE}
\t\t\t\t██╗███╗░░██╗░██████╗████████╗░█████╗░██╗░░░░░██╗░░░░░░░░░░░██╗░░░██╗░█████╗░░██████╗██╗░░░██╗██╗░░██╗██╗
\t\t\t\t██║████╗░██║██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║░░░░░░░░░░░██║░░░██║██╔══██╗██╔════╝██║░░░██║██║░██╔╝██║
\t\t\t\t██║██╔██╗██║╚█████╗░░░░██║░░░███████║██║░░░░░██║░░░░░█████╗╚██╗░██╔╝███████║╚█████╗░██║░░░██║█████═╝░██║
\t\t\t\t██║██║╚████║░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░░░░░╚════╝░╚████╔╝░██╔══██║░╚═══██╗██║░░░██║██╔═██╗░██║
\t\t\t\t██║██║░╚███║██████╔╝░░░██║░░░██║░░██║███████╗███████╗░░░░░░░░╚██╔╝░░██║░░██║██████╔╝╚██████╔╝██║░╚██╗██║
\t\t\t\t╚═╝╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚══════╝░░░░░░░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░░╚═════╝░╚═╝░░╚═╝╚═╝
${NORMAL}"

echo -e "[${YW}VASUKI UPDATE${NORMAL}] == Updating all tools in Vasuki reconnaissance suite (${BOLD}${MAGENTA}@CyberZest${NORMAL})"
echo -e ""

# Check if running as root
if (( $EUID != 0 )); then
    echo -e "${RED}Please run as root (sudo) to update system packages and install tools globally${NORMAL}"
    exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get latest version from GitHub API
get_latest_version() {
    local repo=$1
    curl -s "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Function to get current version of a tool
get_current_version() {
    local tool=$1
    local version_cmd=$2
    
    if command_exists "$tool"; then
        eval "$version_cmd" 2>/dev/null | head -1
    else
        echo "not_installed"
    fi
}

# Function to update Go tools
update_go_tool() {
    local tool_name=$1
    local go_package=$2
    local version_cmd=$3
    
    echo -e "\n${BK}Updating $tool_name${NORMAL}"
    
    if command_exists "$tool_name"; then
        current_version=$(get_current_version "$tool_name" "$version_cmd")
        echo -e "Current version: ${LIGHT_YELLOW}$current_version${NORMAL}"
        
        echo -e "Installing latest version..."
        go install "$go_package@latest" > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            new_version=$(get_current_version "$tool_name" "$version_cmd")
            echo -e "${GR}✓ $tool_name updated successfully${NORMAL}"
            echo -e "New version: ${LIGHT_GREEN}$new_version${NORMAL}"
        else
            echo -e "${RED}✗ Failed to update $tool_name${NORMAL}"
        fi
    else
        echo -e "${LIGHT_YELLOW}$tool_name not installed, installing...${NORMAL}"
        go install "$go_package@latest" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "${GR}✓ $tool_name installed successfully${NORMAL}"
        else
            echo -e "${RED}✗ Failed to install $tool_name${NORMAL}"
        fi
    fi
}

# Function to update Python packages
update_python_package() {
    local package_name=$1
    local import_name=$2
    
    echo -e "\n${BK}Updating $package_name${NORMAL}"
    
    if python3 -c "import $import_name" 2>/dev/null; then
        current_version=$(python3 -c "import $import_name; print(getattr($import_name, '__version__', 'unknown'))" 2>/dev/null)
        echo -e "Current version: ${LIGHT_YELLOW}$current_version${NORMAL}"
    else
        echo -e "${LIGHT_YELLOW}$package_name not installed${NORMAL}"
    fi
    
    echo -e "Installing/updating latest version..."
    pip3 install --upgrade "$package_name" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        new_version=$(python3 -c "import $import_name; print(getattr($import_name, '__version__', 'unknown'))" 2>/dev/null)
        echo -e "${GR}✓ $package_name updated successfully${NORMAL}"
        echo -e "New version: ${LIGHT_GREEN}$new_version${NORMAL}"
    else
        echo -e "${RED}✗ Failed to update $package_name${NORMAL}"
    fi
}

# Function to update system packages
update_system_packages() {
    echo -e "\n${BK}${BOLD}${UNDERLINE}${MAGENTA}UPDATING SYSTEM PACKAGES${NORMAL}"
    
    echo -e "Updating package lists..."
    apt update > /dev/null 2>&1
    
    echo -e "Upgrading system packages..."
    apt upgrade -y > /dev/null 2>&1
    
    echo -e "Installing/updating essential packages..."
    apt install -y curl wget git jq python3 python3-pip build-essential libpcap-dev > /dev/null 2>&1
    
    echo -e "${GR}✓ System packages updated${NORMAL}"
}

# Function to update Go language
update_go() {
    echo -e "\n${BK}Checking Go installation${NORMAL}"
    
    if command_exists go; then
        current_version=$(go version | awk '{print $3}')
        echo -e "Current Go version: ${LIGHT_YELLOW}$current_version${NORMAL}"
        
        # Get latest Go version
        latest_version=$(curl -s https://go.dev/VERSION?m=text | grep -o 'go[0-9.]*')
        echo -e "Latest Go version: ${LIGHT_GREEN}$latest_version${NORMAL}"
        
        if [ "$current_version" != "$latest_version" ]; then
            echo -e "Updating Go to $latest_version..."
            wget -q "https://go.dev/dl/$latest_version.linux-amd64.tar.gz"
            rm -rf /usr/local/go
            tar -C /usr/local -xzf "$latest_version.linux-amd64.tar.gz"
            rm "$latest_version.linux-amd64.tar.gz"
            echo -e "${GR}✓ Go updated to $latest_version${NORMAL}"
        else
            echo -e "${GR}✓ Go is already up to date${NORMAL}"
        fi
    else
        echo -e "${LIGHT_YELLOW}Go not installed, installing latest version...${NORMAL}"
        latest_version=$(curl -s https://go.dev/VERSION?m=text | grep -o 'go[0-9.]*')
        wget -q "https://go.dev/dl/$latest_version.linux-amd64.tar.gz"
        tar -C /usr/local -xzf "$latest_version.linux-amd64.tar.gz"
        rm "$latest_version.linux-amd64.tar.gz"
        echo -e "${GR}✓ Go installed successfully${NORMAL}"
    fi
    
    # Update PATH
    export PATH=$PATH:/usr/local/go/bin
    echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
}

# Function to update GitHub-based tools
update_github_tool() {
    local tool_name=$1
    local repo=$2
    local binary_name=$3
    local install_cmd=$4
    
    echo -e "\n${BK}Updating $tool_name${NORMAL}"
    
    if command_exists "$tool_name"; then
        echo -e "Current $tool_name is installed"
    else
        echo -e "${LIGHT_YELLOW}$tool_name not installed${NORMAL}"
    fi
    
    echo -e "Installing/updating latest version..."
    eval "$install_cmd" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo -e "${GR}✓ $tool_name updated successfully${NORMAL}"
    else
        echo -e "${RED}✗ Failed to update $tool_name${NORMAL}"
    fi
}

# Main update function
main() {
    echo -e "${BOLD}${LIGHT_MAGENTA}Starting Vasuki tools update...${NORMAL}\n"
    
    # Update system packages first
    update_system_packages
    
    # Update Go
    update_go
    
    # Update Go-based tools
    echo -e "\n${BK}${BOLD}${UNDERLINE}${MAGENTA}UPDATING GO-BASED TOOLS${NORMAL}"
    
    update_go_tool "subfinder" "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest" "subfinder -version"
    update_go_tool "nuclei" "github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest" "nuclei -version"
    update_go_tool "httpx" "github.com/projectdiscovery/httpx/cmd/httpx@latest" "httpx -version"
    update_go_tool "naabu" "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest" "naabu -version"
    update_go_tool "dnsx" "github.com/projectdiscovery/dnsx/cmd/dnsx@latest" "dnsx -version"
    update_go_tool "notify" "github.com/projectdiscovery/notify/cmd/notify@latest" "notify -version"
    update_go_tool "assetfinder" "github.com/tomnomnom/assetfinder@latest" "assetfinder -version"
    update_go_tool "anew" "github.com/tomnomnom/anew@latest" "anew -version"
    update_go_tool "gau" "github.com/lc/gau/v2/cmd/gau@latest" "gau -version"
    update_go_tool "waybackurls" "github.com/tomnomnom/waybackurls@latest" "waybackurls -version"
    update_go_tool "gobuster" "github.com/OJ/gobuster/v3@latest" "gobuster version"
    update_go_tool "gf" "github.com/tomnomnom/gf@latest" "gf -version"
    update_go_tool "httprobe" "github.com/tomnomnom/httprobe@latest" "httprobe -version"
    update_go_tool "ffuf" "github.com/ffuf/ffuf@latest" "ffuf -V"
    update_go_tool "dalfox" "github.com/hahwul/dalfox/v2@latest" "dalfox version"
    update_go_tool "crlfuzz" "github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest" "crlfuzz -version"
    update_go_tool "kxss" "github.com/Emoe/kxss@latest" "kxss -version"
    update_go_tool "gxss" "github.com/KathanP19/Gxss@latest" "gxss -version"
    update_go_tool "qsreplace" "github.com/tomnomnom/qsreplace@latest" "qsreplace -version"
    update_go_tool "amass" "github.com/owasp-amass/amass/v4/...@master" "amass version"
    update_go_tool "katana" "github.com/projectdiscovery/katana/cmd/katana@latest" "katana -version"
    update_go_tool "jaeles" "github.com/jaeles-project/jaeles@latest" "jaeles version"
    update_go_tool "trufflehog" "github.com/trufflesecurity/trufflehog/v3@latest" "trufflehog version"
    update_go_tool "gitleaks" "github.com/zricethezav/gitleaks/v8@latest" "gitleaks version"
    update_go_tool "unfurl" "github.com/tomnomnom/unfurl@latest" "unfurl -version"
    update_go_tool "meg" "github.com/tomnomnom/meg@latest" "meg -version"
    update_go_tool "hakrawler" "github.com/hakluke/hakrawler@latest" "hakrawler -version"
    update_go_tool "jeeves" "github.com/ferreiraklet/Jeeves@latest" "jeeves -version"
    
    # Update Python packages
    echo -e "\n${BK}${BOLD}${UNDERLINE}${MAGENTA}UPDATING PYTHON PACKAGES${NORMAL}"
    
    update_python_package "bhedak" "bhedak"
    update_python_package "uro" "uro"
    update_python_package "tldextract" "tldextract"
    update_python_package "agnee" "agnee"
    update_python_package "paramspider" "paramspider"
    update_python_package "arjun" "arjun"
    update_python_package "linkfinder" "linkfinder"
    update_python_package "wfuzz" "wfuzz"
    update_python_package "interlace" "interlace"
    
    # Update GitHub-based tools
    echo -e "\n${BK}${BOLD}${UNDERLINE}${MAGENTA}UPDATING GITHUB-BASED TOOLS${NORMAL}"
    
    # Findomain
    update_github_tool "findomain" "findomain/findomain" "findomain" "
        curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip
        unzip -o findomain-linux-i386.zip > /dev/null 2>&1
        chmod +x findomain
        mv findomain /usr/bin/ > /dev/null 2>&1
        rm -f findomain* LICENSE.txt README.md
    "
    
    # Aquatone
    update_github_tool "aquatone" "michenriksen/aquatone" "aquatone" "
        wget -q https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
        unzip -o aquatone_linux_amd64_1.7.0.zip > /dev/null 2>&1
        mv aquatone /usr/bin/ > /dev/null 2>&1
        rm -f aquatone* LICENSE.txt README.md
    "
    
    # Massdns
    update_github_tool "massdns" "blechschmidt/massdns" "massdns" "
        cd /tmp
        git clone https://github.com/blechschmidt/massdns.git -q
        cd massdns
        make > /dev/null 2>&1
        make install > /dev/null 2>&1
        cp bin/massdns /usr/bin/
        cd /
        rm -rf /tmp/massdns
    "
    
    # Masscan
    update_github_tool "masscan" "robertdavidgraham/masscan" "masscan" "
        cd /tmp
        git clone https://github.com/robertdavidgraham/masscan.git -q
        cd masscan
        make > /dev/null 2>&1
        make install > /dev/null 2>&1
        cp bin/masscan /usr/bin/
        cd /
        rm -rf /tmp/masscan
    "
    
    # GoSpider
    update_github_tool "gospider" "jaeles-project/gospider" "gospider" "
        cd /tmp
        git clone https://github.com/jaeles-project/gospider.git -q
        cd gospider
        go install > /dev/null 2>&1
        cd /
        rm -rf /tmp/gospider
    "
    
    # Update Nuclei templates
    echo -e "\n${BK}Updating Nuclei templates${NORMAL}"
    if command_exists nuclei; then
        nuclei -update-templates > /dev/null 2>&1
        echo -e "${GR}✓ Nuclei templates updated${NORMAL}"
    else
        echo -e "${LIGHT_YELLOW}Nuclei not installed, skipping template update${NORMAL}"
    fi
    
    # Update GF patterns
    echo -e "\n${BK}Updating GF patterns${NORMAL}"
    if [ -d ~/.gf ]; then
        cd /tmp
        git clone https://github.com/1ndianl33t/Gf-Patterns.git -q
        cp Gf-Patterns/*.json ~/.gf/ 2>/dev/null
        rm -rf Gf-Patterns
        echo -e "${GR}✓ GF patterns updated${NORMAL}"
    else
        echo -e "${LIGHT_YELLOW}GF directory not found, creating and updating patterns${NORMAL}"
        mkdir -p ~/.gf
        cd /tmp
        git clone https://github.com/1ndianl33t/Gf-Patterns.git -q
        cp Gf-Patterns/*.json ~/.gf/
        rm -rf Gf-Patterns
        echo -e "${GR}✓ GF patterns installed${NORMAL}"
    fi
    
    # Update wordlists
    echo -e "\n${BK}Updating wordlists${NORMAL}"
    mkdir -p ~/vasuki/wordlists
    cd ~/vasuki/wordlists
    
    # Update subdomains wordlist
    wget -q -O subdomains.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/deepmagic.com-prefixes-top50000.txt
    echo -e "${GR}✓ Subdomains wordlist updated${NORMAL}"
    
    # Update resolvers
    wget -q -O resolvers.txt https://raw.githubusercontent.com/janmasarik/resolvers/master/resolvers.txt
    echo -e "${GR}✓ Resolvers list updated${NORMAL}"
    
    # Update fuzz wordlist
    wget -q -O fuzz.txt https://raw.githubusercontent.com/Bo0oM/fuzz.txt/master/fuzz.txt
    echo -e "${GR}✓ Fuzz wordlist updated${NORMAL}"
    
    # Copy Go binaries to system PATH
    echo -e "\n${BK}Copying Go binaries to system PATH${NORMAL}"
    if [ -d ~/go/bin ]; then
        cp ~/go/bin/* /usr/bin/ 2>/dev/null
        echo -e "${GR}✓ Go binaries copied to /usr/bin/${NORMAL}"
    fi
    
    # Update Vasuki script itself
    echo -e "\n${BK}Checking for Vasuki script updates${NORMAL}"
    if [ -f /usr/bin/vasuki ]; then
        echo -e "${GR}✓ Vasuki script is installed${NORMAL}"
        echo -e "${LIGHT_YELLOW}Note: To update the Vasuki script itself, please pull from the repository${NORMAL}"
    fi
    
    echo -e "\n${BOLD}${LIGHT_GREEN}🎉 Vasuki tools update completed!${NORMAL}"
    echo -e "${LIGHT_YELLOW}Please run 'source ~/.bashrc' or restart your terminal to use updated tools${NORMAL}"
    echo -e "\n${BOLD}${LIGHT_MAGENTA}Happy Hunting! 🐛${NORMAL}"
}

# Run main function
main "$@"
