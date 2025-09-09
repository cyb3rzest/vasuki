# Additional Bug Bounty Tools for Vasuki

## Overview
This document lists additional popular bug bounty tools that can be integrated into Vasuki to enhance reconnaissance and vulnerability assessment capabilities.

## Tool Categories

### 🔍 **Reconnaissance & Discovery**

#### **1. ParamSpider**
- **Purpose**: Discovers hidden parameters for IDOR, XSS, and SQLi testing
- **GitHub**: https://github.com/devanshbatham/ParamSpider
- **Installation**: `pip3 install paramspider`
- **Usage**: `paramspider -d target.com --level high --subs`

#### **2. Katana**
- **Purpose**: Fast web crawler for JavaScript-heavy applications
- **GitHub**: https://github.com/projectdiscovery/katana
- **Installation**: `go install github.com/projectdiscovery/katana/cmd/katana@latest`
- **Usage**: `katana -u https://target.com -depth 3`

#### **3. Arjun**
- **Purpose**: Finds hidden GET and POST parameters
- **GitHub**: https://github.com/s0md3v/Arjun
- **Installation**: `pip3 install arjun`
- **Usage**: `arjun -u https://target.com`

#### **4. LinkFinder**
- **Purpose**: Extracts endpoints from JavaScript files
- **GitHub**: https://github.com/GerbenJavado/LinkFinder
- **Installation**: `pip3 install linkfinder`
- **Usage**: `python3 linkfinder.py -i https://target.com -o results.html`

#### **5. SecretFinder**
- **Purpose**: Finds secrets in JavaScript files
- **GitHub**: https://github.com/m4ll0k/SecretFinder
- **Installation**: `pip3 install secretfinder`
- **Usage**: `python3 SecretFinder.py -i https://target.com -o results.html`

### 🎯 **Vulnerability Scanning**

#### **6. OpenRedireX**
- **Purpose**: Detects open redirect vulnerabilities
- **GitHub**: https://github.com/devanshbatham/OpenRedireX
- **Installation**: `pip3 install openredirex`
- **Usage**: `python3 openredirex.py -l urls.txt -p payloads.txt`

#### **7. Xray**
- **Purpose**: Powerful security scanner for multiple vulnerability types
- **GitHub**: https://github.com/chaitin/xray
- **Installation**: Download binary from releases
- **Usage**: `./xray webscan --url https://target.com --plugins xss,sqli`

#### **8. Jaeles**
- **Purpose**: Template-based vulnerability scanner
- **GitHub**: https://github.com/jaeles-project/jaeles
- **Installation**: `go install github.com/jaeles-project/jaeles@latest`
- **Usage**: `jaeles scan -s signatures/ -u https://target.com`

#### **9. SQLMap**
- **Purpose**: Automated SQL injection testing
- **GitHub**: https://github.com/sqlmapproject/sqlmap
- **Installation**: `pip3 install sqlmap`
- **Usage**: `sqlmap -u "https://target.com/page?id=1"`

#### **10. Wfuzz**
- **Purpose**: Web application fuzzer
- **GitHub**: https://github.com/xmendez/wfuzz
- **Installation**: `pip3 install wfuzz`
- **Usage**: `wfuzz -c -z file,wordlist.txt https://target.com/FUZZ`

### 🔐 **Secret & Credential Discovery**

#### **11. TruffleHog**
- **Purpose**: Searches for secrets in Git repositories
- **GitHub**: https://github.com/trufflesecurity/trufflehog
- **Installation**: `go install github.com/trufflesecurity/trufflehog/v3@latest`
- **Usage**: `trufflehog git https://github.com/target/repo`

#### **12. Gitleaks**
- **Purpose**: Detects hardcoded secrets in Git repos
- **GitHub**: https://github.com/zricethezav/gitleaks
- **Installation**: `go install github.com/zricethezav/gitleaks/v8@latest`
- **Usage**: `gitleaks detect --source . --verbose`

#### **13. GitDorker**
- **Purpose**: Searches GitHub for sensitive information
- **GitHub**: https://github.com/obheda12/GitDorker
- **Installation**: `pip3 install gitdorker`
- **Usage**: `python3 GitDorker.py -tf targets.txt -d dorks.txt`

### 📸 **Screenshot & Analysis**

#### **14. EyeWitness**
- **Purpose**: Takes screenshots and collects server headers
- **GitHub**: https://github.com/FortyNorthSecurity/EyeWitness
- **Installation**: `git clone` and run setup script
- **Usage**: `python3 EyeWitness.py -f urls.txt --web`

#### **15. Wappalyzer**
- **Purpose**: Identifies web technologies
- **GitHub**: https://github.com/AliasIO/wappalyzer
- **Installation**: `npm install wappalyzer`
- **Usage**: `wappalyzer https://target.com`

### 🚀 **Automation & Orchestration**

#### **16. Interlace**
- **Purpose**: Parallel command execution across targets
- **GitHub**: https://github.com/codingo/Interlace
- **Installation**: `pip3 install interlace`
- **Usage**: `echo target.com | interlace -t 10 -c "nuclei -u _target_"`

#### **17. Jaeles**
- **Purpose**: Template-based vulnerability scanner
- **GitHub**: https://github.com/jaeles-project/jaeles
- **Installation**: `go install github.com/jaeles-project/jaeles@latest`
- **Usage**: `jaeles scan -s signatures/ -u https://target.com`

### 🔧 **Utility Tools**

#### **18. Unfurl**
- **Purpose**: URL parsing and manipulation
- **GitHub**: https://github.com/tomnomnom/unfurl
- **Installation**: `go install github.com/tomnomnom/unfurl@latest`
- **Usage**: `echo "https://target.com/path?param=value" | unfurl`

#### **19. Meg**
- **Purpose**: Fetches many paths for many hosts
- **GitHub**: https://github.com/tomnomnom/meg
- **Installation**: `go install github.com/tomnomnom/meg@latest`
- **Usage**: `meg / /path/to/urls`

#### **20. Hakrawler**
- **Purpose**: Fast web crawler for URLs and endpoints
- **GitHub**: https://github.com/hakluke/hakrawler
- **Installation**: `go install github.com/hakluke/hakrawler@latest`
- **Usage**: `echo "https://target.com" | hakrawler`

## Integration Benefits

Adding these tools to Vasuki will provide:

1. **Enhanced Reconnaissance**: Better subdomain discovery and endpoint enumeration
2. **Comprehensive Vulnerability Scanning**: Multiple scanning engines for different vulnerability types
3. **Secret Discovery**: Automated detection of exposed credentials and secrets
4. **Technology Fingerprinting**: Better understanding of target technologies
5. **Automation**: Streamlined workflows for large-scale testing
6. **Coverage**: Broader attack surface coverage

## Installation Priority

**High Priority** (Essential for bug bounty):
- ParamSpider, Katana, Arjun, LinkFinder, OpenRedireX, TruffleHog, Gitleaks

**Medium Priority** (Very useful):
- Xray, Jaeles, SQLMap, Wfuzz, EyeWitness, Interlace

**Low Priority** (Nice to have):
- SecretFinder, GitDorker, Wappalyzer, Unfurl, Meg, Hakrawler

## Notes

- Some tools may require additional dependencies (Node.js, specific Python packages)
- Consider system resources when installing all tools
- Test tools individually before integrating into automated workflows
- Keep tools updated regularly for best results
