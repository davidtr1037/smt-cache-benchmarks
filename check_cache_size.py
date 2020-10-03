import sys
import glob
import os
from klee_out_parser import KLEEOut


PROGRAMS = [
    "m4",
    "make",
    "sqlite",
    "apr",
    "libxml2",
    "expat",
    "bash",
    "json",
]

def validate(ko1, ko2):
    return ko1.instructions == ko2.instructions and ko1.paths == ko2.paths

def compare(ko1, ko2, program=None):
    if not validate(ko1, ko2):
        print "Inconsistent result:"
        ko1.dump()
        ko2.dump()
        return

    print "{},{},{},{},{}".format(program, ko1.time, ko2.time, ko1.memory, ko2.memory)

def dump(root_dir):
    for p in PROGRAMS:
        klee_out_dir = os.path.join("{}/out-klee".format(os.path.join(root_dir, p)))
        cache_out_dir = os.path.join("{}/out-cache".format(os.path.join(root_dir, p)))
        if os.path.exists(klee_out_dir) and os.path.exists(cache_out_dir):
            klee_ko = KLEEOut(klee_out_dir)
            cache_ko = KLEEOut(cache_out_dir)
            print "{}:\n- klee: {}\n- cache: {}".format(p, klee_ko.cache_size, cache_ko.cache_size)
        else:
            assert(False)

def main():
    if len(sys.argv) != 2:
        print "Usage: <qc_dir>"
        return

    dump(sys.argv[1])

if __name__ == '__main__':
    main()
