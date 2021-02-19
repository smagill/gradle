#!/usr/bin/env bash
commit=$2
cmd=$3

function version() {
    echo 1
}

function applicable() {
    echo "true"
}

function gettool() {
  pushd /tmp >/dev/null
  curl -LO https://github.com/smagill/codenarc-muse/blob/main/CodeNarc-2.0.0.tgz?raw=true
  tar xzf CodeNarc-2.0.0.tgz
  popd >/dev/null
}

function emit_results() { 
  echo "$1"  | \
    jq --slurp '.[] | .file = .location.file | .line = .location.line | .type = .code | del(.location) | del(.severity) |  del(.code) | del(.end)' | jq --slurp
}

function run() {
  gettool
  raw_results=$(/tmp/codenarc ./)
  emit_results "$raw_results"
}

if [[ "$cmd" = "run" ]] ; then
  run
fi
if [[ "$cmd" = "applicable" ]] ; then
  applicable
fi
if [[ "$cmd" = "version" ]] ; then
  version
fi
