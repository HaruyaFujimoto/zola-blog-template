# Proposal

## Why

一覧ページのページネーションを Bulma 公式の pagination の作りに揃えたい。現状は次の 2 点で公式と異なる。

- `<section class="content">` の内側にあり、Bulma の `.content` が記事本文用に `ul` / `li` へ当てるスタイル (`li+li` の上余白、`ul` の左インデント) が漏れている。1 ページ目のリンクだけ上下位置がずれて見えるのはこれが原因と推測される (現在ページかどうかは無関係)
- 公式のマークアップにある「省略記号 (`pagination-ellipsis`)」と「無効状態 (`is-disabled`)」を使っていない。番号は全ページ分を並べ、端の前へ/次へは非表示にしている

## What Changes

- `section.html` / `section/page_list.html` / `taxonomy_single.html` で、`pagination.nav` を `section.content` の外に出す
- `pagination.nav` を公式の構造に合わせる
  - ページ番号は最初・最後・現在ページ ± N のみ表示し、間を `pagination-ellipsis` で省略する。N は既定 2 で、component 内の変数 1 か所で変更できる
  - 先頭ページの「前へ」・最終ページの「次へ」は非表示にせず、`is-disabled` で表示する

## Capabilities

### New Capabilities
- `pagination-nav`: 一覧ページのページネーションナビが、Bulma 公式の pagination の構造で、記事本文用スタイルの影響を受けずに表示されること

### Modified Capabilities

(なし: 既存 spec は存在しない)

## Impact

- `templates/components/pagination.html`
- `templates/section.html`, `templates/section/page_list.html`, `templates/taxonomy_single.html`
- CSS の変更なし (公式クラスのみ使用)

## Non-Goals

- 「前へ」「次へ」ラベルの日本語化 (公式の構造に含まれないため今回は現状の英語のまま。別途検討)
- 1 ページ目リンクを `/page/1/` から正規 URL にすること
- サイズ・配置などの修飾子 (`is-centered`, `is-small` 等) の追加
