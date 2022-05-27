#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import ast
import json
import pathlib
import re

srcs = pathlib.Path('src')
my_extra_paths = []
for repo_file in srcs.glob('**/.git'):
    if (repo_file.parent / 'CATKIN_IGNORE').exists():
        continue
    config = repo_file.parent / 'setup.cfg'
    if not config.exists():
        config.symlink_to(pathlib.Path.home() / 'work/.github/setup.cfg')
for setup_file in srcs.glob('**/setup.py'):
    if '.venv' in str(setup_file):
        continue
    if (setup_file.parent / 'CATKIN_IGNORE').exists():
        continue
    with open(setup_file, 'r') as f:
        for line in f:
            if 'package_dir' in line:
                elms = [e.strip(' \n\t)') for e in re.split('[=,]', line)]
                index = -1
                for i, e in enumerate(elms):
                    if 'package_dir' in e:
                        index = i + 1
                if index == -1:
                    break
                package_dir = ast.literal_eval(elms[index])
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
