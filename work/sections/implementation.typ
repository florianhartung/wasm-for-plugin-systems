#import "../wip.typ": todo, td

= Proof of concept: Implementing a WebAssembly plugin system for a text editor
The first part of this work did a technology comparison to find out if Wasm is feasible as a technology for plugin systems.
In this second part, a basic proof of concept for a Wasm plugin system will be implemented for a text editor.
To make this process as realistic as possible, to learn as much as possible from this implementation, a text editor that is already being used today by developers will be used.

The text editor chosen is the Helix editor (#link("https://helix-editor.com/")).
It is a terminal-based text editor written in Rust with controls similar to Vim, however it provides more features out of the box.
Currently the Helix editor is missing an official plugin system, although there are some community-driven projects trying to implement plugin systems.

== Requirements
#todo[Weight the requirements for plugin systems and optionally add new requirements for this project]

// Plugins
- Plugins shall contain metadata such as a name, version and description.
- Plugins shall be fully self-contained WASM files
    - for simplicity
    - to see if WASM can hold metadata
- Plugins are loaded at startup of the editor

// Main editor <-> plugin interaction
- Plugins shall be able to modify the core editor state / call functions of the core editor
    - 2-3 interface functions suffice
        - log
        - set_status
        - insert char at current cursor location
- Plugins shall support event hooks for: key presses, startup, saving of buffers

// Security
- Plugins shall not be able to access any other interfaces

// Non-requirements
- Complex interfaces such as GUIs due to time-constraints
- WASI for System calls
- Extensive Unit-Testing


== System Architecture

- Component Model
- Wasmtime as the official Wasm runtime with good component model support

- (Allows WASI in future)

#todo[Choose appropriate Wasm technologies based on the previous findings and document how they are used together to build a working system]

== Implementation
#todo[Give brief overview over code structure] 
#todo[Technical challenges and how they were addressed]
#todo[What optimizations were made?]

== Evaluation
#todo[Reevaluate the key requirements for plugin systems]
#todo[Provide measurements for memory/performance impact (there are no real reference points)]
#todo[Summarize findings & challenges]

// Standard plugin definieren (z.b. textsuche für performance)
// Graph mit x geladenen Standard plugins für memory/performance