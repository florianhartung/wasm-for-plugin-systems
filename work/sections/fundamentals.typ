#import "../wip.typ": todo, td
#import "../util.typ": flex-caption
#import "@preview/subpar:0.2.2"

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
    caption: flex-caption([A multilevel computer system running Wasm code. Based on @tanenbaum-structured[fig.~1-2]], [A multilevel computer system running WebAssembly code]),
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
    caption: flex-caption([
        Flowchart for the creation of a Wasm module from a higher-level language and execution through a host application.
    ], [Flowchart of the lifecycle of a WebAssembly module])
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
Wasm runtimes are usually hardware-specific and not portable, unlike the Wasm module.
The Wasm runtime is able to parse the received Wasm module file, instantiate a _Wasm instance_ from it and provide an Application Programming Interface (API) for interaction with the Wasm instance.
APIs can differ from one Wasm runtime to another.
Some runtimes exist as standalone programs that can run Wasm modules comparable to how native binaries can be executed.
Others like the one shown in @fig:wasm-execution-model are in the form of libraries, that can only be used from a host application to embed a Wasm runtime into them.
// Wasm runtime library interfacing
These Wasm runtime libraries often provide common operations to the host application like calling Wasm functions, reading and writing operations for Wasm memories, linking mechanisms between Wasm modules, exposing host-defined functions for Wasm instances to call, etc.
// TODO name all important common interfaces for Wasm runtime libraries

// Web (example)
In a web context a server might provide this Wasm module to the client's browser, which usually comes with a Wasm runtime.
Detailed information on the current status of Wasm support for internet browsers can be viewed at #link("https://caniuse.com/wasm").
A concrete example is Ebay using Wasm for their barcode scanner algorithm to achieve higher performance#footnote(link("https://innovation.ebayinc.com/tech/engineering/webassembly-at-ebay-a-real-world-use-case/")).

// Distributed computing and serverless (example)
For distributed computing and especially serverless functions a compiled Wasm module could be distributed among multiple different nodes regardless of their platform and architecture while still providing good performance.
This is what the projects WasmEdge or Fermyon (see #link("https://wasmedge.org/") and #link("https://www.fermyon.com/")) are trying to achieve.

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
To further elaborate, a Wasm module in its binary format consists of 11 different sections.
These sections must only occur in a very specific order to allow Wasm runtimes to parse and/or skip them efficiently.
Another example is the absence of backwards jump (except for the `loop` statement), which allows the use of faster one-pass compilers.

During runtime Wasm's execution time varies.
The original design paper for Wasm found Wasm to be at most two times as slow as native code and around 30% of PolyBenchC's benchmarks to close to native code execution time @bringing-the-web-up-to-speed[p.~197].
Another performance analysis by Jangda et al. measures peak slowdowns of 2.5x (Chrome) and 1.45x (Firefox) for running Wasm code in different browsers and comparing their execution times to native execution@analyzing-the-performance.

An additional property of Wasm bytecode is that it can be either compiled, interpreted or just-in-time compiled by a runtime.
This provides users of Wasm with flexibility for performance optimizations.
Some use cases require the fast startup time, determinism and relocatability (see @other_features) only an interpreter can provide.
Others require high performance at the cost of flexibility of a compiler or just-in-time compiler.

==== Safe <design_safe>
Wasm's execution is safe and sandboxed by default.
All operations operate on a stack, which contains values, labels as references for branch instructions and activations, which are similar to function call frames.
The Wasm stack differs from a stack used in most native architectures in two ways:
Wasm code can only access the top-most value of the stack, and the stack is type-checked by the Wasm runtime during a validation phase@spec.

Wasm modules also have their own linear memory.
This linear memory is completely isolated from the stack and can only be accessed using special instructions and bounds-checked indices instead of pointers.
While host applications can always read from and write to Wasm linear memory, Wasm instances cannot access host memory in the opposite direction.
Instead, Wasm instances can only interact with the host through functions explicitly exposed by the host@spec.

While the Wasm execution format is sandboxed, it is still important that the implementing Wasm runtime does not introduce any sandbox escapes due to bugs, etc.
In their article "Provably-Safe Multilingual Software Sandboxing using WebAssembly" Bosamiya et al. have acknowledge Wasm as a safe sandboxed execution format and implemented a provably safe and verifiable Wasm runtime@provably-safe-multilingual-software-sandboxing.
This shows that implementation of a fully sandboxed and safe runtime is possible not only in theory but also in practice.

Because Wasm is able to provide safety for untrusted code execution, it is currently gaining interest in certain safety-critical non-web contexts, such as avionics@wasm-in-avionics or automotive industries (see https://oxidos.io/).

// - Because of its simplicity: easier to implement a minimal working runtime than it is for higher level languages like C, C++, Java, Python, ...
//     - This again reduces risk of (safety-critical) bugs
// - Properties like portability and safety are especially important in the context of the web, where untrusted software from a foreign host is executed on a client's device.
// - Note: Applications inside Wasm can still corrupt their own memory.


==== Portable <design_portable>
// This includes goals: hardware-independent, platform-independent
Originally Wasm was designed for fast and safe code execution on a client's web browser@bringing-the-web-up-to-speed.
This means that a variety of web browsers, all running on different platforms and architectures from desktop computers, mobile devices and even embedded devices, have to be able to run Wasm code.

Thus Wasm was designed to be able to be portable for various target platforms and architectures@spec.
It does this by defining only the most basic types and instructions necessary to act as a compilation target.
The basic types and instructions chosen exist on most platforms and architectures today.
For example Wasm defines \~172 different instructions and \~8 types@spec[sec.~4.2.1].
In comparison, the x64 architecture defines ca. 1500 - 6000 instructions@provably-safe-multilingual-software-sandboxing.

// - minimal set of opcodes (172), that exist on all architectures(#todo[insert screenshot of opcode table] (+ proposals for more additional instructions like SIMD, atomics, etc.)
// #figure(todo[opcode table], caption: flex-caption([All WebAssembly opcodes. Opcodes for proposals are encoded by specific marker bytes, which indicate that the following opcodes are to be interpreted as different instructions.], [An overview over all WebAssembly opcodes]))

// Independence of hardware:
// - Desktop architectures
// - Mobile device architectures
// - Embedded system architectures

// Independence of platform:
// - Browsers
// - Other environments which only require some kind of a Wasm runtime

==== Independence of language <design_independence_language>
Wasm is designed to be a compilation target for higher level languages.
In particular it is not designed for a specific language, programming model or object model@spec[sec.~1.1.1].
Currently Wasm can already be used as a compilation target by various languages such as C, C++, Rust, Haskell or Ada.

==== Compact <design_compact>
The representation of the Wasm bytecode format is designed to be compact.
Especially on the web file size is very important to minimize loading times and achieve better user experiences.
Also smaller files are faster to load into memory, which might lead to a slight increase in performance.

Research shows that the compactness of Wasm bytecode in non-web contexts is close to native code with around 246% the size of natively compiled x86_64 machine code for the PolyBenchC benchmarks@an-evaluation-of-wasm-in-non-web-environments.
While Wasm should optimally come as close to native code compactness as possible, this is close to impossible as native code is able to provide a larger variety of instructions exposing hardware-specific behavior.

As a concrete examples for how Wasm bytecode is compacted, variable integers are explained in the following:
Often times, the top-most bytes of integers are 0.
To reduce the size of integers, their bit information is not stored as a fixed amount of bytes (e.g. 4 bytes for a 32-bit integer) anymore.
Instead only 7 bits per byte are used to store the integer's bits, while the 8th bit is reserved for a flag that indicates whether the next byte also belongs to the integer currently being encoded.
This allows to store 32-bit unsigned integers in the interval $[0; 127]$ inside one byte, $[128; 16383]$ inside two bytes, etc., while the maximum possible integer value of $2^32-1$ now requires 5 bytes for storage.
This design is very similar to how Unicode encodes multi-byte characters.


==== Other features <other_features>
This section lists some other noteworthy features and design goals of Wasm.
These are not directly related to this work, but instead provide a better overview over Wasm's potential use cases and applications.

- *Determinism*: The majority of Wasm code is deterministic and undefined behavior is prevented through validation before execution of Wasm code happens.
    There are only three possible sources of indeterminism:
    - Functions exposed by the host application and imported into a Wasm instance can cause side-effects and introduce indeterminism@spec[sec.~4.4.10].
    - NaN float values and operations on them are not defined deterministically, because there exists a variety of different NaN values@spec[sec.~2.2.3].
    - Wasm instances can grow their memory or tables through the `memory.grow` and `table.grow` instructions.
        Wasm runtimes are able to make these instructions fail, either due to missing resources, because of resource limitations or any other reason without determinism@spec[sec.~4.4.6, sec.~4.4.7].
- *Parallelizable*: Wasm bytecode is designed for operations on it to be easy to parallelize@spec[sec.~1.1.1].
    This applies to decoding, validation and compilation of Wasm bytecode and it may allow for faster startup times of Wasm instances.
- *Streamable*: With Wasm being made for the web, the streamable property is quite unique from other ISAs.
    This property means that Wasm bytecode is able to be read and consumed by a Wasm runtime, before the entire data has been seen@spec[sec.~1.1.1].
    On the web this means, that the Wasm runtime inside a client's browser can start parsing and validating a Wasm module while it is being received over the internet.
    This reduces startup time for Wasm instances especially on the web, but it may also be relevant for non-web contexts, e.g. where large Wasm modules are being read from slow hard disk drives.
- *Modular*: Wasm applications consist of smaller modules, so called Wasm modules.
    They are self-contained, which allows them to be "transmitted, cached and consumed separably"@spec[sec.~1.1.1].
    During runtime most Wasm runtimes also allow multiple Wasm modules to be linked together, as long as all imports required by those Wasm modules are fulfilled.
- *Well-defined*: Wasm code is designed to be easy to understand and "reason about informally and formally"@spec[sec.~1.1.1] without loopholes or undefined behavior.
- *Relocatability*: Wasm modules by themselves are clearly defined at runtime consisting of their bytecode, a linear memory, reference tables, etc.
    Thus it is possible to halt execution of Wasm instances, serialize the entire runtime state and relocate it to another computer system for continuation of execution in theory.
    This could enable new methods for debugging, where traditionally a runtime state and logs are dumped for later analysis by a developer.
    Now an entire snapshot of the runtime state could be created, that can be rerun and analyzed at a later time.
// - *Efficient*: #todo[Wasm bytecode is efficient to read and parse, regardless of whether AOT or Just-in-time (JIT) compilation or interpretation is used at runtime @spec.]
// - *Backwards-compatibility*: #td
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


// Missing
// WASM is formally specified with no "loopholes"


=== Challenges & Limitations
// Challenges with Wasm in non-web contexts
This section deals with common challenges and limitations of Wasm in non-web contexts.

#todo[type system too simple with only 8 types: i32, i64, f32, f64, v128, ref.null, ref funcaddr, ref.extern externaddr]
#todo[simple type system results in ambiguities regarding common types used by programming such as strings, futures, tagged unions (enums with values associated per variant), options, results]
#todo[
    Example: convention in C is to use ASCII string pointer with null-termination.
    Rust uses Unicode string pointer without a terminator and instead stores the length of the string together with the pointer.
    Mapping both to Wasm would result in interfaces: `(pointer: i32)` and `(pointer: i32 len: i32)` with different contents at the pointer location.
]
#todo[
    Wasm tries to find and provide minimal execution environment and interoperable compilation target.
    While it leaves a lot of freedom for type layouts and representations to the compiler for optimizations, this also has downsides.
]
#todo[
    Two solutions arise:
    - Use a common serialization format such as JSON or a library such as protobuf, optimally with generators for serialization & deserialization bindings for all languages used.
        This has overhead though
    - Specify concrete representation for all types used in interfaces as constructs building on Wasm's simple type system.
        This however also requires glue code/ bindings for all languages to be written by hand which is error-prone and hard to maintain.
        E.g. conversion of C ASCII null-terminated string pointer to pointer and string length.

        One projects that follows this approach is the WebAssembly Component Model.
        It provides a common representation, interface definition language (WIT), and generators for bindings for various languages.
]

// #subpar.grid(
//     figure(
//         ```c
//         (module
//             (func alsdkf
//             )
//         )
//         ```,
//         caption: [Bla]
//     ),
//     figure(
//         ```rs
//         fn foo()
//         ```,
//         caption: [Foo]
//     ),
//     columns: (1fr, 1fr),
//     caption: [Comparison bla],
//     label: <fig:comparison-string-c-rust>,
// )

#todo[
    Another related problem are common interfaces used by almost all programming languages such as FS, networking or RNG.
    Most standard libraries rely on these functions to provide abstractions, e.g. over reading data from a file regardless of the current OS.

    An interface for these common APIs must be defined, that is language-agnostic, independent of compilers and compatible across all host platforms, on which the Wasm runtime will eventually execute the Wasm code.
    This is solved by the WebAssembly System Interface (WASI) in @wasi, which also relies on the WebAssembly Component Model for its interface definition.
]

#todo[
    Another problem is the transferral of large binary data objects.
    Wasm function only accept Wasm's basic types.
    Hosts are able to write into arbitrary linear memory, however the Wasm module's allocator does not know this, which can result in data loss if data get's allocated again and overwritten.

    Current approach also used by Component Model: Modules expose allocator functions such as `malloc` and `free`, which the host can call, write data into the allocated buffer, and then pass the index to that linear memory location to the Wasm instance as an argument.

    A better solution in the future could be the Multiple Memory proposal.
    It allows Wasm modules to use multiple different linear memories.
    Then a Wasm module could import a linear memory owned and managed by the host, which could be used for passing arguments.
    This no longer requires interactions between the host and Wasm module prior to the actual function invocations.
]
// How can a host provide large binary data objects to a Wasm module? It cannot write to the modules memory, so it would have to call the module's allocator first and then copy data into the allocated memory chunk.

// Interface for common non-web APIs: filesystem, networking, random number generation.
// 

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


=== WebAssembly Component Model <component-model>
// References: Design documents for component model (no spec yet)

#td

// - complex types: list, enum (tagged union), option, result, resource (host types opaque to Wasm instances)
// - language-agnostic interfaces
// - WebAssembly Interface Type (WIT) specification
// - generate bindings for various languages from a WIT definition
// Show current progress

=== WebAssembly System Interface (WASI) <wasi>
// References: WASI Spec

// The WebAssembly System Interface (WASI) is a common interface definition for common functionalities that may be provided by a host.
// These can be simple such as random number generation or more complex like filesystem access or networking.
// Show current progress
// Based on WIT

#td

== Plugin systems

#td

// - What are plugin systems?
// - Why are plugin systems important?
// - Where are plugin systems used?
