#import "../wip.typ": todo, td

= Fundamentals (15 pages)
This section introduces theoretical and technical fundamentals used in this work.
// TODO are there any methodical fundamentals?

== Instrucion set architectures
In the field of structured computer organization Tanenbaum defines a instruction set architecture (ISA) as a level in a multilayered computer system @tanenbaum-structured.
The ISA level defines a machine language with a fixed set of instructions @tanenbaum-structured.
According to Tanenbaum the ISA level then acts as a common interface between the hardware and software.
This allows software in the form of ISA instructions to manipulate the hardware @tanenbaum-structured.
Software written in a higher level machine language (Assembly, C, Java, ...) can not be executed directly by the hardware.
Instead higher level machine codes are compiled to ISA machine code or interpreted by a program, that is present in ISA machine code itself @tanenbaum-structured.

== WebAssembly
=== Overview
// Missing:
// Wasm is stack-based, provides separate linear memory addressable by indices only (no pointers!) and per-function local types.
// Types on the stack are checked statically.
// Bounds are checked on every memory-access.

// Wasm as virtual ISA
WebAssembly (Wasm) is an ISA for a portable, time- and space-efficient code format, designed for but not limited to the web@spec.
In the web it is used to execute code on a Wasm runtime, that is usually shipped with the client's internet browser.

// When was WASM made?
// #todo[source for 1.0 and date]
// - made for the web with 1.0 release in 2019 
// - no assumptions about execution enviroment are made
//     - There are APIs for the web specifically (Javascript Embedding, Web Embedding)

What is special about Wasm is that it is a _virtual_ ISA @spec.
There is no agreed-upon definition for a virtual ISA, however the term _virtual_ can be assumed to refer to an ISA that is running in a virtualized environment on a higher level in a multilevel computer#footnote[There are a couple toy projects which have tried to execute Wasm directly. One example is the discontinued `wasmachine` project, which tried to execute Wasm on FPGAs.].
We call this virtualized environment the *host environment* (used by the specification) or the *WebAssembly runtime* (used by most technical documentation).

#figure(
    table(columns: (auto,),
        [WebAssembly code],
        [WebAssembly runtime],
        [Problem-oriented language level],
        [Assembly language level],
        [Operating system machine level],
        [Instrucion set architecture level],
        [Microarchitecture level],
        [Digial logic level],
    ),
    caption: [#todo[This figure needs annotations for compilation/interpretation and level numbers]. A multilevel computer system running Wasm code. Inspired by Figure 1-2 in @tanenbaum-structured]
)
#todo[Descripe Wasm in a multilevel computer system with a figure and give examples for levels]
// In a multilevel computer system the Wasm runtime, which is written in a level
// The task of the Wasm runtime is to translate the Wasm code given to it into machine-specific ISA either through interpretation or compilation.

// Wasm is very simple
WebAssembly code can be written by hand, just as one could write traditional ISA instructions (think of writing x86 machine code) by hand.
Even though it is possible, it would not be efficient to write useful software systems in Wasm because the language is too simple.
For example it provides only a handful of types#footnote[Signed/unsigned integers, floating point numbers, a 128-bit vectorized number and references to functions/ host objects].

// Wasm is a compilation target
WebAssembly also does not provide any way to specify memory layouts as it can be done in higher-level languages with structs, classes, records, etc.
Instead it provides most basic features and instructions, which exist on almost all modern computer architectures like integer and floating point arithmetic, memory operations or simple control flow constructs.
This is by design, as WebAssembly is mor of a compilation target for higher level languages@spec.
Those higher level languages can then build upon Wasms basic types and instructions and implement their own abstractions like memory layouts or control flow constructs on top.
This is analogous to the non-virtual ISA machine code in a conventional computer, which also acts as a compilation target for most low-level languages such as Assembly, C, or Rust.
Most of these compiled languages like C, C++, Rust, Zig or even Haskell can be compiled to WebAssembly moderatly easily nowadays#footnote[#todo[provide examples for compilers that can target Wasm]].
However most compilers are still being actively worked on and improved over time.

=== Design goals
// The design goals are listed here, so they can be later referenced
// This section also contains related information, such as measurements, interesting proofs, etc. that verify that the design goals were really achieved

Wasm was designed with certain design goals in mind.
// TODO also prove some things like speed, small-binary-size, safety using third-party papers
This section presents the design goals according to the specification @spec.
Each design goal is accompanied by related information from various papers and articles for a deeper understanding of each goal.

Some of these design goals are specific to the web, most notably @design_streamable or @design_compact.
However it turns out that most properties are generally desireable in non-web contexts too#footnote[e.g. portability and compactness for embedded systems @wasm-potential-embedded or portability, modularity and safety for distributed computing @wasm-potential-distributed ].
// Examples for non-web contexts are embedded systems @wasm-potential-embedded or distributed computing @wasm-potential-distributed.

==== Fast <design_fast>
- Fast Runtime
    - Parsable by a single-pass compiler: e.g. no backwards-jumps allowed (except loops), branches are referenced relativly and not absolutely (like jumps and addresses)
    - Minimal translation of opcodes: small set of basic opcodes, that exist on most architectures(#todo[insert screenshot of opcode table] (+ proposals for more additional instructions like SIMD, atomics, etc.)
    - Fast startup time (especially web): Runtime can start parsing a WebAssembly module that is still being downloaded. Goes hand in hand with @design_streamable
- WASM bytecode execute by WASM RT: AOT, JIT, interpreted
    - RT can switch between fast execution (AOT, JIT) or fast startup time (interpreted)

#td

==== Safe <design_safe>
- safe by default in sandbox
- Sandboxed
    - Memory access is safe: Wasm is stack based & provides a linear memory, which can only be accessed through indices with bounds checks on every access.
    - Can only interact with host enviroment through functions that are explicitly exposed by the host
- Because of its simplicity: easier to implement a minimal working runtime than it is for higher level languages like C, C++, Java, Python, ...
    - This again reduces risk of (safety-critical) bugs
- Properties like portability and safety are especially important in the context of the web, where untrusted software from a foreign host is executed on a client's device.
- This makes WASM, a sandboxed and fast execution enviroment, interesting for safety-critical fields like avionics (#todo[ref?], automotive (#todo[ref] https://oxidos.io/), #todo[what else?]
#td

==== Well-defined <design_well_defined>
#td

==== Independence of hardware, language and platform <design_independence>
#td

==== Open <design_open>
#td

==== Compact <design_compact>
#td

==== Modular <design_modular>
#td

==== Efficient <design_efficient>
#td

==== Streamable <design_streamable>
#td

==== Parallelizable <design_parallelizable>
#td

==== Portable <design_portable>
- portable across architectures: Compilation target for higher level languages like C, C++, Rust
- embedding higher-level languages such as Python or JavaScript is also possible. In this case their runtimes are compiled to Wasm and shipped with the main Python/JS application.
#td

==== Other noteworthy features
- *Determinism*: Indeterminism has only 3 sources: host functions, float NaNs, growing memory/tables
- *Backwards-compatibility*: #td
    // Wasm is also designed with backwards compatibility in mind.
    // This is especially important on the web, where Wasm bytecode, that was compiled with a previous compiler, still has to be able to run in newer Wasm runtimes.
    // To minimize technical debt due to backwards compatibility, a standardization process for new feature proposals is employed.
    // During this process a proposal has to go through multiple stages.
    // In those stages the feature has to be added to the specification, implemented by Wasm runtimes and is will only then be standardized if all criteria are met#footnote[See #link("https://github.com/WebAssembly/meetings/blob/main/process/phases.md") for the full standardization process.].
    // #todo[Maybe include examples for proposals. Maybe also show https://webassembly.org/features/]
    // Backwards compatibility: Bytecode compiled with previous compilers will always be valid.
    // - Examples:
    //     - Placeholders opcodes
    //     - Only one memory per module allowed, yet a memory index of 0 has to be included for some opcodes.
    // - New features go though 5 stages in their proposal process, before they are added to the specification. This allows for testing and for runtimes to implement proposals before they are standardized
- *Migratability/Relocatability*: Running Wasm instances can be serialized and migrated to another computer system. However for this to be easy the Wasm runtime should only execute Wasm code through interpretation.




=== Challenges & Limitations
// Challenges with Wasm in non-web contexts
This section deals with common challenges and limitations of Wasm in non-web contexts.

// WASM type system is too simple for complex interfaces between WASM-host or WASM-WASM interfaces. It does not even have strings or pointer types.
// #todo[List all types here and show how a complex C type could be represented as a WASM type]
// Here it must also be clear that it is completely language and compiler dependent how high level types are represented in the compiled WASM bytecode with its simple types.
// Here it becomes clear again that WASM only provides a very minimal execution environment and leaves all the responsibility and optimizations to compilers, very similar to tranditional assembly/machine code.
// How can a host provide large binary data objects to a Wasm module? It cannot write to the modules memory, so it would have to call the module's allocator first and then copy data into the allocated memory chunk.

#td
// - Interfaces
//     - WASM #sym.arrow.l.r Environment:
//         By default a WASM module cannot access its environment.
//         It may export functions and import functions, provided by the host system through the WASM runtime.
//         How to design a common interface that works for all WASM modules (regardless of their origin/compiler/language) and all hosts and runtimes?
//         Examples: Accessing a filesystem, Sending and receiving requests over a network.
//     - WASM #sym.arrow.l.r WASM:
//         How can two WASM modules, which may have been compiled by different compilers from different languages (Any combination of C, Rust, C++, JS, Python, ...), communicate even though they have completely different memory layouts or one might even use GC? All languages allow for complex types made up of WASMs rather minimal type system
//         Examples: Two WASM modules implement features, for example an efficient library for performing calculations in Rust and a Python module that uses that library and stores the results in a provided filesystem.




=== WebAssembly System Interface (WASI) <wasi>
// References: WASI Spec

// The WebAssembly System Interface (WASI) is a common interface definition for common functionalities that may be provided by a host.
// These can be simple such as random number generation or more complex like filesystem access or networking.
// Show current progress

#td

=== WebAssembly Component Model <wasm_component_model>
// References: Design documents for component model (no spec yet)

#td

// - language-agnostic interfaces
// - WebAssembly Interface Type (WIT) specification
// - bindings can be generated for a lot of languages from a WIT definition
// Show current progress

== Plugin systems

#td

// - What are plugin systems?
// - Why are plugin systems important?
// - Where are plugin systems used?

== Rust
#todo[Is a Rust section necessary?]

// - Short explaination of why Rust is used for this project:
// - The text editor, for which a plugin system will be implemented as a proof of concept is written in Rust.
// - However this work is not about any technology in particular, and instead it will focus more on WebAssembly, which may be used from pretty much any language where a runtime exists.
// The text editor probably uses Rust for safety and performance reasons.
