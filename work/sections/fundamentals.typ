#import "../wip.typ": todo

= Fundamentals
This section introduces technical fundamentals for some technologies in this work.
// Separation between theoretical, technical, methodical

== Instruction set architectures
// Basics of structed computer organization
In the field of structured computer organization Tanenbaum defines the instruction set architecture (ISA) as a level in a multilayered computer system @tanenbaum-structured.
The ISA level defines a machine language (also sometimes referred to as machine code) with a fixed set of instructions @tanenbaum-structured.
According to Tanenbaum the ISA level then acts as a common interface between the hardware and software.
This allows software in the form of ISA instructions to manipulate the hardware @tanenbaum-structured.
Software written in a higher level machine language (Assembly, C, Java, ...) can not be executed directly by the hardware.
Instead higher level machine codes are compiled to ISA machine code or interpreted by a program, that is present in ISA machine code itself @tanenbaum-structured.

== WebAssembly
// (virtual) instruction set architecture?
WebAssembly (Wasm) is virtual ISA for a portable, time- and space-efficient code format @spec. // WTF? remove space before @
According to its specification it designed mostly for code execution on the Web, however it is not limited to the Web as an environement by design.

// Wasm as virtual ISA
Even though one could design specific hardware that executes the WebAssembly ISA directly, this usually is not the case#footnote[There are a couple toy projects which tried to execute Wasm directly, for example the discontinued `wasmachine` project with FPGAs.].
Instead WebAssembly calls itself a _virtual_ ISA @spec.
There is no common definition for a virtual ISA, however the term _virtual_ can be assumed to refer to an ISA that is running in a virtualized environment on a higher level in a multilevel computer.
We call this virtualized environemnt the *host environment* (used by the specification) or the *WebAssembly runtime* (used by most technical documentation).

// Wasm is too simple
WebAssembly code can be written by hand, just as one could write ISA instructions (think of writing x86 machine code) by hand.
Even though it is possible, it would not be efficient to write useful software in Wasm because the language is too simple.
For example it provides only a handful of types: 1. Signed and unsigned integers, 2. floating point numbers, 3. a 128-bit vectorized number, 4. references to functions or 5. to host objects.

// Wasm is a compilation target
WebAssembly also does not provide any way to specify memory layouts as it can be done in higher-level languages with structs, classes, records, etc.
This is by design, as WebAssembly acts more as a compilation target for higher level languages@spec.
Those higher level languages can then build upon Wasms basic types and implement their own memory layouts on top.
This is analogous to the non-virtual ISA machine code in a conventional computer, which also acts as a compilation target for most low-level languages such as Assembly, C, or Rust.
Most of these compiled languages like C, C++, Rust, Zig or even Haskell can be compiled to WebAssembly moderatly easily nowadays#footnote[#todo provide examples for compilers that can target Wasm].
However most compilers are still being actively worked on and improved over time to support not only the basic WebAssembly specification but also extensions such as the Wasm Systems Interface and the Wasm Component Model, which are covered in @wasm_component_model and @wasi respectively.

// What makes WASM unique?
Java bytecode is very similar to Wasm:
- Both define a virtual ISA
- Wasm is sandboxed by default, JVMs allow restrictions through a ```SecurityManager```#footnote[#link("https://docs.oracle.com/javase/tutorial/essential/environment/security.html")]
- Wasm is optimized to be parsed and compiled quickly. It allows for parsing/compilation to start while the bytecode is still being streamed/downloaded.
- Java uses GC, which may not be useful in time-critical software #todo[cite java usage in avionics]
- Wasm's machine language is more minimal and simpler, it thus is easier to compile a lot of languages to Wasm #todo[provide numbers for number of ops]

Wasm is designed with specific goals specifically suited for the web and efficiency in mind.

They include fast execution, 
- Designed with specific goals in mind: ...
    - Fast Runtime:
        - Parsable by a single-pass compiler: e.g. no backwards-jumps allowed (except loops), branches are referenced relativly and not absolutely (like jumps and addresses)
        - Minimal translation of opcodes: small set of basic opcodes, that exist on most architectures(#todo[insert screenshot of opcode table] (+ proposals for more additional instructions like SIMD, atomics, etc.)
        - Fast startup time (especially web): Runtime can start parsing a WebAssembly module that is still being downloaded
    - portable across architectures: Compilation target for higher level languages like C, C++, Rust#footnote[In theory it can also contain other languages that require a runtime such as JS, Python] which is independant of the target systems' architecture.
    - safe by default in sandbox
- WASM bytecode execute by WASM RT: AOT, JIT, interpreted
- Because of its simplicity: easier to implement a minimal working runtime than it is for higher level languages like C, C++, Java, Python, ...
    - This again reduces risk of (safety-critical) bugs

// When was WASM made?
#todo[source for 1.0 and date]
- made for the web with 1.0 release in 2019 
- no assumptions about execution enviroment are made
    - There are APIs for the web specifically (Javascript Embedding, Web Embedding)
    - This makes WASM, a sandboxed and fast execution enviroment, interesting for safety-critical fields like avionics (#todo[ref?], automotive (#todo[ref] https://oxidos.io/), #todo[what else?]
- Originally designed as: fast, safe, low-level bytecode for the web
- History and today's usage of WebAssembly

// What makes WASM unique?

// - Backwards-compatibility
Backwards compatibility: Bytecode compiled with previous compilers will always be valid.
- Examples:
    - Placeholders opcodes
    - Only one memory per module allowed, yet a memory index of 0 has to be included for some opcodes.
- New features go though 5 stages in their proposal process, before they are added to the specification. This allows for testing and for runtimes to implement proposals before they are standardized

#todo[Maybe include current browser support for stage 5 proposals from https://webassembly.org/features/]


// WASM in the web
SOURCES: https://webassembly.org/docs/use-cases/, researched projects
- HPC inside the browser: Simulations, etc. #todo
- Frontends written in compiled languages like C, C++, Rust (Leptos) by using frameworks. This still uses JS as a shim to access the DOM.

// WASM outside of the web
- Run untrusted code (TEXT EDITORS!! Plugins *do not* require complete access to FS, Network, etc.)
- Distributed systems where many nodes work together on a single computation. No Containerisation, Virtualization necessary. (Although WASM RT could be seen as a form of containerisation)
- Distributed systems: microservices, distributed computing

// Current important proposals
#todo[List most important proposals and why they are limiting factors for big projects]

// WASM type system is too simple for complex interfaces between WASM-host or WASM-WASM interfaces. It does not even have strings or pointer types.
#todo[List all types here and show how a complex C type could be represented as a WASM type]
Here it must also be clear that it is completely language and compiler dependent how high level types are represented in the compiled WASM bytecode with its simple types.
Here it becomes clear again that WASM only provides a very minimal execution environment and leaves all the responsibility and optimizations to compilers, very similar to tranditional assembly/machine code.

// What are problems with WASM and how are they solved? (common interface definitions: WASI, WASM component model, ...?)
- Interfaces
    - WASM #sym.arrow.l.r Environment:
        By default a WASM module cannot access its environment.
        It may export functions and import functions, provided by the host system through the WASM runtime.
        How to design a common interface that works for all WASM modules (regardless of their origin/compiler/language) and all hosts and runtimes?
        Examples: Accessing a filesystem, Sending and receiving requests over a network.
    - WASM #sym.arrow.l.r WASM:
        How can two WASM modules, which may have been compiled by different compilers from different languages (Any combination of C, Rust, C++, JS, Python, ...), communicate even though they have completely different memory layouts or one might even use GC? All languages allow for complex types made up of WASMs rather minimal type system
        Examples: Two WASM modules implement features, for example an efficient library for performing calculations in Rust and a Python module that uses that library and stores the results in a provided filesystem.


=== WebAssembly System Interface (WASI) <wasi>
// References: WASI Spec

=== WebAssembly Component Model <wasm_component_model>
// References: Design documents for component model (no spec yet)

- language-agnostic interfaces
- WebAssembly Interface Type (WIT) specification
- bindings can be generated for a lot of languages from a WIT definition

== Plugin systems
- What are plugin systems?
- Why are plugin systems important?
- Where are plugin systems used?

== Rust
- Short explaination of why Rust is used for this project:
- The text editor, for which a plugin system will be implemented as a proof of concept is written in Rust.
- However this work is not about any technology in particular, and instead it will focus more on WebAssembly, which may be used from pretty much any language where a runtime exists.
The text editor probably uses Rust for safety and performance reasons.
