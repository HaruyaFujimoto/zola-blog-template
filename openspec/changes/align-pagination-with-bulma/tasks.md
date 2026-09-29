# Tasks

## 1. 現状確認

- [x] 1.1 `zola serve` で `/articles/` を開き、開発者ツールで `pagination-list` 内の `li` の margin-top と `ul` の margin-inline-start を確認し、1 ページ目だけ上余白が無いこと・左インデントがあることを記録する (原因の推測を裏付ける)
- [x] 1.2 同梱 `static/css/bulma.min.css` に `.pagination-next.is-disabled` があることを grep で確認する

## 2. 配置の修正

- [x] 2.1 `templates/section.html` の `pagination.nav` を `</section>` の外へ移し、`zola build -o <scratchpad>` の出力 HTML で `nav.pagination` が `section.content` の兄弟になっていることを確認する
- [x] 2.2 `templates/section/page_list.html` に同じ修正を行い、`/articles/` の出力 HTML で確認する
- [x] 2.3 `templates/taxonomy_single.html` に同じ修正を行い、`/tags/pagination-test/` の出力 HTML で確認する

## 3. component を公式の構造に揃える

- [x] 3.1 `templates/components/pagination.html` の前へ/次へを、移動先が無い場合 `is-disabled` (href なし) で出力するようにし、1 ページ目と最終ページの出力 HTML で確認する
- [x] 3.2 ページ番号を「最初・最後・現在 ±2」に間引き、`pagination-ellipsis` を挿入する。`paginate_by` を一時的に下げて 12 ページ以上にし、1・5・6・12 ページ目の出力が spec のシナリオ通りになることを確認する
- [x] 3.3 `paginate_by` を元に戻し、`zola build -o <scratchpad>` がエラーなく通ることを確認する
- [x] 3.4 表示範囲を変数 `window` (既定 2) に切り出し、式から `2` 依存の定数を除く。`window` = 0〜5、ページ数 3・5・7・14・27 の全組み合わせで、全ページの出力が参照実装 (隠れる区間が 1 ページなら番号、2 ページ以上なら省略記号) と一致することをスクリプトで確認し、`window` を 2 に戻す

## 4. 見た目の検証

- [x] 4.1 `/articles/` の各ページで、番号リンク (1 ページ目を含む) の上下位置がそろい、左インデントが無いことを開発者ツールで確認する
- [x] 4.2 `/articles/` と `/tags/pagination-test/` で、記事リストとの間隔、無効状態の前へ/次への見た目を目視確認し、必要なら Bulma のユーティリティクラスで調整する
- [x] 4.3 ライト/ダーク両方とスマホ幅で、レイアウトが崩れていないことを確認する
