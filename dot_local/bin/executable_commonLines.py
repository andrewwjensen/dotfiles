#!/usr/bin/env python3
#
# Check for common lines across files specified on the command line.
#
# The output is aggregated according to the number of files a given line
# occurred in, lowest to highest. In each section, a line is printed, followed
# by a list of all the filenames given on the command line. The filenames in
# which the line was found are highlighted.

import sys
from collections import defaultdict
from typing import DefaultDict, Dict, Set, List

from rich import print


def output_match(s: str):
    print(f'[green]{s}', end=' ')


def output_miss(s: str):
    print(f'[red]{s}', end=' ')


def output_summary(line: str, max_line_length: int, files: Set[str], all_filenames: List[str]):
    print(f'  {line}', end='')
    print('[yellow]' + '.' * (max_line_length - len(line) + 1) + ' ', end='')
    for filename in all_filenames:
        if filename in files:
            output_match(filename)
        else:
            output_miss(filename)
    print()


def plural(n):
    return '' if n == 1 else 's'


def main():
    unique_lines: DefaultDict[str, Set[str]] = defaultdict(set)
    all_filenames = sys.argv[1:]
    max_line_len = 0
    for fn in all_filenames:
        with open(fn) as f:
            for line in f:
                line = line.strip()
                max_line_len = max(max_line_len, len(line))
                unique_lines[line].add(fn)

    histogram: DefaultDict[int, Dict] = defaultdict(dict)
    for line in unique_lines:
        filename_list = unique_lines[line]
        num_files = len(filename_list)
        histogram[num_files][line] = filename_list

    for num_files in sorted(histogram):
        print(f'{len(histogram[num_files])} Lines contained in {num_files} file{plural(num_files)}:')
        for line in sorted(histogram[num_files]):
            files = histogram[num_files][line]
            output_summary(line, max_line_len, files, all_filenames)


if __name__ == '__main__':
    main()
