#!/usr/bin/env python3
#
# Print commands which set path variables to stdout.

import os
import sys
from collections import deque
from pathlib import Path

debug = False

HOME = Path(os.environ['HOME'])


def canon(directory):
    """Return canonicalized path."""
    if not directory or not os.path.isdir(directory):
        return None
    else:
        return str(directory)


def parse_path_variable(var_name) -> deque[str]:
    """Parse a path variable into a list of paths."""
    current_val = os.getenv(var_name)
    if current_val:
        # Keep only the first occurrence of each entry while preserving order.
        return deque(dict.fromkeys(current_val.split(':')))
    else:
        return deque()


def set_path_from_list(var_name: str, paths: list[str], /, sep=':'):
    """Output a shell command to set a path variable from a list of paths."""
    if paths:
        print(f'export {var_name}="{sep.join(paths)}"')


def add_path(paths: deque[str], path: str, /, sep=':', at_front=False):
    """Add a path to a list of paths."""
    new_path = canon(path)
    if new_path and new_path not in paths and os.path.realpath(new_path) not in paths:
        if at_front:
            new_val = paths.appendleft(new_path)
        else:
            new_val = paths.append(new_path)


def set_path():
    """Set up the PATH environment variable"""
    paths = parse_path_variable('PATH')

    # "at front" section (note: add in reverse order you wish paths to appear in $PATH)
    add_path(paths, '/usr/local/bin', at_front=True)
    add_path(paths, '/opt/homebrew/bin', at_front=True)
    add_path(paths, '/usr/local/opt/findutils/libexec/gnubin', at_front=True)
    add_path(paths, HOME / 'Library/Python/3.7/bin', at_front=True)
    add_path(paths, HOME / '.local/bin', at_front=True)
    add_path(paths, HOME / 'IdeaProjects/stratus-aws/scripts', at_front=True)
    add_path(paths, HOME / 'bin/archind', at_front=True)
    add_path(paths, HOME / 'bin', at_front=True)
    add_path(paths, HOME / 'unix-environment/bin/archind', at_front=True)
    add_path(paths, HOME / 'unix-environment/bin/src/mine/build-default', at_front=True)
    add_path(paths, HOME / 'unix-environment/bin/src/mine/bazel-bin', at_front=True)

    # Other paths
    add_path(paths, HOME / 'Library/Application Support/JetBrains/Toolbox/scripts')
    add_path(paths, HOME / 'dev/util/tis')
    add_path(paths, HOME / 'dev/util/bin')
    add_path(paths, HOME / 'dev/scripts')
    add_path(paths, HOME / 'dev/curlstuff')
    add_path(paths, HOME / '.pyenv/bin')
    add_path(paths, '/usr/local/sbin')
    add_path(paths, '/Library/Frameworks/Python.framework/Versions/3.7/bin')
    add_path(paths, '/usr/local/opt/tomcat@8/bin')

    # For Raspberry Pi
    add_path(paths, '/usr/sbin')
    add_path(paths, '/sbin')
    add_path(paths, '/usr/local/games')
    add_path(paths, '/usr/games')

    set_path_from_list('PATH', paths)


def set_pythonpath():
    """Set up the PYTHONPATH environment variable"""
    paths = parse_path_variable('PYTHONPATH')
    add_path(paths, HOME / 'dev/util')
    set_path_from_list('PYTHONPATH', paths)


def main():
    global HOME
    if HOME == Path('/'):
        # Special case for root user; just set HOME to something
        # bogus so we don't get an unwanted entry for /bin
        HOME = Path('/InVaLiD:dIrEcToRy')
    set_path()
    set_pythonpath()
    return 0


if __name__ == '__main__':
    sys.exit(main())
