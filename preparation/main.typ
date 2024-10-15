#set page(paper: "a4", margin: 2cm)
#set text(size: 12pt, font: "Arial");
#set par(
  justify: true,
  hanging-indent: 0em,
  leading: 0.8em,
);

#align(center)[
  #text(size: 1.5em)[
    Exploring WebAssembly for versatile plugin systems through the example of a text editor
  ]

  _Florian Hartung_
]

= Problem definition
WebAssembly is a bytecode format, initially released in 2017 as a compilation target for web-based applications.
However, the utilisation of WebAssembly has since expanded beyond the web.
It offers advantages such as cross-language interoperability and sandboxed execution, which enable emerging use cases in vastly different areas such as cloud computing, safety-critial systems and blockchains.
Another promising application for WebAssembly is plugin systems, for which only limited research and a few projects exists.

Plugin systems are software components that allow plugins to extend or modify the functionality of some host application.
Most common plugin systems using languages such as JavaScript, Lua or Python have some issues regarding performance or safety while their plugins might be non-portable and locked to their respective programming language.
This work aims to explore how WebAssembly can be leveraged to create fast and safe plugin systems for portable and interoperable plugins.
As a test case a plugin system will be developed for a text editor.
Text editors are suitable as their broad spectrum of users usually demand a high degree of customization.
A WebAssembly plugin system provides this customization by enabling features to be implemented by third-party developers, while still guaranteeing a safe, sandboxed plugin execution.

= Objectives
- Analyze requirements for plugin systems from real world projects
- Analyze the pros and cons of WebAssembly (and its related technologies) in comparison to traditional architectures of plugin systems
  - Performance, Safety, Portability of the plugin system
  - Language-interoperability for plugin development
- Gain insight into designing and implementing a WebAssembly plugin system for a text editor as a proof of concept

= Approach/ Table of contents (WIP)
- Introduction
- Fundamentals
  - WebAssembly
  - Plugin systems
  - Rust
- Plugin system requirements
- Related work (research and projects)
- WebAssembly for plugin systems
  - Overview
  - Choosing a plugin API (native/wat/wasi)
  - Safety
  - Performance
  - Summary 
- Implementing a plugin system for a text editor
  - Requirements
  - Design
  - Implementation
  - Example plugin development (preferable in different languages to demonstrate interoperability)
  - Verification and validation
- Discussion
- Conclusion
// - allows for portable software as it runs platform-independent and can run a lot of different languages, safe by default
// - plugin systems traditionally use specific languages and interfaces for their plugins
// - WASM might be a suitable language for versatile plugin systems, however there is a gap in are few plugin systems that use WASM


// Plugin systems are software components that can be used by host software to execute plugin components.
// These modular plugin components may add new or modify existing features of the host software.
// That makes a plugin systems architecture a popular approach for text editors, IDEs, games and audio processing software.
// However most plugin systems require their plugins to be implemented in a specific programming language where they are provided a language-specific interface to the host software.

// WebAssembly is a new platform-independent bytecode format, that allows its bytecode to be executed in a sandbox while still providing high performance.
// It acts as a compilation target for some languages (C, C++, Rust, ...) and allows code of other languages (Python, Javascript, ...) to be embedded along with a their runtime engine.
// Thus WebAssembly allows for extreme interoperability for plugin developers of any language and also allows for compiled plugins to be portable to all architectures, that can provide a WebAssembly runtime.

// It is still unclear to what extent one can make use of WebAssembly plugin systems in practise and also what downsides might arise.

// Text editors, in particular, benefit from such systems because they offer a high degree of customization to meet the diverse needs of users.
// Common text editors and IDEs require their plugins to be written in a particular language such as Java, Javascript, Lua, a custom scripting languages, etc.

// In contrast to these traditional plugin systems stands WebAssembly - a bytecode format that many languages (C, C++, Rust, ...) can be compiled to and in which other can be embedded (Javascript, Python, ...).

// promises interoperability, portability and a sandboxed code execution environment, while still providing high performance.
// Even though plugin systems that use WebAssembly have been developed, it is still unsure whether a WebAssembly plugin system is suited for a text editor.

// Helix is a new terminal-based text editor with vim-like controls, but it currently lacks support for a plugin system.
// Its official issue tracker has long-requested features like a filetree (since 2021) or an integration for generative AI (since 2022), which could greatly profit off of a plugin system.
// A plugin systems would allow the development of unofficial self-contained plugins, that can be used without them having to go through a time-consuming CI/CD pipeline, review and merge processes.

// In summary, it is unsure, if and how text editors can make use of WebAssembly plugin systems.

// Some existing features might even be outsourced into their own build-in plugins for a reduction in code complexity and better encapsulation.

// *Context*  
// - What are plugin systems?
// - Why are plugin system architectures better?
// - Text editors and their need for plugin systems
// *Actual problem*
// - What is Helix as a project?
// - Helix does not provide a plugin system and it has a lot of new requested features (some of which are for very special usecases, and thus they should not necessarily be included in the core software due to additional dependencies, complexity (and performance overhead)).


// - Software-Systems provide plugin systems
// - Plugin systems enable development of new features by independent third-party developers
// - A plugin system architecture has lots of advantages over including a set of features from the start:
// - Such modular software has lots of advantages, as it is impossible to 

// - Text editors need really high configurability, which a plugin system can provide.
// - Big text editors and IDEs provide plugin system: VSCode, IntelliJ-based IDEs, (Neo-)Vim
// - Helix is a new terminal-based editor inspired by VIM motions.
// - As of now Helix does not provide a plugin 
// Some software systems offer plugin systems, through which users can extend the orginal software with new features.
// Especially text editors and IDEs make use of such plugin systems, where they benefit from extreme configurability and versatility.
// Common plugins (also called extensions) might provide custom syntax highlighting, colored highlighting for matching braces, new keybinds or a GUI for dependency management in NodeJS and Rust projects.


// Helix is a new terminal-based text editor with vim-like controls, but it currently lacks support for a plugin system.
// Its official issue tracker has long-requested features like a filetree (since 2021) or an integration for generative AI (since 2022), which could greatly profit off of a plugin system.
// A plugin systems would allow the development of unofficial self-contained plugins, that can be used without them having to go through a time-consuming CI/CD pipeline, review and merge processes.

// In summary, it is unsure, if and how text editors can make use of WebAssembly plugin systems.
// The objective is to explore WebAssembly as a language for versatile plugin systems.
// This will be done by analysing existing plugin systems, then designing and implementing a new WebAssembly plugin system.
// Then the pros and cons of using WebAssembly and the 


// design a new WebAssembly plugin system based on an analysis of plugin systems of some common text editors and IDEs.
// explore what pros and cons there are to WebAssembly plugin systems for text editors.
// As a proof To prove the results

// This includes one text editor in particular: Helix.
// Helix is a new terminal-based text editor with vim-like controls, but it currently lacks support for a plugin system.
// Its official issue tracker has long-requested features like a filetree (since 2021) or an integration for generative AI (since 2022), which could greatly profit off of a plugin system.
// A plugin systems would allow the development of unofficial self-contained plugins, that can be used without them having to go through a time-consuming CI/CD pipeline, review and merge processes.


// This work will present and analyze plugin systems of common text editors and IDEs.
// Also  and existing WebAssembly plugin systems.

// Then a generic and versatile plugin system will be developed as a proof of concept to showcase how plugin systems benefit from using WebAssembly.

// With this knowledge a generic plugin system will be designed and developed.
// This plugin system will use the very promising WebAssembly bytecode format for plugins
// Then a new plugin system 

// This work will extend the Helix editor with a new WebAssembly plugin system, that allows for plugins to be written in almost any language.
// Plugins will be able to add or modify basic functionality of the Helix editor, such as adding new commands, inserting text or rendering new UI components.
// More complex features will not be implemented in this work, as this is is as a proof of concept and lays a foundation for future development rather than providing a fully functional product.

// - Careful integration into Helix while still being flexible for future upstream Helix changes
// - Decoupling of plugin system into separate modular library
// - Especially the plugin system design requires analysis of current technologies and research.


// However, the plugin system will not be implemented directly inside the Helix editor project, and instead it will be implemented as a separate modular plugin system, that has the possibility of being used in other projects in the future.

// / Analysis of existing technologies and (WebAssembly) plugin systems, design and implementation of a generic and versatile WebAssembly plugin system: aflk
// / Analysis of Helix's architecture and a careful integration of the plugin system into the project, while keeping complexity to a minimum: adsf

// + The goal is to create a plugin system that runs plugins in the WebAssembly bytecode format.
//   This plugin system shall provide a simple, yet versatile interface for a host to execute plugins.
//   These plugins may have been written in any language that compiles to WebAssembly, which is why designing a generic plugin interface will be especially important.
//   Even though some technology decisions are already made (Rust and WebAssembly), a lot of analysis will be required to design a robust and extensible plugin system:
//   - Which WASM runtime to choose: Wasmtime, Wasmer, ...
//   - How to design the plugin interfaces: native WASM vs. WAT, events/commands, ...
//   - What to learn from existing (WebAssembly) plugin systems: zellij, extism, VSCode, IntelliJ, ...

// + In this section the previously developed plugin system will be integrated into the Helix text editor as a proof of concept with the potential to become a fully functioning system eventually.
//   To make the integrated plugin system future-proof and extensible for newer upstream Helix features, a careful plugin system integration is necessary.
//   This requires a careful analysis of the current Helix architecture to decide how to integrate the plugin system.

// To achieve this robustness and allow for newer Helix features to be integrated easily, the Helix project architecture must be carefully analysed and the plugin system integrated as modular as possible without introducing too much complexity.


// - WebAssembly as the plugin language
//   - performance (in comparison to traditional plugin languages), interoperability (any language can be compiled to or embedded into WebAssembly) and portability (WASM plugins are platform-independent)
// - Rust as the plugin system language
//   - Helix is written in Rust. Thus introducing another language barrier includes unnecessary complexity.
//   - The plugin system shall be safe to use for the host system. Rust's safety guarantees will help achieve this. 

// - This work will design and implement a generic plugin system, that can then later be embedded into the Helix text editor project.
// - A fundamental design decicision
// - In the plugin system design process other plugin systems 
// will design analyze other plugin systems and 

// = Approach
// Instead of directly implementing the plugin system in the Helix project, this work will be split into two main sections:
// / Design and implementation of a generic plugin system:
//   To make the generic plugin system as versatile as possible, existing plugin systems and technologies such as the WebAssembly runtime and the plugin interface will have to be analyzed.
//   Then a generic plugin system can be designed and implemented as a standalone project.
// / Integration of the plugin system into the Helix project:
//   In this section the previously developed plugin system will be integrated into the Helix editor.
//   The integration requires careful analysis of Helix's architecture to make sure that the result is future-proof and extensible for newer upstream Helix features.

// They essentially provide the framework for a working editor while also benefitting from  to allow for extreme configurability and 

// Bestimmte Software-Systeme bieten Plugin-Systeme an, sodass modular neue Funktionen hinzugefügt werden können.
// Vorallem bei Text-Editoren spielen Plugin-Systeme eine große Rolle, denn sie erlauben es den Nutzern eigene Syntaxregeln, , ...
// Plugin-Systeme von konventionellen Texteditoren wie VSCode, IntelliJ oder Neovim verwenden jeweils eine eigene Programmiersprache zur Erstellung


// #pagebreak

// == Kontext
// - Herkömmliche Plugin-Systeme für Text-Editoren verwenden oft spezifische Sprachen wie Lua (neovim), Java (IntelliJ) oder JS/TS (VScode)
// - Sicherheit?
// == Problem
// - Sprache und Ecosystem müssen z.T. neu erlernt werden
// - Schnittstelle ist stark abhängig von den Features der Programmiersprache des Plugin-Systems (Exception, async mit Promises, ...)



// // Idee: Language and editor-agnostic plugins? VSCode plugins in intellij? probably impossible though

// = Zielsetzung

// = Vorgehen

// == Zeitplan
// Bereits erfolgt:
// - Tests mit Helix
// - Tests mit WebAssembly Component Model in Rust und anderen Sprachen für WASM-Programme
// Noch zu tun:
// - Ratatui Layouting anschauen
// - Helix Codebase testing: Left panel for future file explorer, new hello world command, manche commands anpassen

// - WASM-Engine in Helix integrieren
// - Plugin: activate() and deactivate()
// - Plugin: Logging
// - Plugin: Calling Helix commands
// - Metadata for plugins
// - Plugin: Definition of new commands
// - Plugin: Insert text/ prompt input text
// - Centralized Plugin Loader mit Plugin Store in ~/.config/Helix/plugins/

// = Notizen
// - Hier schon zentrale Literatur nennen
// - Selber Plugin Development ausprobieren
// - Anmelde-Formular
// - Plugin-Host stellt Features bereit: Tree-Component, Command-System, File-Access and (Configuration-)Storage
// - Es sollen als Proof of Concept Plugins in den meistverwendeten Sprachen implementiert werden (Rust, Java, Javascript, Python).
