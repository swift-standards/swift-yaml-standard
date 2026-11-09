import Graph
public import Tagged

extension YAML.Representation.Graph {
    @frozen
    public enum Error: Swift::Error, Sendable, Equatable {
        case invalidRoot(YAML.Representation.Node.Identifier)
        case invalidReference
        case incompleteNode(YAML.Representation.Node.Identifier)
        case duplicateDefinition(YAML.Representation.Node.Identifier)
        /// A mapping has two keys that are the same node, or equal nodes (YAML 1.2.2 §3.2.1.1).
        case duplicateKey(YAML.Representation.Node.Identifier)
    }
}
