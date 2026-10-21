import Graph
public import Tagged

extension YAML.Representation.Graph {
    @frozen
    public enum Error: Swift::Error, Sendable, Equatable {
        case invalidRoot(YAML.Representation.Node.Identifier)
        case invalidReference
        case incompleteNode(YAML.Representation.Node.Identifier)
        case duplicateDefinition(YAML.Representation.Node.Identifier)
    }
}
