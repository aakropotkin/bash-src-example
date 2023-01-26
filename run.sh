#! /usr/bin/env bash

mkdir -p ./example;

cat <<'EOF' > ./example/script1.sh
#! /usr/bin/env bash
echo "${BASH_SOURCE[0]}";
EOF

cat <<'EOF' > ./example/script2.sh
#! /usr/bin/env bash
${REALPATH:-realpath} "${BASH_SOURCE[0]}";
EOF

chmod +x ./example/script{1,2}.sh;

mkdir links;
ln -srf ./example/script1.sh ./links/link1.sh;
ln -srf ./example/script2.sh ./links/link2.sh;

PATH="$PATH:$PWD/example";
run_v() {
  echo "> $*";
  eval "$@";
  echo '';
}

run_v ./example/script1.sh;
run_v ./example/script2.sh;

run_v script1.sh;
run_v script2.sh;

run_v $PWD/example/script1.sh;
run_v $PWD/example/script2.sh;

run_v ./links/link1.sh;
run_v ./links/link2.sh;

run_v $PWD/links/link1.sh;
run_v $PWD/links/link2.sh;


ODIR="$PWD"
pushd /tmp >/dev/null;

run_v "$( realpath --relative-to "$PWD" "$ODIR/example/script1.sh"; )";
run_v "$( realpath --relative-to "$PWD" "$ODIR/example/script2.sh"; )";

popd >/dev/null;
rm -rf "$ODIR/example" "$ODIR/links";
