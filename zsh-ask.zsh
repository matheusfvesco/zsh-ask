# A lightweight Zsh plugin serves as a ChatGPT API frontend, enabling you to interact with ChatGPT directly from the Zsh.
# https://github.com/Licheam/zsh-ask
# Copyright (c) 2023-2024 Leachim

#--------------------------------------------------------------------#
# Global Configuration Variables                                     #
#--------------------------------------------------------------------#

0=${(%):-%N}
typeset -g ZSH_ASK_PREFIX=${0:A:h}

(( ! ${+ZSH_ASK_REPO} )) &&
typeset -g ZSH_ASK_REPO="https://github.com/matheusfvesco/zsh-ask"

# Get the corresponding endpoint for your desired model.
(( ! ${+ZSH_ASK_API_URL} )) &&
typeset -g ZSH_ASK_API_URL="http://127.0.0.1:11434/v1/chat/completions"

(( ! ${+ZSH_ASK_API_KEY} )) &&
typeset -g ZSH_ASK_API_KEY="ollama"

# Default configurations
(( ! ${+ZSH_ASK_MODEL} )) &&
typeset -g ZSH_ASK_MODEL="llama3.2:3b"
(( ! ${+ZSH_ASK_CONVERSATION} )) &&
typeset -g ZSH_ASK_CONVERSATION=false
(( ! ${+ZSH_ASK_INHERITS} )) &&
typeset -g ZSH_ASK_INHERITS=false
(( ! ${+ZSH_ASK_TOKENS} )) &&
typeset -g ZSH_ASK_TOKENS=800
(( ! ${+ZSH_ASK_HISTORY} )) &&
typeset -g ZSH_ASK_HISTORY=""
(( ! ${+ZSH_ASK_INITIALROLE} )) &&
typeset -g ZSH_ASK_INITIALROLE="system"
(( ! ${+ZSH_ASK_INITIALPROMPT} )) &&
typeset -g ZSH_ASK_INITIALPROMPT="You are a helpful specialist in code and linux commands. Be consise and direct in your answers. Try to give as many solutions as a single command, instead of developing a script, for example. If the user says something like 'find all jpeg files' for example, simply interpret it as a question on how to do it."

function _zsh_ask_show_help() {
  echo "A lightweight Zsh plugin serves as a Ollama OpenAI API frontend, enabling you to interact with ollama models directly from Zsh."
  echo "Usage: ask [options...]"
  echo "       ask [options...] '<your-question>'"
  echo "Options:"
  echo "  -h                Display this help message."
  echo "  -v                Display the version number."
  echo "  -i                Inherits conversation from ZSH_ASK_HISTORY."
  echo "  -c                Enable conversation."
  echo "  -M <ollama_model> Set the Ollama model to <ollama_model>, default sets to 'llama3.2:3b'."
  echo "                    Models can be found at http://127.0.0.1:11434/v1/models."
  echo "  -t <max_tokens>   Set max tokens to <max_tokens>, default sets to 800."
  echo "  -u                Upgrade this plugin."
  echo "  -r                Print raw output."
  echo "  -d                Print debug information."
}

function _zsh_ask_upgrade() {
  git -C $ZSH_ASK_PREFIX remote set-url origin $ZSH_ASK_REPO
  if git -C $ZSH_ASK_PREFIX pull; then
    source $ZSH_ASK_PREFIX/zsh-ask.zsh
    return 0
  else
    echo "Failed to upgrade."
    return 1
  fi
}

function _zsh_ask_show_version() {
  cat "$ZSH_ASK_PREFIX/VERSION"
}

function ask() {
    local api_url=$ZSH_ASK_API_URL
    local api_key=$ZSH_ASK_API_KEY
    local conversation=$ZSH_ASK_CONVERSATION
    local stream=$ZSH_ASK_STREAM
    local tokens=$ZSH_ASK_TOKENS
    local inherits=$ZSH_ASK_INHERITS
    local model=$ZSH_ASK_MODEL
    local history=""

    local requirements=("curl" "jq")
    local debug=false
    local raw=false
    local satisfied=true
    local assistant="assistant"
    while getopts ":hvcdmsiurM:f:t:" opt; do
        case $opt in
            h)
                _zsh_ask_show_help
                return 0
                ;;
            v)
                _zsh_ask_show_version
                return 0
                ;;
            u)
                if ! which "git" > /dev/null; then
                    echo "git is required for upgrade."
                    return 1
                fi
                if _zsh_ask_upgrade; then
                    return 0
                else
                    return 1
                fi
                ;;
            c)
                conversation=true
                ;;
            d)
                debug=true
                ;;
            i)
                inherits=true
                ;;
            t)
                if ! [[ $OPTARG =~ ^[0-9]+$ ]]; then
                    echo "Max tokens has to be an valid numbers."
                    return 1
                else
                    tokens=$OPTARG
                fi
                ;;
            f)
                usefile=true
                if ! [ -f $OPTARG ]; then
                    echo "$OPTARG does not exist."
                    return 1
                else
                    if ! which "xargs" > /dev/null; then
                        echo "xargs is required for file."
                        satisfied=false
                    fi
                    filepath=$OPTARG
                fi
                ;;
            M)
                model=$OPTARG
                ;;
            r)
                raw=true
                ;;
            :)
                echo "-$OPTARG needs a parameter"
                return 1
                ;;
        esac
    done

    for i in "${requirements[@]}"
    do
    if ! which $i > /dev/null; then
        echo "zsh-ask \033[0;31merror:\033[0m $i is required."
        return 1
    fi
    done

    if $inherits; then
        history=$ZSH_ASK_HISTORY
    fi
    
    if [ "$history" = "" ]; then
        history='{"role":"'$ZSH_ASK_INITIALROLE'", "content":"'$ZSH_ASK_INITIALPROMPT'"}, '
    fi

    shift $((OPTIND-1))

    input=$*


    while true; do
        history=$history' {"role":"user", "content":"'"$input"'"}'
        if $debug; then
            echo -E "$history"
        fi
        local data='{"messages":['$history'], "model":"'$model'", "stream":'$stream', "max_tokens":'$tokens'}'
        local message=""
        local generated_text=""
        local response=$(curl -s -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $api_key" -d $data $api_url)
        if $debug || $raw; then
            echo -E "$response"
        fi
        if ! $raw; then
            echo -n "\033[0;36m$assistant: \033[0m"
            if echo -E $response | jq -e '.error' > /dev/null; then
                echo "zsh-ask \033[0;31merror:\033[0m"
                echo -E $response | jq -r '.error'
                return 1
            fi
        fi
        assistant=$(echo -E $response | jq -r '.choices[].role')
        message=$(echo -E $response | jq -r '.choices[].message')
        generated_text=$(echo -E $message | jq -r '.content')
        if ! $raw; then
            echo -E $generated_text
        fi
        history=$history', '$message', '
        ZSH_ASK_HISTORY=$history
        if ! $conversation; then
            break
        fi
        echo -n "\033[0;32muser: \033[0m"
        if ! read -r input; then
            break
        fi
    done
}
