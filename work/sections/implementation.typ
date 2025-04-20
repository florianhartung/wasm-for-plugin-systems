#import "../wip.typ": todo, td
#import "../util.typ": flex-caption

= Proof of concept: Implementing a WebAssembly plugin system for a text editor
The first part of this work did a technology comparison to find out if Wasm is feasible as a technology for plugin systems.
In this second part, a basic proof of concept for a Wasm plugin system will be implemented for a text editor.
To make this process as realistic as possible, to learn as much as possible from this implementation, a text editor that is already being used today by developers will be used.

The text editor chosen is the Helix editor (#link("https://helix-editor.com/")).
It is a terminal-based text editor written in Rust with controls similar to Vim, however it provides more features out of the box.
Currently the Helix editor is missing an official plugin system, although there are some community-driven projects trying to implement plugin systems.

== Requirements
This section presents the requirements for the plugin system and plugins.
It divides the requirements into functional and non-functional, to distinguish between the what the system should do and how it should do it.
Also a list of non-requirements is presented to put constraints on the complexity of this proof of concept.

=== Functional
/ Plugin metadata: Plugins shall contain metadata in some form.
    This is required, so that users can view information about plugins such as their name, version, description, etc.
/ Plugin loading: Plugins are loaded by the plugin system at startup.
    Additional dynamic loading of plugins at runtime is not required to reduce complexity.
/ Modification of editor state: Plugins shall be able to modify the program state of the core editor.
    For this proof of concepts, 2-3 different interface features should be exposed to every plugin.
    // - 2-3 interface functions suffice: logging, set_status, insert char at current cursor location
/ Invocation through event hooks: The plugin system shall allow plugins to register event hooks.
    Event hooks are functions of a plugin, that get invoked by the plugin system on certain events in the core editor.
    For this proof of concept 2-3 different event hooks suffice.
    // Plugins shall support event hooks for: key presses, startup, saving of buffers

=== Non-functional
/ Plugins as self-contained WASM files: Plugins shall exist only as fully self-contained WASM files.
    They do not come with additional resources or metadata and require no dependencies during runtime.
    This limits the complexity of the plugin system, as no inter-plugin dependencies are necessary.
    // Also it requires no new file 
/ Sandboxed plugin execution: The execution of plugins must be fully sandboxed.
    Plugins may only access those interfaces provided to it by the plugin system.
    This is a key requirements for a possible implementation of a permission system, where plugins can only access permissions explicitly granted by the user.

=== Non-requirements
/ No complex interfaces: This proof of concept is not required to allow plugins access to complex interfaces such as GUIs due to time constraints.
/ No system calls: Usually plugins need access to the system such as file system access, networking, or random number generation.
    These interfaces are defined by the WASI specification.
    However this proof of concept is not required to provide WASI access to plugins for simplicity.
/ No production-readiness: The implemented system is not required to be production-ready.
    Thus no time-intensive tasks such as unit testing, coverage, or benchmarking for optimal solutions are required.

== System Architecture

#figure(image("../images/wasm_plugin_loading.drawio.png", width: 80%),
caption: flex-caption([
        Dataflow diagram for the process of loading \*.wasm files into a Wasm runtime and storing it in the main editor state.
        The instantiated plugins inside the Wasm runtime contain additional data such as the linear memory, tables, or the program stack.
    ], [
        Dataflow for loading Wasm plugins
    ])
) <runtime-plugin-loading>

This section describes the architecture and technologies used for the Wasm plugin system and plugins.
Even though a minimal proof of concept is implemented, it is still important to choose the technologies used carefully, so that the minimal system can represent more complex Wasm plugin systems as well as possible.
This proof of concept is used to determine, whether Wasm and the technologies in its current ecosystem are ready for use and if they can be scaled up to larger software projects.

As the base technology the Wasm Component Model (see @component-model) is chosen.
It offers great plugin language interoperability, while also building on top of Wasm's rather basic type system.
It allows the plugin interface to be specified in the WIT language, which scales well for larger real-world systems, where the plugin interface might become very complex.

The core editor project then defines a single WIT definition containing the entire interface for plugins consisting of type definitions, imports and exports.
Plugins consist of individual Wasm components, which must implement this WIT definition.

@runtime-plugin-loading shows the dataflow for how plugins are loaded into the editor.
A plugin loader component reads the Wasm Component files and loads them into a Wasm runtime.
The Wasm runtime contains objects such as the linear memory, tables or a stack for every Wasm module/component.
While instantiating plugins, the plugin loader also makes sure that each plugin implements an interface according to the WIT definition.
Finally, the Wasm runtime is stored in the core editor state, which is used by helix for providing access to the editor context from most points in the program.

The design for allowing plugins to modify the core editor state and event hooks are rather straightforward.
Modification of the core editor state works by exposing functions to the Wasm components by defining them as imports in the WIT definition.
Event hooks on the other hand work by having each plugin export one function per event type by defining them as exports in the WIT definition.
These functions are then called by the core editor, each time a certain point in the program is reached.

== Implementation
#figure(
    ```wit
    package helix:plugin;

    interface types {
        record plugin-metadata {
            name: string,
            version: string,
            description: string,
            keywords: list<string>,
        }
        enum log-level {
            info,
            warn,
            error,
        }
    }
    world base {
        use types.{log-level, plugin-metadata};

        export get-metadata: func() -> plugin-metadata;
        export initialize: func();

        import log: func(level: log-level, msg: string);
        import set-editor-status: func(msg: string);
        import get-text-selection: func() -> option<string>;
    }
    world keyevents {
        export handle-key-press: func(input: char);
    }
    world modify-buffers {
        import write: func() -> result<_, string>;
        import close-buffer: func() -> result<_, string>;
    }
    ```,
    caption: flex-caption([
        The entire WIT definition for all plugin interfaces.
        For more complex interfaces it should be divided into multiple files to modularize feature sets.
    ], [
        WIT definition with all interfaces for the developed WebAssembly plugin system
    ]),
) <full-wit-definition>

#figure(
    ```wit
    package component:my-example-plugin;

    world my-example-plugin {
        include helix:plugin/base;
        include helix:plugin/keyevents;
        include helix:plugin/modify-buffers;
    }

    ```,
    caption: flex-caption([
        A WIT definition for a single plugin.
        It defines a single world `my-example-plugin` as the plugin's interface and reexports/includes a subset of the worlds defined in the main package `helix:plugin` defined in @full-wit-definition.
    ], [
        WIT definition for a single example Wasm plugin
    ])
) <plugin-wit-definition>
This section provides an insight into chosen parts of the implementation of the Wasm plugin system.
It outlines the choices made during implementation, the technologies used for implementation and the challenges faced.

A central part of the implementation is the Wasm runtime.
It is used as a library for loading and interacting with Wasm components.
For this proof of concept the official Wasmtime runtime is chosen.
It is the official reference implementation for the Wasm specification, providing better support for newer features such as the Wasm Component Model than other runtimes.
Also it supports WASI, which may be useful for future testing on this project.
Both the Helix editor and the Wasmtime library are written in the Rust, which is why this proof of concept is also fully implemented in Rust.

@full-wit-definition shows the main WIT definition for the plugin interface.
It defines a WIT package called `helix:plugin`, which contains one WIT interface and three WIT worlds.
The WIT interface is used here to define complex types, which are then imported and used in the worlds.
Normally this WIT definition would specify a single world, which contains all the imported and exported functions required for every plugin.
However in practice every plugin only uses a subset of all interfaces.
This is why the interface is split into three different worlds, all providing different feature sets to the plugin.
Here a base feature set called `base` is defined.
It must be implemented by all plugins.
Additionally two worlds `keyevents` and `modify-buffers` for allowing plugins to hook into key events and for allowing access to the state of currently opened buffers are defined.

With this modular approach of feature sets in place, every plugin can then define its own WIT definition containing a single world.
@plugin-wit-definition shows a world of such a plugin, which is now able to simply reexport the worlds of the main WIT definition by using the `include` statement.
This allows plugin developers to choose only a subset of features required by their plugin.
At runtime, the plugin system then iterates through all worlds and checks whether each world's interface is provided by the plugin.

During plugin development, after the developer has written their plugin WIT definition, a tool like `wit-bindgen`, `componentize-py` or `componentize-js` can be used to generate bindings or project skeletons, which adhere to the correct WIT interface.
// TODO example Rust code generated?

// - WIT specification
// - WIT plugin specification
// - then wit-bindgen or componentize-py/js for component binding generation
- challenges
    - Optional interfaces for Plugins using the Component Model
        - WIT language allow specification of world. This can be used for implementation of optional interfaces, where plugins can opt-in.
    - Plugin metadata: Plugins exporting a global symbol is possible, however the Component Model does not allow this.
        - Instead each plugin has to specify an additional function `get-metadata` which may not access the host editor state and is evaluated directly after plugins are loaded.

== Evaluation
#todo[Validate requirements]
#todo[Reevaluate criteria from Section 3. Here measurements for plugin sizes, performance and memory impact can be used.]
#todo[Summarize findings & challenges]

// Standard plugin definieren (z.b. textsuche für performance)
// Graph mit x geladenen Standard plugins für memory/performance