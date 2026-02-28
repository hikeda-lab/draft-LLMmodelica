#import "style/jsme_style.typ" : *
#import "bib-style/lib.typ" : *

#show: jsme_init
#show: bib_init
#show: equate.with(breakable: true, number-mode: "line")

#show: jsme_title.with(
  title: [大規模言語モデルを用いた1DCAEのモデリング作業の支援],
  //subtitle: [(日本機械学会指定テンプレートファイル利用について)],
  authors: (
    (
      name: "○池田 孟",
      english_name: "Hajime IKEDA",
      thanks: "三菱電機株式会社 設計開発技術センター",
      english_thanks: "Engineering and Development Center, Mitsubishi Electric Corporation",
      english_place: "8-1-1, Tsukaguchi-Honmachi, Amagasaki City, Hyogo 661-8661, Japan",
    ),
    (
      name: "石橋 祐太郎",
      english_name: "Yutaro ISHIBASHI",
      thanks: "三菱電機株式会社 生産技術センター",
      english_thanks: "Manufacturing Technology Center, Mitsubishi Electric Corporation",
      english_place: "8-1-1, Tsukaguchi-Honmachi, Amagasaki City, Hyogo 661-8661, Japan",
    ),
    (
      name: "金丸　正寛",
      english_name: "Masahito Kanamaru",
      thanks: "三菱電機株式会社 設計開発技術センター",
      english_thanks: "Engineering and Development Center, Mitsubishi Electric Corporation",
      english_place: "8-1-1, Tsukaguchi-Honmachi, Amagasaki City, Hyogo 661-8661, Japan",
    ),
    (
      name: "小林 孝",
      english_name: "Takashi KOBAYSHI",
      thanks: "三菱電機株式会社 設計開発技術センター",
      english_thanks: "Engineering and Development Center, Mitsubishi Electric Corporation",
      english_place: "8-1-1, Tsukaguchi-Honmachi, Amagasaki City, Hyogo 661-8661, Japan",
    )
  ),
  english_title: [Supporting 1DCAE modeling using Large Language Model],
  english_subtitle: [],
  abstruct: [In complex system design, where mechanical, electrical, and control subsystems interact, 1D CAE is increasingly adopted to optimize products quickly by verifying requirements through early-stage physical simulations on virtual prototypes. The Modelica language has become the standard for modeling these systems due to its object-oriented, declarative nature and ability to handle multi-domain interactions. It supports hierarchical modeling using extensive libraries. Recent advancements in generative AI, particularly Large Language Models (LLMs), have enabled new approaches in design engineering, such as automating design system handling and managing design knowledge. This study presents a framework that uses Retrieval-Augmented Generation (RAG) to search closed corporate Modelica repositories and employs three collaborative agents—a planner, coder, and tester—to automatically assemble libraries. Experiments using OpenAI-4o demonstrated that this agent-based workflow could generate candidate code for tasks that RAG alone could not handle. The results also showed improved code generation performance when working with proprietary internal libraries, highlighting the potential of combining LLMs with structured agent collaboration in engineering design automation. ],
  keywords: ("Large Language Model", "Model-based Development", "1DCAE", "Design Engineering"),
  email: "taro@jsme.or.jp",
)

// 句読点をカンマとピリオドに変換
#show "、": "，"
#show "。": "．"

// ============================================================
// 本文：各章ファイルを include で読み込む
// ============================================================

#include "chapters/introduction.typ"

#include "chapters/role_of_1dcae.typ"

#include "chapters/previous_works.typ"

#include "chapters/method.typ"

#include "chapters/result.typ"

#include "chapters/conclusion.typ"

// ============================================================
// 参考文献
// ============================================================

#include "chapters/references.typ"
