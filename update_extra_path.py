#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import json
import pathlib

srcs = pathlib.Path('src')
my_extra_paths = []
for setup_file in srcs.glob('**/setup.py'):
    if '.venv' in str(setup_file):
        continue
    if (setup_file.parent / 'CATKIN_IGNORE').exists():
        continue
    my_extra_paths.append(str("${workspaceFolder}" / setup_file.parent / 'src'))
# print(extra_path)

with open('.vscode/settings.json', 'r') as f:
    settings = json.load(f)

extra_paths = settings['python.analysis.extraPaths'][-2:]
settings['python.analysis.extraPaths'] = my_extra_paths + extra_paths
settings['python.autoComplete.extraPaths'] = my_extra_paths + extra_paths

with open('.vscode/settings.json', 'w') as f:
    json.dump(settings, f)
