#!/bin/bash

echo "🐉 ZILLA-DAM CROSS-PLATFORM INSTALLER"

detect_platform() {
    case "$(uname -s)" in
        Linux*)     
            if [[ -f "/proc/version" ]] && grep -q "Microsoft" /proc/version; then
                echo "wsl"
            elif [[ -f "/etc/termux" ]]; then
                echo "termux" 
            else
                echo "linux"
            fi
            ;;
        Darwin*)    echo "mac" ;;
        CYGWIN*)    echo "cygwin" ;;
        MINGW*)     echo "gitbash" ;;
        *)          echo "unknown" ;;
    esac
}

PLATFORM=$(detect_platform)
echo "🔍 Detected platform: $PLATFORM"

install_dependencies() {
    case $PLATFORM in
        "wsl"|"linux")
            echo "📦 Installing dependencies for Linux/WSL..."
            sudo apt update
            sudo apt install -y nodejs npm python3 python3-pip git curl wget
            # Install Julia for ML
            wget https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.5-linux-x86_64.tar.gz
            tar -xzf julia-1.8.5-linux-x86_64.tar.gz
            sudo mv julia-1.8.5 /opt/
            sudo ln -s /opt/julia-1.8.5/bin/julia /usr/local/bin/julia
            ;;
        "mac")
            echo "📦 Installing dependencies for macOS..."
            # Check if Homebrew is installed
            if ! command -v brew &> /dev/null; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            brew install node npm python3 git curl wget
            brew install --cask julia
            ;;
        "termux")
            echo "📦 Installing dependencies for Termux (Android)..."
            pkg update
            pkg install -y nodejs python git curl wget
            # Termux-specific limitations
            echo "⚠️  Note: Julia ML engine limited on Termux"
            ;;
    esac
}

setup_zilla_dam() {
    echo "🚀 Setting up ZILLA-DAM..."
    
    # Clone or extract to current directory
    if [ ! -d "zilla-dam" ]; then
        echo "📥 Downloading ZILLA-DAM..."
        git clone https://github.com/zilla-dam/zilla-dam.git
    fi
    
    cd zilla-dam
    
    # Platform-specific configurations
    case $PLATFORM in
        "termux")
            echo "📱 Applying Termux optimizations..."
            # Reduce memory usage for mobile
            export NODE_OPTIONS="--max-old-space-size=1024"
            ;;
        "wsl")
            echo "🪟 Applying WSL optimizations..."
            # WSL-specific performance tweaks
            ;;
    esac
    
    # Install Node dependencies
    npm install
    
    # Initialize quantum security
    node security_lock.js --init
}

install_dependencies
setup_zilla_dam

echo "✅ ZILLA-DAM installation complete for $PLATFORM!"
echo "🚀 Start with: cd zilla-dam && ./startup.sh"
