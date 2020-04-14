import sys
import glob
import os
from klee_out_parser import KLEEOut


PREFIX = "experiments-overhead"

def validate(ko1, ko2):
    return ko1.instructions == ko2.instructions and ko1.paths == ko2.paths

def compare(ko1, ko2, program=None):
    if not validate(ko1, ko2):
        print "Inconsistent result:"
        ko1.dump()
        ko2.dump()
        return

    print "{},{},{}".format(program, ko1.time, ko2.time)

def get_dirs():
    dirs = []
    programs = [
        "libosip",
        "libyaml",
        "base32",
        "cat",
        "numfmt",
        "stdbuf",
        "timeout",
        "factor",
        "hostid",
        "nice",
        "stty",
        "tr",
    ]

    for p in programs:
        klee_out_dir = os.path.join(PREFIX, "klee-out-{}".format(p))
        cache_out_dir = os.path.join(PREFIX, "cache-out-{}".format(p))
        if os.path.exists(klee_out_dir) and os.path.exists(cache_out_dir):
            dirs.append((p, klee_out_dir, cache_out_dir, ))
        else:
            print "skipping program: {}".format(p)

    return dirs

def main():
    for program, baseline, cache in get_dirs():
        ko1 = KLEEOut(baseline)
        ko2 = KLEEOut(cache)
        compare(ko1, ko2, program)

if __name__ == '__main__':
    main()
