= Requirement analysis for plugin systems
- Als Marktanalyse
- Analysis of related work and other projects/software
- Formal definition of requirements

// Related Work wird hier im Zuge der Requirements recherchiert
- Projects
  - Text editors with WASM plugin systems: Zed
  - Common text editors with plugin systems: VSCode, IntelliJ, Eclipse
  - WASM plugin systems: Extism (cross-language plugin framework), maybe for audio processing?
  - Software with WASM plugin systems: Microsoft Flight Simulator, ZelliJ (terminal multiplexer)

- Works
  - Containerization with WASM in HPC: "Exploring the Use of WebAssembly in HPC" 10.1145/3572848.3577436
  - Structural and behavioural analysis of plugin components in Java: "Predictable Dynamic Plugin Systems" https://link.springer.com/chapter/10.1007/978-3-540-24721-0_9

== Notes: Interesting projects
*Zed*
Editor für Mac/Linux mit WASM Plugin System
https://zed.dev/docs/extensions/developing-extensions
https://github.com/zed-industries/zed/blob/94faf9dd56c494d369513e885fe1e08a95256bd3/crates/extension_api/wit/since_v0.2.0/http-client.wit
- WASM mit kompletter WIT Schnittstellendefinition (Generisches Typ/Funktions-basiertes System)pro Version
- Fokus auf Isolation von WASM Code
- Nur shim library für Rust vorhanden: zed_extension_api

*Microsoft Flight Simulator*
- Bietet unterschiedliche SDKs: WASM, JS, SimConnect SDK (?), SimVars (?)

*ZelliJ*
Terminal multiplexer
- WASM mit WASI Unterstützung 
- API unabhängig von der Sprache mit Protobuf (Message-basiertes System, https://protobuf.dev/)
- Permission System gruppiert Events & Commands zusammen

*Language Server Protocol*
- wird oft als Ersatz für Plugin genutzt, um 