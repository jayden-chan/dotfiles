# Arch Linux Configuration Files

This repository contains all of the various configuration files I use on my Linux installation. It also includes some configs for other programs/games.

## Screenshots

![alt text](/img/clean.png "Clean")
![alt text](/img/busy.png "Busy")
![alt text](/img/rofi.png "Rofi")
![alt text](/img/vim.png "Vim")

## Vim config cheatsheet

### Binds

| Keys                   | Function                                       | Mode            |
| ---------------------- | ---------------------------------------------- | --------------- |
| `space`                | Leader                                         | Normal          |
| `F9`                   | Toggle relative line numbers                   | Normal          |
| `<leader>` + `s` + `s` | Reload vimrc                                   | Normal          |
| `ctrl` + `s`           | Save all                                       | Normal & Insert |
| `F6`                   | Toggle spellcheck                              | Normal          |
| `;` `;`                | Insert semicolon at EOL                        | Insert          |
| `<leader>` + `w` + `w` | Remove trailing whitespace                     | Normal          |
| `<leader>` + `t` + `t` | Auto indent file                               | Normal          |
| `ctrl` + `m`           | Expand 'thicc' comment                         | Normal          |
| `g` + `o`              | Insert line below without entering insert mode | Normal          |
| `<leader>` + `d` + `d` | Delete line without filling yank buffer        | Normal & Visual |
| `x`                    | Delete without filling yank buffer             | Normal & Visual |
| `c`                    | Change without filling yank buffer             | Normal & Visual |
| `c` + `c`              | Replace line without filling yank buffer       | Normal          |
| `ctrl` + `n`           | Open file explorer (NERDTree)                  | Normal          |

### Settings
* Syntax on
* 256 colors on
* Soft tabs (spaces) size 4
* Smart tab & smart indent on
* Backspace on
* Find & replace is global by default
* Searching is not case sensitive
* Incremental search enabled
* Splits open to the right
* Current line is highlighted
* Command bar hidden
* Cursor will not reach top/bottom 8 lines
* .tex set to LaTeX syntax
* Update time set to 1s
* Airline powerline fonts enabled
* YCM keys set to `Enter` and `Down`
* JavaScript, HTML, CSS, JSON set to 2 space tabs
* snippets, Go set to hard tabs, 4 chars
* Spell check auto-enabled for gitcommit, text, markdown, LaTeX
* NERDTree opens automatically
