# swift-yaml-standard

Use this package when you are writing a YAML 1.2 parser, composer or emitter and need the standard's information models to target: the event stream of `YAML.Serialization.Stream` and the node graph of `YAML.Representation.Graph`. Build a graph with `YAML.Representation.Graph.Builder`. This package doesn't read or write YAML text. To parse YAML, use swift-yaml.

## Laws

- Nodes refer to each other by identifier, not by containment. A node can appear more than once in a collection and a collection can contain itself, and the graph keeps both as given.
- `YAML.Representation.Graph.Builder.reserve()` hands out an identifier before its node exists, so a node can refer to one defined later. Every reserved identifier must be defined exactly once: a second definition is refused, and `YAML.Representation.Graph.Builder.finalize(root:)` refuses a reserved identifier that was never defined.
- An identifier is only a position. Building a graph checks that the root and every sequence element, mapping key and mapping value is a position inside the graph, and nothing more. An identifier from another builder is refused only when its position is out of range.
- A mapping keeps its entries in the order given. It doesn't check that keys are unique, and the same node may be both key and value.
