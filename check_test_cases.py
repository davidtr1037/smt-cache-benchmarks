import sys
import os
from glob import glob
import subprocess
import json
import re

OBJ_NAME = re.compile("object (\d*): name: '(.*)'")
OBJ_DATA = re.compile("object (\d*): data: b'(.*)'")


def ktest_tool(f):
    p = subprocess.Popen(["ktest-tool", f], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=False)
    out, err = p.communicate()
    lines = out.split("\n")
    return lines

def get_obj_id(lines, obj_name):
    for l in lines:
        match = OBJ_NAME.findall(l)
        if len(match) != 0:
            obj_id, name = match[0]
            if name == obj_name:
                return obj_id
    return None

def decode_data(data):
    return eval('"%s"' % data)

def get_obj_data(lines, obj_id):
    for l in lines:
        match = OBJ_DATA.findall(l)
        if len(match) != 0:
            _id, data = match[0]
            if _id == obj_id:
                return decode_data(data)
    return None

def get_data(f, obj_name):
    lines = ktest_tool(f)
    obj_id = get_obj_id(lines, obj_name)
    data = get_obj_data(lines, obj_id)
    return data

def get_test_cases(out_dir, name):
    print out_dir
    files = glob(os.path.join(out_dir, "*.ktest"))
    cases = set()
    for f in files:
        data = get_data(f, name)
        cases.add(data)
    return cases

def check_suites(suites):
    for s1 in suites:
        for s2 in suites:
            if len(s1) != len(s2):
                return False
            for t1 in s1:
                if t1 not in s2:
                    print t1
                    for x in s2:
                        print x
                    return False
    return True

def main():
    suites = []
    result_dir = sys.argv[1]
    name = sys.argv[2]
    dirs = glob(os.path.join(result_dir, "klee-out-*"))
    for d in dirs:
        s = get_test_cases(d, name)
        suites.append(s)

    if check_suites(suites):
        print "OK"
    else:
        print "DIFF"

if __name__ == "__main__":
    main()
