#import "../wip.typ": todo, td

= Criteria for plugin systems (20 pages)
// TODO Normally a technology comparison defined weights for each score
To evaluate whether Wasm is a viable technology for versatile plugin systems, one must first understand what criteria make a plugin system good and versatile.
This section will perform a technology comparison between several technologies and existing software projects.
First, a set of criteria is defined.
Then, appropriate technologies and software projects are selected to represent a spectrum of different plugin systems.
Next, the technologies and projects are evaluated against the previously defined criteria.
Finally, a technology comparison matrix is used to summarize and visualize the results.

== Definition of criteria
In this section criteria for good plugin systems are defined.
// TODO Mention, that choice of criteria should be specifically suited for text editor plugin systems?
Each criterion will define a scale from 0 to 5, along with requirements for each score.
This scale will be useful later to enable an objective evaluation and comparison of technologies and projects.

=== Performance
A computer's performance usually refers to the speed it is able to execute software at.
Generally one wants every piece of code to run as fast as possible.
However in some scenarios one might also choose other features such as less memory usage or dynamic typing over performance.

In the context of plugin systems, performance also refers to the speed at which software is executed.
Here the most important software components are the host system, a plugin system and a plugin.
In this case performance describes how quickly a host system can temporarily transfer execution to a plugin system, that then loads and invokes a plugin's entry point.

While performance can be measured quantitatively through benchmarks, in practice this is quite hard for plugin systems.
To benchmark different plugin systems one would have to implement a variety of algorithms and scenarios for multiple plugin systems.
Then one could measure the time each plugin system and plugin takes to execute.

Due to time-constraints and the wide spectrum of knowledge necessary for such a benchmark, this work will not utilize quantitative benchmarks to measure performance.
Instead performance will be rated through educated guesses based on benchmarks and comparisons already available for chosen technologies.
This section presents a rough outline for the scores used, but the final score has to be determined for each technology individually.

#td Performance scores

// Improvements
// - Maybe differentiate between individual plugins and plugin systems?
// - Overhead of context switches between plugin system and plugins might be important?

=== Plugin size
#todo[Maybe look at sizes of plugin systems as well? e.g. native has no overhead at all vs. JS needs an entire runtime with jit compiler]
- Guess based on existing benchmarks (no time to write custom benchmarks)
- memory footprint might impact performance

=== Plugin isolation
Often times plugins contain foreign code.
This is especially the case for text editors, where plugins are often downloaded from a central registry, also known as plugin/extension marketplaces.
Event though there might be checks in place to check for malicious contents, plugins are still foreign code.


- isolation is property how isolated plugin is from its host execution environment
- the interface between plugin and host plays a big role: only if it can be abused in unexpected ways, isolation is violated


Isolation is a property of plugins, that describes how isolated a plugin is from its outside execution environment.
// Additional notes:
// One might even go a step further and consider plugins as untrusted code.
// A plugin system could employ a zero-trust strategy, where plugins are executed fully sandboxed and given permissions to certain interfaces only through the user.
// Then the plugin system could also monitor and analyze plugins and their behavior and warn or disable them when suspicious behavior is detected.

/ 0 -- No isolation, required elevated privileges: #td \
  _Worst case: Elevated privilege access to current system._
/ 1 -- No isolation: #todo[Limited privilege access to current system, inherits host privileges] \
  _Worst case: Full access to the current user's system and peripherals._
/ 2 -- In isolation with host application: #td \ // game engine plugin
  _Worst case: Full access to host application._
/ 3 -- Partially sandboxed: #todo[An attempt is made to restrict the plugin's access to the host system] \
  _Worst case: Full access to host application._
/ 4 -- Fully sandboxed, dynamic interface: #td \
  _Worst case: Access to parts of the host application not meant to be exposed due to a bug in the interface._
/ 5 -- Fully sandboxed, static interface: The plugin runs fully sandboxed.
      It has no way of interacting with the host system, except for statically checked interfaces.
      Here statically checked interfaces refers to interfaces, that can be proven safe during compilation (or alternatively development) of the plugin system.
      One way to achieve this might be an interface definition in a common interface definition language.
      This restriction was chosen because it disallows plugin systems giving full access to parts of a host application without a proper interface definition. \
  _Worst case: Indeterminable, a major bug in the sandboxing mechanism is required._

=== Plugin portability <crit-plugin-portability>

Portability stems from the field of distributed systems.
A high portability refers to software components, that can be moved from one distributed system A to another distributed system B without having to make any modifications@distributed.
This assumes that both systems A and B share a common interface for interaction to the software component@distributed.
In the context of plugin systems for text editors, portability can be interpreted in one of two different ways:
1. Every individual plugin is seen as a software component. This plugin is portable, if it can be loaded into two instances of the same text editor running on different platforms.
2. The entire plugin system itself is seen as a modular software component of a text editor. It is portable if it can be integrated into different text editors and run across different platforms.

This work considers only the first scenario, in which portability refers to each individual plugin.
// TODO Why was the first scenario chosen?

/ 0 -- Not portable: The plugin is not portable between different platforms.
  It is theoretically and practically impossible to run the plugin on different platforms.
/ 1 -- Theoretically portable: The plugin is theoretically portable between different platforms.
  In practice this might be very complex and costly, e.g. having to run each plugin in its own dedicated virtual machine.
/ 2,3,4 -- Portable with a runtime: The plugin is portable between different platforms, but it requires a runtime on the target platform.
  Because these runtimes can vary from one plugin system to another, a score range from 2 to 4 is specified here.
  During evaluation the specific runtime has to be analyzed regarding its complexity and impact on the host system.
  A more lightweight runtime could also enable higher portability of the plugin system itself as described in @crit-plugin-portability.
/ 5 -- Portable by design: The plugin is portable between different platforms without requiring a runtime on each host application.
  In practice this is very hard to achieve.
  Advanced technologies such as fat binaries, which are binaries that encapsulate compiled machine code for multiple different architectures, might be necessary. 

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

=== Summary <technology-comparison-matrix>
#todo[Present findings in a table]
#todo[What could have been done better?]
#todo[Which other technologies and criteria might also be interesting? Which ones were left out?]