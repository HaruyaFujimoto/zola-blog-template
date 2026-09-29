# Design

## Context

`pagination.nav` は 3 つのテンプレート (`section.html`, `section/page_list.html`, `taxonomy_single.html`) で、`<section class="content">` の内側・`<ul>` の直後に置かれている。同梱の Bulma 1.0.4 では `.content li+li { margin-top: .25em }` と `.content ul { margin-inline-start: 2em }` が子孫の `li` / `ul` に効き、`pagination-list` はこれらを打ち消さない。カスタム CSS (`sass/css/theme-for-bulma.scss`) に pagination 用の上書きは無い。ずれの原因はここまで CSS の読解による推測で、ブラウザでの確認は実装時に行う。

公式の構造 (bulma.io/documentation/components/pagination/): `nav.pagination` の直下に `pagination-previous` / `pagination-next`、`ul.pagination-list` の中に `li` > `a.pagination-link` (現在は `is-current` + `aria-current="page"`) と `li` > `span.pagination-ellipsis`。無効状態は `is-disabled`。同梱 CSS には `.pagination-previous.is-disabled` と `[disabled]` の両方がある。

Zola の `paginator` (0.23.6) は `number_pagers`, `current_index`, `previous`, `next`, `base_url`, `first` を持つ。

## Goals / Non-Goals

**Goals:**
- 公式の構造とクラスのみで組み、追加 CSS を書かない
- 番号の間引きを component 内の Tera で完結させ、呼び出し側は配置の変更のみとする

**Non-Goals:**
- ラベルの日本語化、`/page/1/` の正規 URL 化、修飾子の追加 (proposal の Non-Goals)
- 表示範囲を `zola.toml` の `extra` などサイト設定に出すこと (component 内の変数 1 か所で足りる)

## Decisions

- **表示範囲の変数化**: 現在ページの前後に表示する数を、component 冒頭の `{%- set window = 2 %}` 1 か所で管理する。番号の選別・省略記号・「隠れるのが 1 ページだけ」の判定はすべて `window` から導く式にし、`2` に依存した定数を式に埋め込まない。代替の `zola.toml` (`config.extra`) 経由は、呼び出し側や設定との結合が増えるため不採用。`window` は 0 以上の整数を想定する。

- **配置**: `{%- if paginator %}...{%- endif %}` を `section.content` の閉じタグの外へ移す (`main > .container` 直下の兄弟)。すき間は `.content:not(:last-child)` の下マージンで確保される見込み。CSS での打ち消しや、component 側での回避は採らない (Bulma 更新に弱い / component が呼び出し側の構造に依存するため)。
- **番号の選別**: ループの各 `page_num` について、`1`・最後・`|page_num - current| <= window` は番号を出す。隠れる区間が 1 ページだけなら (現在が `window + 3` のときの 2、`最後 - window - 2` のときの最後 - 1) その番号を出す。それ以外は非表示。省略記号は、隠れる区間 (2 ページ以上) の先頭位置で 1 つだけ `li > span.pagination-ellipsis` を出す。Tera のループ内で状態を持てないため、各番号の表示可否と省略記号の要否を現在ページと総数からの式だけで導く。代替の「番号リストを事前生成する」案は、Tera で配列の可変操作が煩雑なため不採用。
- **無効状態**: 移動先が無い側は `<a class="pagination-previous is-disabled" aria-disabled="true">` (href なし) とする。`<button disabled>` は公式の `a` 前提の構造から外れるため不採用。
- **ラベル・1 ページ目 URL**: 現状のまま。

## Risks / Trade-offs

- [Tera の式が複雑になり読みにくい] → 区間の判定を `set` で名前を付けて分け、コメントで意図を残す
- [`section` の外に出すと下マージンが想定と違う] → ブラウザで確認し、必要なら Bulma のユーティリティクラスで調整する
- [ずれの原因が推測と違う] → 実装前に開発者ツールで現状のずれを確認し、移動後に解消することを確認する
- [`is-disabled` の見た目が `.pagination-next` 側で無い] → 同梱 CSS を grep で確認し、無ければ `[disabled]` 属性を併用する
- [テストデータが最大 3 ページで省略記号が出ない] → 確認時のみ `paginate_by` を一時的に下げ、確認後に戻す
