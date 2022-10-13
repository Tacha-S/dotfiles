#!/bin/zsh -eu

cat ./build_release/*/**/compile_commands.json > build_release/compile_commands.json && sed -i -e ':a;N;$!ba;s/\]\n*\[/,/g' build_release/compile_commands.json
compdb -p build_release list > compile_commands.json
