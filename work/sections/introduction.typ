#import "../wip.typ": *

= Introduction
Web applications are becoming more and more popular and complex requiring the use of compute-intensive algorithms for applications such as 3D visualizations or interactive games@bringing-the-web-up-to-speed.
Thus the need for faster code execution that cannot be provided by JavaScript grows.
Traditionally JavaScript is the only language allowing client side code execution, however it was never designed for these kinds of high-performance tasks.

WebAssembly (Wasm) is a modern web technology developed through collaboration of the four major web browsers providing performance, safety and portability.
It is used by popular frameworks such as Qt for building web interfaces powered by C++ code @qt-docs or companies such as Ebay to optimize a slow barcode scanner algorithms@ebay-blog.


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