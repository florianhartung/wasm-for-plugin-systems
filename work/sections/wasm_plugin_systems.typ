#import "../wip.typ": todo, td

= WebAssembly for plugin systems (20 pages)
#todo[Present basic idea of running Wasm code for each plugin inside a Wasm runtime]

== Overview of basic plugin system architecture

== Evaluation of requirements


== Evaluation of interface-specific requirements
It is not possible to evaluate all requirements for WebAssembly.
WebAssembly as a technology is often too unrestrictive and thus the decision of whether a requirement is fulfilled often comes down to the host- and plugin-language and whether a common interface definition between them exists.

To illustrate this point, consider a scenario in which a host system is written in JavaScript.
When this host system wants to call a Wasm function it serializes the arguments, which might consist of complex JavaScript types, to JSON strings.
Then it passes these JSON strings to the Wasm plugin.
A plugin written in JavaScript itself will be able to easily parse the JSON string given to it, however a plugin written in C first has to get a system in place to parse and convert JavaScript types to equivalent C types.

#todo[Wasm interfacing is still an unsolved problem. There are many different solutions, of which some will be evalued separatly here]


#[
  #set heading(outlined: false)

  === WebAssembly without a standardized interface
  #td

  // WASM + Custom interface definition + Custom memory layout for complex types (e.g. string = null-terminated pointer vs. string = pointer + length)
  // Microsoft flight simulator does this I think? It also only supports C++ as a plugin language

  === WebAssembly + WebAssembly System Interface
  #td

  // WASM + WASI allows some std libraries to work (rust std, C++ stl)

  === WebAssembly + WebAssembly Component Model
  #td

  // WASM + WAT for common interface definition + automatic binding generation
  //   Zellij does this without binding generation

  === WebAssembly + WebAssembly System Interface + WebAssembly Component Model
  #td

  // WASM + WASI + WAT: there are predefined WAT files for WASI interfaces

  === WebAssembly + custom serialization format (JSON, XML, Protobuf)
  #td

  // WASM + serialization like Protobuf: Every communication goes through one exported Wasm function and one imported host function

]

== Summarized evaluation for WebAssembly
#todo[Show all WebAssembly configuration in a table with all requirements as columns]
