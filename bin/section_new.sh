#! /bin/bash

set -euo pipefail

bin_dir_path=$(cd -- "$(dirname -- "$0")" && pwd -P)
root_dir_path=$(dirname "$bin_dir_path")

if [ $# -ne 1 ]
then
  echo "usage: ${0} <content 配下に作成する section のパス>" >&2
  exit 1
fi

# realpath は存在しないパスを解決できないため、親ディレクトリだけを解決して繋ぎ直す
parent_dir_path=$(cd -- "$(dirname -- "$1")" 2>/dev/null && pwd -P) || {
  echo "親ディレクトリが存在しません。 ${1}" >&2
  exit 1
}
section_dir_path="${parent_dir_path}/$(basename -- "$1")"

# 指定された path が content ディレクトリ内のパスかどうかを確認する
case "$section_dir_path" in
  "$root_dir_path/content/"*)
    ;;
  *)
    echo "指定された path は content ディレクトリ内のパスではありません。 ${1}" >&2
    exit 1
    ;;
esac

if [ -e "$section_dir_path" ]
then
  echo "${1} は既に存在しています。" >&2
  exit 1
fi

mkdir -- "$section_dir_path"

section_index_file_path="${section_dir_path}/_index.md"
section_title=$(basename -- "$section_dir_path")

# .md ファイルの先頭にヘッダを追加する
cat <<EOL > "$section_index_file_path"
+++
title = "$section_title"
sort_by = "date"
description = ""
+++

## 

EOL

echo "${1} に新しい section を作成しました。"
