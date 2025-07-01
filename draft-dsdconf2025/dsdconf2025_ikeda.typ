
#import "style/jsme_style.typ" : *
#import "bib-style/lib.typ" : *

#show: jsme_init
#import bib_setting_jsme: *
#show: bib_init
#show: equate.with(breakable: true, number-mode: "line")
#show: bib_init

#show: jsme_title.with(
  title: [大規模言語モデルを用いた1DCAEのモデリング作業の支援],
  //subtitle: [(日本機械学会指定テンプレートファイル利用について)],
  authors: (
    (
      name: "池田 孟",
      english_name: "Taro KIKAI",
      thanks: "正員，三菱電機株式会社設計開発技術センター（〒661-8661 兵庫県尼崎市塚口本町8-1-1",
      english_thanks: "Japan Society of Mechanical Engineering",
      english_place: "35Shinanomachi,Shinjuku-kuTokyo160-0016,Japan"
    ),
    (
      name: "石橋　祐太郎",
      english_name: "Sakura GIJYUTSU",
      thanks: "，三菱電機株式会社生産技術センター〒661-8661 兵庫県尼崎市塚口本町8-1-1",
      english_thanks: "Department of Mechanical Engineering, Kikai University",
      english_place: "1 Kogakumachi, Shinjuku-ku, Tokyo 160-0001, Japan"
    ),
    (
      name: "金丸 正寛",
      english_name: "Hanako TOKYO",
      thanks: "三菱電機株式会社設計開発技術センター（〒661-8661 兵庫県尼崎市塚口本町8-1-1",
      english_thanks: "Department of Mechanical Engineering, Kikai University",
      english_place: "1 Kogakuma孝hi, Shinjuku-ku, Tokyo 160-0001, Japan"
    ),
      (
      name: "小林　孝",
      english_name: "Hanako TOKYO",
      thanks: "正員，三菱電機株式会社設計開発技術センター（〒661-8661 兵庫県尼崎市塚口本町8-1-1",
      english_thanks: "Department of Mechanical Engineering, Kikai University",
      english_place: "1 Kogakumachi, Shinjuku-ku, Tokyo 160-0001, Japan"
    ),
        
  ),
  english_title: [Making research paper],
  english_subtitle: [(About the use of the JSME specification template file)],
  abstruct: [In complex system design, where mechanical, electrical, and control subsystems interact, 1D CAE is increasingly adopted to optimize products quickly by verifying requirements through early-stage physical simulations on virtual prototypes. The Modelica language has become the standard for modeling these systems due to its object-oriented, declarative nature and ability to handle multi-domain interactions. It supports hierarchical modeling using extensive libraries like the Modelica Standard Library, which includes components for thermal, electromagnetic, and control domains.Recent advancements in generative AI, particularly Large Language Models (LLMs), have enabled new approaches in design engineering, such as automating design system handling and managing design knowledge. This study presents a framework that uses Retrieval-Augmented Generation (RAG) to search closed corporate Modelica repositories and employs three collaborative agents—a planner, coder, and tester—to automatically assemble libraries.Experiments using OpenAI-4o demonstrated that this agent-based workflow could generate candidate code for tasks that RAG alone could not handle. The results also showed improved code generation performance when working with proprietary internal libraries, highlighting the potential of combining LLMs with structured agent collaboration in engineering design automation. ],
  keywords: ("Term1", "Term2", "Term3", "Term4", "...(Show five to ten key words)"),
  email: "taro@jsme.or.jp"
  )



= 緒　　　言

複雑なシステムの設計においては，機械，電気，制御の各サブシステムが相互に干渉する複雑な製品を短期間で最適化するため，設計初期から物理シミュレーションを活用して仮想プロトタイプ上で要求充足性を検証する1DCAEが主流となりつつある#citep(<jsme2020_1dcae>) ．
// SBD は CAD 形状と挙動モデルを結合したコンポーネントを組み合わせることで，設計判断の即時フィードバックを可能にする手法として提案され，航空宇宙や自動車分野を中心に急速に普及している．
物理シミュレーションモデルの記述には，オブジェクト指向かつ宣言型で多領域連成を自然に扱える Modelica 言語が事実上の標準となっている．Modelica Standard Library をはじめ，熱流体，電磁気，制御系など多様なドメインのサブモデルがライブラリとして公開されており，ユーザは既存コンポーネントをインポートして階層的にモデルを構築できる．
// さらに，ESI SimulationX や Dassault Systèmes Dymola などの商用ツールは分野別拡張ライブラリを備え，設計者は GUI 上でライブラリを組み合わせながらマルチフィジックス解析を実施できる．
//加えて，タスクを分担するマルチエージェント AI は計画・検証・修正を自律的に反復することでコード品質を高め，人間と協調して開発サイクルを短縮する可能性が指摘されている． 
近年，設計工学では，生成AIを用いて設計知識を管理し，設計システムの取り扱いを自動化する試みが行われてきた#citep(<fujita2023design>)．大規模言語モデル Large Language Model (LLM)を中心とした生成AIの性能は大きく向上し、さまざまな設計問題への応用が検討されてされている。
本研究は，企業内でクローズされた1DCAEのライブラリの作業支援・読解支援にLLMを適用した．
企業内でクローズされたModelicaのライブラリを対象にRAGで関連ドキュメントを検索し，プランナー，コーダ，テスターの三つのエージェントが協調してライブラリを自動組立するフレームワークを構築した事例を報告する．OpenAI 4o-miniを用いた実験ではRAGでけのシステムでは，生成できなかったコード作成タスクにおいて候補コードが生成できるようになることを確認できた．企業内のクローズなライブラリの操作においてもエージェントワークフローによってコード生成能力が向上することがわかった．
//自動車用冷却系モデル（約 4 k 行）で評価した結果，生成コードの単体シミュレーション通過率は 96 % に達し，社内中堅エンジニア（93 %）と同等以上の品質を実現した．

= 先行研究

== LLMの設計の展開事例

2024年以降に設計問題のLLMを適用した事例を紹介する．
Picard らは，概念設計から製造・検査に至る四つの設計フェーズを対象として，マルチモーダル Vision-Language Model（VLM）である GPT-4V と LLaVA 1.6 34B の有効性を体系的に評価した#citep(<picardConceptManufacturingEvaluating2024a>)．
//この研究では，スケッチ類似度解析，CAD モデル生成，トポロジ最適化，製造性評価，工学教科書問題の解答など十種類以上のタスクを設定し，総計 1000 件超のベンチマークデータセットを整備して性能を比較した．
//評価の結果，GPT-4V は手書き図面の文字認識や材料選択の上位概念抽出において高い正答率を示した一方，三次元形状の空間把握や寸法精度を要する CAD 出力では精度不足が顕在化した．
///また，LLaVA 1.6 は低計算資源でも同等のタスクをこなせるものの，複雑な製造公差を含む課題で大幅に性能が低下し，モデルサイズと推論時間のトレードオフが課題として残った． 
同研究は VLM が生成した回答根拠を設計図や仕様書にトレースする手法を提案し，設計者が結果を検証しやすい解釈性向上の方向性を示した．

//== 企業における事例
//日本国内のメーカーにおいても，さまざまな取り組みが行われている．
トヨタ自動車は，熟練エンジニアの暗黙知を LLM にリンクさせて次世代車両の開発速度を高める目的で，マルチエージェント型の設計支援基盤を構築している#citep(<onishi2024lessons>)．同社では，パワートレイン設計部門において GenAI エージェントが資料検索，要件整理，設計レビューの各フェーズを自律分担し，意思決定を加速する事例が報告された．
//このシステムは Azure OpenAI Service 上の GPT-4 系モデルを中心に，社内ドキュメントを格納した Azure Cosmos DB，設計 BOM／図面リポジトリ，およびシミュレーションコードを連携させた Retrieval-Augmented Generation 構成である．各エージェントは「知識検索」「根拠付き要約」「コード生成」「結果検証」を役割分担し，生成した回答には元資料へのハイパーリンクを自動付与してトレーサビリティを確保した． 
//その結果，新型車のコンセプト検討から詳細設計立ち上げまでに要する社内レビュー回数を大幅に削減し，設計サイクル短縮への貢献が示された．さらに，引退が進むベテラン設計者のノウハウを LLM で保全することで，世代交代に伴う技能ギャップリスクを低減できる可能性が示唆された．
//本事例は，LLM を中核とするマルチエージェントが企業設計プロセスへ実装された先行研究として位置づけられ，部門横断の知識共有と設計自動化を両立した点で，他の製造業に対しても有用な示唆を与える．
三菱電機は，設計・生産準備を含む ECM（Engineering Chain Management）領域に生成 AI を組み込む社内プラットフォームを構築し，2017 年以降の AI 活用技術を集約したソリューション群を展開している#citep(<tamaya2024ai>)．同社は技術文書のレイアウト解析と差分照合を行う自然言語処理 AI，FMEA／DRBFM データを参照して新規設計変更リスクを自動抽出するリスク抽出 AI，CAE 解析結果を学習したサロゲートモデル AI などを設計フローに導入し，設計パラメーター探索の高速化と知見の再利用を図った．さらに，デジタルツインと生成 AI エージェントを連携させ，IoT で収集した実機データと仮想空間のシミュレーション結果を横断的に解析しながら設計条件を最適化する将来像を提案している．
// これらの取り組みは，企業内の広範な設計資産を LLM／生成 AI で有効活用し，サイクルタイム短縮と技能継承を両立した事例として注目される．

企業内では，社内でクローズされた情報を検索し設計活動に用いる．このように機密情報をRAGなどの検索システムを構築し、知識管理にLLMを適用している．

== 1DCAEのモデリング作業の支援

物理シミュレーションや制御シミュレーションには，さまざまの専門ライブラリを用いてモデリング作業をおこなう．

このようなモデリング作業は，モデル対象への理解，プログラム言語と専門ライブラリの仕様，数値計算などの知識や経験など高度なドメイン知識と経験が必要になる．このようなモデリングとシミュレーションを実行可能なエンジニアの養成するためには，多くの時間とコストが必要になる。
物理シミュレーション言語Modelicaや数値流体計算ライブラリOpenFOAMによるモデリング作業とシミュレーション実行は，研究開発でよく使われる専門ライブラリであるが，ライブラリの複雑さと,モデル対象の理解に専門性が必要なため，高度な専門知識をもつエンジニアや研究者を必要とする．
このようなシミュレーションのモデリングへのLLMの適用は，依然に難しい．最近の先行研究を紹介する．

近年の大規模言語モデルLLMはコード生成能力の向上により，Modelica コンポーネント自動生成への応用が進む．ベンチマーク「ModiGen」では，LLM が  指標で 0.33 以上を達成する事例が報告されており，複雑なモデル構造でも一定の妥当性を保持する段階に到達した#citep(<xiang2025modigenlargelanguagemodelbased>)．
OpenFOAMを用いたCFDシミュレーションの自動化を目的として，GPT-4oおよびCoT機能搭載モデルを基盤とするエージェント「OpenFOAMGPT」が提案されている．
本手法では，OpenFOAMチュートリアルケースから得た領域知識を検索拡張生成（RAG）パイプラインに組み込み，入力ファイルの自動生成・実行・エラー訂正を反復的に行う構造を採用している．評価では，RAGを用いた少数ショットプロンプトにより，境界条件やメッシュ解像度の変更に対応できることが示された．一方，精度担保のための人手監視やモデル性能の時間変動が課題として指摘されている．
「MetaOpenFOAM」は，Architect，InputWriter，Runner，Reviewerの四つのエージェントが連携し，ユーザーの自然言語要求から入力ファイル生成，シミュレーション実行，エラー分析・修正までを自動化する反復ループを構築する．

このような専門ライブラリの適用がLLMにとっていまだに難しい原因をまとめる．

- 高度なドメイン知識の不足　LLMはインターネット上の広範囲のデータを用いて訓練されているが，Modelicaの特定のライブラリやOpenFOAMのファイル構造やパラメータ設定や各種コマンドのなどの情報をインターネット上の汎用的な訓練データから学習することは，難しい．
- 信頼性と正確性の向上　シミュレーション作業のセットアップは，一般的に厳密な正確性が要求される．モデリング作業は，複数のセットアップ作業を正確に実行する必要があるが，すべての作業を正確にじっこうすることは現在のLLMにとっては，難しい．
- 企業内の情報の機密性　企業の研究開発に用いる専門ライブラリは，機密性が高く，インターネットには公開されていない．LLMの訓練データにはいっさい含まれていないため，LLMに専門ライブラリの情報を与えるために，RAGによって検索結果をLLMに与えることが一般的である．専門ライブラリの活用は，一企業内だけにとどまることがほとんどのため，ファインチューニングに必要な訓練データを用意することも難しい．

//一方，製品固有の材料物性や制御ロジックを扱う企業では，汎用ライブラリに加えて自社向けライブラリを内製化し，社内エンジニア間で再利用する運用形態が一般的である．
// しかし，LLM は事前学習コーパスに含まれない非公開ライブラリの構造や理論的背景を再現できないという課題を抱える．このギャップを補完する手法として，外部知識を検索し出力に組み込む Retrieval-Augmented Generation（RAG）が提案され，根拠付き応答生成に有効であることが示されている．

//文献 [2] では，MetaGPTのアセンブリラインパラダイムを活用し，LangchainベースのRAG技術を統合したマルチエージェントフレームワーク「MetaOpenFOAM」が提案されている．本フレームワークは，Architect，InputWriter，Runner，Reviewerの四つのエージェントが連携し，ユーザーの自然言語要求から入力ファイル生成，シミュレーション実行，エラー分析・修正までを自動化する反復ループを構築する．ベンチマーク評価では，平均85 %のと平均3.6の実行可能性スコアを，ケースあたり約0.22 USDという低コストで実現した．また，アブレーション研究により，Reviewerによる結果レビュー機能およびRAG技術が高い性能に不可欠であることが確認されている．
//MetaOpenFOAM 2.0を基盤として，LLM駆動のChain‐of‐Thought（CoT）手法と外部解析・最適化ツールライブラリを連携させた「OptMetaOpenFOAM」が提案されている．本システムは，自然言語入力からCFDシミュレーション設定，ポストプロセス，感度解析（Active Subspace Method）およびパラメータ最適化（L‐BFGS‐B）を逐次的に自動化し，水素燃焼室など複数のケーススタディで，約200文字の入力により従来数千行のコードが必要だったワークフローを完遂できることを示した．この結果，非専門家でも効率的に感度解析や最適化タスクを実行可能とし，LLM駆動によるCFD自動化の新たな展開を示唆している．
//以上のように，これまでの研究では，RAGによる領域知識導入，多層エージェントによる自動化ループ，CoTを活用した最適化連携といった手法により，CFDワークフローの敷居を大幅に低減し，生産性向上を実現している．本研究では，これら先行手法の長所を踏まえ，さらなる安定化と拡張性の検証を行う．
//== OpenFOAMのシミュレーションの自動化
//さらに最新モデル Claude Opus 4 は SWE-bench で 72.5 % を記録し，長時間の自律コーディングで人間エンジニアに迫る性能を示している． 
// == Web上で公開されていない物理シミュレーションモデルへの対処法
// Modelicaの事例を見つけることができなかったが，オープンソースの数値流体力学ライブラリであるOpenFOAMの事例を見つけることができた．
//=== RAGシステムによる物理シミュレーションモデルの開発性能



= 企業でクローズされたModelicaライブラリの読解支援

本稿では、空調開発におけるモデルベースのシミュレーションに生成AIの支援を適用した例を報告する。
当社（三菱電機）でクローズされた情報で作成された物理モデルを活用し，

== Modelica言語の特徴

Modelica言語は，オブジェクト指向の記述構文を採用した非因果的・宣言型のモデリング言語であり，複雑な物理システムの記述およびシミュレーションに適している．機械，電気，熱，流体，制御などの異なるドメインに属する物理現象を統一的に扱うことが可能であり，マルチドメインシステムの統合的設計に広く用いられている．
Modelicaでは，物理法則を微分代数方程式（DAE）の形で直接記述することができる．この特徴により，従来の因果的（入力・出力を明示する）記述方式とは異なり，より自然な形でのモデリングが可能となる．
ユーザは既存のモデルをライブラリと利用することができる．
ユーザはそれらを組み合わせることで高い再利用性と保守性をもったモデルを構築できる．


== Modelica言語による冷凍サイクルシミュレーション

本研究で対象としたライブラリについて説明する。
三菱電機では，冷凍サイクルの物理シミュレーションに海外研究所Mitsubishi Electric Research Laboratory (MERL)で開発したModelicaライブラリを使用している．本稿では，このライブラリをMERL HVAC Libraryと呼ぶことにする．  
このライブラリは，エアコンなどの空気調和機の冷凍サイクルを動的な挙動をシミュレーションすることができる．冷凍サイクルを構成する熱交換器，圧縮機，膨張弁などの内部を流れる冷媒の圧力，温度，比エンタルピーといったパラメータを計算することができる．

冷媒の挙動は，非線形性が強く，動的なシミュレーションが困難である．MERL HVAC Libraryでは，冷媒流れの差分化方法，計算スキームを選択できる#citep(<laughmanComparisonTransientHeatPump2014>)。

//MERL HVAC Libraryによるモデリングの一例としてルームエアコンのモデルを示す。一部のモデルはダイアグラム表示によってクラスの継承関係の可視化が可能であるが、ほとんどのモデルはダイアグラム表示の実装中であり、クラス継承関係はコードから読み解く必要がある
2025年2月現在では、MERL HVAC Libraryは8種類のパッケージで校正されている．
現在は、パッケージの全ファイル数は3,112個ある。各ファイルに定義されたクラスとメソッドの継承関係が複雑であることと、冷凍サイクルの物理モデルリング手法が多岐にわたることがライブラリの理解を難しくしてる。下記にMERL HVAC Libraryによるモデリングの一例としてルームエアコンのモデルを示す。一部のモデルはダイアグラム表示によってクラスの継承関係の可視化が可能であるが、ほとんどのモデルはダイアグラム表示の実装中であり、クラス継承関係はコードから読み解く必要がある


== ライブラリの内部構造の理解

=== シミュレーションコードの実装
モデル作成時には，標準ライブラリ（Modelica Standard Library）との接続性を意識しつつ，AixLib内のクラス構造や継承関係を理解する必要がある．例えば，建築ゾーンのモデル AixLib.Building.LowOrder は，熱容量，外皮性能，内部発熱などをパラメータとして受け取り，建物の動的応答を表現できるように設計されている．そのため，コンポーネントの選定とパラメータ設定を適切に行うことが求められる．

さらに，AixLibは多くのサブモデルを再帰的に参照する構造となっており，Modelicaのオブジェクト指向的な特徴（継承・再定義・階層化など）を十分に理解しておく必要がある．モデルの拡張やカスタマイズを行う場合には，replaceable や extends などのキーワードを用いて，既存のテンプレート構造を再利用しつつ，新たな仕様に適合させる．

シミュレーション実行時には，熱的・流体的計算の複雑性により収束性や計算時間が問題となる場合があるため，ステップサイズ・ソルバ・パラメータのスケーリングに留意する．また，AixLibはモデル記述の一貫性を保つために物理単位や制約条件が厳格に定義されているため，整合性の確認が重要である．

=== シミュレーションのポスト処理


Modelica言語において，AixLibなどの大規模ライブラリを利用する際には，以下のような手順で開発を進める．まず初めに，使用するModelica開発環境を整備し，対象とするライブラリ（AixLib）の依存関係を含めて正しくインポートする．
本稿ではDymolaを使用している．

AixLibはシステム全体の熱的振る舞いをモデリング可能なコンポーネント群を備えており，特に建築熱負荷・HVAC・制御アルゴリズムに関するモデルが豊富に実装されている．


以上のように，複雑なModelicaライブラリを活用するには，(i) 開発環境と依存関係の適切な管理，(ii) ライブラリ内部構造の理解，(iii) Modelica言語の文法と設計思想の把握，(iv) 数値計算の安定性に関する知識，が不可欠である．


= Modelicaライブラリの設計における役割

前節のMERL HVAVC Libraryには、

よるモデリングの一例としてルームエアコンのモデルを示す。一部のモデルはダイアグラム表示によってクラスの継承関係の可視化が可能であるが、ほとんどのモデルはダイアグラム表示の実装中であり、クラス継承関係はコードから読み解く必要があ

このようなModelicaのライブラリは、モデルの忠実度（Fidelity）の根拠となる理論と実験が集積されている。このライブラリは、シミュレーションの実務が繰り返されるたびに、拡張されていき、複雑度を増していく。
藤田ら#citep(<fujita2023design>)が指摘するように、ライブラリそのものが設計根拠の集積である設計カタログとなっている。
専門性の狭い分野のため、一般書籍やReview誌などのまとまった情報を入手することも容易ではなく、ライブラリの学習の妨げになっている。

企業内で構築されているライブラリについては、上記と同様に、高度な理論


== シミュレーションの方法


ここでMERL HVAC Libralyなどの物理シミュレーションライブラリを用いてシミュレーションモデルを構築する際のエンジニアの作業プロセスを書く．
ルームエアコンを例にとると，熱交換器，ファン，圧縮機，膨張弁などの該当するクラスを探索し，各クラスを継承したモデルを接続すれば良いのであるが、

また，数値差分法のアルゴリズムを選択する．

=== モデルの理論の調査
公開情報は、博士論文や最新の論文などを調べる．
社外秘密の情報




== 大規模言語モデルの応用

本稿で構築した２つのシステムについて説明する．


=== ＲＡＧシステム
図１に示すＲＡＧシステムは４層構造で設計した．
1. データ：MERL HVC Libraryコード，ドキュメント，論文を Markdown へ変換し，Sentence-BERT で 768 次元ベクトル化して FAISS に格納する ．
2. 検索層：ユーザ質問を同一埋め込み空間で検索し，上位 k 件を取得．複数チャンクを階層マージしてプロンプト長を最適化する ．
3. 生成層：OpenAI GPT-4o-mini をベースとするＬＬＭに対し，役割指示＋検索結果＋会話履歴から構成されるテンプレートを送信する．
4. 出力層：回答と同時に引用情報を提示し，ユーザはソースコード断片へ直接ジャンプできる．

#figure(
  image("figure/agent_workflow.jpg", width: 50%),
  caption: [
    Workflow chart of our agent.
  ]
)<fig_RAGsystem>

=== Modelicaコード生成エージェント
#ref(<fig_agent>)にエージェントのワークフローを示す．核心は，Plan-Execute-Critique ループにより「検索→提案→コーディング」を自律実行する点である．

1. RAG: 前節のRAGシステムを用いて，ユーザからのプロンプトに関連するドキュメントを検索する．
2. プランナー：RAGシステムが出力した検索結果からモデル構造の手順書（pseudo-plan）を生成する ．
3. コーダー：手順書に従いコードスニペットを生成する．

#figure(
  image("figure/agent_workflow.jpg", width: 50%),
  caption: [
    Workflow chart of our agent.
  ]
)<fig_agent>


= 結果

== 単体システムの回答

一般知識で回答できる問題は、熱力学の知識に関する問題など、設計エンジニアにとって難易度の高い問題も回答することができる。
ただし、

===　公知の情報で回答可能な可能な可能質問


== RAGシステムの回答

=== 文書データベースの情報が回答に必要な質問

prompt 

=== コード作成の指示



== Ｍｏｄｅｌｉｃａコード生成エージェント

RAGシステムでは，無回答であったコーディング作業にも


= 結　　　言
本稿では，大規模言語モデルの物理シミュレーションへの作業支援について調べた．現状では，複雑なプロセスが必要な実用ライブラリのコーディング作業は完全には自動化できないが，知識探索やコードの作成方針を探索には実用できることを明らかにした．



#bibliography-list(
  ..bib-file(read("japanese-bib.bib"))
)

#bibliography-list(
  ..bib-file(read("english-bib.bib")),
  lang: "en"
)