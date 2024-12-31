# Installation

Setup ollama, and download any model. `llama3.2:3b` is the default selected model. For a quick start, use `ollama run llama3.2:3b`


## Manual (Git Clone)

1. Clone this repository somewhere on your machine. This guide will assume `$HOME/.zsh_addons/zsh-ask`.
   ```sh
   git clone https://github.com/matheusfvesco/zsh-ask $HOME/.zsh_addons/zsh-ask
   ```
2. Add the following to your `.zshrc`:
   ```sh
   source $HOME/.zsh_addons/zsh-ask/zsh-ask.zsh
   ```
3. Start a new terminal session.

### Usage with other models

If you want to use other models, ensure the model is installed. `llama3.2:3b` is the default selected model.

for instance, if you want to use `qwen2.5-coder:3b` instead, download the model (`ollama run qwen2.5-coder:3b`), and use
```sh
export ZSH_ASK_MODEL="qwen2.5-coder:3b"
```

Alternatively make a model the default model by adding the export to your `.zshrc`, e.g.
```sh
echo "export ZSH_ASK_MODEL='qwen2.5-coder:3b'" >> ~/.zshrc
```

## Uninstallation

1. Remove the code referencing this plugin from `~/.zshrc`.
2. Remove the git repository from your hard drive. (`rm -rf $HOME/.zsh_addons/zsh-ask`)
