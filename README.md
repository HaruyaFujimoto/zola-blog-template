# zola-blog-template

## このプロジェクトはなにか

[Zola](https://www.getzola.org/) 用のブログテンプレート。

## 使い方

git clone 後、 `zola.toml` を書き換えて使用。
開発用サーバー起動、ビルドのコマンドは以下。

```sh
# zola --version
# zola 0.22.1

# 開発サーバ、 localhost:1111
zola serve

# public/ に出力
zola build

# 本番ビルド
zola build --minify # 開発用と差が出る可能性があるので注意
```

## セクション、記事の作成

セクションと記事はスクリプトで作成する。
このテンプレートは front matter に特定のキーがある前提で組まれており、スクリプトはそれを初期設定する。

```sh
# content/ 配下のパスを渡す
# ディレクトリ名は存在しないものを指定する
./bin/section_new.sh content/blog
```

```sh
# content/ 配下のパスを渡す
# ディレクトリ名は存在するものを指定する
# ファイル名は .md の拡張子を指定し、存在しないものを指定する
./bin/page_new.sh content/blog/foo.md
```

### 見出しの規約

サイトタイトルは、トップページとセクションでは `<h1>`、記事ページでは `<p>` として出力される。つまり **`<h1>` が無い状態になるのは記事ページだけ**。

そのためスクリプトは、記事に `# `、`_index.md` に `## ` の見出しスタブを書き出す。この行にタイトルを書く。空のままビルドすると `<h1 id=""></h1>` が出力される。

## header, footer のナビゲーションに含めるアイテムの管理

`zola.toml` の `[extra]` に、`content/` からの相対パスでセクションを指定する。

```toml
[extra]
sections_in_header_nav = ["blog/_index.md"]
sections_in_footer_nav = ["blog/_index.md"]
```

- `sections_in_header_nav` — ヘッダのナビに並ぶ。空なら描画されない。
- `sections_in_footer_nav` — フッタのナビに並ぶ。どちらもセクションへのリンクだけで、配下のページは出さない。

存在しないパスを書くとビルドが `get_section` で失敗するので注意。

## 記事のタグ

タグを付ける場合は記事の front matter の `tags` に書く。空のままなら分類されない。

```toml
[taxonomies]
tags = [
  "zola",
  "日本語タグ",
]
```

> **注意**: 大文字小文字だけが違うタグ（`"A"` と `"a"`）は同じタームに統合され、その記事がタグ別一覧に2回並ぶ。警告は出ないので表記を揃えること。

- タグを持つ記事だけ、本文の下にタグのリンクが出る。
- `/tags/` にタグ一覧、`/tags/<タグ名>/` にそのタグの記事一覧が生成される。記事は日付の降順、タグ一覧は名前順。

## スタイル

[Bulma](https://bulma.io/) v1.0.4（MIT）を `static/css/bulma.min.css` にベンダリングして読み込んでいる。

### テーマカラー

`sass/css/theme.scss` で Bulma の CSS 変数を上書きする。`bulma.min.css` 自体は編集しない（差し替え時に変更が消えるため）。

`zola.toml` の `compile_sass = true` により `public/css/theme.css` へ出力される。

> **注意**: `static/css/` に `theme.css` を置くと、Sass の出力を上書きしてしまう。テーマの変更は必ず `sass/css/theme.scss` 側で行うこと。

Bulma は色を色相 / 彩度 / 明度に分解して持っており、`--bulma-link-h` と `--bulma-link-s` を変えれば、ホバー時の色や反転色まで自動で追従する。

```css
:root {
  --bulma-link-h: 213deg;
  --bulma-link-s: 75%;
}
```

> **注意**: 文字色の明度 `--bulma-link-on-scheme-l` だけは自動計算されず、Bulma のビルド時に決まった値が焼き込まれている。色相や彩度を変えると背景とのコントラストが不足することがあるので、明度も併せて調整すること。ライト / ダークで別々に指定する必要がある。

現状このテンプレートは `is-primary` を使っていないため、`--bulma-primary-*` を変えても見た目は変わらない。`sass/css/theme.scss` の末尾にコメントアウトで用意してある。

### 配色モード（ライト / ダーク）

Bulma はライトとダークの両方を持っており、デフォルトでは OS の設定（`prefers-color-scheme`）に従う。固定したい場合は `zola.toml` で指定する。

```toml
[extra]
color_scheme = "auto"  # "auto" | "light" | "dark"
```

`auto` 以外を指定すると `<html>` に `data-theme` 属性が出力され、OS の設定より優先される。

> **注意**: `[markdown.highlighting]` のシンタックスハイライトは配色モードに追従しない。デフォルトの `catppuccin-mocha` はダーク向けのテーマなので、`light` に固定する場合はコードブロックだけ暗いままになる。`catppuccin-latte` などライト向けのテーマに変えること。

## フィード

`zola.toml` の `generate_feeds = true` により、サイト全体の Atom フィードを `/atom.xml` に出力する。テンプレートは zola 組み込みのものを使うため、自前で用意する必要はない。

`<title>` / `<subtitle>` は `zola.toml` の `title` / `description` から入る。
