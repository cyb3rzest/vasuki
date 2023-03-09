#!/bin/bash
# coded by CyberZest
# inspired by Asheem Shrey
# Vasuki - version 2.0

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

echo -e "${ORANGE}
\t\t\t\t██╗███╗░░██╗░██████╗████████╗░█████╗░██╗░░░░░██╗░░░░░░░░░░░██╗░░░██╗░█████╗░░██████╗██╗░░░██╗██╗░░██╗██╗
\t\t\t\t██║████╗░██║██╔════╝╚══██╔══╝██╔══██╗██║░░░░░██║░░░░░░░░░░░██║░░░██║██╔══██╗██╔════╝██║░░░██║██║░██╔╝██║
\t\t\t\t██║██╔██╗██║╚█████╗░░░░██║░░░███████║██║░░░░░██║░░░░░█████╗╚██╗░██╔╝███████║╚█████╗░██║░░░██║█████═╝░██║
\t\t\t\t██║██║╚████║░╚═══██╗░░░██║░░░██╔══██║██║░░░░░██║░░░░░╚════╝░╚████╔╝░██╔══██║░╚═══██╗██║░░░██║██╔═██╗░██║
\t\t\t\t██║██║░╚███║██████╔╝░░░██║░░░██║░░██║███████╗███████╗░░░░░░░░╚██╔╝░░██║░░██║██████╔╝╚██████╔╝██║░╚██╗██║
\t\t\t\t╚═╝╚═╝░░╚══╝╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚══════╝░░░░░░░░░╚═╝░░░╚═╝░░╚═╝╚═════╝░░╚═════╝░╚═╝░░╚═╝╚═╝
${NORMAL}"

if (( $EUID != 0 )); then
    echo -e "Make sure you're ${BOLD}${RED}ROOT USER${NORMAL} before running this script"
    exit
fi

folders(){
    mkdir -p ~/vasuki
    mkdir -p ~/vasuki/.tmp
    mkdir -p ~/.gf
    mkdir -p ~/vasuki/wordlists
}

golanguage(){
    echo -e "${BK}Installing GO-Language${NORMAL}"
    goversion=$(curl -ks -L https://go.dev/VERSION?m=text)
    wget https://go.dev/dl/$goversion.linux-amd64.tar.gz -q
    rm -rf /usr/local/go && tar -C /usr/local -xzf $goversion.linux-amd64.tar.gz
    export PATH=$PATH:/usr/local/go/bin
    echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
    echo 'source ~/go/pkg/mod/github.com/tomnomnom/gf@*/gf-completion.bash' >> ~/.bashrc
    source ~/.bashrc
    cp -r ~/go/pkg/mod/github.com/tomnomnom/gf@*/examples ~/.gf
    if command -v go &> /dev/null; then
        echo -e "\n${GR}GO INSTALLED SUCCESSFULLY${NORMAL}"
    else
        echo -e "\n${YW}THERE'S A PROBLEM IN INSTALLING ${LIGHT_GREEN}GO${NORMAL}, TRY INSTALLING IT MANUALLY${NORMAL}"
    fi
    rm -rf $goversion.linux-amd64.tar.gz
}
#golanguage

dependencies(){
    mv .github/payloads/patterns/*.json ~/.gf/ 2> /dev/null && cd
    echo -e "${BK}${BOLD}${UNDERLINE}${MAGENTA}INSTALLING ALL DEPENDENCIES${NORMAL}"
    sudo apt update > /dev/null 2>&1
    sudo apt upgrade -y > /dev/null 2>&1
    pip3 install requests
    pip3 install ipaddress
    sudo apt install apt-transport-https bsdmainutils build-essential snapd cmake curl dnsutils gcc git jq libdata-hexdump-perl libffi-dev libpcap-dev libssl-dev libxml2-dev libxml2-utils libxslt1-dev lynx medusa nmap procps pv python3 python3-dev python3-pip wget zip unzip zlib1g-dev libpcap-dev screen make gcc -y > /dev/null 2>&1
    sudo snap install chromium > /dev/null 2>&1
    cd /root/ && git clone https://github.com/1ndianl33t/Gf-Patterns
    mv ~/Gf-Patterns/*.json ~/.gf
    echo -e "${GR}SUCCESS${NORMAL}\n"
}

githubd(){
    echo -e "${BK}CHECKING & DOWNLOADING AND INSTALLING ALL TOOLS FROM GITHUB.${NORMAL}\n"

    echo -e "\n- Installing Bhedak"
    cd && pip3 install bhedak > /dev/null 2>&1
    cd && pip3 install tldextract > /dev/null 2>&1
    which bhedak &> /dev/null && 
    if command -v bhedak &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING BHEDAK MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing uro"
    cd && pip3 install uro > /dev/null 2>&1
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
    cd && git clone https://github.com/jaeles-project/gospider ~/vasuki/.tmp/gospider -q
    cd ~/vasuki/.tmp/gospider 2> /dev/null
    go install > /dev/null 2>&1
    if [ -f ~/go/bin/gospider ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING GOSPIDER MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing findomain"
    curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip  > /dev/null 2>&1
    unzip findomain-linux-i386.zip > /dev/null 2>&1
    mv findomain /usr/bin/ > /dev/null 2>&1
    rm -rf findomain* LICENSE.txt README.md
    if command -v findomain &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING FINDOMAIN MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing aquatone"
    wget -q https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip  > /dev/null 2>&1
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

    echo -e "\n- Installing kxss"
    go install github.com/KathanP19/Gxss@latestt > /dev/null 2>&1
    if [ -f ~/go/bin/Gxss ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING KXSS MANUALLY${NORMAL}"
    fi
 
    echo -e "\n- Installing qsreplace"
    go install github.com/tomnomnom/qsreplace@latest > /dev/null 2>&1
    if [ -f ~/go/bin/qsreplace ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING QSREPLACE MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing ffuf"
    cd ~/vasuki/.tmp/ && git clone https://github.com/ffuf/ffuf -q
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
    cd ~/vasuki/.tmp/ && git clone https://github.com/dwisiswant0/crlfuzz -q
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
    go install -v github.com/OWASP/Amass/v3/...@master > /dev/null 2>&1
    if [ -f ~/go/bin/amass ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING AMASS MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing MASSDNS"
    git clone https://github.com/blechschmidt/massdns.git -q ~/vasuki/Massdns
    cd ~/vasuki/Massdns && sudo make && sudo make install > /dev/null 2>&1
    cp ~/vasuki/Massdns/bin/massdns /bin > /dev/null 2>&1
    if [ -f /bin/massdns ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING MASSDNS MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing MASSCAN"
    git clone https://github.com/robertdavidgraham/masscan -q ~/vasuki/Masscan
    cd ~/vasuki/Masscan && sudo make && sudo make install > /dev/null 2>&1
    cp ~/vasuki/Masscan/bin/masscan /bin > /dev/null 2>&1
    if [ -f /bin/masscan ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING MASSCAN MANUALLY${NORMAL}"
    fi

    echo -e "\n- Installing Vayu"
    sudo pip3 install git+https://github.com/R0X4R/Search-Engines-Scraper.git > /dev/null 2>&1 && sudo pip3 install agnee > /dev/null 2>&1
    if command -v agnee &> /dev/null; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING VAYU MANUALLY${NORMAL}"
    fi
}

wordlistsd(){
    echo -e "\n${BK}DOWNLOADING ALL THE WORDLISTS.${NORMAL}"
    cd ~/vasuki/wordlists/
    echo -e "\n- Downloading subdomains wordlists"

    git clone https://github.com/vortexau/dnsvalidator.git
    cd dnsvalidator
    python3 setup.py install
    echo "alias resolvers='dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 100 -o ~/resolvers.txt && sort -R ~/resolvers.txt | tail -n 50 > ~/50resolvers.txt'" >> ~/.zshrc
#    echo "alias vasuki='~/vasuki/./vasuki'" >> ~/.bashrc
    cd ~/vasuki/wordlists/
    cp ~/vasuki/vasuki /usr/bin/
    cp ~/vasuki/vasuki /bin/
    source ~/.zshrc

    wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/deepmagic.com-prefixes-top50000.txt -O subdomains.txt
    git clone https://github.com/scipag/vulscan scipag_vulscan
    cp ~/vasuki/wordlists/scipag_vulscan/vulscan.nse /usr/share/nmap/scripts/
    cd /usr/share/nmap/scripts/
    git clone https://github.com/vulnersCom/nmap-vulners.git
    cd ~/vasuki/wordlists/
    if [ -s subdomains.txt ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING 'SUBDOMAIN LIST' MANUALLY${NORMAL}"
    fi
    
    echo -e "\n- Downloading resolvers wordlists"
    wget -q https://raw.githubusercontent.com/janmasarik/resolvers/master/resolvers.txt -O resolvers.txt
    if [ -s resolvers.txt ]; then
        echo -e "${GR}SUCCESS${RT}"
    else
        echo -e "${YW}FAILED${RT}"
    fi
 
    echo -e "\n- Downloading fuzz wordlists"
    wget -q https://raw.githubusercontent.com/Bo0oM/fuzz.txt/master/fuzz.txt -O fuzz.txt
    if [ -s fuzz.txt ]; then
        echo -e "${GR}SUCCESS${NORMAL}"
        source ~/.zshrc
    else
        echo -e "${RED}FAILED, TRY INSTALLING FUZZ-LIST MANUALLY${NORMAL}"
    fi

    source ~/.zshrc
    resolvers
    if [ -s ~/50resolvers.txt ]; then
        echo -e "${GR}SUCCESS. Use ${BOLD}${LIGHT_YELLOW}resolvers${NORMAL}${GR}to generate resolver file at root directory${NORMAL}"
    else
        echo -e "${RED}FAILED, TRY INSTALLING IT MANUALLY${NORMAL}"
	echo -e "After installing, paste this command in ${ORANGE}.bashrc${Normal}. \nCommand = ${LIGHT_GREY}alias resolvers='dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 100 -o ~/resolvers.txt && sort -R ~/resolvers.txt | tail -n 50 > ~/50resolvers.txt'${NORMAL}. \nUse ${BOLD}${LIGHT_YELLOW}resolvers${NORMAL}${GR}to generate resolver file at root directory${NORMAL}"
    fi
}

main(){
    folders
    golanguage
    dependencies
    githubd
    wordlistsd
    echo -e "\n${LIGHT_GREEN}FINISHING UP THINGS.${NORMAL}"
    rm -rf ~/vasuki/.tmp/ > /dev/null 2>&1
    sudo cp ~/go/bin/* /usr/bin/ > /dev/null 2>&1
    nuclei -update-templates > /dev/null 2>&1
    echo -e "\nPLEASE CONFIGURE NOTIFY API'S IN ${LIGHT_YELLOW} ~/.config/notify/provider-config.yaml .${NORMAL} FILE"
    echo -e "THANKS FOR INSTALLING ${BOLD}${LIGHT_MAGENTA}VASUKI${NORMAL}. HAPPY HUNTING :)\nPS: If you get any bug using Vasuki, please tweet about it and tag @CyberZeast, also support me with ${BOLD}${LIGHT_GREEN}BuyMeaCoffee${NORMAL}"
    vasuki -h 2> /dev/null
}

while true
do
    main
    exit
done
