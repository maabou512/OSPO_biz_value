# LFResearch_Group_Business_Value_of_OSPO_Report 翻訳（前工程と後工程）

- [name=Masa Taniguchi]
- [time=Sun, Apr 23, 2023 10:00 AM]

###### tags: `value_of_ospo_paper`

## 全体工程と本書のスコープ

![](https://hackmd.io/_uploads/SJ20L4Mmh.jpg)


## 前工程
### step 0 : idmlファイルをindd抽出
(省略)
```bash!
$ ls ./*.idml
LFResearch_Group_Business_Value_of_OSPO_Report.idml
```

### step 1 : idmlからxliffファイルを抽出


```bash!
$ java -jar /home/tani/translation/okapi-apps_gtk2-linux-x86_64_0.37/lib/tikal.jar -x LFResearch_Group_Business_Value_of_OSPO_Report.idml -sl EN -tl JA -od step1_xlf/
-------------------------------------------------------------------------------
Okapi Tikal - Localization Toolset
Version: 2.0.37
-------------------------------------------------------------------------------
Extraction
Source language: en
Target language: ja
Default input encoding: UTF-8
Filter configuration: okf_idml
Output: .step1_xlf/a/LFResearch_Group_Business_Value_of_OSPO_Report.idml.xlf
Input: /home/tani/translation/LFResearch_Group_Business_Value_of_OSPO_Report/LFResearch_Group_Business_Value_of_OSPO_Report.idml
Done in 0.887s

$ ls step1_xlf/
LFResearch_Group_Business_Value_of_OSPO_Report.idml.xlf
```
:::danger
:warning: 以下のエラーがでるときは、idmlファイルを差し替える（通常のzipファイルと認識されxlfが抽出できない。）
:::

```bash!
-------------------------------------------------------------------------------
Okapi Tikal - Localization Toolset
Version: 2.0.37
-------------------------------------------------------------------------------
Extraction
Source language: en
Target language: ja
Default input encoding: UTF-8
Filter configuration: okf_idml
Output: .step1_xlf/LFResearch_Group_Business_Value_of_OSPO_Report.idml.xlf
Input: /home/tani/translation/LFResearch_Group_Business_Value_of_OSPO_Report/LFResearch_Group_Business_Value_of_OSPO_Report.idml
Error: Error opening zipped input file.
You can use the -trace option for more details.
```
zipとして認識されているとき：
```bash!
$ file LFResearch_Group_Business_Value_of_OSPO_Report.idml
LFResearch_Group_Business_Value_of_OSPO_Report.idml: Zip archive data, at least v2.0 to extract
```
idmlとして認識されてるとき：
```bash!
$ file LFResearch_Group_Business_Value_of_OSPO_Report.idml 
work_trans/step0_idml_org/LFResearch_Group_Business_Value_of_OSPO_Report.idml: Zip data (MIME type "application/vnd.adobe.indesign-idml-package"?)

```


### step 2: xliffを機械翻訳

[ここ](https://hackmd.io/GEu0eHFaSBigq9_mXsNBPA)に記載した```xlifftranslate```を用いてGoogle Translate APIで翻訳する

```bash!

$ cp step1_xlf/LFResearch_Group_Business_Value_of_OSPO_Report.idml.xlf step2_ML/
$ cd step2_ML/

#事前にファイル名を修正しておく
$ mv LFResearch_Group_Business_Value_of_OSPO_Report.idml.xlf LFResearch_Group_Business_Value_of_OSPO_Report.ja.xlf 
#機械翻訳実行
$ xlifftranslate LFResearch_Group_Business_Value_of_OSPO_Report.ja.xlf 

#機械翻訳実行後はファイルが上書きされる
$ ls
LFResearch_Group_Business_Value_of_OSPO_Report.ja.xlf
#xliffファイルが機械翻訳されていることを確認する
$ head LFResearch_Group_Business_Value_of_OSPO_Report.ja.xlf -n20
<?xml version="1.0" encoding="UTF-8"?>
<xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2" xmlns:okp="okapi-framework:xliff-extensions" xmlns:its="http://www.w3.org/2005/11/its" xmlns:itsxlf="http://www.w3.org/ns/its-xliff/" its:version="2.0">
<file original="Stories/Story_u1b279.xml" source-language="en" target-language="ja" datatype="xml" okp:inputEncoding="UTF-8">
<body>
</body>
</file>
<file original="Stories/Story_u24fa.xml" source-language="en" target-language="ja" datatype="xml" okp:inputEncoding="UTF-8">
<body>
<trans-unit id="P70123D5-tu1" xml:space="preserve">
<source xml:lang="en"><g id="1">The Business Value of the OSPO</g></source>
<target xml:lang="ja" state="translated"><g id="1">OSPO のビジネス価値</g></target>
</trans-unit>
</body>
</file>
<file original="Stories/Story_u24e3.xml" source-language="en" target-language="ja" datatype="xml" okp:inputEncoding="UTF-8">
<body>

```

:::danger
:warning: ```xlifftranslate```はファイル名にシビアなので、ファイル名を事前に、filename.ja.xlf などに変えておくこと（以下は変えない場合のエラーの例）。また、コマンド自体もファイルのあるディレクトリで実行すること。
:::

```bash!
#ファイル形式が違うことによるエラー
$ xlifftranslate LFResearch_Group_Business_Value_of_OSPO_Report.idml.xlf 
Error: idml is not a valid locale
Error: idml is not a valid locale
Error: idml is not a valid locale
Error: idml is not a valid locale
Error: idml is not a valid locale
Error: idml is not a valid locale
Error: idml is not a valid locale

#ディレクトリの階層がずれている場合のエラー
$ xlifftranslate step2_ML/LFResearch_Group_Business_Value_of_OSPO_Report.idml.xlf 
Error, expecting three part filename like something.en.xliff
Error, expecting three part filename like something.en.xliff
Error, expecting three part filename like something.en.xliff
Error, expecting three part filename like something.en.xliff
Error, expecting three part filename like something.en.xliff
Error, expecting three part filename like something.en.xliff
Error, expecting three part filename like something.en.xliff
Error, expecting three part filename like something.en.xliff
```
### step3: 対訳を戻すためのpatch作成と対訳の生成

ファイルの配置
```bash!
$ cd ..
#機械翻訳後のxlfファイルをコピー
$ cp step2_ML/LFResearch_Group_Business_Value_of_OSPO_Report.ja.xlf step3_taiyaku/
#原文のxlfファイルをコピー
$ cp step1_xlf/LFResearch_Group_Business_Value_of_OSPO_Report.idml.xlf step3_taiyaku/LFResearch_Group_Business_Value_of_OSPO_Report.en.xlf
$ cd step3_taiyaku/
$ ls -1 
LFResearch_Group_Business_Value_of_OSPO_Report.en.xlf #原文
LFResearch_Group_Business_Value_of_OSPO_Report.ja.xlf #機械翻訳
```

対訳部分の抽出
```bash!
$ cat LFResearch_Group_Business_Value_of_OSPO_Report.ja.xlf |grep -e "<trans-unit" -e "target xml:lang=\"ja\"" -e  "source xml:lang=\"en\"" > taiyaku_prep1
#抽出部分の確認
$ head taiyaku_prep1 
<trans-unit id="P70123D5-tu1" xml:space="preserve">
<source xml:lang="en"><g id="1">The Business Value of the OSPO</g></source>
<target xml:lang="ja" state="translated"><g id="1">OSPO のビジネス価値</g></target>
<trans-unit id="P2C41208-tu1" xml:space="preserve">
<source xml:lang="en"><g id="1"><x id="2"/></g></source>
<target xml:lang="ja" state="translated"><g id="1"><x id="2"/></g></target>
<trans-unit id="P4065E1BD-tu1" xml:space="preserve">
<source xml:lang="en"><g id="1">The Business Value of the OSPO</g></source>
<target xml:lang="ja" state="translated"><g id="1">OSPO のビジネス価値</g></target>
<trans-unit id="P4065E1BD-tu2" xml:space="preserve">

#翻訳終了後のpatchファイルを作成
#diff ①対訳用ファイル② 機械翻訳後ファイル > ③patchファイル　の順番
$ diff taiyaku_prep1 LFResearch_Group_Business_Value_of_OSPO_Report.ja.xlf > taiyaku.patch

$

```
## 中間工程（略）

### step4 : HackMDでのコラボによる翻訳レビュー


## 後工程

## step5: レビュー完了後のxlfファイルを生成する
```bash!
$ cd ../step5_reviewed_xlf/
$ ls
taiyaku.patch # step4でつくったpatchファイル
taiyaku_test　# レビュー後の対訳　

#step4で作成したpatchファイルからxlfファイルを生成する
$ patch taiyaku_test taiyaku.patch 
$ head -n20 taiyaku_test 
<?xml version="1.0" encoding="UTF-8"?>
<xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2" xmlns:okp="okapi-framework:xliff-extensions" xmlns:its="http://www.w3.org/2005/11/its" xmlns:itsxlf="http://www.w3.org/ns/its-xliff/" its:version="2.0">
<file original="Stories/Story_u1b279.xml" source-language="en" target-language="ja" datatype="xml" okp:inputEncoding="UTF-8">
<body>
</body>
</file>
<file original="Stories/Story_u24fa.xml" source-language="en" target-language="ja" datatype="xml" okp:inputEncoding="UTF-8">
<body>
<trans-unit id="P70123D5-tu1" xml:space="preserve">
<source xml:lang="en"><g id="1">The Business Value of the OSPO</g></source>
<target xml:lang="ja" state="translated">【翻訳後】<g id="1">OSPO のビジネス価値</g></target>
</trans-unit>
</body>
</file>
<file original="Stories/Story_u24e3.xml" source-language="en" target-language="ja" datatype="xml" okp:inputEncoding="UTF-8">
<body>
<trans-unit id="P2C41208-tu1" xml:space="preserve">
<source xml:lang="en"><g id="1"><x id="2"/></g></source>
<target xml:lang="ja" state="translated">【翻訳後】<g id="1"><x id="2"/></g></target>

#次のステップに向けて名前を変更しておく
$ mv taiyaku_test LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf 
$ ls
LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf  taiyaku.patch

```
## step6: レビュー完了後のxlfファイルからidmlファイルを生成する


```bash!ファイル
#step5でつかったレビュー後のxlfファイルをコピーする
$ cp LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf ../step6_reviewed_idml/
$ cd ../step6_reviewed_idml/
#さらにマージの際には、最初のidmlファイルを使うのでコピーしてファイル名を変更する
$ cp ../LFResearch_Group_Business_Value_of_OSPO_Report.idml ./
$ mv LFResearch_Group_Business_Value_of_OSPO_Report.idml LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml
#tikal でマージする
$java -jar /home/tani/translation/okapi-apps_gtk2-linux-x86_64_0.37/lib/tikal.jar -m LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf  -sl EN -tl JA -od  ./out
#うまく生成された場合
-------------------------------------------------------------------------------
Okapi Tikal - Localization Toolset
Version: 2.0.37
-------------------------------------------------------------------------------
Merging
Source language: en
Target language: ja
Default input encoding: UTF-8
Output encoding: UTF-8
Filter configuration: okf_idml
XLIFF: LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf
Output: out/LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml
Input: /home/tani/translation/LFResearch_Group_Business_Value_of_OSPO_Report/step6_reviewed_idml/LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf
Done in 1.211
```
:::info
:bulb:この際、機械翻訳の影響で、エスケープ文字が翻訳されたりやタグのIDに空白文字列が入ることが起こりがち。これはそんなに多くはないので、エラーに応じて手作業で修正する
:::

・上記コマンド後エラーの例1：```&amp;```（39行目）が翻訳されてしまっているケース
```bash!
-------------------------------------------------------------------------------
Okapi Tikal - Localization Toolset
Version: 2.0.37
-------------------------------------------------------------------------------
Merging
Source language: en
Target language: ja
Default input encoding: UTF-8
Output encoding: UTF-8
Filter configuration: okf_idml
XLIFF: LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf
Output: ./LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml
Input: /home/tani/translation/LFResearch_Group_Business_Value_of_OSPO_Report/step6_reviewed_idml/LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf
Error: Error merging from original file
Error: Failed to parse XLIFF for ITS annotations
Undeclared general entity "アンプ"
 at [row,col,system-id]: [39,77,"file:/home/tani/translation/LFResearch_Group_Business_Value_of_OSPO_Report/step6_reviewed_idml/LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf"]
You can use the -trace option for more details.

```

- 上記コマンド後エラーの例2：&がエスケープされずにそのままになっているケース
```bash!
-------------------------------------------------------------------------------
Okapi Tikal - Localization Toolset
Version: 2.0.37
-------------------------------------------------------------------------------
Merging
Source language: en
Target language: ja
Default input encoding: UTF-8
Output encoding: UTF-8
Filter configuration: okf_idml
XLIFF: LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf
Output: ./LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml
Input: /home/tani/translation/LFResearch_Group_Business_Value_of_OSPO_Report/step6_reviewed_idml/LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf
Error: Error merging from original file
Error: Failed to parse XLIFF for ITS annotations
Unexpected character ' ' (code 32); expected a semi-colon after the reference for entity 'D'
 at [row,col,system-id]: [811,82,"file:/home/tani/translation/LFResearch_Group_Business_Value_of_OSPO_Report/step6_reviewed_idml/LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf"]
You can use the -trace option for more details.

```

ファイル内「R&D」の「&」)が当該箇所なので```&```を```&amp;```にする
```xml=811
 <target xml:lang="ja" state="translated">【翻訳後】<g id="1">「OSPO は戦略に取り組み、それを設定し、R&D 担当者を参加させて正しいことを行う必要があります」と Kunz      氏は述べています。 OSPO、Kunz、および他の多くの人々は、ビジョンと戦略に取り組み、そのビジョンを実現するために会社全体で適切な人々と協力していることを確認する必>     要があると考えています。 </g></target>
```


- 上記コマンド後エラーの例3:"" 内に数字以外に半角空白が入っているケース⇨unit idから検索して修正
```bash!
-------------------------------------------------------------------------------
Okapi Tikal - Localization Toolset
Version: 2.0.37
-------------------------------------------------------------------------------
Merging
Source language: en
Target language: ja
Default input encoding: UTF-8
Output encoding: UTF-8
Filter configuration: okf_idml
XLIFF: LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf
Output: out/LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml
Input: /home/tani/translation/LFResearch_Group_Business_Value_of_OSPO_Report/step6_reviewed_idml/LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf
Error: Text Unit id: P4065E1BD-tu4
Added Codes in target=','
Missing Codes in target='</content-5>,<content-5>'
Target Text Unit:
【翻訳後】<content-1>エミリー・オミエ、ポジショニング&メッセージング コンサルタント、<content-2>Emily Omier Consulting<content-3/></content-2></content-1><content-4>Chris Aniszczyk、CTO、クラウド ネイティブ コンピューティング ファウンデーション</content-4>
Error: Text Unit id: P4065E1BD-tu6
Added Codes in target=','
Missing Codes in target='</content-7>,<content-7>'
Target Text Unit:
【翻訳後】<content-1>Georg Kunz (オープン ソース マネージャー)、<content-2>Ericsson</content-2>、<content-3/>Leslie Hawthorn (シニア マネージャー) による序文付き、 <content-4>Red Hat OSPO </content-4>および<content-5> <content-6/></content-5>Kimberly Craven、シニア ディレクター、Red Hat OSPO、CTO オフィス</content-1>
Error: Error closing IDML output.
Pipe closed
Error: Pipe closed
You can use the -trace option for more details.

```
該当箇所（最初の部分はLで39id="5 "とスペースが入っている）

```vim=37
 <trans-unit id="P4065E1BD-tu4" xml:space="preserve">
  38 <source xml:lang="en"><g id="1">Emily Omier, Positioning &amp; Messaging Consultant, <g id="2">Emily Omier Consulting<x id="3"/></g></g><g id="4">Chris Aniszczyk     , CTO, <g id="5">Cloud Native Computing Foundation</g></g></source>
  39 <target xml:lang="ja" state="translated">【翻訳後】<g id="1">エミリー・オミエ、ポジショニング&amp;メッセージング コンサルタント、<g id="2">Emily Omier Consulting     <x id="3"/></g></g><g id="4">Chris Aniszczyk、CTO、<g id="5 ">クラウド ネイティブ コンピューティング ファウンデーション</g></g></target>
```



:::warning
:point_up_2: マージコマンド後以下のエラーがでているときは、以下２つの要因がある。
①idmlファイルが通常のzipとして認識されている
②idmlのファイル名がxlfファイルと合ってない
:::

```bash!
-------------------------------------------------------------------------------
Okapi Tikal - Localization Toolset
Version: 2.0.37
-------------------------------------------------------------------------------
Merging
Source language: en
Target language: ja
Default input encoding: UTF-8
Output encoding: UTF-8
Filter configuration: okf_idml
XLIFF: LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf
Output: ./LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml
Input: /home/tani/translation/LFResearch_Group_Business_Value_of_OSPO_Report/step6_reviewed_idml/LFResearch_Group_Business_Value_of_OSPO_Report.ja.idml.xlf
Error: Exception in InputStreamFromOutputStream thread. Check exception stack for original cuase
Error: null
You can use the -trace option for more details.

$file LFResearch_Group_Business_Value_of_OSPO_Report.idml 
LFResearch_Group_Business_Value_of_OSPO_Report.idml: Zip archive data, at least v2.0 to extract
```

## step7: InDesignで編集作業、リリース。
省略）