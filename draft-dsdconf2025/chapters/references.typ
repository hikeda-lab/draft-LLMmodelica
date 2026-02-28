#import "/bib-style/lib.typ": bibliography-list, bib-file

// 参考文献リスト
// このファイルはメインファイルから include して使う
// bibファイルは dsdconfstyle-bib.bib（英語・日本語まとめて管理）

#bibliography-list(
  ..bib-file(read("../dsdconfstyle-bib.bib")),
  lang: "en",
)
