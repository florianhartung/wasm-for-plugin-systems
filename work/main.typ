#import "dhbw_template/lib.typ": dhbw_template
#import "util.typ": setup as setup_utils
#import "wip.typ": todo

#let abstract_en = [
  // Context, previous work
  Plugin systems are a software architecture pattern for making host applications extensible without modification of the host application itself.
  They are used in various applications such as realtime audio processing or computer games, however they play an especially important role for text editors.
  Text editors and IDEs are applications used mostly for software development by developers.
  Depending on the required technologies and highly individual developer preferences, text editors must be able to adapt to a variety of different use cases.
  Such use cases might include language support, complex keybindings or development on a remote server.

  WebAssembly (Wasm) is a relatively new technology first released in March 2017.
  It was originally designed as a fast, safe and portable compilation target for higher level languages to allow fast code execution on the web.
  However it is designed without assumptions about its execution environment and its properties make it an interesting technology for non-web contexts such as avionics or the automotive industry as well.
  
  // Problem statement, goal
  This work explores Wasm as a technology for implementing a safe and fast plugin system with portable plugins compiled from higher level languages, such as C, C++, Rust, Python or JavaScript.
  It asks the question if Wasm is able to surpass existing plugin system technologies in terms of performance, safety and its host system impact as a new versatile technology.

  // Methods
  For that a technology comparison between selected existing plugin system is conducted to analyze the state of the art of plugin system technologies.
  Then WebAssembly is evaluated across the same criteria to enable an objective comparison with existing technologies.
  Finally as a proof of concept, a plugin system based on WebAssembly is developed for an existing text editor project, to provide better insight into the current state of the rapidly evolving Wasm ecosystem.

  // Results
  #todo[present results]

  // Discussion, impact of this work
  #todo[discuss results and impact of this work briefly]
]

#let abstract_de = todo[Abstract übersetzen]

#show: dhbw_template.with(
  title: [Exploring WebAssembly for versatile plugin systems through the example of a text editor],
  author: "Hartung, Florian",
  course: "TINF22IT1",
  submissiondate: datetime(year: 2025, month: 04, day: 15),
  workperiod_from: datetime(year: 2024, month: 10, day: 15),  
  workperiod_until: datetime(year: 2024, month: 04, day: 15),
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