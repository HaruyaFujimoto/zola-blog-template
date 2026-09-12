#! /bin/bash

set -euo pipefail

bin_dir_path=$(cd -- "$(dirname -- "$0")" && pwd -P)
root_dir_path=$(dirname "$bin_dir_path")

if [ $# -ne 1 ]
then
  echo "usage: ${0} <content/articles 配下に作成する記事セクション名>" >&2
  exit 1
fi

section_name="$1"

# ネスト禁止 + トラバーサル対策
case "$section_name" in
  ""|.|..|*/*)
    echo "セクション名が不正です（スラッシュを含まない単一階層の名前を指定してください）。 ${section_name}" >&2
    exit 1
    ;;
esac

articles_dir_path=$(cd -- "${root_dir_path}/content/articles" && pwd -P)
section_dir_path="${articles_dir_path}/${section_name}"

if [ -e "$section_dir_path" ]
then
  echo "content/articles/${section_name} は既に存在しています。" >&2
  exit 1
fi

mkdir -- "$section_dir_path"

section_index_file_path="${section_dir_path}/_index.md"

# .md ファイルの先頭にヘッダを追加する
cat <<EOL > "$section_index_file_path"
+++
title = "$section_name"
sort_by = "date"
description = ""
transparent = true
+++

##

EOL

echo "content/articles/${section_name} に新しい記事セクションを作成しました。"
