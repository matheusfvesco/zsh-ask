# Installation

Setup ollama, and download any model. `llama3.2:3b` is the default selected model. For a quick start, use `ollama run llama3.2:3b`


## Manual (Git Clone)

1. Clone this repository somewhere on your machine. This guide will assume `~/.zsh_addons/zsh-ask`.
   ```sh
   git clone https://github.com/matheusfvesco/zsh-ask ~/.zsh_addons/zsh-ask
   ```
2. Add the following to your `.zshrc`:
   ```sh
   source ~/.zsh_addons/zsh-ask/zsh-ask.zsh
   ```
3. Start a new terminal session.

# Settings

## Usage with other models

If you want to use other models, ensure the model is installed. `llama3.2:3b` is the default selected model.

for instance, if you want to use `qwen2.5-coder:3b` instead, download the model (`ollama run qwen2.5-coder:3b`), and use
```sh
export ZSH_ASK_MODEL="qwen2.5-coder:3b"
```
or use
```sh
ask -M "qwen2.5-coder:3b" who are you
```

Alternatively make a model the default model by adding the export to your `.zshrc`, e.g.
```sh
echo "export ZSH_ASK_MODEL='qwen2.5-coder:3b'" >> ~/.zshrc
```

## Other OpenAI compatible providers

To use it with other OpenAI compatible APIs, with vllm or groq for instance, update the api endpoint using
```sh
export ZSH_ASK_API_URL="https://api.groq.com/openai/v1/chat/completions"
```

If you need a specific api key, like in groq for example, update it exporting it
```sh
export ZSH_ASK_API_KEY="my_api_key"
```

Finally, update the model accordingly
```sh
export ZSH_ASK_MODEL="llama-3.3-70b-versatile"
```

## Complete reference

1. **ZSH_ASK_MODEL**
   - This variable controls the model used by the assistant.
   ```sh
   export ZSH_ASK_MODEL="llama3.2:3b"
   ```

2. **ZSH_ASK_CONVERSATION**
   - This variable determines if, by default, conversation mode will be used.
   ```sh
   export ZSH_ASK_CONVERSATION=false
   ```

3. **ZSH_ASK_INHERITS**
   - This variable controls the default on whether the assistant should inherit or not the previous chat messages.
   ```sh
   export ZSH_ASK_INHERITS=false
   ```

4. **ZSH_ASK_TOKENS**
   - This variable sets the maximum number of tokens to use for generating responses.
   ```sh
   export ZSH_ASK_TOKENS=800
   ```

5. **ZSH_ASK_INITIALROLE**
   - This variable sets the initial role of the initial prompt in the conversation.
   ```sh
   export ZSH_ASK_INITIALROLE="system"
   ```

6. **ZSH_ASK_INITIALPROMPT**
   - This variable provides an initial prompt to guide the assistant's response.
   ```sh
   export ZSH_ASK_INITIALPROMPT="You are a helpful specialist in code and linux commands. Be consise and direct in your answers. Try to give as many solutions as a single command, instead of developing a script, for example. If the user says something like 'find all jpeg files' for example, simply interpret it as a question on how to do it."
   ```

# Uninstall

1. Remove the code referencing this plugin from `~/.zshrc`.
2. Remove the git repository from your hard drive. (`rm -rf ~/.zsh_addons/zsh-ask`)
