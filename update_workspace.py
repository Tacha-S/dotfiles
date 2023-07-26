#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import ast
import json
import pathlib
import re

srcs = pathlib.Path('src')
folders = sorted([f for f in srcs.iterdir() if f.is_dir()])
my_extra_paths = []
for repo_file in srcs.glob('**/.git'):
    if (repo_file.parent / 'CATKIN_IGNORE').exists():
        continue
    old_config = repo_file.parent / 'setup.cfg'
    if old_config.is_symlink():
        old_config.unlink()
    config = repo_file.parent / 'pyproject.toml'
    if not config.exists():
        config.symlink_to(pathlib.Path.home() / 'work/.github/pyproject.toml')
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
                        my_extra_paths.append(str(setup_file.parent.absolute() / v))

workspace_file = list(pathlib.Path('.').glob('*.code-workspace'))[0]
with open(workspace_file, 'r') as f:
    settings = json.load(f)

settings['folders'] = [{'path': str(f)} for f in folders]
extra_paths = settings['settings']['python.analysis.extraPaths'][-2:]
settings['settings']['python.analysis.extraPaths'] = my_extra_paths + extra_paths
settings['settings']['python.autoComplete.extraPaths'] = my_extra_paths + extra_paths

with open(workspace_file, 'w') as f:
    json.dump(settings, f)
