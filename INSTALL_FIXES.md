# Vasuki Installation Script Fixes

## Overview
This document outlines the fixes and improvements made to the `vasuki_install.sh` script to support both bash and zsh shells and resolve various errors.

## Key Fixes Applied

### 1. **Shell Detection and Configuration**
- **Added automatic shell detection**: Detects whether the system is using bash or zsh
- **Dynamic RC file selection**: Uses `.bashrc` for bash and `.zshrc` for zsh
- **Shell-specific completions**: Adds appropriate GF completion files based on shell type
- **Universal configuration**: All shell configurations now work with both shells

### 2. **Syntax and Logic Errors Fixed**

#### **Line 83**: Fixed broken conditional statement
```bash
# BEFORE (BROKEN):
which bhedak &> /dev/null && 
if command -v bhedak &> /dev/null; then

# AFTER (FIXED):
if command -v bhedak &> /dev/null; then
```

#### **Line 111**: Fixed malformed echo statement
```bash
# BEFORE (BROKEN):
elsegrep -o 'go[0-9.]*'

# AFTER (FIXED):
else
    echo -e "${RED}FAILED, TRY INSTALLING WhatWeb MANUALLY${NORMAL}"
```

#### **Line 123**: Fixed malformed gobuster installation line
```bash
# BEFORE (BROKEN):
echo -e "\n- Installing gobuster"go install github.com/OJ/gobuster/v3@lates

# AFTER (FIXED):
echo -e "\n- Installing gobuster"
go install github.com/OJ/gobuster/v3@latest > /dev/null 2>&1
```

#### **Line 362**: Fixed undefined variable reference
```bash
# BEFORE (BROKEN):
echo -e "${GR}SUCCESS${RT}"

# AFTER (FIXED):
echo -e "${GR}SUCCESS${NORMAL}"
```

#### **Line 365**: Fixed misplaced echo statement
```bash
# BEFORE (BROKEN):
else
echo -e "\n- Installing nuclei"
    echo -e "${YW}FAILED${RT}"

# AFTER (FIXED):
else
    echo -e "${YW}FAILED${NORMAL}"
```

#### **Line 386**: Fixed undefined variable reference
```bash
# BEFORE (BROKEN):
echo -e "After installing, paste this command in ${ORANGE}.bashrc${Normal}.

# AFTER (FIXED):
echo -e "After installing, paste this command in ${ORANGE}$SHELL_RC${NORMAL}.
```

### 3. **Improved Error Handling**
- **Better file existence checks**: Added checks for directory and file existence before operations
- **Improved error messages**: More descriptive error messages with proper color coding
- **Safer file operations**: Added error suppression and proper cleanup

### 4. **Enhanced Functionality**

#### **Shell Configuration Function**
```bash
add_to_shell_rc() {
    local config_line="$1"
    local comment="$2"
    
    if [ -n "$comment" ]; then
        echo "# $comment" >> "$SHELL_RC"
    fi
    echo "$config_line" >> "$SHELL_RC"
}
```

#### **Shell Detection Function**
```bash
detect_shell() {
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_TYPE="zsh"
        SHELL_RC="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        SHELL_TYPE="bash"
        SHELL_RC="$HOME/.bashrc"
    else
        # Fallback detection
        CURRENT_SHELL=$(basename "$SHELL")
        if [ "$CURRENT_SHELL" = "zsh" ]; then
            SHELL_TYPE="zsh"
            SHELL_RC="$HOME/.zshrc"
        else
            SHELL_TYPE="bash"
            SHELL_RC="$HOME/.bashrc"
        fi
    fi
}
```

### 5. **Path and Installation Improvements**
- **Fixed exit codes**: Changed `exit` to `exit 1` for proper error handling
- **Improved file paths**: Fixed incorrect file path references
- **Better cleanup**: Enhanced cleanup operations for temporary files
- **Safer installations**: Added proper error checking for all installations

### 6. **Configuration Improvements**
- **Dynamic shell RC**: All configurations now use the detected shell's RC file
- **Proper sourcing**: Shell RC files are sourced after modifications
- **Better aliases**: Improved alias creation with proper shell detection

## Usage

### For Bash Users
The script will automatically detect bash and configure `.bashrc`:
```bash
sudo ./vasuki_install.sh
```

### For Zsh Users
The script will automatically detect zsh and configure `.zshrc`:
```bash
sudo ./vasuki_install.sh
```

## Benefits of the Fixes

1. **Universal Compatibility**: Works with both bash and zsh shells
2. **Better Error Handling**: More robust error checking and reporting
3. **Cleaner Code**: Removed syntax errors and improved readability
4. **Safer Operations**: Better file handling and cleanup
5. **Improved User Experience**: Clear feedback and proper configuration

## Testing Recommendations

1. Test on both bash and zsh systems
2. Verify all tools install correctly
3. Check that shell configurations are properly added
4. Ensure all aliases work after installation
5. Test the vasuki command after installation

## Notes

- The script maintains backward compatibility with existing installations
- All original functionality is preserved
- Additional error checking has been added for robustness
- Shell detection is automatic and requires no user intervention
