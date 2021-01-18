#!/bin/zsh -eu

cat ./build/*/**/compile_commands.json > build/compile_commands.json && sed -i -e ':a;N;$!ba;s/\]\n*\[/,/g' build/compile_commands.json
compdb -p build list > compile_commands.json

