#import "../wip.typ": todo, td

= Fundamentals
This section introduces theoretical and technical fundamentals used in this work.
First it covers the definition of an instruction set architecture.
Then it gives an overview over WebAssembly, its features, challenges, limitations and extensions.
Finally, plugin systems are explained as a software architecture model.

== Instruction set architectures
In his book "Structured Computer Organization" Tanenbaum defines an instruction set architecture (ISA) as a level in a multilayered computer system@tanenbaum-structured[sec.~1.1.2].
The ISA level defines a machine language with a fixed set of instructions.
According to Tanenbaum the ISA level then acts as a common interface between the hardware and software.
This allows software in the form of ISA instructions to manipulate the hardware.
Software written in a higher level machine language (Assembly, C, Java, ...) can not be executed directly by the hardware.
Instead higher level machine codes are compiled to ISA machine code or interpreted by a program, that is present in ISA machine code itself @tanenbaum-structured[sec.~1.1.2].

#todo[move @multi-level-wasm here and explain basics of multi-level systems here separately]

// TODO Move ISA figure here and only lightly explain it later.

== WebAssembly
=== Overview
// TODO Information missing?
// Wasm is stack-based, provides separate linear memory addressable by indices only (no pointers!) and per-function local types.
// Types on the stack are checked statically.
// Bounds are checked on every memory-access.

// Wasm as virtual ISA
WebAssembly (Wasm) is a stack-based ISA for a portable, efficient and safe code format.
Originally it was designed by engineers from the four major vendors to enable high-performance code execution on the web @bringing-the-web-up-to-speed.
However it is also becoming increasingly interesting for researchers and developers in non-web contexts.
Some examples are avionics for Wasm's safe and deterministic execution @wasm-in-avionics, distributed computing for its portability and migratability @wasm-for-edge-computing or embedded  systems for its portability and safety @potential-of-wasm-for-embedded.

// TODO When was WASM made?

What is special about Wasm is that it is a _virtual_ ISA @spec[sec.~1.1.2].
There is no agreed-upon definition for a virtual ISA, however the term _virtual_ can be assumed to refer to an ISA that is running in a virtualized environment on a higher level in a multilevel computer#footnote[Projects that try to execute Wasm directly exist. One example is the discontinued `wasmachine` project, which tried executing Wasm on FPGAs: #link("https://github.com/piranna/wasmachine")].
We call this virtualized environment the *host environment* (used by the specification@spec[sec.~1.2.1]) or the *WebAssembly runtime* (used by most technical documentation).

#figure(table(columns: (auto, auto),
        [WebAssembly code], table.cell(stroke: none, []),
        [WebAssembly runtime], table.cell(rowspan: 7, rotate(-90deg, reflow: true)[Wasm runtime environment]),
        [Problem-oriented language level],
        [Assembly language level],
        [Operating system machine level],
        [Instruction set architecture level],
        [Microarchitecture level],
        [Digital logic level],
    ),
    caption: [#todo[This figure still needs some improvements]. A multilevel computer system running Wasm code. Based on Figure 1-2 in @tanenbaum-structured],
    kind: image,
) <multi-level-wasm>

// Multi-level computer and the wasm environment
If one considers a system running Wasm code as a multi-level computer system, the Wasm runtime can be modeled as a separate layer.
@multi-level-wasm shows a multi-level computer system based on Tanenbaum's model @tanenbaum-structured[sec.~1.1.2].
Here each level is executed by logic implemented in the next lower level either through compilation or interpretation.
The digital logic level itself only exists in the form of individual gates, consisting of transistors and tracks on the processors' chip.
This level runs the next microarchitecture and ISA levels, which are also often implemented directly in hardware.
The ISA level then provides a fixed set of instructions for higher levels to use.
Operating systems build on top of this and provide another level for user space programs, which exist on the assembly language level.
Then there are problem-oriented languages such as C, #box[C++] or Rust, which are specifically made for humans to write code in@tanenbaum-structured[sec.~1.1.2].

One program written in a problem-oriented language is the Wasm runtime, which itself is a layer here.
Its task it to interpret or compile higher-level Wasm code to lower-level problem-oriented or even the assembly language level.
However for this work all layers starting with the Wasm runtime level until the digital logic level can be seen as a single hardware specific layer called the _Wasm runtime environment_.

// Wasm is very simple
WebAssembly code can be written by hand, just as one could write traditional ISA instructions (think of writing x86 machine code) by hand.
Even though it is possible, it would not be efficient to write useful software systems in Wasm because the language is too simple.
For example it provides only a handful of types: Signed/unsigned integers, floating point numbers, a 128-bit vectorized number and references to functions/ host objects.

// Wasm is a compilation target
WebAssembly also does not provide any way to specify memory layouts as it can be done in higher-level languages with structs, classes, records, etc.
Instead it provides most basic features and instructions, which exist on almost all modern computer architectures like integer and floating point arithmetic, memory operations or simple control flow constructs.
This is by design, as WebAssembly is more of a compilation target for higher level languages#footnote[#link("https://webassembly.org/")].
Those higher level languages can then build upon Wasm's basic types and instructions and implement their own abstractions like memory layouts or control flow constructs on top.
This is analogous to the non-virtual ISA machine code in a conventional computer, which also acts as a compilation target for most low-level languages such as Assembly, C, or Rust.
Nowadays there are compilers for most popular languages already.
Some of which are `clang` for C/C++, `rustc` for Rust or the official Zig and Haskell compilers.
However most compilers are still being actively worked on and improved over time to support the latest Wasm proposals.

=== Execution model and lifecycle
#figure(
    image("../images/wasm_execution.svg"),
    caption: [
        Flowchart for the creation and execution of a Wasm module from a higher-level language
        #todo[This figure is still too compilated]
        // Show 2 variants?: Wasm Runtime as CLI or library
    ]
) <fig:wasm-execution-model>

@fig:wasm-execution-model shows the different stages a Wasm module goes through in its lifecycle.
// Source code
Its lifecycle starts with a developer writing source code.
This source code can be written in an arbitrary programming language such as C, C++ or Rust.
These languages are often used because they have compilers that support Wasm.
// Compiler
The compiler then compiles this source code to a _Wasm module_.
This step requires a compiler that support Wasm as a compilation target.
// LLVM makes things easy
Many modern compilers such as `clang` or `rustc` use the LLVM#footnote[According to its official website the acronym _LLVM_ was once short for _Low Level Virtual Machine_, however now it has "grown to be an umbrella project" referred to simply as the LLVM project. #link("https://llvm.org/")] project for optimization and code generation.
These compilers compile source code to LLVM's intermediate representation (LLVM IR) and pass this to LLVM.
LLVM can then perform optimizations and compile this IR to any compilation target, which can be selected by choosing a LLVM backend.
One such LLVM backend targets Wasm.
This way the Wasm-specific compiler logic can be implemented once within LLVM, and any compiler using LLVM can then target Wasm with minimal additional effort.

// *.wasm file
The compiled Wasm module exists in the form of a `.wasm` file.
It is fully self-contained and unlike binaries it cannot depend on any dynamic libraries at runtime.
It consists of different ordered sections, each with their own purpose: Some example sections contain function signatures, data segments, import- and export definition or actual Wasm instructions for each function.
// TODO more details about sections?

// Runtime environment
The previously generated Wasm module can then be transferred to any target device or platform providing a Wasm runtime.
// Wasm runtime
That specific Wasm runtime is hardware-specific and not portable, unlike the Wasm module.
The Wasm runtime is able to parse the received Wasm module file, instantiate a _Wasm instance_ from it and provide an Application Programming Interface (API) for interaction with the Wasm instance.
APIs can differ from one Wasm runtime to another.
Some runtimes exist as standalone programs that can run Wasm modules comparable to how native binaries can be executed.
Others are in the form of libraries, that can only be used from a host application to embed a Wasm runtime into them.
// Wasm runtime library interfacing
These Wasm runtime libraries often provide common operations to the host application like calling Wasm functions, reading and writing operations for Wasm memories, linking mechanisms between Wasm modules, exposing host-defined functions for Wasm instances to call, etc.
// TODO name all important common interfaces for Wasm runtime libraries

// Web (example)
In a web context a server might provide this Wasm module to the client's browser, which usually comes with a Wasm runtime.
Detailed information on the current status of Wasm support for internet browsers can be viewed at #link("https://caniuse.com/wasm").
A concrete example is Ebay using Wasm for their barcode scanner algorithm to achieve higher performance#footnote(link("https://innovation.ebayinc.com/tech/engineering/webassembly-at-ebay-a-real-world-use-case/")).

// Distributed computing and serverless (example)
For distributed computing a compiled Wasm module could be distributed among multiple different nodes regardless of their platform and architecture... #td
// TODO also include serverless aspect, which might become very important in the future
// TODO only requirement is wasm runtime 
// TODO name multiple examples: wasmedge, fermyon spin

=== Design goals
// The design goals are listed here, so they can be later referenced
// This section also contains related information, such as measurements, interesting proofs, etc. that verify that the design goals were really achieved

Wasm was designed with certain design goals in mind.
This section presents the design goals relevant for this work according to the official Wasm specification @spec[sec.~1.1.1].
Each design goal is accompanied by related information from various papers and articles for a deeper understanding of each goal.

==== Fast <design_fast>
Wasm is designed to be fast both during startup and execution @spec[sec.~1.1.1].
// It is designed so its bytecode can be quickly read and parsed by a Wasm 
Startup time is mostly optimized through the structure of the Wasm bytecode format, which is optimized for fast parsing and compiling of Wasm code.
A Wasm module in its binary format consists of 11 different sections
#footnote[This section count excludes custom sections, which are optional and may only add additional information on top, such as debug information.]
that may only show up in a fixed order.
Another example is the absence of backwards jump (except for the `loop` statement), which allows the use of faster one-pass compilers.
// TODO Why is are one-pass compilers better?

During runtime Wasm can also achieve near-native performances... #td

// - Fast Runtime
    // - Minimal set of opcodes
    // - Parsable by a single-pass compiler: e.g. no backwards-jumps allowed (except loops), branches are referenced relatively by nesting depth per function (not absolutely with jumps to addresses)

// - WASM bytecode can be execute in a number of different ways:
An additional property of Wasm bytecode is that it can be either compiled, interpreted or just-in-time compiled by a runtime.
This allows users to customize Wasm runtimes for their specific needs and use cases.
For example one could choose compilation to achieve faster execution at the cost of slow startup times due to compilation.
On the other end users might prefer interpretation where execution speeds are less of a priority and fast startup times or relocatable runtime instances (see @other_features) are needed.

==== Safe <design_safe>
#todo[
    - safe by default
    - sandboxed
        - Memory access is safe: Wasm is stack based & provides a linear memory, which can only be accessed through indices with bounds checks on every access.
        - Can only interact with host environment through functions that are explicitly exposed by the host
    - Because of its simplicity: easier to implement a minimal working runtime than it is for higher level languages like C, C++, Java, Python, ...
        - This again reduces risk of (safety-critical) bugs
    - Properties like portability and safety are especially important in the context of the web, where untrusted software from a foreign host is executed on a client's device.
    - This makes WASM, a sandboxed and fast execution environment, interesting for safety-critical fields like avionics (#todo[ref?], automotive (#todo[ref] https://oxidos.io/), #todo[what else?]
    - Note: Applications inside Wasm can still corrupt their own memory.
]


==== Portable <design_portable>
// This includes goals: hardware-independent, platform-independent
Wasm is designed to be able to be portable for a lot of different hardwares and platforms.

#todo[
    - minimal set of opcodes (172), that exist on all architectures(#todo[insert screenshot of opcode table] (+ proposals for more additional instructions like SIMD, atomics, etc.)
    #figure(todo[opcode table], caption: [All WebAssembly opcodes. Opcodes for proposals are encoded by specific marker bytes, which indicate that the following opcodes are to be interpreted as different instructions.])

    Independence of hardware:
    - Desktop architectures
    - Mobile device architectures
    - Embedded system architectures

    Independence of platform:
    - Browsers
    - Other environments which only require some kind of a Wasm runtime
]

==== Independence of language <design_independence_language>
#todo[
    - Not designed for a specific language, programming model or object model@spec[sec.~1.1.1]
    - Should act as a compilation target for all kinds of higher-level machine languages
    - Some Examples for languages that can be used at the time of writing are: #td
]

==== Compact <design_compact>
#todo[
    - Wasm bytecode representation format should be compact.
    - Smaller binary files are easier and faster to transmit especially in web contexts @spec.
    - Also smaller files can be loaded into memory faster at runtime, which might lead to a slightly faster execution overall, but this is more of a speculation.
]

==== Modular <design_modular>
#todo[
    - Programs consist of smaller modules, which allows modules to be "transmitted, cached and consumed separably"
    - Modules can also be combined/linked together at runtime
]


==== Other features <other_features>
This section lists some other noteworthy features of Wasm.
These are not directly related to this work, however they provide a better overview over Wasm's potential use cases and applications.

- *Well-defined*: #todo[Wasm is designed in such a way that it is "easy to reason about informally and formally" @spec[sec.~1.1.1].]
- *Open*: #td
- *Efficient*: #todo[Wasm bytecode is efficient to read and parse, regardless of whether AOT or Just-in-time (JIT) compilation or interpretation is used at runtime @spec.]
- *Parallelizable*: #todo[
        Working with Wasm bytecode should be easily parallelizable.
        This applies to all steps: decoding, validation, compilation.
        This property allows for a faster startup time.
    ]
- *Streamable*: #todo[
        This goal is especially important for the web.
        It should be possible to parse Wasm code while it is still being streamed/received.
        On the web data can be transferred in separate blocks called chunks.
        Wasm bytecode allows a Wasm runtime to decode, validate and compile a chunk before the full bytecode has arrived.
        This reduces startup time for Wasm applications especially on the web.
    ]
- *Determinism*: #todo[Indeterminism has only 3 sources: host functions, float NaNs, growing memory/tables]
- *Backwards-compatibility*: #td
    // TODO: consider this property for non-web contexts
    // In non-web contexts this property might be used by Wasm runtimes to read and parse a Wasm file sequentially
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
- *Migratability/Relocatability*: #todo[Running Wasm instances can be serialized and migrated to another computer system. However for this to be easy the Wasm runtime should only execute Wasm code through interpretation.]


// Missing
// WASM is formally specified with no "loopholes"


=== Challenges & Limitations
// Challenges with Wasm in non-web contexts
This section deals with common challenges and limitations of Wasm in non-web contexts.

// WASM type system is too simple for complex interfaces between WASM-host or WASM-WASM interfaces. It does not even have strings or pointer types.
// #todo[List all types here and show how a complex C type could be represented as a WASM type]
// Here it must also be clear that it is completely language and compiler dependent how high level types are represented in the compiled WASM bytecode with its simple types.
// Here it becomes clear again that WASM only provides a very minimal execution environment and leaves all the responsibility and optimizations to compilers, very similar to traditional assembly/machine code.
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
