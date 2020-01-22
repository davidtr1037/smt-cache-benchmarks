from check_test_cases import *

def main():
    with open(sys.argv[1]) as f:
        template = f.read()

    suite = get_test_cases(sys.argv[2])
    out_dir = sys.argv[3]

    for index, test in enumerate(suite):
        d = "'"
        for i, c in enumerate(template):
            if c == '?':
                d += test[i]
            else:
                d += c
        with open(os.path.join(out_dir, "test_%d" % index), "w+") as f:
            f.write(d)

if __name__ == "__main__":
    main()
