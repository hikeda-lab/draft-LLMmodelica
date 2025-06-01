#import "style/jsme_style.typ" : *
#import "bib-style/lib.typ" : *

#show: jsme_init
#import bib_setting_jsme: *
#show: bib_init
#show: equate.with(breakable: true, number-mode: "line")
#show: bib_init

#show: jsme_title.with(
  title: [投稿論文作成について],
  subtitle: [(日本機械学会指定テンプレートファイル利用について)],
  authors: (
    (
      name: "機械 太郎",
      english_name: "Taro KIKAI",
      thanks: "正員，日本機械学会(〒160-0016 東京都新宿区信濃町35)",
      english_thanks: "Japan Society of Mechanical Engineering",
      english_place: "35Shinanomachi,Shinjuku-kuTokyo160-0016,Japan"
    ),
    (
      name: "技術 さくら",
      english_name: "Sakura GIJYUTSU",
      thanks: "学生員，日本機械大学工学部(〒160-0001 東京都新宿区工学町1)",
      english_thanks: "Department of Mechanical Engineering, Kikai University",
      english_place: "1 Kogakumachi, Shinjuku-ku, Tokyo 160-0001, Japan"
    ),
    (
      name: "東京 花子",
      english_name: "Hanako TOKYO",
      thanks: "日本機械大学 工学部",
      english_thanks: "Department of Mechanical Engineering, Kikai University",
      english_place: "1 Kogakumachi, Shinjuku-ku, Tokyo 160-0001, Japan"
    ),
  ),
  english_title: [Making research paper],
  english_subtitle: [(About the use of the JSME specification template file)],
  abstruct: [The length of the abstract should be 200-300 words. In the beginning of the abstract, the subject of the paper should be stated clearly, together with its scope and objectives. Then, the methods, equipment, results and conclusions in the paper should be stated concisely in a sufficiently logical manner. The discussion on the results may also be stated to emphasize their importance appropriately.],
  keywords: ("Term1", "Term2", "Term3", "Term4", "...(Show five to ten key words)"),
  email: "taro@jsme.or.jp"
)

#include "chapters/introduction.typ"
#include "chapters/previous_works.typ"




= 結　　　言

本テンプレートファイルのスタイルを利用すると，各々の項目の書式が自動的に利用できるので便利である．

#bibliography-list(
  ..bib-file(read("japanese-bib.bib"))
)

#bibliography-list(
  ..bib-file(read("english-bib.bib")),
  lang: "en"
)
