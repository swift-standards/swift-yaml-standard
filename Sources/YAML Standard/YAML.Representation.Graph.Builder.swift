public import Graph_Sequential

extension YAML.Representation.Graph {
    public struct Builder: Sendable {
        private var nodes: [YAML.Representation.Node?]

        public init() {
            nodes = []
        }
    }
}

extension YAML.Representation.Graph.Builder {
    public mutating func reserve() -> YAML.Representation.Node.Identifier {
        let identifier = YAML.Representation.Node.Identifier(
            _unchecked: Ordinal(UInt(nodes.count))
        )
        nodes.append(nil)
        return identifier
    }

    public mutating func define(
        _ identifier: YAML.Representation.Node.Identifier,
        as node: YAML.Representation.Node
    ) throws(YAML.Representation.Graph.Error) {
        guard let current = identifier.value(in: nodes) else { throw .invalidReference }
        guard current == nil else { throw .duplicateDefinition(identifier) }
        guard identifier.replace(node, in: &nodes) else { throw .invalidReference }
    }

    public consuming func finalize(
        root: YAML.Representation.Node.Identifier
    ) throws(YAML.Representation.Graph.Error) -> YAML.Representation.Graph {
        var complete: [YAML.Representation.Node] = []
        complete.reserveCapacity(nodes.count)
        for (position, node) in nodes.enumerated() {
            guard let node else {
                throw .incompleteNode(.init(_unchecked: Ordinal(UInt(position))))
            }
            complete.append(node)
        }
        return try YAML.Representation.Graph(root: root, nodes: complete)
    }
}
