import sys
import os
import re
import subprocess


class KLEEOut(object):

    def __init__(self, dir_path, parse_query_stats=False):
        self.dir_path = dir_path
        self.time = None
        self.instructions = None
        self.paths = None

        if not os.path.exists(dir_path):
            raise Exception("missing directory: {}".format(dir_path))

        self.parse_info(parse_query_stats=parse_query_stats)
        self.parse_stats()

    def parse_info(self, parse_query_stats=False):
        with open(os.path.join(self.dir_path, "info")) as f:
            lines = f.readlines()
            self.paths = self.get_completed_paths(lines)
            self.queries = self.get_queries(lines)
            self.elapsed = self.get_elapsed_time(lines)

        with open(os.path.join(self.dir_path, "messages.txt")) as f:
            lines = f.readlines()
            self.cache_size = self.get_cache_size(lines)
            if parse_query_stats:
                self.all_queries = self.get_all_queries(lines)
                self.relevant_queries = self.get_relevant_queries(lines)
                self.relevant_address_dependent_queries = self.get_relevant_ad_queries(lines)
                self.unhandled_queries = self.get_unhandled_queries(lines)

    def get_completed_paths(self, lines):
        for line in lines:
            m = re.search("KLEE: done: completed paths = (\w*)", line)
            if m is not None:
                return int(m.groups()[0])
    
        return None

    def get_queries(self, lines):
        for line in lines:
            m = re.search("KLEE: done: total queries = (\w*)", line)
            if m is not None:
                return int(m.groups()[0])

        return None

    def get_elapsed_time(self, lines):
        for line in lines:
            m = re.search("Elapsed: ([\w:]*)", line)
            if m is not None:
                return m.groups()[0]
    
        return None

    def get_cache_size(self, lines):
        for line in lines:
            m = re.search("KLEE: - Total cache: (\w*)", line)
            if m is not None:
                qs = int(m.groups()[0])
                if qs != 0:
                    return qs

            m = re.search("KLEE: Query cache size: (\w*)", line)
            if m is not None:
                return int(m.groups()[0])

        return None

    def get_all_queries(self, lines):
        for line in lines:
            m = re.search("KLEE: - All queries: (\w*)", line)
            if m is not None:
                return m.groups()[0]

        return None

    def get_relevant_queries(self, lines):
        for line in lines:
            m = re.search("KLEE: - Relevant queries: (\w*)", line)
            if m is not None:
                return m.groups()[0]

        return None

    def get_relevant_ad_queries(self, lines):
        for line in lines:
            m = re.search("KLEE: - Relevant address dependent queries: (\w*)", line)
            if m is not None:
                return m.groups()[0]

        return None

    def get_unhandled_queries(self, lines):
        for line in lines:
            m = re.search("KLEE: - Unhandles queries: (\w*)", line)
            if m is not None:
                return m.groups()[0]

        return None

    def get_elapsed_time(self, lines):
        for line in lines:
            m = re.search("Elapsed: ([\w:]*)", line)
            if m is not None:
                return m.groups()[0]

        return None

    def parse_stats(self):
        p = subprocess.Popen(
            ["klee-stats", "--print-more", self.dir_path],
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=False
        )
        out, err = p.communicate()
        lines = out.split("\n")
        values = [v.strip() for v in lines[3].split('|')]
        self.instructions = int(values[2])
        self.time = int(float((values[3])))
        self.memory = int(float((values[10])))

    def dump(self):
        print "Time: {}".format(self.time)
        print "Instructions: {}".format(self.instructions)
        print "Paths: {}".format(self.paths)

def main():
    klee_dir = sys.argv[1]
    ko = KLEEOut(klee_dir)
    ko.dump()

if __name__ == '__main__':
    main()
