#import "../wip.typ": *

= Introduction
#todo[Introduce Wasm as modern web technology, used by popular frameworks (Qt) and companies (Ebay)]
// Wasm in the web
// On the web Wasm is used for a lot of different reasons, such as running native applications in a web context
// #footnote[The application development framework Qt allows C/C++ applications to be compiled to Wasm: #link("https://doc.qt.io/qt-6/wasm.html")]
// or running code that requires high performance
// #footnote[Ebay uses Wasm to allow sellers to scan barcodes through their webapp, for which Javascript would have been too unresponsive: #link("https://innovation.ebayinc.com/tech/engineering/webassembly-at-ebay-a-real-world-use-case/")].

#todo[Explain why Wasm is attractive for non-web contexts]
// However Wasm can also be used in non-web contexts.
// WASM outside of the web

#todo[Name some non-web contexts, where Wasm is already being used and actively being researched on]
// According to its specification it designed mostly for code execution on the Web, however it is not limited to the Web by design.
// - Run untrusted code (TEXT EDITORS!! Plugins *do not* require complete access to FS, Network, etc.)
// - Distributed systems where many nodes work together on a single computation. No Containerization, Virtualization necessary. (Although WASM RT could be seen as a form of containerization)
// - Distributed systems: microservices, distributed computing

#todo[Plugin systems on the other hand are software architectures widely used, especially in text editors.]
#todo[Explain the advantages of plugin systems and why they are so important for text editors]
#todo[Name some problems plugin system might have]

#todo[Wasm looks promising as a technology for plugin systems]

== Motivation & problem statement
#todo[
  Motivate in two parts:
  + Plugin systems are suitable architecture for highly individual software like text editors
  + WASM is relatively new bytecode that provides speed, safety, portability by default
]

#todo[
  Problem statement:
  - Plugin systems suffer from many issues: Security, interoperability, Portability, (Developer experience?)
  - WASM's use cases are very limited -> it is still very new and evolving
  - Can both be combined for better plugin systems?
]

== Research question
Is WebAssembly the best technology choice for designing versatile plugin systems especially for text editors?

== Methodology
#todo[
  How this work is structured:
  - Technology comparison
  - Additional evaluation and comparison of Wasm
  - Development of a proof of concept
]