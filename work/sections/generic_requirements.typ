#import "../wip.typ": todo, td

= Criteria for plugin systems
// TODO Normally a technology comparison defined weights for each score
To evaluate whether Wasm is a viable technology for versatile plugin systems, one must first understand what criteria make a plugin system good and versatile.
This section will perform a technology comparison between several technologies and existing software projects.
First, a set of criteria is defined.
Then, appropriate technologies and software projects are selected to represent a spectrum of different plugin systems.
Next, the technologies and projects are evaluated against the previously defined criteria.
Finally, a technology comparison matrix is used to summarize and visualize the results.

== Definition of criteria
In this section criteria for good plugin systems are defined.
// TODO Mention, that choice of criteria should be specifically suited for text editor plugin systems?
Each criterion will define a scale from 0 to 5, along with requirements for each score.
This scale will be useful later to enable an objective evaluation and comparison of technologies and projects.

=== Performance <req_performance>
A computer's performance usually refers to the speed it is able to execute software at.
For interactive computer systems one generally wants every piece of code to run as fast as possible to minimize its time on the CPU.
// However in some scenarios one might prefer other properties such as less memory usage or dynamic typing over performance.

In the context of plugin systems, performance also refers to the speed at which software is executed.
The three relevant software components necessary to define performance of a plugin system technology are the host system, the plugin system and the plugins managed and called by the plugin system.
For this work we define performance as the property that describes how quickly a host system can temporarily transfer execution to a plugin system, which then loads and invokes a plugin's function.

While performance can be measured quantitatively through benchmarks, in practice this is quite hard for plugin systems.
Plugin systems and their technologies often vary between host applications as they are by nature highly individual.
To benchmark different plugin systems one would have to implement a variety of algorithms and scenarios for a variety of plugin systems.
Then one could measure the time each plugin system and plugin takes to execute.

Due to time-constraints and the broad spectrum of knowledge about programming languages and host applications necessary, this work does not use quantitative benchmarks to measure performance.
Instead performance is judged through educated guesses based on benchmarks and comparisons already available for the technologies chosen and built upon by plugin systems.

/ 0 -- Very slow: The transfer of execution to the plugin systems and invocation of a plugin is highly inefficient.
  Thus the plugin system is not viable for use within interactive software.
  Reasons for significant bottlenecks might include heavy serialization or expensive VM-based sandboxing.
/ 1, -- Slow: Both the plugin system and plugins run very slowly.
  Transferring execution between the host system and a plugin is inefficient.
  Therefore this plugin system is also not recommended for use in interactive software, unless these inefficiencies can be somewhat mitigated, e.g. by offloading to other threads.
/ 2, 3 -- Acceptable: The plugin system and plugins are not fast but their performance is acceptable for interactive software such as text editors.
  They can negatively impact the user experience by causing stuttering or slow loading times, but there are workarounds to minimize the impact of these problems.
/ 4 -- Fast: Transferring execution to the plugin system and/or executing a plugin is fast, with only a small overhead, not noticeable by a user.
  While there is still a small overhead present, it is usually negligible in practice, except in scenarios with real-time requirements.
/ 5 -- Optimal: Transferring execution and invoking a plugin is virtually instantaneous. There is no measurable overhead.
  All plugin code executes as fast as if it were implemented natively within the host system.

The scoring outline presented here is intentionally not very specific, without any hard lines between the different scores.
It is meant to give only a rough guideline for evaluation, which then needs to be done very carefully on a case-by-case basis.
For example, one could evaluate plugin systems based on whether plugins are compiled/interpreted or how large and thus slow plugins might be to load.

=== Plugin size
The plugin size property refers to the average size of a plugin for a specific plugin system technology.
This property does not refer to the size of one specific plugin, but rather it is used to compare different plugin system technologies and how compact and small plugins for them are generally.
The average plugin size may vary from technology to technology due to factors such as static vs. dynamic linking of libraries or the size of the specific language's standard library.

The importance of plugin size depends on the specific use case and user requirements.
For text editors specifically a smaller plugin size might result in faster startup times and less time spent downloading or updating the plugin.
// TODO: Maybe mention, that memory footprint might be more relevant for terminal-based text editors, as they have a smaller memory footprint by nature anyway
However reducing the overall impact a program has on the system's resource usage is generally preferred.

Also note that this section only refers to the plugin size and not the size of the entire plugin system.
While the plugin system's size is also very important for the memory impact of the host application, it is harder to measure.
This is due to the fact that plugin systems are usually very tightly coupled with the host application.
To measure a plugin system's size, one would have to disable the plugin system of some host application, without breaking the host application itself.
Only then would it be possible to compare system resource usages between the host application with and without a plugin system.
Due to the high complexity, the plugin system's size will not be taken into account in this work.

The following scores will be used to evaluate a plugin's size.
They are chosen specifically for plugin systems for text editors.

/ 5 -- Minimal(#sym.lt~5KB): Plugin sizes are as minimal as they can possibly be.
  Plugins contain the minimal amount of program code necessary to achieve their desired functionality.
  The plugin code format is also made to be very space-efficient, which could be implemented for example through compression and hacks on the byte/bit levels.
/ 4 -- Negligible(#sym.lt~500KB): Plugin sizes are so small that they are negligible in practice.
  There is no replication of similar information between multiple plugins such as statically-linked libraries.
/ 3,2 -- Moderate(#sym.lt~50MB): Plugins are not very small, however their size is still quite manageable in the context of text editors.
  Examples could be plugin system technologies, that require a large fully-self contained runtime to be shipped with every plugin.
  Plugins might also have to contain all libraries and standard libraries that they depend on.
/ 1 -- Large(#sym.lt.eq~500MB): Plugins are unusually large specifically in the context of text editors.
  They are not as easy to manage and during runtime they might also have a non-negligible impact on the memory footprint of their host application.
/ 0 -- Very large(#sym.gt 500MB): Plugins are very large.
  This may be due to the fact that their internal program logic requires very costly operations such as the virtualization of an entire environment, that must be completely self-contained in the plugin code.

// Memory footprint might also impact performance:
// Note that the criterions plugin size and performance (see @req_performance) for plugin system technologies are differentiated here.
// However in practice a technology, where plugin sizes are generally larger, might also be slower due to the fact that a larger amount of data has to be transferred.

=== Plugin isolation
Often times plugins contain foreign code.
This is especially true for text editors, where plugins are often downloaded from a central registry, also known as plugin/extension marketplaces.
This means that plugins downloaded from such sources are usually not validated and thus should be treated as foreign code.
Even though there might be checks in place for malicious contents, foreign code should not be trusted to not access its host environment unless otherwise allowed.

For this work we define the property of plugin isolation to describe how isolated a plugin's environment is from its host environment.
While there has to be some kind of interface between both environments to make plugins accessible and usable, this interface must not be considered when evaluating plugin isolation.
Instead we define plugin isolation completely separated from the interface, meaning if an interface is unsafe by nature, plugin isolation is not automatically violated.

// Additional notes:
// One could even go a step further and consider plugins as untrusted code and adopt a zero trust strategy.
// A plugin system could employ a zero-trust strategy, where plugins are executed fully sandboxed and given permissions to certain interfaces only through the user.
// Then the plugin system could also monitor and analyze plugins and their behavior and warn or disable them when suspicious behavior is detected.

/ 0 -- No isolation, required elevated privileges: Plugins are not only not isolated from the host application, they also require certain elevated privileges, which the host application usually does not require by itself.
  \ _Worst case: Elevated privilege access to current system._
/ 1 -- No isolation: Plugins are not isolated from the host application.
  They inherit the host application's privileges without any attempt of the host plugin system to restrict these permissions.
  \ _Worst case: Plugins gain the same privileges as the host system, usually this means access to the current user's system and peripherals._
/ 2, 3 -- Restricted isolation: Plugins are not isolated from the host application by design.
  Normally the plugin would inherit the host application's privileges, however the host application makes an attempt to restrict plugins from accessing certain critical functionalities.
  Some examples for restrictions on Linux systems could be allowing only a specific subset of syscalls through `seccomp(2)`#footnote(link("https://www.man7.org/linux/man-pages/man2/seccomp.2.html")) or using `namespaces(7)`#footnote(link("https://www.man7.org/linux/man-pages/man7/namespaces.7.html")) to isolate and limit resources.
  However both of these examples do not use a sandboxing strategy for isolation.

  Because these restrictions can come in a various shapes and forms each based on different technologies, during evaluation either 2 or 3 can be chosen as a score.
  \ _Worst case: Plugins have similar privileges to that of the host application, except for those specifically disallowed. However this restriction might be able to be circumvented._ 
/ 4 -- Fully sandboxed, dynamic interface:
  Plugins generally run completely isolated.
  However their interface is not statically defined, which can lead to vulnerabilities of the interface during runtime due to higher complexity and risk of bugs.
  Imagine a scenario where a host application exposes only a single interface for passing serialized messages back and forth with a plugin.
  Then the host application has to serialize and deserialize those messages during runtime.
  For complex systems, where advanced concepts such as additional shared memory between the host and plugins are used, this interface can become susceptible to logic bugs due to the dynamic interface.
  \ _Worst case: Access to parts of the host application not meant to be exposed due to a bug in the interface._ // TODO: call this bypass, exploit?
/ 5 -- Fully sandboxed, static interface: The plugin runs fully sandboxed.
      It has no way of interacting with the host system, except for statically checked interfaces.
      Here statically checked interfaces refers to interfaces, that can be proven safe during compilation (or alternatively development) of the plugin system.
      One way to achieve this might be an interface definition in a common interface definition language.
      This restriction was chosen because it disallows plugin systems giving full access to parts of a host application without a proper interface definition.
  \ _Worst case: Indeterminable, a major bug in the sandboxing mechanism is required._

=== Plugin portability <crit-plugin-portability>

Portability stems from the field of distributed systems.
A high portability refers to software components, that can be moved from one distributed system A to another distributed system B without having to make any modifications@distributed.
This assumes that both systems A and B share a common interface for interaction to the software component@distributed.
In the context of plugin systems for text editors, portability can be interpreted in one of two different ways:
1. Every individual plugin is seen as a software component. This plugin is portable, if it can be loaded into two instances of the same text editor running on different platforms.
2. The entire plugin system itself is seen as a modular software component of a text editor. It is portable if it can be integrated into different text editors and run across different platforms.

This work considers only the first scenario, in which portability refers to each individual plugin, because this scenario is less extensive and the portability of individual plugins is easier to measure.
The following scores are used to measure plugin portability:

/ 0 -- Not portable: The plugin is not portable between different platforms.
  It is theoretically and practically impossible to run the plugin on different platforms.
/ 1 -- Theoretically portable: The plugin is theoretically portable between different platforms.
  In practice this might be very complex and costly, e.g. having to run each plugin in its own dedicated virtual machine.
/ 2,3,4 -- Portable with a runtime: The plugin is portable between different platforms, but it requires a runtime on the target platform.
  Because these runtimes can vary from one plugin system to another, a score range from 2 to 4 is specified here.
  During evaluation the specific runtime has to be analyzed regarding its complexity and impact on the host system.
  A more lightweight runtime could also enable higher portability of the plugin system itself as described in @crit-plugin-portability.
/ 5 -- Portable by design: The plugin is portable between different platforms without requiring a runtime on each host application.
  In practice this is very hard to achieve.
  Advanced technologies such as fat binaries, which are binaries that encapsulate compiled machine code for multiple different architectures, might be necessary. 

Note that the most extreme scores 0 and 5 are very unlikely for any imaginable plugin system.
0 requires a plugin not to be portable at all, while 5 requires that a plugin is portable to different platforms and architectures which is near impossible to implement on a technical level.

// === Adaptability of the interface

// Maintained software is never completely static.
// Software receives updates for new features, fixes for bugs or refactorings for already existing features.
// When software integrates a plugin system, the plugin system must provide the host software with extensible and easy to use interfaces to not harm the development process of given host software.

// This criterion is used to rate how adaptable a plugin technology is regarding its interface between the host- and plugin environment.
// It describes whether there is much work needed to extend interfaces with new features or change existing features.

=== Plugin language interoperability

Text editors and their plugin systems are highly individual software.
Some users have personal preferences e.g. keybindings, macros or color schemes, while others may require tools such as language servers for semantic highlighting and navigation, or tools to compile and flash a piece of software onto an embedded device.

A lot of times plugin systems are used to overcome this challenge of high configurability.
Major text editors and IDEs such as Neovim, VSCode, Emacs, IntelliJ or Eclipse provide plugin systems, some even in-built plugins.
The advantage of implementing features as plugins is the reduced code complexity and size of the host application.
Also providing a plugin systems with a publicly documented interface allows every user and developer to implement their own plugins for their own needs.

This property describes how interoperable plugins written in different languages are.
In other words, the larger the set of languages is, in which a plugin can be written for a given plugin system technology, the better its plugin language interoperability is.
The more languages are available, the less effort it requires for users to develop their own plugins without the need of learning a new (possibly domain-specific) programming language.

One could argue, that supporting a variety of different languages can result in higher interface complexity and less adaptability to new changes.
Even though the complexity and adaptability of interfaces is another important property, which deserves its own rating, it will not be covered in this work.

/ 0 -- Domain-specific custom language: Only a domain-specific language can be used to write plugins in.
  This language is specifically designed for given plugin system technology, which is why it is the least interoperable and might be the most unfamiliar and hardest for developers to learn and use.
/ 1 -- One language: A single general purpose programming language is supported to write plugins in.
  There might be some developers who are already familiar with the language.
/ 2 -- Multiple languages: A set of multiple languages is supported to write plugins in.
  The plugin system is able to abstract over multiple different plugin languages, so that the host application has only a single interface to communicate with plugins regardless of their specific language used.
/ 3 -- Build target for some languages: The plugin system supports a compilation target for plugins, that is targeted by multiple compilers for multiple programming languages.
  For example the Java bytecode is a compilation target for the Java, Kotlin and Scala compilers.
/ 4 -- Build target for a variety of languages: The plugin system supports a compilation target for plugins, that is targeted by a variety of different languages.
  This score differs from the previous score, that this score's compilation target is targeted by a considerably higher number of languages with more differences between them.
  Differences between languages could include dynamic vs. static typing, weak vs. strong typing, interpretation vs. just-in-time compilation vs. ahead-of-time compilation.
/ 5 -- Universal build target: The plugin system supports a compilation target to which most software can be compiled directly, or which can be embedded indirectly by a compiled runtime.
  For example all source code is eventually compiled to native ISA instructions specific to some hardware and platform.
  Thus it is also theoretically possible to package source code such as Python or JavaScript source code and combine it with their specific runtimes inside a native plugin.

== Technology comparison of existing plugin system technologies
This section chooses appropriate plugin system technologies and software projects implementing a plugin system.
Then the previously defined criteria will be evaluated for chosen technologies and projects.

// #todo[What is this section about?] \
// #todo[Why is a technology comparison important for the work of this paper?]
// #todo[explain the methodology for evaluation: e.g. analysis of code, documentation, papers?]

=== Overview of chosen technologies
An important step during a technology comparison is the correct selection of technologies.
When choosing technologies, one has to be careful to not introduce any bias towards certain technologies.
This work mainly focuses on plugin systems for text editors, so text editor plugin systems will be the majority of technologies.
However it could also be interesting to compare text editor plugin system technologies to plugin system technologies for other applications.

To make an appropriate decision for text editor projects, the popularity of different text editors will be as a metric for selection.
As a source for the most popular text editors and integrated development environments (IDEs), the StackOverflow Developer Survey 2024 will be used@stackoverflow-survey.
The platform StackOverflow is known as a forum for developers helping each other by asking questions and exchanging information regarding various technical topics such as programming languages, certain APIs, technologies, etc.
Annually it organizes a survey open to all developers regardless of their background to gather statistics about used programming languages, salaries of developers, used development tools, etc.
In 2024 a total amount of \~65.000 developers took part in this survey, which is why it can be considered fairly representative.
The four most popular text editors and integrated development environments (IDEs) according to the survey are the following.
They are described and also considered for evaluation in this work:
/ 1. Visual Studio Code: Visual Studio Code (abbreviated as VS Code) is a text editor designed for "coding".
  It provides built-in basic features such as a terminal, version control or themes #footnote(link("https://code.visualstudio.com/")).
  However it does not provide built-in integration for specific programming languages or technologies.
  In VS Code a lot of features are instead packaged as plugins (here: extensions) written in JavaScript which can be installed from a central marketplace.
  VS Code itself is also written in JavaScript.
  It is chosen for evaluation in this work, because it has successfully implemented a plugin system able to integrate a broad spectrum of plugins ranging from simple plugins for coloring brackets to highly complex plugins such as programming language integrations or plugins enabling interactive jupyter notebooks.

/ 2. Visual Studio (not evaluated here): Visual Studio is an IDE, that is describes itself as "the most comprehensive IDE for .NET and C++ developers on Windows"#footnote("https://visualstudio.microsoft.com/").
  It is not to be confused with Visual Studio Code, as Visual Studio provides more built-in features for developing, debugging, testing and collaboration between developers#footnote("https://visualstudio.microsoft.com/vs/features/").
  It also allows users to install plugins (here: extensions) written in C\# from a central marketplace.
  However due to personal unfamiliarity with this IDE and the C\# programming language together with the .NET ecosystem, this IDE will not be evaluated in this work.

/ 3. IntelliJ-family: Intellij IDEA is an editor made by Jetbrains for development of JVM-based languages such as Java or Kotlin#footnote(link("https://www.jetbrains.com/idea/")).
  According to the StackOverflow developer survey, it is ranked as the third-most popular IDE.

  IntelliJ's so called "Community Edition" is freely available and open-source, however Jetbrains also develops proprietary alternatives for other use cases.
  In fact most of these alternatives such as CLion for C/C++ development or WebStorm for web development are also based on the IntelliJ framework. 
  There are also third-party IDEs built upon the IntelliJ IDEA such as Android Studio for development of Android apps.

  IntelliJ provides a plugin system where plugins can be written in Java or Kotlin, that can be used from all IDEs based on the IntelliJ framework.
  Thus the IntelliJ IDEA is not listed as a single IDE here, but rather a family of various IDEs all based on the same framework using the same plugin system technology.

/ 4. Notepad++: Notepad++ is an open-source text editor focused around minimalism and efficiency#footnote(link("https://notepad-plus-plus.org/")).
  The editor itself is written in C++ with support for the Windows operating system exclusively.
  It provides a plugin system for loading plugins in the form of dynamically linked libraries (DLLs)#footnote(link("https://npp-user-manual.org/docs/plugins/")).

Besides these text editors and IDEs, this work also evaluates plugin system technologies for one other application types.
A lot of projects were considered, however due to their similarity to already chosen technologies or due to missing documentation they were disregarded:

/ VST3 for music production: During music production in a digital audio workstation, producers use plugins to simulate a variety of different audio effects or even entire instruments.
  One notable standard used for for these kinds of plugins is the VST3 standard@vst3. #td
  It specifies the interface between the digital audio workstation as the host application and a plugin which applies some effects or produces an audio signal.
  VST3 also specifies #td
  - What technology does it use? #td

/ Microsoft Flight Simulator (not evaluated here): #td
  - Microsoft flight simulator (has a Wasm plugin system) [lacks documentation, is not free/open-source]
  - Bietet unterschiedliche SDKs: WASM, JS, SimConnect SDK (?), SimVars (?)

/ #td (not evaluated here): #td

==== VSCode
#td

==== IntelliJ-based IDEs
#td


==== Zellij
Zellij is a terminal workspace (similar to a terminal multiplexer).
It is used to manage and organize many different terminal instances inside one terminal emulator process.
Similar commonly known terminal multiplexers are Tmux, xterm or the Windows Terminal.

- plugin system to allow users to add new features
- plugin system is not very mature https://zellij.dev/documentation/plugin-system-status
- Wasm for plugins, however only Rust is supported
- Permission system
#td

// - WASM mit WASI Unterstützung 
// - API unabhängig von der Sprache mit Protobuf (Message-basiertes System, https://protobuf.dev/)
// - Permission System gruppiert Events & Commands zusammen

=== Summary <technology-comparison-matrix>
#todo[Present findings in a table]
#todo[
  What could have been done better?

  - Complexity and adaptability of the interface
]
#todo[Which other technologies and criteria might also be interesting? Which ones were left out?]