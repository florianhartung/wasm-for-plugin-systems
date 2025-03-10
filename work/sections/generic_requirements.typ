#import "../wip.typ": todo, td

= Requirements for plugin systems (20 pages)
To be able to evaluate whether Wasm is a viable technology for versatile plugin systems, one must first understand traditional plugin systems.
This section will perform a technology comparison between multiple technologies and existing software projects.

First a list of requirements #todo[(alternative name: criteria?)] is defined.
Along with each requirement a scale is defined to be able to compare different scores.
Then different technologies and software projects are chosen.
Then the requirements will be evaluated for chosen technologies/projects.

In the end all technologies/projects are put into a technology comparison matrix, which can be analyzed to gain further insight on the current state of the art of plugin systems.

#todo[Maybe in introduction of next section: This will then make it possible to make an objective statement about Wasm in comparison.]

== Definition of requirements
// Define key requirements that are important for plugin systems of any kind
// also discuss the requirements for text editors specifically]

=== Performance
#todo[Differentiate between individual plugins and plugin systems?]
- Guess based on existing benchmarks (no time to write custom benchmarks)
- Overhead of context switches between plugin system and plugins might be important?

=== Plugin size
#todo[Maybe look at sizes of plugin systems aswell? e.g. native has no overhead at all vs. JS needs an entire runtime with jit compiler]
- Guess based on existing benchmarks (no time to write custom benchmarks)
- memory footprint might impact performance

=== Plugin isolation
- Checklist for safety to find out what is the worst case:
- full access to the underlying hardware e.g. root privileges on os
- full access to current user profile
- access to peripherals e.g. network, connected disks, keyboard

=== Portability
#todo[Is portability only interesting for plugins or also for entire plugin systems?]
- Scores: not portable, portable but very hard (e.g. an entire VM is necessary), portable with runtime, portable without runtime (basically impossible, fat binaries for multi-architecture?)

=== Extensibility for new features/interfaces (relativ)
- Can the API be changed easily?

- Language interoperability for plugin development  (which/how many languages are supported)
  - Advantages:
    - More accessibility for developers without knowledge of a singular specific language.
  - Scores: a domain-specific language (custom language), multiple programming languages (JS, Python), a compilation target (JVM), no restrictions (machine code)
  - Some languages can be embedded reasonably well into others (e.g. JS in C)

#todo[define a scale for rating each requirement] \
#todo[explain the methodology for evaluation: e.g. analysis of code, documentation, papers?]

== Technology comparison of existing projects
#todo[What is this section about?] \
#todo[Why is a market analysis important for the work of this paper?]

=== Overview of chosen projects
#todo[How and why are these projects chosen?]
- VSCode (versatile text editor)
  - JavaScript based
- IntelliJ-family (IDE)
  - Java based
- Zed (text editor with Wasm plugin system, no windows support)
  - Wasm, but official interface only for Rust plugins?
// - Eclipse (IDE) [very similar to IntelliJ-based editors, less popular than IntellIJ nowadays]
// - Microsoft flight simulator (has a Wasm plugin system) [lacks documentation, is not free/open-source]
  // - Bietet unterschiedliche SDKs: WASM, JS, SimConnect SDK (?), SimVars (?)
- ZelliJ (terminal multiplexer, has a Wasm plugin system)
  - Wasm, but official interface only for Rust plugins?
- DLL-based plugins (e.g. FL studio)
  - Native code
// - Extism (generic Wasm plugin system library usable in many different languages)
  // ==== Extism
  // Extism is a cross-language framework for embedding WebAssembly code into a project.
  // It is originally written in Rust and provides bindings (Host SDKs) and shims (Plugin Development Kits: PDKs) for many different languages.
  // #td

// Docs: https://extism.org/docs/overview
// Github: https://github.com/extism/extism

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

=== Summary
#todo[Present findings in a table]
#todo[What could have been done better?]
#todo[Which other technologies and requirements might also be interesting? Which ones were left out?]