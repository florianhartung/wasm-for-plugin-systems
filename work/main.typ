#import "dhbw_template/lib.typ": dhbw_template
#import "util.typ": setup as setup_utils
#import "wip.typ": todo

#let abstract_en = [
  // Context, previous work
  Plugin systems are a software architecture pattern for making host applications extensible without modifying the host application itself.
  They are used in various applications such as real-time audio processing or computer games, but they play a particularly important role in text editors.
  Text editors and IDEs are applications used primarily by developers for software development.
  Text editors require a high degree of flexibility to accommodate the highly individual user requirements.

  // Depending on the required technologies and highly individual developer preferences, text editors must be able to adapt to a variety of different use cases.
  // Such use cases may include language support, complex keybindings or development on a remote server.
  WebAssembly (Wasm) is a relatively new technology first released in March 2017.
  It was originally designed as a fast, safe and portable compilation target for higher level languages to enable fast code execution on the web.
  However, it is designed with no assumptions about its execution environment and its properties make it an interesting technology for non-web contexts such as avionics, distributed computing, embedded devices or automotive as well.

  // Problem statement, goal
  This work explores Wasm as a technology for implementing a secure and fast plugin system with portable plugins compiled from higher level languages, such as C, C++, Rust, Python or JavaScript.
  The question is whether Wasm, as a new and versatile technology, can outperform existing plugin system technologies in terms of performance, security, compatibility and ease of development.

  // Methods
  A technology comparison is conducted for a selection of existing plugin systems to analyze the state of the art of plugin system technologies.
  Wasm will then be evaluated against the same criteria to provide an objective comparison with existing technologies.
  Finally, as a proof of concept, a plugin system based on Wasm will be developed for an existing text editor project to provide a better insight into the current state of the rapidly evolving Wasm ecosystem.

  // Results
  The technology comparison reveals that none of the selected existing plugin system technologies stands out across five criteria.
  Wasm however performant at least equally well as existing technologies for three out of the five criteria, with only native machine code-based plugin systems providing better performance and plugin size.
  The development of a proof of concept for a Wasm plugin system for the existing Helix text editor showed that Wasm is ready for use in real software applications with only minor challenges.
  In hindsight, the technology comparison could be improved by including more criteria and plugin system technologies and using better quantitative measures for evaluation.
  In the future, Wasm looks promising as a technology, especially for plugin systems for text editors.
  It is continuously improving though new proposals and the WebAssembly Component Model, allowing it to be easier to integrate into existing software projects.
]

#let abstract_de = todo[Abstract übersetzen]

#show: dhbw_template.with(
  title: [Exploring WebAssembly for versatile plugin systems through the example of a text editor],
  author: "Hartung, Florian",
  course: "TINF22IT1",
  submissiondate: datetime(year: 2025, month: 04, day: 15),
  workperiod_from: datetime(year: 2024, month: 10, day: 15),  
  workperiod_until: datetime(year: 2024, month: 04, day: 22),
  matr_num: 6622800,
  supervisor: "Gerhards, Holger, Prof. Dr.",
  abstract: abstract_en,
  abstract_de: abstract_de,
)

#show: setup_utils

#include("sections/introduction.typ")
#include("sections/fundamentals.typ")
#include("sections/generic_requirements.typ")
#include("sections/wasm_plugin_systems.typ")
#include("sections/implementation.typ")
#include("sections/results_discussion_outlook.typ")


// #bibliography("bib.yml")