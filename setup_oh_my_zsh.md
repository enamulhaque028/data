# Installing Oh My Zsh with Autosuggestions on Mac

## Initial Setup with Homebrew

<!-- ### Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
``` -->

### Install Zsh
```bash
brew install zsh
```

### Install Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install Zsh Autosuggestions
```bash
brew install zsh-autosuggestions
```

### `.zshrc` Configuration
1. Add the zsh-autosuggestions plugin. Find the plugins line and modify it:
```bash
plugins=(git zsh-autosuggestions)
```

2. Add these lines to `~/.zshrc`:
```bash
source $ZSH/oh-my-zsh.sh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
```
<span style="color:red">* These two lines must be added before the line: "plugins=(git zsh-autosuggestions)"</span>