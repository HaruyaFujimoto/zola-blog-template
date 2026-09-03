#! /bin/bash

set -euo pipefail

bin_dir_path=$(cd -- "$(dirname -- "$0")" && pwd -P)
root_dir_path=$(dirname "$bin_dir_path")

if [ $# -ne 1 ]
then
  echo "usage: ${0} <content 配下の .md パス>" >&2
  exit 1
fi

case "$1" in
  *.md)
    ;;
  *)
    echo "指定された path が .md ファイルではありません。 ${1}" >&2
    exit 1
    ;;
esac

# realpath は存在しないパスを解決できないため、親ディレクトリだけを解決して繋ぎ直す
parent_dir_path=$(cd -- "$(dirname -- "$1")" 2>/dev/null && pwd -P) || {
  echo "親ディレクトリが存在しません。先に bin/section_new.sh で作成してください。 ${1}" >&2
  exit 1
}
file_full_path="${parent_dir_path}/$(basename -- "$1")"

# 指定された path が content ディレクトリ内のファイルかどうかを確認する
case "$file_full_path" in
  "$root_dir_path/content/"*)
    ;;
  *)
    echo "指定された path は content ディレクトリ内のファイルではありません。 ${1}" >&2
    exit 1
    ;;
esac

if [ -e "$file_full_path" ]
then
  echo "${1} は既に存在しています。上書きを避けるため中断します。" >&2
  exit 1
fi

file_name=$(basename -- "$file_full_path")
page_title=${file_name%.md}
# section 側が sort_by = "date" のため、date が無いページは一覧から除外される
today=$(date +%F)

# .md ファイルの先頭にヘッダを追加する
cat <<EOL > "$file_full_path"
+++
title = "$page_title"
date = $today
description = ""

[taxonomies]
tags = [
  # "",
]
+++

# 

EOL

echo "${1} を作成しました。"
