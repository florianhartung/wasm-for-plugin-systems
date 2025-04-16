#import "../wip.typ": todo, td

= WebAssembly for plugin systems
#todo[Present basic idea of running Wasm code for each plugin inside a Wasm runtime]

== Overview of basic plugin system architecture

== Evaluation of criteria
/ Performance: #td
/ Plugin size: #td
/ Plugin isolation: #td
/ Plugin portability: #td
/ Plugin language interoperability: #td


== Evaluation of interface-specific requirements
#todo[
  It is not possible to evaluate Wasm as a technology, because it only provides fundamental technology for executing WebAssembly program code.
  In practice WebAssembly is often combined with other technologies that build upon Wasm's basic constructs and allow for more complex systems such as type systems or interface definitions.

  WebAssembly as a technology is often not restrictive enough and thus the decision of whether a requirement is fulfilled often comes down to the host- and plugin-language and whether a common interface definition between them exists.

  To illustrate this point, consider a scenario in which a host system is written in JavaScript.
  When this host system wants to call a Wasm function it serializes the arguments, which might consist of complex JavaScript types, to JSON strings.
  Then it passes these JSON strings to the Wasm plugin.
  A plugin written in JavaScript itself will be able to easily parse the JSON string given to it, however a plugin written in C first has to get a system in place to parse and convert JavaScript types to equivalent C types.
]
#todo[Wasm interfacing is still an unsolved problem. There are many different solutions, of which some will be evaluated separately here]



=== Without a standardized interface
#td

// abstractions over very trivial wasm type system have to be made
// WASM + Custom interface definition + Custom memory layout for complex types (e.g. string = null-terminated pointer vs. string = pointer + length)
// Microsoft flight simulator does this I think? It also only supports C++ as a plugin language

=== WebAssembly Component Model
#td

// WASM + WAT for common interface definition + automatic binding generation
//   Zellij does this without binding generation

=== WebAssembly Component Model + WebAssembly System Interface (WASI)
#td
// WASM + WASI allows some std libraries to work (rust std, C++ stl)

// WASM + WASI + WAT: there are predefined WAT files for WASI interfaces


=== Custom serialization format (JSON, XML, Protobuf)
#td

// WASM + serialization like Protobuf: Every communication goes through one exported Wasm function and one imported host function

== Plugin systems already using WebAssembly today
// Present some projects that have implemented Wasm plugin systems and also present their development processes and choices made

#todo[
  / Zed: text editor with Wasm plugin system, no windows support
    - Wasm, but official interface only for Rust plugins?
    - WASM mit kompletter WIT Schnittstellendefinition (Generisches Typ/Funktions-basiertes System)pro Version
    - Fokus auf Isolation von WASM Code
    - shim library nur für Rust vorhanden: zed_extension_api
    #link("https://zed.dev/docs/extensions/developing-extensions")
    #link("https://github.com/zed-industries/zed/blob/94faf9dd56c494d369513e885fe1e08a95256bd3/crates/extension_api/wit/since_v0.2.0/http-client.wit")

  / Zellij: terminal multiplexer, has a Wasm plugin system.
    - Wasm, but official interface only for Rust plugins?

    Zellij is a terminal workspace (similar to a terminal multiplexer).
    It is used to manage and organize many different terminal instances inside one terminal emulator process.
    Similar commonly known terminal multiplexers are Tmux, xterm or the Windows Terminal.

    - plugin system to allow users to add new features
    - plugin system is not very mature https://zellij.dev/documentation/plugin-system-status
    - Wasm for plugins, however only Rust is supported
    - Permission system

  // - WASM mit WASI Unterstützung 
  // - API unabhängig von der Sprache mit Protobuf (Message-basiertes System, https://protobuf.dev/)
  // - Permission System gruppiert Events & Commands zusammen

  / Extism: generic Wasm plugin system library usable in many different languages
    - Extism is a cross-language framework for embedding WebAssembly code into a project.
    - It is originally written in Rust and provides bindings (Host SDKs) and shims (Plugin Development Kits: PDKs) for many different languages.
    - Docs: #link("https://extism.org/docs/overview")
    - Github: #link("https://github.com/extism/extism")

  / go-plugin: #td
]

== Summarized evaluation for WebAssembly
#todo[Show all WebAssembly configuration in a matrix with all criteria as columns]
