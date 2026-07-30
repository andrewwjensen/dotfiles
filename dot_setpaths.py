#!/usr/bin/env python3
#
# Print commands which set path variables to stdout.

import os
import sys
from collections import deque
from pathlib import Path

debug = False


def canon(directory: Path) -> Path | None:
    """Return canonicalized path."""
    if not directory or not directory.is_dir():
        return None
    else:
        return directory


def debug_path(msg, path):
    if debug:
        print(f'{msg}:\n  {"\n  ".join(map(str, path))}', file=sys.stderr)


def parse_path_variable(var_name) -> deque[Path]:
    """Parse a path variable into a list of paths."""
    current_val = os.getenv(var_name)
    if current_val:
        # Keep only the first occurrence of each entry while preserving order.
        paths = deque(Path(p) for p in dict.fromkeys(current_val.split(os.pathsep)))
    else:
        paths = deque()
    debug_path(f'{var_name} before modification', paths)
    return paths


def set_path_from_list(var_name: str, paths, /, sep=os.pathsep):
    """Output a shell command to set a path variable from a list of paths."""
    if paths:
        print(f'export {var_name}="{sep.join(map(str, paths))}"')
    debug_path(f'{var_name} after modification', paths)


def add_path(paths: deque[Path], path_str: str | Path, /, at_front=False):
    """Add a path to a list of paths."""
    path = Path(path_str)
    if debug:
        print(f'Adding [{path}]{" at front" if at_front else ""}', file=sys.stderr)
    new_path = canon(path)
    if new_path and new_path not in paths and new_path.resolve() not in {p.resolve() for p in paths}:
        if at_front:
            paths.appendleft(new_path)
        else:
            paths.append(new_path)


def set_path():
    """Set up the PATH environment variable"""
    paths = parse_path_variable('path_input')
    home = Path(os.environ['HOME'])

    # "at front" section (note: add in reverse order you wish paths to appear in $PATH)
    add_path(paths, Path('/usr/local/bin'), at_front=True)
    add_path(paths, Path('/opt/homebrew/bin'), at_front=True)
    add_path(paths, home / '.local/bin', at_front=True)
    add_path(paths, home / 'IdeaProjects/stratus-aws/scripts', at_front=True)
    add_path(paths, home / 'bin/archind', at_front=True)
    add_path(paths, home / 'bin', at_front=True)
    add_path(paths, home / 'unix-environment/bin/archind', at_front=True)
    add_path(paths, home / 'unix-environment/bin/src/mine/bazel-bin', at_front=True)

    # Other paths
    add_path(paths, home / 'Library/Application Support/JetBrains/Toolbox/scripts')
    add_path(paths, home / 'dev/util/tis')
    add_path(paths, Path('/usr/local/sbin'))
    add_path(paths, Path('/Library/Frameworks/Python.framework/Versions/3.7/bin'))
    add_path(paths, Path('/usr/local/opt/tomcat@8/bin'))

    # For Raspberry Pi
    add_path(paths, Path('/usr/sbin'))
    add_path(paths, Path('/sbin'))
    add_path(paths, Path('/usr/local/games'))
    add_path(paths, Path('/usr/games'))

    set_path_from_list('PATH', paths)


def set_pythonpath():
    """Set up the PYTHONPATH environment variable"""
    paths = parse_path_variable('ppath_input')
    add_path(paths, Path(os.environ['HOME']) / 'dev/util')
    set_path_from_list('PYTHONPATH', paths)


def main():
    if os.environ['HOME'] == '/':
        # Special case for root user; just set HOME to something
        # bogus so we don't get an unwanted entry for /bin
        os.environ['HOME'] = '/InVaLiD:dIrEcToRy'
    set_path()
    set_pythonpath()
    return 0


if __name__ == '__main__':
    sys.exit(main())
