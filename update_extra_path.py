#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import ast
import json
import pathlib

srcs = pathlib.Path('src')
my_extra_paths = []
for setup_file in srcs.glob('**/setup.py'):
    if '.venv' in str(setup_file):
        continue
    if (setup_file.parent / 'CATKIN_IGNORE').exists():
        continue
    config = setup_file.parent / 'setup.cfg'
    if not config.exists():
        config.symlink_to(pathlib.Path.home() / 'work/.github/setup.cfg')
    with open(setup_file, 'r') as f:
        for line in f:
            if 'package_dir' in line:
                print(setup_file)
                package_dir = ast.literal_eval(line.split('=')[1].strip(' \n\t,'))
                for k, v in package_dir.items():
                    if k == '':
                        my_extra_paths.append(str("${workspaceFolder}" / setup_file.parent / v))

with open('.vscode/settings.json', 'r') as f:
    settings = json.load(f)

extra_paths = settings['python.analysis.extraPaths'][-2:]
settings['python.analysis.extraPaths'] = my_extra_paths + extra_paths
settings['python.autoComplete.extraPaths'] = my_extra_paths + extra_paths

with open('.vscode/settings.json', 'w') as f:
    json.dump(settings, f)
