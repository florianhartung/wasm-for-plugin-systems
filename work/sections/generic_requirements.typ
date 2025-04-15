#import "../wip.typ": todo, td
#import "../util.typ": flex-caption, stacked-bar-chart

= Technology comparison of existing plugin systems
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

// == A technology comparison between existing plugin systems
// This section chooses appropriate plugin system technologies and software projects implementing a plugin system.
// Then the previously defined criteria will be evaluated for chosen technologies and projects.


== Choice of technologies & projects
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
/ 1. Visual Studio Code: Visual Studio Code (abbreviated as VS Code) is a text editor designed for software development.
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

/ 4. Notepad++: Notepad++ is an open-source text editor focused around minimalism and efficient software#footnote(link("https://notepad-plus-plus.org/")).
  The editor itself is written in C++ with exclusive support for the Windows operating system.
  It provides a plugin system for loading plugins in the form of dynamically linked libraries (DLLs)#footnote(link("https://npp-user-manual.org/docs/plugins/")).

Besides these text editors and IDEs, this work also evaluates plugin system technologies for other application types.
Multiple projects and technologies were considered, however due to their similarity to already chosen technologies, missing documentation and time-constraints for this work most of them were disregarded:

/ VST3 for music production: During music production in a digital audio workstation, producers use plugins to simulate a variety of different audio effects, entire instruments or traditional analog devices such as compressors.
  One notable standard used for for these kinds of plugins is the open and free Virtual Studio Technology (VST) 3 standard developed by Steinberg@vst3.
  It specifies a standard for technology on how to implement a plugin system technology between a digital audio workstation (DAW) as the host application and a plugin which applies some effects or produces an audio signal.
  For example a DAW could sends an audio stream to some plugin, then the plugin could apply an effect such as a simple equalizer on the audio signal and return the signal back to the DAW.

  On the technical level VST3 plugins are DLLs on Windows, Mach-O Bundles on Mac and packages on Linux. The term package on Linux can have different meanings depending on the Linux distribution and package manager used.

  The company behind the VST3 standard also provides a software development kit (SDK) for the C++ programming language and an API for the C programming language.
/ Microsoft Flight Simulator (not evaluated here): Microsoft Flight Simulator is a simulator for aircraft with focus on ultra-realism#footnote(link("https://www.flightsimulator.com/")).
  It allows for a wide variety of aircraft, airports and systems such as advanced flight information panels.
  This is achieved by providing multiple software development kits (SDKs) for plugins (so called add-ons).
  These SDKs support plugin languages such as C, C++, .NET languages, JavaScript or WebAssembly#footnote(link("https://docs.flightsimulator.com/html/Programming_Tools/Programming_APIs.htm")).
  
  However this software project will not be evaluated in this work.
  It's source code is not publicly available, which makes analysis of its architecture harder.
  Also a paid license is required to make an appropriate evaluation possible.
/ Eclipse(not evaluated here): Eclipse is an IDE used during software development for a variety of programming languages.
  It features a plugin system where plugins are written in Java and a central marketplace for installing plugins.
  However Eclipse is not chosen for evaluation, because its plugin system is too similar to IntelliJ's.
  Also IntelliJ is more popular as an IDE @stackoverflow-survey and thus required to support a greater variety of plugins.

== Evaluations of technologies & projects
=== Visual Studio Code
/ Performance: In terms of performance Visual Studio Code performs reasonably well.
  It builds on web technologies, specifically Electron which utilizes the Chromium browser engine together with Node.js.
  VS Code is written in JavaScript, which still imposes some limitations compared to native applications such as pauses due to garbage collection or the single-threaded nature of Node.js modules#footnote(link("https://www.electronjs.org/docs/latest/tutorial/multithreading#native-nodejs-modules")).
  While JavaScript engines such as the V8 engine try to mitigate most issues, the performance of VS Code still remains slower and more memory-hungry than native alternative IDE and text editor applications written in C, C++, Rust, etc.

  Even though the overhead imposed could be considered small and VS Code and it's plugin system is quite fast for today's standards, its performance is still rated with a score of 3.
  This score is chosen, because VS Code performs below average but still acceptable in comparison to typical native applications.

#figure(
  stacked-bar-chart(
    (
      "VSIX-Manifest",
      "Package metadata",
      "Third-party packages",
      "Source code",
      "Other (binaries, resources, data)"
    ), (
      "rust-lang.rust-analyzer": (2800, 253000 + 159000, 1000000, 451000, 43000000),
      "ms-python.python": (3300, 74000, 3000000, 13000000, 30000000),
      "esbenp.prettier-vscode": (3200, 14000, 7000000, 3000000, 10500000),
      "sibiraj-s.scss-formatter": (2800, 3700, 8700000, 467000, 9400000),
      "vscodevim.vim": (2800, 45000, 0, 3200000, 4000000),
    ),
    category_colors: i => (orange, color.fuchsia, blue, green, gray).map(c => c.darken(20%)).at(i)
  ), caption: flex-caption([Plugin size distributions of selected VS Code plugins], [Plugin size distributions of selected VS Code plugins])
) <fig:size-distributions-vscode-plugins>
/ Plugin size: The average plugin size for VS Code plugins is highly variable.
  Most minimal plugins typically consist of JavaScript or TypeScript code and a JSON manifest file.
  However, more complex plugins can be significantly langer, for example plugins that bundle third-party libraries and dependencies or language servers.

  Because VS Code is based on web technologies, its plugins can also be used in web environments, where its dependencies have to be bundled, which can further increase plugin sizes.
  Though on average, the size of VS code plugins a lot due to the size of libraries and resources needed for specific use cases.

  @fig:size-distributions-vscode-plugins shows plugin sizes of various arbitrarily selected VS Code plugins.
  The largest plugin here is the rust-analyzer plugin with a size of 43MB.
  The smallest is the Vim emulation plugin with 4MB.
  The diagram also shows the distribution of different data types and their contribution to each plugin's total size.
  Here one can see that some plugins contain mostly other data, such as the rust-analyzer plugin which contains the binary rust language server.
  While other plugins make use of third-party packages such as external dependencies or libraries, such as the SCSS Formatter plugin, there are also plugins with a high share of source code such as the Vim emulation plugin.
  However for the evaluation of the average plugin size for the VS Code plugin system, other data such as resources, images and binaries must be left out, because this data varies from one plugin to another.
  Looking at the diagram, one can see, that the size of source code around the high KBs to the low MBs.
  Thus this plugin system technology is evaluated at a score of 3.

/ Plugin isolation: 
  // Not mentioned on purpose: no real permission system

  // VS Code based on web & JS
  VS Code provides a moderate level of plugin isolation.
  It is based on web technologies such as JavaScript.
  A lot of web technologies like JavaScript are designed to enable safe code execution on a client's browser.
  This is achieved through sandboxing, which means running an application in an isolated "sandbox", where the application cannot escape this sandbox.

  // However when running a host application and plugins together in a single sandbox, there is no isolation between those two anymore.
  VS Code runs all plugins (officially known as extensions) in separate extension host processes to isolate them from the main application@vscode-docs[sec. Extension runtime security].
  Also plugins do not gain direct access to the main editor's state such as the DOM tree.
  Instead only specific APIs are exposed to the extension host.

  However the extension host inherits the same permissions as the original VS Code application.
  This means that plugins running together in a process with the extension host may have full access to filesystems, peripherals or running processes.
  Because of this inheritance of permissions and the dynamic and flexible nature of JavaScript itself, malicious plugins are not necessarily restricted from accessing the main editor state.

  Thus VS Code's plugin isolation is evaluated at a score of 3.
  Plugins run isolated from the main application, however malicious plugins may be able to circumvent this isolation through the inherited host privileges.

/ Plugin portability:
  VS Code plugins are very portable.
  Since they are build on web technologies, that are required to be portable, plugins can run on various platforms, operating systems and architectures mostly without modifications.

  That said, plugins that rely on native binaries such as language servers, which are often compiled in advance and then shipped with the plugin, may require separate build for different platforms, reducing portability.

  In summary the portability of VS Code plugins is still very high, except for some edge cases, relying on native code, resulting in a plugin portability score of 4.

/ Plugin language interoperability:
  Plugin language interoperability describes how many programming languages may be used to develop plugins.
  VS Code only allows JavaScript or TypeScript, which builds on JavaScript with a type system, as plugin languages.

  - asm.js is subset of JS: acts as a compilation target for C/C++ with Emscripten
  - Also plugins may include native code. This allows them to ship compiled programs written in C, C++, Rust or entire compiled runtimes for languages such as Python.
  In such scenarios a plugin's JavaScript code could contains only glue code to forward function calls between the plugin core written in C, C++, Python, etc. and the VS Code host application.

  While it is possible to write parts of VS Code extensions in other languages than JavaScript or TypeScript, the complexity of such plugins may increase rapidly.
  However following a strict evaluation for VS Code's plugin system, it receives a score of 1, because the plugin system always requires plugins to contain some JavaScript code, even if it is just glue code.

=== IntelliJ-family
/ Performance: 
  IntellIj IDEs also perform reasonably well.
  Both the IDE, as well as its plugin system and plugins are written in languages targeting the Java Virtual Machine (JVM).
  That is, languages such as Java, Kotlin or Scala, which are optimized and compiled to Java bytecode by their respective compilers.
  This Java bytecode can then be executed by the JVM.
  During execution the JVM can apply additional optimizations and generate native machine code for execution for example through optimizing Just-in-time (JIT) compilation, only then when it is needed.

  Even though JVMs are highly complex systems with loads of mechanisms for optimization, they still introduce some overhead.
  Also they are responsible for holding the state of programs during runtime and for garbage collecting no longer used object instances.

  Thus the performance of plugin systems and plugins based on the JVM, will not be able to outperform native non garbage-collected approaches.
  This plugin system technology, as it is used in IntelliJ-based IDEs is rated with an average performance score of 3.

  // - IntelliJ IDEs also perform reasonably well
  // - Both the IDE, its plugin system and plugins are build in languages executed inside the Java Virtual Machine (JVM)
  // - The execution lifecycle for Java or Kotlin code is as follows:
    // The javac or kotlinc compiler compiled source code to Java bytecode.
    // Then this Java bytecode can be loaded into a JVM and executed there.
    // During execution a JVM is allowed to perform optimizations such as using Just-in-time compilation for compiling the Java bytecode to native machine code only when it is needed.
  // - Even though JVMs can be highly complex systems, which are able to apply loads of optimizations, they still introduce some overhead due to other factors such as garbage collection.
  // - Thus the performance of Plugin systems and plugins based on the JVM, will not outperform native non-garbage-collected approaches, where source code is compiled to native machine code ahead of time.
  // - The plugin system as it is used in the IntelliJ-family is thus rated as average with a score of 3.
/ Plugin size:
  Plugin sizes for IntelliJ plugins also vary a lot.
  IntelliJ plugins are Java Archive (JAR) files, that can contain source code in the form of class files, resources or any arbitrary data.
  Small plugin JARs might contain only a few source files, while larger plugins might rely on various dependencies, which are all compiled and statically linked into the plugin JAR file.

  For IntelliJ plugins an extensive analysis of plugin size distributions was not possible due to the complexity of internal plugin structures.
  However some plugins were selected as examples for their total size: The official plugin for Rust language support has a size of 54MB, the official Python language support plugin 69MB and the Prettier formatter plugin has 508KB.
  Thus the average plugin size for the IntelliJ plugin system is evaluated at a score of 3.

/ Plugin isolation:
  Both the IntelliJ IDEs and plugins are written in JVM-based languages.
  No documentation or information was found on the security of IntelliJ plugins.
  Thus is it assumed, that IntelliJ plugins are loaded into the same JVM as the host IDE, inheriting the host's privileges.

  Because there are no isolation mechanisms in place, the plugin isolation of plugins for IntelliJ-based IDEs are evaluated at a score of 1.

/ Plugin portability:
  Since IntelliJ plugins are written in Java or other JVM-based languages, they benefit from Java's cross-platform portability.
  This allows plugins to run consistently across different environments.
  Because IntelliJ itself is build on the same technology, this enables every plugin to run on every platform, as long as plugins do not introduce platform-specific behavior such as relying on native binaries.
  Plugin portability is rated at a score of 4 for all IntelliJ-based IDEs, as Java bytecode is portable because the JVM is still required as a runtime on the target platform.

/ Plugin language interoperability:
  IntelliJ supports all plugins that can be compiled to Java bytecode, as long as they adhere to the IntelliJ Platform API, which can vary from one IntelliJ-based IDE to another.

  While only Java and Kotlin are officially supported, other JVM-based languages such as Groovy or Scala could also be used, as they also compile to Java bytecode.
  This plugin system, which supports one compilation target used by a variety of languages, is evaluated at a score of 4.

=== Notepad++
/ Performance:
  Notepad++ is written in C++ and compiled to native machine code for the Windows operating system exclusively.
  It tries to maximize efficiency and minimize the impact on the system it is running on.
  Its plugin system is based on compiled dynamically linked libraries (DLLs).
  A plugin developer compiles their plugin, which can be written in any arbitrary language, to a DLL, which is a library containing machine code and lists of imported and exported symbols.
  Notepad's plugin system can then load theses libraries at runtime via the `LoadLibrary` Win32-API call and execute arbitrary functions exported from the plugin.
  
  This is the fastest way for how host applications can embed plugins.
  It relies only on the operating system for loading already compiled machine code at runtime.
  There is no additional overhead except having to load the DLL itself into memory.
  Thus Notepad++'s plugin system is evaluated at a score of 5 for its optimal performance.

#figure(
  stacked-bar-chart(
    (
      "Machine code",
      "Resources",
      "Other",
    ), (
      "Lua language support": (314368, 122368, 443152),
      "Java language support": (243712, 146432, 394000),
      "Rust language support": (172032, 61952, 234496),
      "Converter between HEX/ASCII": (123904, 73728, 199024),
    ),
    category_colors: i => (orange, color.fuchsia, blue, green, gray).map(c => c.darken(20%)).at(i)
  ), caption: flex-caption([Plugin size distributions of selected Notepad++ plugins. They were analyzed by running `winedump` on a Linux system on the plugin DLL files. Then the `size of code` and `size of initialized data` fields were extracted to show here.], [Plugin size distributions of selected Notepad++ plugins])
) <fig:size-distributions-notepad-plugins>

/ Plugin size:
  Notepad++ uses DLLs as its plugin format, meaning plugins are compiled directly to machine code.
  These binaries may include statically linked libraries and dependencies, though some exceptions for example for `libc` might exist.
  @fig:size-distributions-notepad-plugins shows selected plugins and their total sizes and size distributions.
  The size distribution into machine code, resources and other data was extracted from the respective DLLs through use of `winedump` on a Linux system.
  The bar chart shows, that most data inside each plugin comes from machine code and not from any other resources or binaries.
  Given this analysis and plugin sizes being under 500KB for all plugins, a rating of 4 is assigned to this plugin system technology.
  This high rating is due to the compactness of machine code, which generally is generally minimized by compilers for better runtime performance already.
  In practice smaller binaries require less data transfer rates between the memory and the CPU and thus result in higher cache hit rates and better performance.

/ Plugin isolation:
  However Notepad++'s plugin isolation is rated poorly at a score of 1.
  Since Notepad++ loads plugins as dynamic libraries at runtime, these libraries inherit all privileges from the host editor.
  There is also no sandboxing in place, so plugins essentially run on the exact same level as the host editor.
  This is a severe risk, because the user has to trust both the plugin developer and also has to verify the integrity of a downloaded plugin.

/ Plugin portability:
  Plugin portability for Notepad++ plugins is rated at a score of 1.
  Notepad++ itself supports only Windows 8.1 - 11 as an operating system for multiple architectures #footnote(link("https://github.com/notepad-plus-plus/notepad-plus-plus/blob/master/SUPPORTED_SYSTEM.md")).
  Plugins have to be compiled and shipped for every supported architecture separately.
  Thus plugins are compatible in theory, because one could run plugins compiled for another architecture inside a virtual machine packaged as a plugin itself.
  However this is not feasible in practice due to performance losses and the complexity involved.

/ Plugin language interoperability:
  With native machine code as plugins, #box[Notepad++] allows for great plugin language interoperability.
  In practice it common to write plugins in languages that compile directly to machine code, such as C, #box[C++] or C\#.
  #box[Notepad++] provides official header files for the API to #box[Notepad++] for plugin development in #box[C++].
  There are also community-driven API definitions and templates for plugin development in Ada, C\#, D, Delphi or Ada available#footnote(link("https://npp-user-manual.org/docs/plugins/")).

  One can also argue, that every piece of software running today is eventually compiled to or interpreted as machine code.
  Thus it may be possible to embed higher-level technologies such as a Python runtime along with plugin logic written in Python inside a plugin.

  Because native machine code is a universal build target for all languages and technologies and the resulting versatility, this plugin system is rated at a score of 5 in terms of plugin language interoperability.

=== VST3
/ Performance:
  The VST3 standard for plugins that create or process audio relies on native machine code just like Notepad++.
  However it's file format also accommodates for the fact that plugins might be run on more than one platform.
  Internally a VST3 file embeds either a DLL for Windows plugins, a Mach-O bundle for MacOS plugins or generic packages for Linux plugins.

  During runtime a host application has to check whether a VST3 plugin contains machine code compiled for the current architecture.
  Then it is able to link the machine code at runtime through the operating system just like Notepad++ does.

  While there is a small overhead of checking if the targeted platform of a plugin is correct for loading a plugin, there is no overhead during execution of plugin code.
  Thus the VST3 technology is evaluated at a score of 5.

/ Plugin size:
  Because VST3 plugins are distributed as platform-specific binaries, their size can also remain relatively small comparable to #box[Notepad++'s] plugins.
  On the other hand, VST3 plugins often contain more resources such as images for providing the user with a graphical user interface.

  Depending on the specific use case, one could rate VST3 plugin sizes at a score of 3 or 4.
  However to enable objective comparison and VST3's strong similarity to Notepad++, plugin size is rated at a score of 4.

/ Plugin isolation:
  VST3 plugins are loaded as dynamic libraries just into the host's memory space inheriting privileges comparable to #box[Notepad++'s] plugin system.
  There is no isolation between the host application and VST3 plugins, which can be used by malicious plugins posing a significant risk to the end-user.
  Thus plugin isolation is rated at a score of 1.

/ Plugin portability:
  VST3 plugins itself are not portable.
  They are compiled for every architecture and operating system and then distributed separately.
  Even though the VST3 documentation states that the source code of plugins can be reused across multiple platforms, the plugin portability stays unaffected as this benefits just the plugin developer.
  The portability of VST3 plugins is therefore rated at a score of 1.

/ Plugin language interoperability:
  VST3's plugin language interoperability is also similar to that of the #box[Notepad++] plugin system technology.
  It's plugins are also based on native machine code, and thus it is possible in theory to compile or embed most technology into a plugin.
  However in practice it is more common for plugin developers to develop plugins with C++ using the official VST3 software development kit.
  The universality of the native binary format earns VST3 a rating of 5 for plugin language interoperability.

== Summary <technology-comparison-matrix>
#let c(n) = {
  let fill = gray
  let contents = [?]

  if n != none {
    let t = n / 5 * 100% // to ratio
    t = t * 55% // rescale to 20%..80%
    t = 100% - t // flip

    fill = gradient.linear(..color.map.turbo).sample(t)
    contents = [#n]
  }

  table.cell(fill: fill, contents)
}

#let header-rot(contents) = table.cell(
  stroke: none,
  inset: 1em,
  align(bottom,
    rotate(70deg,
      origin: start,
      reflow: true,
      [
        #set par(leading: 0.5em)
        #contents
      ]
    ))
  )

#let scores = (
  "Visual Studio Code": (3, 3, 3, 4, 1),
  "IntelliJ-family": (3, 3, 1, 4, 3),
  "Notepad++": (5, 4, 1, 1, 5),
  "VST3": (5, 4, 1, 1, 5),
  // "Wasm": (4, 3, 5, 4, 5),
  // "Wasm (Component Model, WASI)": (none, none, none, none, none),
  // "Wasm (custom serialization)": (none, none, none, none, none),
)

// WEIGHTING SCORE
// #let weights = (5, 3, 4, 5, 3)
// #let scores = scores.pairs().map(((k, v)) => {
//   if v.contains(none) {
//     (k, (..v, none))
//   } else {
//     let s = v.at(0) * weights.at(0) + v.at(1) * weights.at(1) + v.at(2) * weights.at(2) + v.at(3) * weights.at(3) + v.at(4) * weights.at(4)
//     let s = s / weights.sum()

//     (k, (..v, s))
//   }
// }).to-dict()

#figure(
  table(
    columns: 6, // set to 7 for weighting
    align: (right + horizon, center, center, center, center, center),
    table.header(table.cell(stroke: none, []), header-rot[Performance], header-rot[Plugin size], header-rot[Plugin isolation], header-rot[Plugin portability], header-rot[Plugin language\ interoperability]), //header-rot[Weighted score]),
    ..scores.pairs().map(((x, y)) => (table.cell(x), ..y.map(c))).flatten()
  ),
  caption: flex-caption([Technology comparison matrix for selected technologies and software projects], [Technology comparison matrix of existing technologies & projects])
) <technology-comparison-matrix-existing>

Three different plugin systems and one standard for a plugin system technology have been evaluated with the previously defined criteria.
The results can be seen in a technology comparison matrix in @technology-comparison-matrix-existing.
Here every technology row is evaluated across all five criteria, namely performance, plugin size, plugin isolation, plugin portability and plugin language interoperability.
Each criterion is rated on a scale from 0 (very poor) to 5 (excellent), however the smallest score that can be found here is 1.

// Key observations
*Visual Studio Code*'s plugin system performs with average scores of 3 across performance, plugin size and plugin isolation.
It provides good plugin portability from its usage of web technology, but is not able to provide a lot of plugin language interoperability due to the limitation to JavaScript/TypeScript.
The plugin system used in all *IntelliJ-based IDEs* achieves similar scores for performance and plugin size, however it does not provide any plugin isolation.
It is able to achieve the same plugin portability as VS Code and a higher score for plugin language interoperability because it allows any JVM-based languages for plugins.
*Nodepad++* is another text editor with efficiency in mind.
This shows, because it achieves the highest score for performance with plugin sizes that are negligible in practice.
However it provides terrible plugin isolation and plugin portability due to plugins consisting of natively compiled machine code.
On the other hand, native machine code also acts as a universal compilation target, allowing pretty much every other technology to be compiled into a plugin.
This allows for an optimal plugin language interoperability.
*VST3* is a standard for a plugin system technology.
It follows the same approach as Notepad++'s plugin system with native machine code inside its plugins.
Thus it achieves the same scores, although in practice the VST3 format is merely a wrapper around native machine code, providing additional features not considered here.

A critical examination of the earlier technology comparison is presented below, outlining possible improvements and other relevant criteria, not covered in this section.

In this section, some criteria, namely the average plugin size and performance, have been analyzed only qualitatively due to time constraints.
However, these criteria can and should be analyzed quantitatively to provide more accurate and verifiable results.
There are also criteria that may also be important for plugin systems in general, not covered here:
/ Complexity and flexibility of plugin system interface: Plugin systems with more flexible and dynamic interfaces without a fixed interface definition may enable faster development and testing of new features.
/ Developer experience: Developer experience could be used as a measure for how easy it is for developers to develop plugins.
/ Debuggability: Some technologies might be easier do debug and inspect during runtime.
  This allows plugin developers to spend less time searching for bugs, which then results in a faster plugin development.
/ Plugin system size: This section analyzed the average size of plugins.
  The size of entire plugin systems was not considered.
  However when plugins get smaller, the size of plugin systems could increase, due to logic being outsourced from plugins to the plugin system.
  Thus to optimally evaluate sizes, one should consider both the plugin size and plugin system size and not just rely on one.