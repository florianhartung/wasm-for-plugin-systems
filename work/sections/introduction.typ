#import "../wip.typ": *

= Introduction
Web applications are becoming more and more popular and complex requiring the use of compute-intensive algorithms for applications such as 3D visualizations or interactive games@bringing-the-web-up-to-speed.
Thus the need for faster code execution, that cannot be provided by JavaScript, grows.
Traditionally JavaScript is the only language allowing client side code execution, however it was never designed for these kinds of high-performance tasks.

WebAssembly (Wasm) is a modern web technology developed through collaboration of the four major web browsers providing performance, safety and portability.
It acts as a compilation target for higher-level languages such as Rust, C or C++@spec.
It is used by popular frameworks such as Qt for building web interfaces powered by C++ code @qt-docs or companies such as Ebay to optimize a slow barcode scanner algorithm@ebay-blog.

However, Wasm is not limited to web environments, which is by design@spec[sec.~1.1].
It is already being actively explored in several non-web contexts, such as avionics@wasm-in-avionics, automotive#footnote(link("https://oxidos.io/")) or edge computing@wasm-for-edge-computing.
There it is chosen for its properties such as safety during untrusted code execution, portability, determinism or performance.

// #todo[Name some non-web contexts, where Wasm is already being used and actively being researched on]
// According to its specification it designed mostly for code execution on the Web, however it is not limited to the Web by design.
// - Run untrusted code (TEXT EDITORS!! Plugins *do not* require complete access to FS, Network, etc.)
// - Distributed systems where many nodes work together on a single computation. No Containerization, Virtualization necessary. (Although WASM RT could be seen as a form of containerization)
// - Distributed systems: microservices, distributed computing

Plugin systems on the other hand are a software architecture pattern widely used to allow the extension of host applications.
They allow (third-party) developers to implemented new features for a host application through isolated plugins, without modification of the host application itself.
This type of software architecture pattern is especially important for text editors and integrated development environments (IDEs).
These editors have to accommodate the highly individual requirements of users such as supporting programming languages, keybindings, themes or other user preferences.

== Motivation & research question //& problem statement
Most text editors and IDE plugin systems do not have strict measures for plugin isolation to protect users from possibly malicious code.
Also plugin execution may be slow at times due to the programming languages used (e.g. JavaScript or Java).
Other plugin systems might require plugins to be recompiled for every platform, operating system or architecture.
WebAssembly looks promising as a new technology to build a plugin system on top of.
Its features such as a high performance, safety through sandboxing or portability by design are all needed to build good plugin systems.

// == Research question
This work explores whether Wasm as a technology can be used to build good and versatile plugin systems especially for text editors.
It asks the question, if Wasm is the best technology choice today for designing a good and versatile text editor plugin system from the ground up.
// TODO revisit research question in discussion at the end

== Methodology
To evaluate whether Wasm is a good technology for plugin systems, multiple methods are used.
First a technology comparison between various existing plugin systems and plugin system technologies is performed.
For that a set of criteria to define what makes a plugin system good and versatile is defined.
This allows to gather information about the current state of the art on plugin systems.

Then Wasm is evaluated using the same criteria.
These evaluation results can then be used to compare Wasm to existing plugin systems, to then decide whether Wasm can outperform other plugin system technologies in theory.

In the end a proof of concept for a Wasm plugin system for a real text editor is developed.
This implementation of a minimal plugin system is used to find out, if Wasm and its ecosystem are ready for use in real software projects not only in theory but also in practice.