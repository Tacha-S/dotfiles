#!/usr/bin/env python3
# -*- coding:utf-8 -*-

import json
import pathlib

workspaces_root = pathlib.Path('.').absolute().parent.parent
srcs = workspaces_root / 'src'
folders = sorted([f for f in srcs.iterdir() if f.is_dir()])
my_extra_paths = []
for setup_file in srcs.glob('**/setup.py'):
    if '.venv' in str(setup_file):
        continue
    if (setup_file.parent / 'CATKIN_IGNORE').exists():
        continue
    if (setup_file.parent / 'pyproject.toml').exists():
        pathlib.Path(setup_file.parent / 'pyproject.toml').unlink()
    # with open(setup_file, 'r') as f:
    #     for line in f:
    #         if 'package_dir' in line:
    #             dirs = re.split('[=]', line)[-1].strip().strip(')')
    #             if dirs.endswith(','):
    #                 dirs = dirs[:-1]
    #             package_dir = ast.literal_eval(dirs)
    #             for k, v in package_dir.items():
    #                 if k == '':
    #                     my_extra_paths.append(str((setup_file.parent.absolute() / v)))
    my_extra_paths.append(str(setup_file.parent.absolute()))

for msgs in (workspaces_root / 'install').glob('**/local/lib/python*/dist-packages'):
    my_extra_paths.append(str(msgs))

workspaces = list(workspaces_root.glob('*.code-workspace'))
if not workspaces:
    workspace_file = workspaces_root / f'{workspaces_root.name}.code-workspace'
    settings = {'settings': {}}
else:
    workspace_file = workspaces[0]
    with open(workspace_file, 'r') as f:
        settings = json.load(f)

excludes = []
if 'excludeFolders' in settings:
    for folder in settings['excludeFolders']:
        excludes.append(folder['path'])
settings['folders'] = [{
    'path': str(f.relative_to(workspaces_root))
} for f in folders if str(f.relative_to(workspaces_root)) not in excludes]
exclude_folders = []
relative_paths = [str(f.relative_to(workspaces_root)) for f in folders]
if 'excludeFolders' in settings:
    for folder in settings['excludeFolders']:
        if folder['path'] in relative_paths:
            exclude_folders.append(folder)
settings['excludeFolders'] = exclude_folders

extra_paths = []
if 'python.analysis.extraPaths' in settings['settings']:
    extra_paths = settings['settings']['python.analysis.extraPaths'][-2:]
settings['settings']['python.analysis.extraPaths'] = my_extra_paths + extra_paths
settings['settings']['python.autoComplete.extraPaths'] = my_extra_paths + extra_paths

with open(workspace_file, 'w') as f:
    json.dump(settings, f)
