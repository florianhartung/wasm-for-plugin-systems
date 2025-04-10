#import "dhbw_template/lib.typ": dhbw_template
#import "util.typ": setup as setup_utils

#let abstract_en = lorem(200)

#let abstract_de = lorem(200)

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