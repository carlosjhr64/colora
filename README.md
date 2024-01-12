# Colora

* [VERSION 0.1.240112](https://github.com/carlosjhr64/colora/releases)
* [github](https://www.github.com/carlosjhr64/colora)
* [rubygems](https://rubygems.org/carlosjhr64/colora)

## DESCRIPTION

Colorizes terminal outputs.

Uses `Rouge::Formatters::Terminal256` to theme/color output to the terminal.
Color codes git diff.

## INSTALL
```console
$ gem install colora
```
## SYNOPSIS
```console
$ # Color outputs file
$ colora ./README.md
$ # Colorizing filter
$ cat README.md | colora
$ # Git running
$ colora --git
```
## HELP
```console
$ colora --help
Usage:
  colora [:options+] [<file=FILE>]
Options:
  -q --quiet
  -g --green   	 Skip red:   /^[-<]/
  -r --red     	 Skip green: /^[+>]/
  -c --code    	 Show only new(changed) code
  -d --dup     	 Show only duplicate code
  -G --git     	 Run git-diff
  --theme=WORD 	 Rouge theme(default: github)
  --lang=WORD  	 Language being diffed
Types:
  FILE /^[-\w\.\/]+$/
  WORD /^[a-z]+$/
Exclusive:
  green red
```
## LICENSE

Copyright (c) 2024 CarlosJHR64

Permission is hereby granted, free of charge,
to any person obtaining a copy of this software and
associated documentation files (the "Software"),
to deal in the Software without restriction,
including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and
to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice
shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS",
WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
