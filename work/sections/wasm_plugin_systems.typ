#import "../wip.typ": todo, td
#import "../util.typ": flex-caption

= WebAssembly for plugin systems
#figure(
  image("../images/wasm_plugin_system.drawio.png", width: 70%),
  caption: flex-caption(
    [A plugin system using a WebAssembly runtime to embed WebAssembly plugins inside of a host application.],
    [A WebAssembly plugin system inside of a host application]
  )
) <wasm-plugin-system>

This section explores Wasm as a technology for how to run individual plugins in a plugin system.
Wasm is able to provide performance (@design_fast), safety through sandboxed isolation (@design_safe), portability (@design_portable) and other features.
To find out, whether Wasm is competitive to the previously evaluated plugin systems, Wasm will be evaluated in this section.

First, an overview over the architecture of Wasm plugin systems and the relevant software components is given.
Then Wasm is evaluated as a technology for the criteria defined in @definition-criteria and compared against previous plugin systems.
In the end related projects implementing Wasm plugin systems and their technology choices are presented briefly.

Generally plugin systems inside a host application manage plugins and allow interaction between the host application and plugins (@plugin-systems).
Wasm plugin system architectures follow this approach, however a Wasm runtime is added as an additional layer between the plugin system and Wasm plugins.
@wasm-plugin-system shows an exemplary plugin system architecture similar to the one shown in @plugin-systems-arch.
However here the Wasm runtime explicitly owns and manages the Wasm plugins, consisting of their Wasm modules and runtime state such as linear memory, the stack, etc.
Also the Wasm runtime and its plugins exist completely inside the plugin system.
They are isolated and sandboxed through software, as opposed to other means of isolation such as running plugins in isolated processes.

== Evaluation of criteria <wasm-evaluation-of-criteria>
/ Performance:
  The execution of WebAssembly bytecode is very fast by design.
  While there is some overhead for loading Wasm plugins and compiling them, at runtime Wasm is able to achieve speeds comparable to native speed by a single-digit factor (see @design_fast).
  Also Wasm bytecode is designed to be compact (see @design_compact), which can further increase its performance, as smaller data can generally be loaded and operated on by the CPU.

  In real interactive applications systems this overhead is negligible in most cases.
  Thus Wasm is rated at a score of 4 for the performance criterion.

/ Plugin size:
  With Wasm being originally designed for the web, the size and compactness of its bytecode are very important.
  On the web larger files result in longer file transfers and loading times, which can possibly impact the user experience negatively.
  Thus Wasm was designed with compact bytecode.
  In comparison to natively compiled machine code, it is larger by a factor of around 2.4x (see @design_compact), which is acceptable for text editor plugin systems.

  However, note that Wasm plugins are also able to embed higher-level level languages that require a runtime such as Python or JavaScript.
  In these cases a small runtime is compiled to Wasm and is distributed along with the source code of the program written in Python/JavaScript.
  This may introduce a comparatively large overhead, as multiple Wasm plugin may contain redundant information, e.g. the same Python runtime.

  Because Wasm is generally able to achieve relatively compact plugin sizes with only larger plugin sizes for some languages which cannot be compiled to Wasm directly, it is rated at a score of 3.

/ Plugin isolation:
  The execution of Wasm code is sandboxed by default.
  It's execution semantics are defined formally by the specification in such a way, that there are no loopholes for Wasm code to escape this sandbox in theory.
  Access to the host is allowed only through functions, that are explicitly exposed by the hos.
  By default Wasm runtimes do not expose any of these interfacing functions to Wasm modules.
  The design goal for Wasm regarding safety is described more detailed in @design_safe.

  Also Wasm's type system does not allow for any methods to share data between the host and Wasm code other than its simple type system or by having the host access the linear memory of a Wasm module.
  This means that every interaction between the host application and Wasm plugins must be defined statically.
  No dynamic sharing of data such as memory mapping or passing pointers is allowed.
  The only exception for this are `funcref`s and `externref`s, which are references  opaque to Wasm, meaning Wasm code cannot forge and read the bits of these references@spec[sec.~2.3.3].

  Because Wasm allows for perfectly isolated plugin execution in theory and its type system does not allow dynamic sharing of data, the plugin isolation criterion is rated at a score of 5.

/ Plugin portability:
  Wasm is designed with portability as a goal.
  Originally it was designed for the web, where portability is necessary to support various browsers, platforms and architectures (see @design_portable).

  For that the execution of Wasm requires a small runtime, able to execute the relatively simple Wasm code.
  Once Wasm code is compiled, it is then portable to any platform, for which any Wasm runtime exists.

  Because of the need of a small Wasm runtime and the extreme portability of Wasm plugins themselves, the plugin portability for Wasm plugins is rated at a score of 4.

/ Plugin language interoperability:
  Wasm is designed to be a universal compilation target for various languages.
  One design goal of Wasm is the independence of languages as described in @independence-language, so that various languages can be supported equally.
  The the time of writing, the official Wasm website lists 25 languages and technologies, which can be compiled or embedded in Wasm modules.
  Examples for popular languages that can be compiled directly to Wasm are Rust, C, C++, Java.
  Other languages such as Python are not compiled directly to Wasm.
  Instead the source code written in these higher-level languages is distributed together with minimal runtimes.
  For example when Python is embedded in Wasm, a Python interpreter is compiled to Wasm instead and distributed along with the original Python source code.
  This is what the project Pyodide does (#link("https://pyodide.org")).

  Because Wasm is able to act both as a compilation target comparable to existing compilation targets such as x86-64 or ARM machine code and as an environment for embedding of higher-level languages,
  it is rated at a score of 5.
  It allows plugins to be written in various different languages without technology restrictions for plugin developers.

== Evaluation of WebAssembly for plugin systems against previous technologies
#let c(n) = {
  let fill = gray
  let contents = [?]

  if n != none {
    let t = n / 5 * 100% // to ratio
    t = t * 55% // rescale to 20%..80%
    t = 100% - t // flip

    fill = gradient.linear(..color.map.turbo).sample(t)
    contents = [#n]
  }

  table.cell(fill: fill, contents)
}

#let header-rot(contents) = table.cell(
  stroke: none,
  inset: 1em,
  align(bottom,
    rotate(70deg,
      origin: start,
      reflow: true,
      [
        #set par(leading: 0.5em)
        #contents
      ]
    ))
  )

#let scores = (
  "Visual Studio Code": (3, 3, 3, 4, 1),
  "IntelliJ-family": (3, 3, 1, 4, 3),
  "Notepad++": (5, 4, 1, 1, 5),
  "VST3": (5, 4, 1, 1, 5),
  "Wasm": (4, 3, 5, 4, 5),
)

// WEIGHTING SCORE
// #let weights = (5, 3, 4, 5, 3)
// #let scores = scores.pairs().map(((k, v)) => {
//   if v.contains(none) {
//     (k, (..v, none))
//   } else {
//     let s = v.at(0) * weights.at(0) + v.at(1) * weights.at(1) + v.at(2) * weights.at(2) + v.at(3) * weights.at(3) + v.at(4) * weights.at(4)
//     let s = s / weights.sum()

//     (k, (..v, s))
//   }
// }).to-dict()

#figure(
  table(
    columns: 6, // set to 7 for weighting
    align: (right + horizon, center, center, center, center, center),
    table.header(table.cell(stroke: none, []), header-rot[Performance], header-rot[Plugin size], header-rot[Plugin isolation], header-rot[Plugin portability], header-rot[Plugin language\ interoperability]), //header-rot[Weighted score]),
    ..scores.pairs().map(((x, y)) => (table.cell(x), ..y.map(c))).flatten()
  ),
  caption: flex-caption(
    [Final technology comparison matrix for selected\ technologies and WebAssembly.],
    [Final technology comparison matrix for existing technologies & WebAssembly]
  ),
) <technology-comparison-matrix-final>

The last section @wasm-evaluation-of-criteria evaluated all five criteria for Wasm as a technology for plugin systems.
Now that existing technologies and Wasm have been evaluated, they can be compared.
@technology-comparison-matrix-final shows the previous technology comparison matrix @technology-comparison-matrix-existing with Wasm and its scores as a new row.
It is visible, that Wasm performs great overall.
On the one hand it lacks performance and has slightly larger plugins in comparison to Notepad++ and VST3.
However both of these technologies use native machine code for execution, which achieves the optimal performance,because they do not require a runtime and thus no overhead is present.
While Wasm cannot take the first place for these criteria, it is able to outperform previous technologies in plugin isolation and portability while still acting as a universal compilation target.
In comparison to the plugin systems used by VS Code and all IntelliJ-based IDEs, Wasm provides severe advantages across all five criteria evaluated in this work.

What stands out the most are the exceptionally low scores for existing technologies for the plugin isolation criterion.
Most plugin systems do not provide any isolation, except for the plugin system of VS Code, which takes advantage of JavaScript's sandboxing capabilities to a certain degree.
Wasm however achieves a perfect score of 5 for plugin isolation with its execution sandboxed by default while only allowing explicitly exposed interfaces by the host.

// Other Wasm advantages/disadvantages? Component Model, WASI?

Overall Wasm performs very well compared to existing plugin system technologies.
This leads to the question, if Wasm is viable for plugin systems in practice.

== Related projects using WebAssembly plugin systems <related-wasm-projects>
This section presents noteworthy software projects, which have implemented a Wasm plugin system.
While Wasm itself acts as the fundamental technology to execute individual plugins similar to virtual machines,
in practice other choices regarding challenges such as interfacing must be made.
These challenges and issues might be be solved differently by various plugin system implementations.

*Zed*, a self-proclaimed "next-generation" text editor, uses a Wasm plugin system.
Plugins (officially called extensions) can add features in the form of languages, themes, icon themes, slash commands or context servers.
Zed plugins come in the form of Wasm components, taking advantage of the Wasm component model.
The main Zed text editor projects defines the plugin interface in the form of a WIT definition, as explained in @component-model.
Currently Zed also provides a small shim library for the Rust programming language.
This shim library contains a Rust trait (similar to interfaces in other programming languages) ```rs zed_extension_api::Extension```, which can be implemented to abstract away the WIT interface.
With this abstraction, plugin developers do not have to deal with Wasm-specific intricacies.
However if developers want to make use of Wasm's language interoperability, they must generate bindings adhering to the WIT definition themselves, as Zed only supports Rust as the only official plugin language@zed-docs.
// WIT definition #link("https://github.com/zed-industries/zed/blob/94faf9dd56c494d369513e885fe1e08a95256bd3/crates/extension_api/wit/since_v0.2.0/http-client.wit")

*ZelliJ* is an application similar to a terminal multiplexer.
It allows to split up one terminal instance into multiple panes or manage terminal sessions.
Similar commonly known terminal multiplexers are Tmux, xterm or the Windows Terminal.
ZelliJ features a Wasm plugin system, to allow accessible development of new features in various programming languages@zellij-docs.
The plugin system is also used by the ZelliJ project itself.
Some features such as a status bar, the about page or even the plugin manager itself are developed as plugins, which can be advantageous for developer accessibility and learning purposes.
For interfacing between the host application and Wasm plugins, ZelliJ uses Protobuf (#link("https://protobuf.dev/")).
Protobuf specifies a language-agnostic interface definition language not particularly for Wasm systems, as described in @wasm-challenges.
An interface definition can then be used to generate bindings for both the host application and Wasm plugins.
It also uses the WASI for abstraction of common system interfaces such as the filesystem or networking (see @wasi)@zellij-docs.

*Extism* is a generic library used to implement Wasm plugin systems in applications written in various languages.
It is originally written in Rust, but provides bindings in the form of so-called Host Software Development Kits (SDKs) for other host languages.
For plugins it provides so-called Plugin Development Kits (PDKs), which provide bindings to the common interface.
It uses a custom serialization format to pass data between hosts and Wasm plugins.
However users can build on top of this format by using other serialization libraries such as Protobuf or JSON@extism-docs.

== Results
Overall, WebAssembly performs at least as good as the four analyzed technologies in 3 of the 5 criteria.
It can achieve *perfect plugin isolation* through its sandboxing without complex dynamic interfaces at runtime, while some other plugin system technologies have no mechanism for isolation in place at all (IntelliJ-family, Notepad++, VST3) or provide just partial isolation (VS Code).
Wasm provides *very good plugin portability* comparable to the JavaScript-based plugin system of VS Code or the JVM-based plugin system of the IntelliJ-based IDEs.
This degree of portability is by design, as Wasm code must run in browsers on all architectures and platforms in a web context.
However Wasm's portability is not rated at a perfect score here, because host applications still have to provide a small Wasm runtime for execution.
Also Wasm achieves a *perfect plugin language interoperability*.
In theory it acts as a universal compilation target for various languages today, however language support is still rapidly evolving and improving over time.
Wasm allows various languages such as Rust, C, C++, etc. to be compiled directly to Wasm bytecode or programs written in higher-level interpreted languages such as Python to be embedded by distribution of an additional runtime for those languages.
In comparison, some other plugin system technologies evaluated in this technology comparison, namely VS Code and IntelliJ-based IDEs, limit plugins to a single language or a compilation target used only by a few languages such as JVM bytecode.
Other plugin systems such as Notepad++ or VST3 use native machine code, which acts as a universal compilation target, just as Wasm bytecode.

On the other hand, Wasm performs worse than other technologies for the performance and plugin size criteria.
Its achieves a *very good, but not optimal performance* at a score of 4.
The only two plugin system technologies are those of Notepad++ and VST3, which both use native code as their execution format.
While only native code can achieve perfect performance scores, Wasm's peak slowdowns in comparison to native code seem to be around single-digit factors, which still outperforms other plugin systems, namely VS Code and IntelliJ-based IDEs.
The scoring for Wasm's plugin size is similar to its performance scoring.
Wasm achieves average plugin sizes, slightly larger than native machine code, again varying only by single-digit factors.

Also some existing Wasm plugin system projects were presented briefly.
All projects use Wasm as their fundamental technology for code execution, however their technology choices for optimizations and interface are highly variable.
While some plugin systems take advantage of the evolving ecosystem around the Wasm Component Model and WASI specification, others rely on third-party serialization libraries such as Protobuf or even specify a completely custom Wasm plugin interface for users to build on top of.
