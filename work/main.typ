#import "dhbw_template/lib.typ": dhbw_template

#show:  dhbw_template.with(
  title: [Exploring WebAssembly for versatile plugin systems through the example of a text editor],
  author: "Hartung, Florian",
  course: "TINF22IT1",
  submissiondate: datetime(year: 2025, month: 04, day: 15),
  workperiod_from: datetime(year: 2024, month: 10, day: 15),  
  workperiod_until: datetime(year: 2024, month: 04, day: 15),
  matr_num: 6622800,
  supervisor: "Gerhards, Holger, Prof. Dr.",
  abstract: include "abstract.typ",
)

= Introduction
= Fundamentals
== WebAssembly
== Plugin systems
== Rust
= Plugin system requirements
= Related work
// research and projects
= WebAssembly for plugin systems
== Overview
== Choosing a plugin API
// native/wat/wasi
== Safety
== Performance
== Summary 
= Implementing a plugin system for a text editor
== Requirements
== Design
== Implementation
== Example plugin development 
// preferable in different languages to demonstrate interoperability
== Verification and validation
= Discussion
= Conclusion