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
        klee_out_dir = os.path.join("{}/out-fmm".format(os.path.join(root_dir, p)))
        if os.path.exists(klee_out_dir):
            klee_ko = KLEEOut(klee_out_dir, parse_query_stats=True)
            print "{}".format(p)
            print "- C1: {}".format(klee_ko.all_queries)
            print "- C2: {}".format(klee_ko.relevant_queries)
            print "- C3: {}".format(klee_ko.relevant_address_dependent_queries)
            print "- C4: {}".format(klee_ko.relevant_address_dependent_queries - klee_ko.unhandled_queries)
        else:
            assert(False)

def main():
    if len(sys.argv) != 2:
        print "Usage: <qc_dir>"
        return

    dump(sys.argv[1])

if __name__ == '__main__':
    main()
