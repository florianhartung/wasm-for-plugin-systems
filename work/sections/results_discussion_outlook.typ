= Results & discussion
A technology comparison of 3 plugin systems of popular editors and IDEs and a plugin system technology was conducted.
It revealed significant differences between the five criteria performance, plugin size, plugin isolation, plugin portability and plugin language interoperability, with no single technology standing out drastically across all dimensions.
WebAssembly (Wasm) was then evaluated against the same criteria and put up for comparison in a technology comparison matrix shown in @technology-comparison-matrix-final.
It performed at least equally well as the others in three out of the five criteria, only falling behind with slightly worse performance and plugin size compared to native machine code-based plugin systems.
Despite these shortcomings, Wasm can offer significantly better plugin isolation through sandboxing and slightly better plugin portability.
When compared to the plugin systems of the popular Visual Studio Code and IntelliJ-based IDEs, Wasm shows potential to outperform them for all criteria.
The viability of Wasm for a text editor plugin system was proven in a proof of concept, where a Wasm plugin system was developed for the Helix editor.
It required basic plugin functionalities such as the interaction between Wasm plugins and the core editor.
These requirements were briefly reviewed, the criteria for good plugin systems were re-evaluated and other useful features such as a common interface definition or automatic binding generation demonstrated.

Wasm-based plugin systems present trade-offs:
In comparison to native machine code-based plugin systems, they are slower and have larger plugins, however they can provide safety, portability and interoperability.
Considering this, Wasm might be a better technology choice than traditional plugin systems, which rely on Java bytecode or JavaScript for plugins.
Wasm beats the performance of these plugin systems, while also providing better plugin isolation and interoperability.

However challenges for Wasm as a plugin system technology remain.
While Wasm itself is stable, its ecosystems consisting of proposals for new features and projects such as the Component Model have not reached stable versions yet.
These technologies and projects are still rapidly evolving, leading to instabilities and frequent breaking changes between versions.
Even though challenges for the Wasm ecosystem exist, multiple software projects, e.g. those presented in @related-wasm-projects, have already proven that Wasm is indeed ready for use in production-grade plugin systems.

= Outlook
Looking back at the technology comparison, a set of five criteria was selected to evaluate the technologies under consideration.
However, in retrospect, it became clear that these criteria were not sufficient for a meaningful evaluation.
Instead more criteria regarding interface complexity, developer experience or the plugin system size should have also been considered.
Also some criteria, such as the performance or plugin size have not been evaluated quantitatively, even though such quantitative analysis can lead to more accurate, objective and reproducible results.
Furthermore, four plugin system technologies were analyzed, which is also not sufficient and representative of the current state of the art of plugin systems.
Thus a larger variety of different plugin systems could have been evaluated.

Looking ahead, future directions include continuing the development of the proof of concept plugin system into a functional and usable plugin system for the Helix editor.
The Wasm ecosystem itself is evolving, with exciting developments such as the Component Model or new proposals adding new features to Wasm.
These developments in Wasm's ecosystem will continue to gain attention from researches and developers in various non-web areas such as avionics, automotive or distributed computing.
The development of WebAssembly, driven by major web browsers, signifies its enduring presence and relevance both in web and possibly also non-web areas.
