#import "dhbw_template/lib.typ": dhbw_template
#import "util.typ": setup as setup_utils
#import "wip.typ": todo

#let abstract_en = [
  // Context, previous work
  Plugin systems allow software applications to be extended without modifying their core code, providing critical flexibility, isolation and reduced complexity of the core code.
  This type of software architecture pattern is particularly important for text editors and integrated development environments (IDEs), to accommodate for the highly individual user requirements.
  WebAssembly (Wasm) is a relatively new fast, safe and portable compilation target originally intended for use in web contexts.
  However, Wasm's design is execution environment agnostic, making it an interesting technology for non-web contexts such as avionics, distributed computing or embedded devices.

  // Problem statement, goal
  This work investigates Wasm as a technology for implementing secure and fast plugin systems with portable plugins compiled from higher level languages such as C, Rust, Python and JavaScript.
  The question is whether Wasm can outperform existing plugin system technologies, with a focus on text editor plugin systems.

  // Methods
  A technology comparison is performed for selected existing plugin systems to gain insight into the current state of the art of plugin system technologies.
  Wasm is then evaluated against these results to provide an objective comparison with existing technologies.
  Finally, as a proof of concept, a Wasm-based plugin system is developed for an existing text editor project to provide a better insight into the current state of the rapidly evolving Wasm ecosystem.

  // Results
  The technology comparison shows that none of the selected existing plugin system technologies stands out across all five defined criteria.
  Wasm, however, matches or exceeds all other technologies in three of the five criteria, falling short only to native machine code-based plugin systems for the other two.
  A basic Wasm plugin system was implemented for the Helix text editor, demonstrating Wasm's real-world viability with only minor challenges faced.

  // Discussion
  Improvements to the technology comparison are identified, including the need for a wider range of technologies and criteria, but also quantitative evaluation.
  The results suggest that Wasm is a promising foundational technology for plugin systems.
  It continues to be improved by new proposals and new emerging projects such as the WebAssembly Component Model, further strengthening its viability.
]

#let abstract_de = [
  // Context, previous work
  Plugin-Systeme ermöglichen die Erweiterung von Softwareanwendungen ohne Änderung des Quellcodes, wodurch Flexibilität, Isolation und reduzierte Komplexität in der Kernsoftware erreicht werden können.
  Diese Softwarearchitektur hat besondere Relevanz für Texteditoren und Entwicklungsumgebungen, wo die Anforderungen der Nutzer sehr variabel und individuell sind.
  WebAssembly (Wasm) ist ein neues Compilation Target, welches schnell, sicher und portabel ist.
  Ursprünglich wurde es für die Nutzung in Web-Browsern erstellt, allerdings macht es keine Annahmen über die Umgebung, in welcher es ausgeführt wird.
  Somit ist Wasm für seine Eigenschaften auch interessant außerhalb des Web-Kontexts wie bspw. in der Avionik, verteilten Systemen oder eingebetteten Geräten.

  // Problem statement, goal
  Diese Studienarbeit erforscht Wasm als eine Technologie für sichere und schnelle Plugin-Systeme mit portablen Plugins, welche von höher-leveligen Sprachen wie C, Rust, Python oder Javascript kompiliert werden.
  Sie stellt die Frage, ob Wasm bisherige Plugin-System Technologien mit einem Fokus auf Texteditoren übertreffen kann.

  // Methods
  Dazu wird ein Technologievergleich für ausgewählte bestehende Plugin-Systeme durchgeführt, um einen Einblick in den aktuellen Stand von Plugin-System Technologien zu bekommen.
  Anschließend wird Wasm mithilfe gleicher Kriterien bewertet, wodurch ein objektiver Vergleich mit bisherigen Technologien ermöglicht wird.
  Zum Abschluss wird ein Prototyp für ein Wasm-basiertes Plugin-System für einen bestehenden Texteditor entwickelt.
  So soll herausgefunden werden, ob das sich schnell entwickelnde Wasm und sein Ökosystem auch in der Praxis produktionreif sind.

  // Results
  Der Technologievergleich zeigt, dass keines der ausgewählten bestehenden Plugin-Systeme für alle fünf Kriterien über andere herausragt.
  Wasm hingegen schneidet in drei von den fünf Kriterien mindestens so gut wie andere Plugin-Systeme ab, wobei es nur von solchen übertroffen wird, welche auf kompiliertem Maschinencode basieren.
  Des Weiteren demonstriert der entwickelte Wasm Plugin-System Prototyp, dass Wasm mit nur kleinen Hürden bereit für die Nutzung in echten Softwareanwendungen ist.

  // Discussion
  Es werden Verbesserungen für den Technolgievergleich identifiziert, unter anderem die Notwendigkeit für einen größeren Umfang an Plugin-System Technologien und Kriterien und einer genaueren quantitativen Bewertung der Kriterien.
  Die Ergebnisse zeigen, dass Wasm eine vielversprechende Technologie für Plugin-Systeme ist.
  Wasm wird stetig durch neue Proposals und Projekte wie das Wasm Component Model verbessert, was seine zukünftige Bedeutung weiter stärkt.
]

#show: dhbw_template.with(
  title: [Exploring WebAssembly for versatile plugin systems through the example of a text editor],
  author: "Hartung, Florian",
  course: "TINF22IT1",
  submissiondate: datetime(year: 2025, month: 04, day: 22),
  workperiod_from: datetime(year: 2024, month: 10, day: 15),  
  workperiod_until: datetime(year: 2025, month: 04, day: 22),
  matr_num: 6622800,
  supervisor: "Gerhards, Holger, Prof. Dr.",
  abstract: abstract_en,
  abstract_de: abstract_de,
  show_jump_to_table_of_contents: false,
)

#show: setup_utils

#include("sections/introduction.typ")
#include("sections/fundamentals.typ")
#include("sections/generic_requirements.typ")
#include("sections/wasm_plugin_systems.typ")
#include("sections/implementation.typ")
#include("sections/results_discussion_outlook.typ")


// #bibliography("bib.yml")