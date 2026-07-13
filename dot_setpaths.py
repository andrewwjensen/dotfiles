#!/usr/bin/env python3
#
# Print commands which set path variables to stdout.

import os
import sys

debug = False

def canon(directory):
    """Return canonicalized path."""
    if not directory or not os.path.isdir(directory):
        return None
    else:
        return directory


def add_path(var, new_path, sep=':', at_front=False):
    current_val = os.getenv(var)
    paths = []
    if current_val:
        paths = current_val.split(sep)
    new_path = canon(new_path)
    if new_path and new_path not in paths and os.path.realpath(new_path) not in paths:
        if at_front:
            new_val = [new_path] + paths
        else:
            new_val = paths + [new_path]
        os.environ[var] = ':'.join(new_val)


def set_path():
    """Set up the PATH environment variable"""

    # "at front" section (note: add in reverse order you wish paths to appear in $PATH)
    add_path('PATH', '/usr/local/bin', at_front=True)
    add_path('PATH', '/opt/homebrew/bin', at_front=True)
    add_path('PATH', '/usr/local/opt/findutils/libexec/gnubin', at_front=True)
    add_path('PATH', os.path.join(os.environ['HOME'], 'Library/Python/3.7/bin'), at_front=True)
    add_path('PATH', os.path.join(os.environ['HOME'], '.local/bin'), at_front=True)
    add_path('PATH', os.path.join(os.environ['HOME'], 'IdeaProjects/stratus-aws/scripts'), at_front=True)
    add_path('PATH', os.path.join(os.environ['HOME'], 'bin/archind'), at_front=True)
    add_path('PATH', os.path.join(os.environ['HOME'], 'bin'), at_front=True)
    add_path('PATH', os.path.join(os.environ['HOME'], 'unix-environment/bin/src/mine/build-default'), at_front=True)
    add_path('PATH', os.path.join(os.environ['HOME'], 'unix-environment/bin/src/mine/bazel-bin'), at_front=True)

    # Other paths
    add_path('PATH', os.path.join(os.environ['HOME'], 'Library/Application Support/JetBrains/Toolbox/scripts'))
    add_path('PATH', os.path.join(os.environ['HOME'], 'dev/util/tis'))
    add_path('PATH', os.path.join(os.environ['HOME'], 'dev/util/bin'))
    add_path('PATH', os.path.join(os.environ['HOME'], 'dev/scripts'))
    add_path('PATH', os.path.join(os.environ['HOME'], 'dev/curlstuff'))
    add_path('PATH', os.path.join(os.environ['HOME'], '.pyenv/bin'))
    add_path('PATH', '/usr/local/sbin')
    add_path('PATH', '/Library/Frameworks/Python.framework/Versions/3.7/bin')
    add_path('PATH', '/usr/local/opt/tomcat@8/bin')

    # For Raspberry Pi
    add_path('PATH', '/usr/sbin')
    add_path('PATH', '/sbin')
    add_path('PATH', '/usr/local/games')
    add_path('PATH', '/usr/games')

    if os.getenv('PATH'):
        print('export PATH="{}"'.format(os.environ["PATH"]))


def set_pythonpath():
    """Set up the PYTHONPATH environment variable"""

    add_path('PYTHONPATH', os.path.join(os.environ['HOME'], 'dev/util'))
    if os.getenv('PYTHONPATH'):
        print('export PYTHONPATH="{}"'.format(os.environ["PYTHONPATH"]))


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
