#import "../wip.typ": todo, td

= Requirement analysis for plugin systems (20 pages)

== Definition of requirements
#todo[Define key requirements that are important for plugin systems of any kind, also discuss the requirements for text editors specifically]

- Extensibility for new features/interfaces (relativ)
  - Can the API be changed easily?
- Plugin Safety/Isolation
  - Checklist for safety to find out what is the worst case:
  - full access to the underlying hardware e.g. root privileges on os
  - full access to current user profile
  - access to peripherals e.g. network, connected disks, keyboard
- Plugin portability
  - Scores: not portable, portable but very hard (e.g. an entire VM is necessary), portable with runtime, portable without runtime (basically impossible, fat binaries for multi-architecture?)
- Language interoperability for plugin development  (which/how many languages are supported)
  - Advantages:
    - More accessibility for developers without knowledge of a singular specific language.
  - Scores: a domain-specific language (custom language), multiple programming languages (JS, Python), a compilation target (JVM), no restrictions (machine code)
  - Some languages can be embedded reasonably well into others (e.g. JS in C)
- Plugin performance
  - Guess based on existing benchmarks (no time to write custom benchmarks)
  - Overhead of context switches between plugin system and plugins might be important?
- Plugin size
  - Guess based on existing benchmarks (no time to write custom benchmarks)

== Market analysis of existing plugin systems
#todo[What is this section about?] \
#todo[Why is a market analysis important for the work of this paper?]

=== Overview of chosen projects
#todo[How and why are these projects chosen?]


- VSCode (versatile text editor)
- IntelliJ-family (IDE)
- Zed (text editor with Wasm plugin system, no windows support)
// - Eclipse (IDE) [very similar to IntelliJ-based editors, less popular than IntellIJ nowadays]
// - Microsoft flight simulator (has a Wasm plugin system) [lacks documentation, is not free/open-source]
- ZelliJ (terminal multiplexer, has a Wasm plugin system)
- DLL-based plugins (e.g. FL studio)
// - Extism (generic Wasm plugin system library usable in many different languages)

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
#todo[Which other technologies might also be interesting? Which ones were left out?]