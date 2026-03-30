# openField
オープンフィールドの解析用プログラムです。

### 手順①:RとRstudioのインストール
まず初めにRをダウンロードします。Rは統計解析に特化したプログラミング言語です。\
Rを快適に使用するためにはRとRstudioのインストールが必須です。\
Rは以下のURLからインストールしてください。\
https://cran.rstudio.com/bin/windows/base/ \
URLを開いたら　Download R-(バージョン名) for Windows (Mac)\
<img width="941" height="94" alt="スクリーンショット 2026-03-27 164021" src="https://github.com/user-attachments/assets/07a8b98e-3da6-4cba-942c-6021f1ddfc69" />
をクリックしてください。\
ダウンロードが完了したら、ダウンロードしたインストーラ(R-(バージョン名)-win.exe)を実行します。おそらくダウンロードというフォルダの中に入っています。

<img width="598" height="131" alt="スクリーンショット 2026-03-27 170445" src="https://github.com/user-attachments/assets/d75305e3-d0f5-40ef-8232-44059f4344f0" />

実行したら、画面の手順に従ってください。

以下のサイトが参考になります。\
https://www.tku.ac.jp/iss/guide/classroom/soft/rrstudio-desktop.html

次は**R-studio**のインストールを行います。\
以下のURLを開いてください。\
https://www.tku.ac.jp/iss/guide/classroom/soft/rrstudio-desktop.html

URLを開いたら、以下の画像にあるDownload RStudio Desktop for windows(Mac)をクリックしてください。

<img width="379" height="218" alt="スクリーンショット 2026-03-27 174022" src="https://github.com/user-attachments/assets/a5f679eb-8ade-4e3c-be26-ed9672750c2a" />\
ダウンロードが完了したら、インストーラを起動してください。\
起動したら画面に従ってください。

### 手順②:bonsaiのインストール
bonsaiは、動画内のマウスをトラッキングし、その中心座標をピクセル単位で出力するためのアプリケーションです。\
bonsaiは以下のURLからダウンロードしてください。

https://bonsai-rx.org/docs/articles/installation.html

ただし、bonsaiはwindowsのみでしか動かないため、MacやLinuxを使っている人は、ラボのパソコンで使用してください。\
また、最新バージョン(29.0)はインストールに失敗するかもしれません。そしたら1個前のバージョンを使ってください。


### 手順③:bonsaiの初期設定
bonsaiのインストールが完了したら、bonsaiの初期設定を行います。\
bonsaiを開くと以下の画面になると思います。(recentには何も表示されていないと思います)\
<img width="960" height="560" alt="スクリーンショット 2026-03-28 222050" src="https://github.com/user-attachments/assets/08980d88-ff8a-434d-b1c0-94ce081c545a" />

開いたら、以下のように赤で示した箇所をクリックしてください。\
<img width="175" height="225" alt="スクリーンショット 2026-03-28 22269" src="https://github.com/user-attachments/assets/f667cd83-571a-4abb-82c2-c565bdef9774" />


### 手順④:openfield.Rおよびopenfield.bonsaiをダウンロード
次に、openfield.Rとopenfield.bonsaiをダウンロードしてください。\
これら二つのプログラムはこのページからダウンロードしてください。\
ダウンロードするためには、これら二つのファイルをクリックしてダウンロードをクリックしてください。

### 手順⑤:動画データの取得
上記のダウンロードが完了したら、以下のURLから動画データを取得してください。

https://1drv.ms/f/c/e7c121b75c232fa5/IgA6dUCz6y6uQYxBbwza2QdpAekgxVjvcEVX6nDEsDc36c0?e=kIWuzm



### 手順⑥:実行手順
まず初めに動画からマウスをトラッキングしてマウスの中心座標を求めます。この解析にはopenfield.bonsaiを使用します。



