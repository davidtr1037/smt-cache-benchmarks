# Replication Package

## Build & Install
Install the following requirements:
```
sudo apt-get install cmake bison flex libboost-all-dev python perl zlib1g-dev build-essential curl libcap-dev git cmake libncurses5-dev python-minimal python-pip unzip libtcmalloc-minimal4 libgoogle-perftools-dev libsqlite3-dev doxygen
pip3 install tabulate wllvm
```

Install LLVM 7.0:

```
wget https://releases.llvm.org/7.0.0/llvm-7.0.0.src.tar.xz
wget https://releases.llvm.org/7.0.0/cfe-7.0.0.src.tar.xz
wget https://releases.llvm.org/7.0.0/compiler-rt-7.0.0.src.tar.xz
tar xJf llvm-7.0.0.src.tar.xz
tar xJf cfe-7.0.0.src.tar.xz
tar xJf compiler-rt-7.0.0.src.tar.xz
mv cfe-7.0.0.src llvm-7.0.0.src/tools/clang
mv compiler-rt-7.0.0.src compiler-rt
mkdir llvm-7.0.0.obj
cd llvm-7.0.0.obj
cmake CMAKE_BUILD_TYPE:STRING=Release -DLLVM_ENABLE_THREADS:BOOL=ON -DLLVM_ENABLE_PROJECTS:STRING=compiler-rt ../llvm-7.0.0.src
make -j4
```
Update the following variables:
```
export PATH=<llvm_build_dir>/bin:$PATH
export LLVM_COMPILER=clang
```

Install minisat:

```
git clone https://github.com/stp/minisat.git
cd minisat
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/ ../
sudo make install
```

Install STP:

```
git clone https://github.com/stp/stp.git
cd stp
git checkout tags/2.3.3
mkdir build
cd build
cmake ..
make
sudo make install
```

Install klee-uclibc:
```
git clone https://github.com/klee/klee-uclibc.git
cd klee-uclibc
git checkout 038b7dc050c07a7b4d941b48a0f548eea3089214
./configure --make-llvm-lib
make
cd ..
```

In our evaluation we used two versions of KLEE:
- Baseline KLEE
- Our extension of KLEE

Building Baseline KLEE:
```
cd src
mkdir klee-vanilla-build
cd klee-vanilla-build
CXXFLAGS="-fno-rtti" cmake \
    -DENABLE_SOLVER_STP=ON \
    -DENABLE_POSIX_RUNTIME=ON \
    -DENABLE_KLEE_UCLIBC=ON \
    -DKLEE_UCLIBC_PATH=<klee_uclibc_dir> \
    -DLLVM_CONFIG_BINARY=<llvm_build_dir>/bin/llvm-config \
    -DLLVMCC=<llvm_build_dir>/bin/clang \
    -DLLVMCXX=<llvm_build_dir>/bin/clang++ \
    -DENABLE_UNIT_TESTS=OFF \
    -DKLEE_RUNTIME_BUILD_TYPE=Release+Asserts \
    -DENABLE_SYSTEM_TESTS=ON \
    -DENABLE_TCMALLOC=ON \
    ../klee-vanilla
make
```

Building our extension of KLEE:
```
cd src
mkdir klee-qc-build
cd klee-qc-build
CXXFLAGS="-fno-rtti" cmake \
    -DENABLE_SOLVER_STP=ON \
    -DENABLE_POSIX_RUNTIME=ON \
    -DENABLE_KLEE_UCLIBC=ON \
    -DKLEE_UCLIBC_PATH=<klee_uclibc_dir> \
    -DLLVM_CONFIG_BINARY=<llvm_build_dir>/bin/llvm-config \
    -DLLVMCC=<llvm_build_dir>/bin/clang \
    -DLLVMCXX=<llvm_build_dir>/bin/clang++ \
    -DENABLE_UNIT_TESTS=OFF \
    -DKLEE_RUNTIME_BUILD_TYPE=Release+Asserts \
    -DENABLE_SYSTEM_TESTS=ON \
    -DENABLE_TCMALLOC=ON \
    ../klee-qc
make
```

## Configuration
Edit `benchmarks/config.sh`:
```
#!/bin/bash

VANILLA_KLEE=<root_dir>/src/klee-vanilla-build/bin/klee
KLEE=<root_dir>/src/klee-qc-build/bin/klee
ARTIFACT_DIR=<output_dir>
```
Edit `benchmarks/Makefile.config`:
```
KLEE_SRC := <root_dir>/src/klee-qc
```
Edit `benchmarks/coreutils/test.env`:
```
PWD=<root_dir>/benchmarks/coreutils
```

## Benchmarks

Compile the benchmarks:
```
cd benchmarks
./build.sh
```

## Traces

We provide the traces of our experiments (KLEE-output directories),
which can be found in the `traces` directory.
Use the following commands to extract the results of our experiments.

Table 2:
```
python benchmarks/check_stats.py traces/validation
```

Table 3:
```
python benchmarks/check_queries.py traces/qc_fmm
python benchmarks/check_queries.py traces/qc_dsmm
```

Table 4:
```
python benchmarks/check_time.py traces/qc_fmm
python benchmarks/check_time.py traces/qc_dsmm
```

Table 5:
```
python benchmarks/check_cache_size.py traces/qc_fmm
python benchmarks/check_cache_size.py traces/qc_dsmm
```

Figure 4:
```
python benchmarks/check_memory_usage.py traces/qc_fmm
python benchmarks/check_memory_usage.py traces/qc_dsmm
```

Overhead (section VI.D):
```
python benchmarks/check_overhead.py traces/overhead_fmm
python benchmarks/check_overhead.py traces/overhead_dsmm
```

## Experiments

### Empirical Validation

Run the following command (from the `benchmarks` directory):
```
./run_validation_all.sh
```

### Performance
Run the following command (from the `benchmarks` directory):
```
./run_qc_all.sh
```

### Overhead
Run the following command (from the `benchmarks` directory):
```
./run_overhead_all.sh
```
