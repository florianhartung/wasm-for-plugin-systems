#import "../wip.typ": *

= Introduction (4 pages)
// Wasm in the web
// On the web Wasm is used for a lot of different reasons, such as running native applications in a web context
// #footnote[The application development framework Qt allows C/C++ applications to be compiled to Wasm: #link("https://doc.qt.io/qt-6/wasm.html")]
// or running code that requires high performance
// #footnote[Ebay uses Wasm to allow sellers to scan barcodes through their webapp, for which Javascript would have been too inresponsive: #link("https://innovation.ebayinc.com/tech/engineering/webassembly-at-ebay-a-real-world-use-case/")].
// However Wasm can also be used in non-web contexts.
// WASM outside of the web
// According to its specification it designed mostly for code execution on the Web, however it is not limited to the Web by design.
// - Run untrusted code (TEXT EDITORS!! Plugins *do not* require complete access to FS, Network, etc.)
// - Distributed systems where many nodes work together on a single computation. No Containerisation, Virtualization necessary. (Although WASM RT could be seen as a form of containerisation)
// - Distributed systems: microservices, distributed computing

== Motivation & problem statement
// Motivation in two parts:
// - Plugin systems are suitable architecture for highly individual software like text editors
// - WASM is relativly modern bytecode that provides speed, safety, ... by default.

// #todo[write motivation last]

// Problem statement
// - WASM's usecases are very limited -> it is still very new and evolving
// - Plugin systems suffer from many issues: Security, interoperability, Portability, (Developer experience?)

== Research question
Is WebAssembly the best technology choice for designing versatile plugin systems for text editors?

== Methodology
// TODO this section might not be necessary
// - How will this work be structured?
// - What technologies, languages and terms are used?
