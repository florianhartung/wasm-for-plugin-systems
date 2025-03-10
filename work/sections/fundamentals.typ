#import "../wip.typ": todo, td

= Fundamentals (15 pages)
This section introduces theoretical and technical fundamentals used in this work.
// TODO are there any methodical fundamentals?

== Instruction set architectures
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
WebAssembly (Wasm) is a stack-based ISA for a portable, efficient and safe code format.
Originally it was designed by engineers from the four major vendors to enable high-performance code execution on the web @bringing-the-web-up-to-speed.
However it is also becoming increasingly interesting for researchers and developers in non-web contexts.
Some examples are avionics for Wasm's safe and deterministic execution @wasm-in-avionics, distributed computing for its portability and migratability @wasm-for-edge-computing or embedded  systems for its portability and safety @potential-of-wasm-for-embedded.

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
) <my_figure>
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
// However most compilers are still being actively worked on and improved over time.

=== Execution model
This section presents the Wasm execution model and lifecycle of a Wasm module.

#figure(image("../images/wasm_execution.svg"), caption: [Flowchart for the creation and execution of a Wasm module from a higher-level language]) <fig:wasm-execution-model>

@fig:wasm-execution-model shows the different stages a Wasm module goes through.
// Source code
The lifetime of a Wasm program starts with a developer writing source code.
This source code can be written in an arbitrary programming language such as C, C++ or Rust.
// Compiler
Then a compiler for that specific programming language creates a Wasm module.
Compiling to Wasm requires explicit support from the chosen compiler.
// LLVM makes things easy and enables a lot of compilers to easily compile to Wasm
- LLVM is used for a lot of projects
- What exactly is LLVM
- Example projects using LLVM
// *.wasm file
This Wasm module is fully self-contained in one singular `.wasm` file.
It consists of different sections, that contain functions with their instructions, data segments, import- and export definition, etc.
// TODO more details about sections

// Runtime environment
The previously generted Wasm module can then be transferred to any target device or platform.
In @fig:wasm-execution-model this device/platform is called the _runtime environment_.
// Wasm runtime
This runtime environment requires a Wasm runtime to be present.
The Wasm runtime is able to parse the Wasm module file, instantiate a _Wasm instance_ from it and provide an Application Programming Interface (API) for interaction with the Wasm instance.
APIs can differ from one Wasm runtime to another.
Some runtimes exist as standalone programs that can run Wasm modules comparable to how native binaries can be executes.
Others are in the form of libraries, that can only be used from a host application to embed a Wasm runtime into them.
// TODO name all important common interfaces for Wasm runtime libraries
These Wasm runtime libraries often provide common operations to the host application like calling Wasm functions, reading and writing operations for Wasm memories, linking mechanisms between Wasm modules, exposing host-defined functions for Wasm instances to call, etc.

// Example environment: web
In a web context a server might provide this Wasm module to the client's browser, which contains a Wasm runtime#footnote[Most modern browsers come with a Wasm runtime: See #link("https://caniuse.com/wasm") for detailed information.]
// Example environment: distributed nodes
For distributed computing this Wasm module could be distributed among multiple different nodes regardless of their architectures#footnote[This assumes that a Wasm runtime is available for those specific architectures. However here the system administrator could opt for different Wasm runtimes specifically tailored to each system. For example one might use an interpreter to avoid compilation complexity for compilers and JIT-compilation only on embedded devices.].
Those nodes could then perform heavy computations and split work between each other by communicating through conventional methods like HTTP.

=== Design goals
// The design goals are listed here, so they can be later referenced
// This section also contains related information, such as measurements, interesting proofs, etc. that verify that the design goals were really achieved

Wasm was designed with certain design goals in mind.
// TODO also prove some things like speed, small-binary-size, safety using third-party papers
This section presents the most relevant design goals as necessary for this work.
Each design goal is accompanied by related information from various papers and articles for a deeper understanding of each goal.

// However it turns out that most properties are generally desireable in non-web contexts too#footnote[e.g. portability and compactness for embedded systems @wasm-potential-embedded or portability, modularity and safety for distributed computing @wasm-potential-distributed ].

==== Fast <design_fast>
Wasm is designed to be fast both during startup and execution @spec.
// It is designed so its bytecode can be quickly read and parsed by a Wasm 

Startup time is optimized through the Wasm bytecode format.
Wasm's bytecode format is designed to make the runtime's work easier.

Why does Wasm provide fast startup time?
- Single-pass compiler, e.g. backwards jumps are disallowed (except for loops). Branches are referenced relativly by nesting depth per function.


This is done through a defined ordering of sections, e.g. by being parsable by a single-pass compiler

- Fast Runtime
    - Minimal set of opcodes
    - Parsable by a single-pass compiler: e.g. no backwards-jumps allowed (except loops), branches are referenced relativly by nesting depth per function (not absolutely with jumps to addresses)
#td

// - WASM bytecode can be execute in a number of different ways:
An additional property of Wasm bytecode is that it can be either compiled, interpreted or just-in-time compiled by a runtime.
This allows users to customize Wasm runtimes for their specific needs and usecases.
For example one could choose compilation to achieve faster execution at the cost of slow startup times due to compilation.
On the other end users might prefer interpretation where execution speeds are less of a priority and fast startup times or relocatable runtime instances (see @other_features) are needed.


==== Safe <design_safe>
- safe by default
- Sandboxed
    - Memory access is safe: Wasm is stack based & provides a linear memory, which can only be accessed through indices with bounds checks on every access.
    - Can only interact with host enviroment through functions that are explicitly exposed by the host
- Because of its simplicity: easier to implement a minimal working runtime than it is for higher level languages like C, C++, Java, Python, ...
    - This again reduces risk of (safety-critical) bugs
- Properties like portability and safety are especially important in the context of the web, where untrusted software from a foreign host is executed on a client's device.
- This makes WASM, a sandboxed and fast execution enviroment, interesting for safety-critical fields like avionics (#todo[ref?], automotive (#todo[ref] https://oxidos.io/), #todo[what else?]
- Note: Applications inside Wasm can still corrupt their own memory.
#td


==== Portable <design_portable>
// This includes goals: hardware-independent, platform-independent
Wasm is designed to be able to be portable for a lot of different hardwares and platforms.
- minimal set of opcodes (172), that exist on all architectures(#todo[insert screenshot of opcode table] (+ proposals for more additional instructions like SIMD, atomics, etc.)
#figure(todo[opcode table], caption: [All WebAssembly opcodes. Opcodes for proposals are encoded by specific marker bytes, which indicate that the following opcodes are to be interpreted as different instructions.])

Independence of hardware:
- Desktop architectures
- Mobile device architectures
- Embedded system architectures

Independece of platform:
- Browsers
- Other environments which only require some kind of a Wasm runtime

#td

==== Independence of language <design_independence_language>
Not designed for a specific language, programming model or object model@spec
- Should act as a compilation target for all kinds of higher-level machine languages
- Some Examples for languages that can be used at the time of writing are: #td

#td

==== Compact <design_compact>
Wasm bytecode representation format should be compact.
Smaller binary files are easier and faster to transmit especially in web contexts @spec.
Also smaller files can be loaded into memory faster at runtime, which might lead to a slightly faster execution overall, but this is more of a speculation.

#td

==== Modular <design_modular>
Programs consist of smaller modules, which allows modules to be "transmitted, cached and consumed separatly" @spec.

#td


==== Other features of WebAssembly <other_features>
This section lists some of Wasm's other noteworthy features.
These are not directly related to this work, however they provide a better overview over Wasm's potential usecases and applications.

// <design_well_defined>
- *Goal: Well-defined*: Wasm is designed in such a way that it is "easy to reason about informally and formally" @spec.
// <design_open>
- *Goal: Open*: #td
- *Goal: Efficient*: Wasm bytecode is efficient to read and parse, regardless of whether AOT or JIT compilation or interpretation is used at runtime @spec.
- *Goal: Parallelizable*: \
    Working with Wasm bytecode should be easily parallelizable.
    This applies to all steps: decoding, validation, compilation.
    This property allows for a faster startup time.
- *Goal: Streamable*: \
    This goal is especially important for the web.
    It should be possible to parse Wasm code while it is still being streamed/received.
    On the web data can be transferred in separate blocks called chunks.
    Wasm bytecode allows a Wasm runtime to decode, validate and compile a chunk before the full bytecode has arrived.
    This reduces startup time for Wasm applications especially on the web.
- *Determinism*: Indeterminism has only 3 sources: host functions, float NaNs, growing memory/tables
- *Backwards-compatibility*: #td

// TODO: consider this property for non-web contexts
// In non-web contexts this property might be used by Wasm runtimes to read and parse a Wasm file sequentially
#td

#td
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


// Missing
// WASM is formally specified with no "loopholes"


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
