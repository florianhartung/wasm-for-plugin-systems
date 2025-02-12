#import "../wip.typ": todo, td

= Requirement analysis for plugin systems (20 pages)

== Definition of requirements
#todo[Define key requirements that are important for plugin systems of any kind, also discuss the requirements for text editors specifically]

// - Plugin portability
// - Plugin development

== Market analysis of existing plugin systems
#todo[What is this section about?] \
#todo[Why is a market analysis important for the work of this paper?]

=== Overview of chosen projects
#todo[How and why are these projects chosen?]


- Zed (text editor with Wasm plugin system, no windows support)
- VSCode (text editor)
- IntelliJ-family (IDE)
- Eclipse (IDE)
- Microsoft flight simulator (has a Wasm plugin system)
- ZelliJ (terminal multiplexer, has a Wasm plugin system)
- Extism (generic Wasm plugin system library usable in many different languages)

=== Evaluation of key requirements
#todo[define a scale for rating each requirement] \
#todo[explain the methodology for evaluation: e.g. analysis of code, documentation, papers?]

==== Zed
#td

// - WASM mit kompletter WIT Schnittstellendefinition (Generisches Typ/Funktions-basiertes System)pro Version
// - Fokus auf Isolation von WASM Code
// - shim library nur für Rust vorhanden: zed_extension_api
// https://zed.dev/docs/extensions/developing-extensions
// https://github.com/zed-industries/zed/blob/94faf9dd56c494d369513e885fe1e08a95256bd3/crates/extension_api/wit/since_v0.2.0/http-client.wit

==== VSCode
#td

==== IntellJ-based IDEs
#td

==== Eclipse
#td

==== Microsoft flight simulator
#td

// - Bietet unterschiedliche SDKs: WASM, JS, SimConnect SDK (?), SimVars (?)

==== Zellij
Zellij is a terminal workspace (similar to a terminal multiplexer).
It is used to manage and organize many different terminal instances inside one terminal emulator process.
Similary commomly known terminal multiplexers are Tmux, xterm or Windows Terminal on Windows.

- plugin system to allow users to add new features
- plugin system is not very mature https://zellij.dev/documentation/plugin-system-status
- Wasm for plugins, however only Rust is supported
- Permission system
#td

// - WASM mit WASI Unterstützung 
// - API unabhängig von der Sprache mit Protobuf (Message-basiertes System, https://protobuf.dev/)
// - Permission System gruppiert Events & Commands zusammen

==== Extism
Extism is a cross-language framework for embedding WebAssembly code into a project.
It is originally written in Rust and provides bindings (Host SDKs) and shims (Plugin Development Kits: PDKs) for many different languages.
#td

// Docs: https://extism.org/docs/overview
// Github: https://github.com/extism/extism

=== Summary
#todo[Present findings in a table]