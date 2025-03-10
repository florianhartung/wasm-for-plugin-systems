#import "@preview/polylux:0.4.0": *

#set page(paper: "presentation-16-9")
#set text(size: 23pt, font: "Lato")

#set list(spacing: 1.2em)
#set enum(spacing: 1.2em)

#show heading: it => it + h(0.2em)
#show heading.where(level: 1): set text(size: 0.8em)

#slide[
  #set align(horizon)
  = Exploring WebAssembly for versatile plugin systems through the example of a text editor

  Florian Hartung

  10.03.2025
]

#slide[
  == Plugin Systeme sind überall
  - IDEs (z.B. ein Quellcode-Formatter, Preview für Webseite)
  - Audio (z.B. VSTs bei Musikproduktion)
  - Computerspiele (z.B. Minecraft Server)
  - Browsererweiterungen (z.B. Adblocker, Dark Mode)
  - ...
]

#slide[
  == Probleme mit Text Editoren
  - Plugins oft nicht abgesichert
    - Beispiel: Issue VSCode offen seit 2018#footnote[#link("https://github.com/microsoft/vscode/issues/52116")]. Scheitert an Sandboxed execution
  - Nicht ressourcen-effizient (JS, Java, Lua)
  - PluginEntwicklung erfordert Einarbeitung in eine neue Sprache
]

#slide[
  == WebAssembly
  - Web + Assembly (quasi: Assembly für das Web bzw. den Browser eines Clients)
  - Compilation target (Abbildung)
  - schnell & sicher
  - Ermöglicht HPC im Browser, wo JS nicht mehr ausreicht ohne Risiko für den Client

  // Beispiel: ebay barcode scanner: https://innovation.ebayinc.com/tech/engineering/webassembly-at-ebay-a-real-world-use-case/
]

#slide[
  #let c(n) = {
    let t = n / 5 * 100% // to ratio
    t = t * 55% // rescale to 20%..80%
    t = 100% - t // flip

    let color = gradient.linear(..color.map.turbo).sample(t)

    table.cell(fill: color, [#n])
  }
  #let td = table.cell(fill: gray, [])

  == WebAssembly für Plugin Systeme
  1. Technologievergleich
  2. Einordnen von WebAssembly
    #figure(table(columns: 7,
      table.header([], [*VSCode*], [*IntelliJ*], [*Zed*], [*ZelliJ*], [*Wasm*], [*Wasm (WIT)*]),
      [Performance], td, td, td, td, td, td,
      [Plugin size], td, td, td, td, td, td,
      [Isolation/Safety], c(2), c(0), c(5), c(5), c(5), c(5),
      [Portability], c(3), c(3), c(4), c(4), c(4), c(4),
      [Erweiterbarkeit], c(2), c(2), c(5), c(2), c(1), c(5),
    ))
]

#slide[
  == Proof of concept
  - Implementierung eines einfachen Plugin Systems für den Helix Editor#footnote[#link("https://www.helix-editor.com")]
]

#slide[
  == Bla
]