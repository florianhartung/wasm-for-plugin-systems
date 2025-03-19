#import "../wip.typ": todo, td

= Criteria for plugin systems (20 pages)
// TODO Normally a technology comparison defined weights for each score
To evaluate whether Wasm is a viable technology for versatile plugin systems, one must first understand what criteria make a plugin system good and versatile.
This section will perform a technology comparison between multiple technologies and existing software projects.
First a list of criteria is defined.
Along with each criterion a scale from 0 to 5 is defined. 
This scale enables an objective comparison between multiple scores.

Then a set of technologies and software projects, each with a different approach to plugin systems, are chosen.
The previously defined criteria are then evaluated for each technology or project.

In the end the results can be combined and visualized in a technology comparison matrix.
This matrix can be analyzed to gain further insight on the current state of the art of plugin systems.

== Definition of criteria
In this section criteria for a good plugin system are defined.
While some are considered important for software in general, others are specific to plugin systems for text editors.

=== Performance
// Improvements
// - Maybe differentiate between individual plugins and plugin systems?
// - Overhead of context switches between plugin system and plugins might be important?

- No quantitative scale, due to time-constrains and complexity
- Guess based on existing benchmarks

=== Plugin size
#todo[Maybe look at sizes of plugin systems as well? e.g. native has no overhead at all vs. JS needs an entire runtime with jit compiler]
- Guess based on existing benchmarks (no time to write custom benchmarks)
- memory footprint might impact performance

=== Plugin isolation
#figure(table(
    columns: (auto, auto, 1fr, 1fr),
    align: (center, center, left, left),
    table.header([Score], [Name], [Worst-case], [Description]),
    [0], [No isolation, requires\ elevated privileges], [Elevated privilege access to current system], [#td],
    [1], [No isolation], [Full access to the current user's system and peripherals], todo[Limited privilege access to current system, inherits host privileges],
    [2], [In isolation with\ host application], [Full access to host application], [#td /*Example: Game engine plugin*/],
    [3], [Partially\ sandboxed], [Full access to host application], todo[An attempt is made to restrict the plugin's access to the host system.],
    [4], [Fully sandboxed,\ dynamic interface], [Access to parts of the host application not meant to be exposed due to a bug in the interface], [#td],
    [5], [Fully sandboxed,\ static interface], [Indeterminable, a major bug in the sandboxing mechanism would be required], [
      The plugin runs fully sandboxed.
      It has no way of interacting with the host system, except for statically checked interfaces.
      Here statically checked interfaces refers to interfaces, that can be proven safe during compilation (or alternatively development) of the plugin system.
      One way to achieve this might be an interface definition in a common interface definition language.
      This restriction was chosen because it disallows plugin systems giving full access to parts of a host application without a proper interface definition.
    ],
  ),
  caption: [#todo[Fix table size and positioning] Scores for the plugin isolation criterion],
) <scores-isolation>

#todo[plugin isolation. scores can be seen in @scores-isolation]

=== Plugin portability <crit-plugin-portability>
#figure(table(
    columns: (auto, auto, 1fr),
    align: (center, center, left),
    table.header([Score], [Name], [Description]),
    [0], [Not portable], [The plugin is not portable between different platforms. It is theoretically and practically impossible to run the plugin on different platforms.],
    [1], [Theoretically portable], [The plugin is theoretically portable between different platforms. In practice this might be very complex and costly, e.g. having to run each plugin in its own dedicated virtual machine.],
    [2-4], [Portable\ with a runtime], [
      The plugin is portable between different platforms, but it requires a runtime on the target platform.
      Because these runtimes can vary from one plugin system to another, a score range from 2 to 4 is specified here.
      During evaluation the specific runtime has to be analyzed regarding its complexity and impact on the host system.
      A more lightweight runtime could also enable higher portability of the plugin system itself as described in @crit-plugin-portability.
    ],
    [5], [Portable by design], [The plugin is portable between different platforms without requiring a runtime on each host application. In practice this is very hard to achieve. Advanced technologies such as fat binaries, which are binaries that encapsulate compiled machine code for multiple different architectures, might be necessary. ]
  ),
  caption: [Scores for the plugin portability criterion]
) <scores-portability>

Portability stems from the field of distributed systems.
A high portability refers to software components, that can be moved from one distributed system A to another distributed system B without having to make any modifications@distributed.
This assumes that both systems A and B share a common interface for interaction to the software component@distributed.
In the context of plugin systems for text editors, portability can be interpreted in one of two different ways:
1. Every individual plugin is seen as a software component. This plugin is portable, if it can be loaded into two instances of the same text editor running on different platforms.
2. The entire plugin system itself is seen as a modular software component of a text editor. It is portable if it can be integrated into different text editors and run across different platforms.

This work considers only the first scenario, in which portability refers to each individual plugin.
// TODO Why was the first scenario chosen?

@scores-portability shows different levels of plugin portability.
Note that the most extreme scores 0 and 5 are very unlikely for any imaginable plugin system.
0 requires a plugin not to be portable at all, while 5 requires that a plugin is portable to different platforms and architectures which is very hard to implement on a technical level.

=== Extensibility for new features/interfaces (relative)
- Can the API be changed easily?

- Language interoperability for plugin development  (which/how many languages are supported)
  - Advantages:
    - More accessibility for developers without knowledge of a singular specific language.
  - Scores: a domain-specific language (custom language), multiple programming languages (JS, Python), a compilation target (JVM), no restrictions (machine code)
  - Some languages can be embedded reasonably well into others (e.g. JS in C)

#todo[define a scale for rating each criterion] \
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
- Zellij (terminal multiplexer, has a Wasm plugin system)
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

==== IntelliJ-based IDEs
#td


==== Zellij
Zellij is a terminal workspace (similar to a terminal multiplexer).
It is used to manage and organize many different terminal instances inside one terminal emulator process.
Similar commonly known terminal multiplexers are Tmux, xterm or the Windows Terminal.

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
#todo[Which other technologies and criteria might also be interesting? Which ones were left out?]