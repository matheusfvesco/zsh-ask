# zsh-ask

A lightweight Zsh plugin serves as a Ollama OpenAI API frontend, enabling you to interact with ollama models directly from the `Zsh` shell using only `cURL` and `jq`.

This plugin is a fork of [zsh-ask](https://github.com/Licheam/zsh-ask).

## Installation

See [INSTALL.md](INSTALL.md) or run `source zsh-ask.zsh` for a quick start.

## Preliminaries

Make sure you have [`cURL`](https://curl.se/) and [`jq`](https://stedolan.github.io/jq/) installed.

## Usage

Setup Ollama, download llama3.2:3b (`ollama run llama3.2:3b`) or any other model you want (see [INSTALL.md](INSTALL.md) for detail information), then just run

```
ask who are you
```

Use `-c` for dialogue format communication.

```
ask -c chat with me
```

Use `-i` to inherits history from last chat (which is recorded in ZSH_ASK_HISTORY).

```
ask -i tell me more about it
```

Use `-h` for more information.

```
ask -h
```

Have fun!

## License

This project is licensed under [MIT license](http://opensource.org/licenses/MIT). For the full text of the license, see the [LICENSE](LICENSE) file.