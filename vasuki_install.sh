#!/bin/bash
# coded by CyberZest
# inspired by Asheem Shrey
# Vasuki - version 3.2 (Fixed)

#### COLORS #### ( Taken from : https://misc.flogisoft.com/bash/tip_colors_and_formatting )
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

# Shell detection and configuration
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_TYPE="zsh"
        SHELL_RC="$HOME/.zshrc"
        echo -e "${LIGHT_YELLOW}Detected ZSH shell - using .zshrc${NORMAL}"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_TYPE="bash"
        SHELL_RC="$HOME/.bashrc"
        echo -e "${LIGHT_YELLOW}Detected BASH shell - using .bashrc${NORMAL}"
    else
        # Fallback detection
        CURRENT_SHELL=$(basename "$SHELL")
        if [ "$CURRENT_SHELL" = "zsh" ]; then
            SHELL_TYPE="zsh"
            SHELL_RC="$HOME/.zshrc"
            echo -e "${LIGHT_YELLOW}Detected ZSH shell (fallback) - using .zshrc${NORMAL}"
        else
            SHELL_TYPE="bash"
            SHELL_RC="$HOME/.bashrc"
            echo -e "${LIGHT_YELLOW}Detected BASH shell (fallback) - using .bashrc${NORMAL}"
        fi
    fi
}

# Function to add configuration to shell RC file
add_to_shell_rc() {
    local config_line="$1"
    local comment="$2"
    
    if [ -n "$comment" ]; then
        echo "# $comment" >> "$SHELL_RC"
    fi
    echo "$config_line" >> "$SHELL_RC"
}

echo -e "${ORANGE}
|\t\t\t\t██╗███╗░░██╗░██████╗████████╗░█████╗░██╗░░░░░██╗░░░░░░░░░░░██╗░░░██╗░█████╗░░██████╗██╗░░░██╗██╗░░██╗██╗
|\t\t\t\t██║████╗░██║██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║░░░░░░░░░░░██║░░░██║██╔══██╗██╔════╝██║░░░██║██║░██╔╝██║
|\t\t\t\t██║██╔██╗██║╚█████╗░░░░██║░░░███████║██║░░░░░██║░░░░░█████╗╚██╗░██╔╝███████║╚█████╗░██║░░░██║█████═╝░██║
|\t\t\t\t██║██║╚████║░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░░░░░╚════╝░╚████╔╝░██╔══██║░╚═══██╗██║░░░██║██╔═██╗░██║
|\t\t\t\t██║██║░╚███║██████╔╝░░░██║░░░██║░░██║███████╗███████╗░░░░░░░░╚██╔╝░░██║░░██║██████╔╝╚██████╔╝██║░╚██╗██║
|\t\t\t\t╚═╝╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚══════╝░░░░░░░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░░╚═════╝░╚═╝░░╚═╝╚═╝
${NORMAL}"

if (( $EUID != 0 )); then
    echo -e "Make sure you're ${BOLD}${RED}ROOT USER${NORMAL} before running this script"
    exit 1
fi

# Detect shell and set configuration
detect_shell

folders(){
    mkdir -p ~/vasuki
    mkdir -p ~/vasuki/.tmp
    mkdir -p ~/.gf
    mkdir -p ~/vasuki/wordlists
}

golanguage(){
    echo -e "${BK}Installing GO-Language${NORMAL}"
    goversion=$(curl -ks -L https://go.dev/VERSION?m=text | grep -o 'go[0-9.]*')
    wget https://go.dev/dl/$goversion.linux-amd64.tar.gz -q
    rm -rf /usr/local/go && tar -C /usr/local -xzf $goversion.linux-amd64.tar.gz
    export PATH=$PATH:/usr/local/go/bin
    
    # Add to appropriate shell RC file
    add_to_shell_rc "export PATH=\$PATH:/usr/local/go/bin" "Go binary path"
    
    # Add GF completion based on shell type
    if [ "$SHELL_TYPE" = "zsh" ]; then
        add_to_shell_rc "source ~/go/pkg/mod/github.com/tomnomnom/gf@*/gf-completion.zsh" "GF completion for zsh"
    else
        add_to_shell_rc "source ~/go/pkg/mod/github.com/tomnomnom/gf@*/gf-completion.bash" "GF completion for bash"
    fi
    
    # Source the shell RC file
    if [ -f "$SHELL_RC" ]; then
        source "$SHELL_RC"
    fi
    
    # Copy GF examples
    if [ -d ~/go/pkg/mod/github.com/tomnomnom/gf@* ]; then
        cp -r ~/go/pkg/mod/github.com/tomnomnom/gf@*/examples ~/.gf 2>/dev/null
    fi
    
    if command -v go &> /dev/null; then
        echo -e "\n${GR}GO INSTALLED SUCCESSFULLY${NORMAL}"
    else
        echo -e "\n${YW}THERE'S A PROBLEM IN INSTALLING ${LIGHT_GREEN}GO${NORMAL}, TRY INSTALLING IT MANUALLY${NORMAL}"
    fi
    rm -rf $goversion.linux-amd64.tar.gz
}

dependencies(){
    # Move patterns if they exist
    if [ -d .github/payloads/patterns ]; then
        mv .github/payloads/patterns/*.json ~/.gf/ 2> /dev/null
    fi
    cd ~
    
    echo -e "${BK}${BOLD}${UNDERLINE}${MAGENTA}INSTALLING ALL DEPENDENCIES${NORMAL}"
    apt update > /dev/null 2>&1
    apt upgrade -y > /dev/null 2>&1
    apt install theHarvester whois whatweb nslookup -y > /dev/null 2>&1
    
    # Install Python requirements if file exists
    if [ -f ~/vasuki/requirements.txt ]; then
        pip3 install -r ~/vasuki/requirements.txt > /dev/null 2>&1
    fi
    
    apt install apt-transport-https bsdmainutils build-essential snapd cmake curl dnsutils gcc git jq libdata-hexdump-perl libffi-dev libpcap-dev libssl-dev libxml2-dev libxml2-utils libxslt1-dev lynx medusa nmap procps pv python3 python3-dev python3-pip wget zip unzip zlib1g-dev libpcap-dev screen make gcc -y > /dev/null 2>&1
    apt install chromium -y > /dev/null 2>&1
    
    # Configure chromium
    if [ -f /etc/chromium-browser/default ]; then
        echo "exec -a \"\$0\" \"\$HERE/chrome\" \"\$@\" --userdata-dir --no-sandbox" >> /etc/chromium-browser/default
        echo "CHROMIUM_FLAGS=\"--user-data-dir\"" >> /etc/chromium-browser/default
    fi
    
    # Clone and setup GF patterns
    cd /root/ && git clone https://github.com/1ndianl33t/Gf-Patterns.git -q
    if [ -d Gf-Patterns ]; then
        mv Gf-Patterns/*.json ~/.gf/ 2>/dev/null
        rm -rf Gf-Patterns
    fi
    echo -e "${GR}SUCCESS${NORMAL}\n"
}

githubd(){
    echo -e "${BK}CHECKING & DOWNLOADING AND INSTALLING ALL TOOLS FROM GITHUB.${NORMAL}\n"
    
    echo -e "\n- Installing Bhedak"
    pip3 install bhedak > /dev/null 2>&1
    pip3 install tldextract > /dev/null 2>&1
    if command -v bhedak &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING BHEDAK MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing uro"
    pip3 install uro > /dev/null 2>&1
    if command -v uro &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING URO MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing anew"
    go install github.com/tomnomnom/anew@latest > /dev/null 2>&1
    if [ -f ~/go/bin/anew ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING ANEW MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing WhatWeb"
    apt install whatweb html2text -y > /dev/null 2>&1
    if command -v whatweb &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING WhatWeb MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing naabu"
    go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest > /dev/null 2>&1
    if [ -f ~/go/bin/naabu ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING NAABU MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing gobuster"
    go install github.com/OJ/gobuster/v3@latest > /dev/null 2>&1
    if [ -f ~/go/bin/gobuster ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING GO-BUSTER MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing gf"
    go install github.com/tomnomnom/gf@latest > /dev/null 2>&1
    if [ -f ~/go/bin/gf ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING GF MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing gospider"
    cd ~/vasuki/.tmp/ && git clone https://github.com/jaeles-project/gospider.git -q
    cd gospider 2> /dev/null
    go install > /dev/null 2>&1
    if [ -f ~/go/bin/gospider ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING GOSPIDER MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing findomain"
    curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip > /dev/null 2>&1
    unzip findomain-linux-i386.zip > /dev/null 2>&1
    chmod +x findomain
    mv findomain /usr/bin/ > /dev/null 2>&1
    rm -rf findomain* LICENSE.txt README.md
    if command -v findomain &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING FINDOMAIN MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing aquatone"
    wget -q https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip > /dev/null 2>&1
    unzip aquatone_linux_amd64_1.7.0.zip > /dev/null 2>&1
    mv aquatone /usr/bin/ > /dev/null 2>&1
    rm -rf aquatone* LICENSE.txt README.md
    if command -v aquatone &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING AQUATONE MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing assetfinder"
    go install github.com/tomnomnom/assetfinder@latest > /dev/null 2>&1
    if [ -f ~/go/bin/assetfinder ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING ASSETFINDER MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing gau"
    go install github.com/lc/gau/v2/cmd/gau@latest > /dev/null 2>&1
    if [ -f ~/go/bin/gau ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING GAU MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing waybackurls"
    go install github.com/tomnomnom/waybackurls@latest > /dev/null 2>&1
    if [ -f ~/go/bin/waybackurls ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING WAYBACKURLS MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing kxss"
    go install github.com/Emoe/kxss@latest > /dev/null 2>&1
    if [ -f ~/go/bin/kxss ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING KXSS MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Gxss"
    go install github.com/KathanP19/Gxss@latest > /dev/null 2>&1
    if [ -f ~/go/bin/Gxss ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING GXSS MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing qsreplace"
    go install github.com/tomnomnom/qsreplace@latest > /dev/null 2>&1
    if [ -f ~/go/bin/qsreplace ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING QSREPLACE MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing ffuf"
    cd ~/vasuki/.tmp/ && git clone https://github.com/ffuf/ffuf.git -q
    cd ffuf && go install > /dev/null 2>&1
    if [ -f ~/go/bin/ffuf ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING FFUF MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing dnsx"
    go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest > /dev/null 2>&1
    if [ -f ~/go/bin/dnsx ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING DNSX MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing notify"
    go install -v github.com/projectdiscovery/notify/cmd/notify@latest > /dev/null 2>&1
    if [ -f ~/go/bin/notify ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING NOTIFY MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing dalfox"
    go install github.com/hahwul/dalfox/v2@latest > /dev/null 2>&1
    if [ -f ~/go/bin/dalfox ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING DALFOX MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing crlfuzz"
    cd ~/vasuki/.tmp/ && git clone https://github.com/dwisiswant0/crlfuzz.git -q
    cd crlfuzz/cmd/crlfuzz && go install > /dev/null 2>&1
    if [ -f ~/go/bin/crlfuzz ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING CRLFUZZ MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing nuclei"
    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest > /dev/null 2>&1
    if [ -f ~/go/bin/nuclei ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING NUCLEI MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing subfinder"
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest > /dev/null 2>&1
    if [ -f ~/go/bin/subfinder ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING SUBFINDER MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing httprobe"
    cd ~/vasuki/.tmp && git clone https://github.com/tomnomnom/httprobe.git -q
    cd httprobe && go install > /dev/null 2>&1
    if [ -f ~/go/bin/httprobe ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING HTTPROBE MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing httpx"
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest > /dev/null 2>&1
    if [ -f ~/go/bin/httpx ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING HTTPX MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing amass"
    go install -v github.com/owasp-amass/amass/v4/...@master > /dev/null 2>&1
    if [ -f ~/go/bin/amass ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING AMASS MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing MASSDNS"
    git clone https://github.com/blechschmidt/massdns.git -q ~/vasuki/Massdns
    cd ~/vasuki/Massdns && make && make install > /dev/null 2>&1
    cp ~/vasuki/Massdns/bin/massdns /usr/bin/ 2>/dev/null
    if command -v massdns &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING MASSDNS MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing MASSCAN"
    git clone https://github.com/robertdavidgraham/masscan.git -q ~/vasuki/Masscan
    git clone https://github.com/initstring/cloud_enum.git -q ~/vasuki/CloudEnum
    cd ~/vasuki/Masscan && make && make install > /dev/null 2>&1
    cp ~/vasuki/Masscan/bin/masscan /usr/bin/ 2>/dev/null
    if command -v masscan &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING MASSCAN MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Vayu"
    pip3 install git+https://github.com/R0X4R/Search-Engines-Scraper.git > /dev/null 2>&1
    pip3 install agnee > /dev/null 2>&1
    if command -v agnee &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING VAYU MANUALLY${NORMAL}"
    fi
}

# Additional Bug Bounty Tools Installation
additional_tools(){
    echo -e "\n${BK}${BOLD}${UNDERLINE}${MAGENTA}INSTALLING ADDITIONAL BUG BOUNTY TOOLS${NORMAL}"
    
    echo -e "\n- Installing ParamSpider"
    pip3 install paramspider > /dev/null 2>&1
    if command -v paramspider &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING PARAMSPIDER MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Katana"
    go install github.com/projectdiscovery/katana/cmd/katana@latest > /dev/null 2>&1
    if [ -f ~/go/bin/katana ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING KATANA MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Arjun"
    pip3 install arjun > /dev/null 2>&1
    if command -v arjun &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING ARJUN MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing LinkFinder"
    pip3 install linkfinder > /dev/null 2>&1
    if command -v linkfinder &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING LINKFINDER MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing SecretFinder"
    cd ~/vasuki/.tmp/ && git clone https://github.com/m4ll0k/SecretFinder.git -q
    cd SecretFinder && pip3 install -r requirements.txt > /dev/null 2>&1
    if [ -f ~/vasuki/.tmp/SecretFinder/SecretFinder.py ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING SECRETFINDER MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing OpenRedireX"
    cd ~/vasuki/.tmp/ && git clone https://github.com/devanshbatham/OpenRedireX.git -q
    cd OpenRedireX && pip3 install -r requirements.txt > /dev/null 2>&1
    if [ -f ~/vasuki/.tmp/OpenRedireX/openredirex.py ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING OPENREDIREX MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Xray"
    cd ~/vasuki/.tmp/ && curl -L https://github.com/chaitin/xray/releases/latest/download/xray_linux_amd64.zip -o xray.zip > /dev/null 2>&1
    unzip xray.zip > /dev/null 2>&1
    chmod +x xray
    mv xray /usr/bin/ > /dev/null 2>&1
    rm -rf xray.zip
    if command -v xray &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING XRAY MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Jaeles"
    go install github.com/jaeles-project/jaeles@latest > /dev/null 2>&1
    if [ -f ~/go/bin/jaeles ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING JAELES MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing SQLMap"
    cd ~/vasuki/.tmp/ && git clone https://github.com/sqlmapproject/sqlmap.git -q
    if [ -d ~/vasuki/.tmp/sqlmap ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING SQLMAP MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Wfuzz"
    pip3 install wfuzz > /dev/null 2>&1
    if command -v wfuzz &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING WFUZZ MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing TruffleHog"
    go install github.com/trufflesecurity/trufflehog/v3@latest > /dev/null 2>&1
    if [ -f ~/go/bin/trufflehog ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING TRUFFLEHOG MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Gitleaks"
    go install github.com/zricethezav/gitleaks/v8@latest > /dev/null 2>&1
    if [ -f ~/go/bin/gitleaks ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING GITLEAKS MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing GitDorker"
    cd ~/vasuki/.tmp/ && git clone https://github.com/obheda12/GitDorker.git -q
    cd GitDorker && pip3 install -r requirements.txt > /dev/null 2>&1
    if [ -f ~/vasuki/.tmp/GitDorker/GitDorker.py ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING GITDORKER MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing EyeWitness"
    cd ~/vasuki/.tmp/ && git clone https://github.com/FortyNorthSecurity/EyeWitness.git -q
    cd EyeWitness/Python/setup && ./setup.sh > /dev/null 2>&1
    if [ -f ~/vasuki/.tmp/EyeWitness/Python/EyeWitness.py ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING EYEWITNESS MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Wappalyzer"
    if command -v npm &> /dev/null; then
        cd ~/vasuki/.tmp/ && git clone https://github.com/AliasIO/wappalyzer.git -q
        cd wappalyzer && npm install > /dev/null 2>&1
        if [ -d ~/vasuki/.tmp/wappalyzer ]; then
            echo -e "${GR}SUCCESS${NORMAL}"
        else
            echo -e "${RED}FAILED, TRY INSTALLING WAPPALYZER MANUALLY${NORMAL}"
        fi
    else
        echo -e "${LIGHT_YELLOW}NPM not found, skipping Wappalyzer installation${NORMAL}"
    fi

    echo -e "\n- Installing Interlace"
    pip3 install interlace > /dev/null 2>&1
    if command -v interlace &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING INTERLACE MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Unfurl"
    go install github.com/tomnomnom/unfurl@latest > /dev/null 2>&1
    if [ -f ~/go/bin/unfurl ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING UNFURL MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Meg"
    go install github.com/tomnomnom/meg@latest > /dev/null 2>&1
    if [ -f ~/go/bin/meg ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING MEG MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Hakrawler"
    go install github.com/hakluke/hakrawler@latest > /dev/null 2>&1
    if [ -f ~/go/bin/hakrawler ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING HAKRAWLER MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Jeeves (SQLi testing)"
    go install github.com/ferreiraklet/Jeeves@latest > /dev/null 2>&1
    if [ -f ~/go/bin/jeeves ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING JEEVES MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Gxss (XSS testing)"
    go install github.com/KathanP19/Gxss@latest > /dev/null 2>&1
    if [ -f ~/go/bin/Gxss ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING GXSS MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Qsreplace (Parameter manipulation)"
    go install github.com/tomnomnom/qsreplace@latest > /dev/null 2>&1
    if [ -f ~/go/bin/qsreplace ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING QSREPLACE MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Uro (URL deduplication)"
    pip3 install uro > /dev/null 2>&1
    if command -v uro &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING URO MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Bhedak (Payload replacement)"
    pip3 install bhedak > /dev/null 2>&1
    if command -v bhedak &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING BHEDAK MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Tldextract (Domain parsing)"
    pip3 install tldextract > /dev/null 2>&1
    if python3 -c "import tldextract" 2>/dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING TLDCXTRACT MANUALLY${NORMAL}"
    fi

    echo -e "\n${GR}ADDITIONAL BUG BOUNTY TOOLS INSTALLATION COMPLETED${NORMAL}"
}

wordlistsd(){
    echo -e "\n${BK}DOWNLOADING ALL THE WORDLISTS.${NORMAL}"
    cd ~/vasuki/wordlists/
    echo -e "\n- Downloading subdomains wordlists"

    git clone https://github.com/vortexau/dnsvalidator.git -q
    cd dnsvalidator
    python3 setup.py install > /dev/null 2>&1
    
    # Add resolvers alias to appropriate shell RC file
    add_to_shell_rc "alias resolvers='dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 100 -o ~/resolvers.txt && sort -R ~/resolvers.txt | tail -n 50 > ~/50resolvers.txt'" "DNS validator resolvers alias"
    
    cd ~/vasuki/wordlists/
    cp ~/vasuki/vasuki /usr/bin/ 2>/dev/null
    
    # Source the shell RC file
    if [ -f "$SHELL_RC" ]; then
        source "$SHELL_RC"
    fi

    wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/deepmagic.com-prefixes-top50000.txt -O subdomains.txt
    git clone https://github.com/scipag/vulscan.git scipag_vulscan -q
    cp ~/vasuki/wordlists/scipag_vulscan/vulscan.nse /usr/share/nmap/scripts/ 2>/dev/null
    cd /usr/share/nmap/scripts/
    git clone https://github.com/vulnersCom/nmap-vulners.git -q
    cd ~/vasuki/wordlists/
    if [ -s subdomains.txt ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING 'SUBDOMAIN LIST' MANUALLY${NORMAL}"
    fi
    
    echo -e "\n- Downloading resolvers wordlists"
    wget -q https://raw.githubusercontent.com/janmasarik/resolvers/master/resolvers.txt -O resolvers.txt
    if [ -s resolvers.txt ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${YW}FAILED${NORMAL}"
    fi

    echo -e "\n- Downloading fuzz wordlists"
    wget -q https://raw.githubusercontent.com/Bo0oM/fuzz.txt/master/fuzz.txt -O fuzz.txt
    wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/combined_directories.txt -O combined_directories.txt
    wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/dirsearch.txt -O dirsearch.txt
    if [ -s fuzz.txt ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING FUZZ-LIST MANUALLY${NORMAL}"
    fi

    # Source the shell RC file again
    if [ -f "$SHELL_RC" ]; then
        source "$SHELL_RC"
    fi
    
    echo -e "\n- Installing nuclei"
    if command -v resolvers &> /dev/null; then
        resolvers > /dev/null 2>&1
        if [ -s ~/50resolvers.txt ]; then
            echo -e "${GR}SUCCESS. Use ${BOLD}${LIGHT_YELLOW}resolvers${NORMAL}${GR} to generate resolver file at root directory${NORMAL}"
        else
            echo -e "${RED}FAILED, TRY INSTALLING IT MANUALLY${NORMAL}"
            echo -e "After installing, paste this command in ${ORANGE}$SHELL_RC${NORMAL}. \nCommand = ${LIGHT_GREY}alias resolvers='dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 100 -o ~/resolvers.txt && sort -R ~/resolvers.txt | tail -n 50 > ~/50resolvers.txt'${NORMAL}. \nUse ${BOLD}${LIGHT_YELLOW}resolvers${NORMAL}${GR} to generate resolver file at root directory${NORMAL}"
        fi
    else
        echo -e "${RED}FAILED, TRY INSTALLING IT MANUALLY${NORMAL}"
        echo -e "After installing, paste this command in ${ORANGE}$SHELL_RC${NORMAL}. \nCommand = ${LIGHT_GREY}alias resolvers='dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 100 -o ~/resolvers.txt && sort -R ~/resolvers.txt | tail -n 50 > ~/50resolvers.txt'${NORMAL}. \nUse ${BOLD}${LIGHT_YELLOW}resolvers${NORMAL}${GR} to generate resolver file at root directory${NORMAL}"
    fi
}

main(){
    folders
    golanguage
    dependencies
    githubd
    additional_tools
    wordlistsd
    echo -e "\n${LIGHT_GREEN}FINISHING UP THINGS.${NORMAL}"
    rm -rf ~/vasuki/.tmp/ > /dev/null 2>&1
    cp ~/go/bin/* /usr/bin/ > /dev/null 2>&1
    
    # Update nuclei templates if nuclei is installed
    if command -v nuclei &> /dev/null; then
        nuclei -update-templates > /dev/null 2>&1
    fi
    
    # Create symlinks for additional tools in /usr/bin
    echo -e "\n${BK}Creating symlinks for additional tools${NORMAL}"
    ln -sf ~/vasuki/.tmp/SecretFinder/SecretFinder.py /usr/bin/secretfinder 2>/dev/null
    ln -sf ~/vasuki/.tmp/OpenRedireX/openredirex.py /usr/bin/openredirex 2>/dev/null
    ln -sf ~/vasuki/.tmp/sqlmap/sqlmap.py /usr/bin/sqlmap 2>/dev/null
    ln -sf ~/vasuki/.tmp/GitDorker/GitDorker.py /usr/bin/gitdorker 2>/dev/null
    ln -sf ~/vasuki/.tmp/EyeWitness/Python/EyeWitness.py /usr/bin/eyewitness 2>/dev/null
    
    echo -e "\nPLEASE CONFIGURE NOTIFY API'S IN ${LIGHT_YELLOW} ~/.config/notify/provider-config.yaml .${NORMAL} FILE"
    echo -e "THANKS FOR INSTALLING ${BOLD}${LIGHT_MAGENTA}VASUKI${NORMAL} WITH ADDITIONAL BUG BOUNTY TOOLS. HAPPY HUNTING :)\nPS: If you get any bug using Vasuki, please tweet about it and tag @CyberZest, also support me with ${BOLD}${LIGHT_GREEN}BuyMeaCoffee${NORMAL}"
    
    # Test vasuki command
    if command -v vasuki &> /dev/null; then
        vasuki -h 2> /dev/null
    else
        echo -e "${LIGHT_YELLOW}Vasuki command not found. Please run 'source $SHELL_RC' or restart your terminal.${NORMAL}"
    fi
    
    # Display installed tools summary
    echo -e "\n${BOLD}${LIGHT_GREEN}🎉 INSTALLATION COMPLETE! 🎉${NORMAL}"
    echo -e "\n${BOLD}${LIGHT_MAGENTA}Installed Tools Summary:${NORMAL}"
    echo -e "${LIGHT_YELLOW}Core Vasuki Tools:${NORMAL} subfinder, nuclei, httpx, naabu, dnsx, notify, assetfinder, anew, gau, waybackurls, gobuster, gf, httprobe, ffuf, dalfox, crlfuzz, kxss, gxss, qsreplace, amass, massdns, masscan, gospider, findomain, aquatone"
    echo -e "${LIGHT_YELLOW}Additional Bug Bounty Tools:${NORMAL} paramspider, katana, arjun, linkfinder, secretfinder, openredirex, xray, jaeles, sqlmap, wfuzz, trufflehog, gitleaks, gitdorker, eyewitness, wappalyzer, interlace, unfurl, meg, hakrawler, jeeves"
    echo -e "\n${BOLD}${LIGHT_GREEN}Total Tools Installed: 40+ security tools for comprehensive bug bounty hunting!${NORMAL}"
}

# Run main function
main
