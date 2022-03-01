#!/bin/bash

cd $(dirname $0)

for d in external_{1,2,3}; do
  tar cf $d.tar $d
done

build() {
  echo "--- $1 ---"
(cd main_$1;
 bazel build @external//:note
 cat $(bazel info bazel-bin)/external/external/note.txt)
}

build A
# build B
build C
build D
build E
build E1
build E2
build F
build G
build G1
build G2
