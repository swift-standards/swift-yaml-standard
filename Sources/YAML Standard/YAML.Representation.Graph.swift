public import Graph_Sequential_Primitives

extension YAML.Representation {
    public struct Graph: Sendable {
        public let root: Node.Identifier
        private let storage: Graph_Sequential_Primitives.Graph.Sequential<Node, Node>

        public init(root: Node.Identifier, nodes: [Node]) throws(Error) {
            guard root.isValid(in: nodes) else { throw .invalidRoot(root) }
            for node in nodes {
                switch node.kind {
                case .scalar:
                    break

                case .sequence(let identifiers):
                    guard identifiers.allSatisfy({ $0.isValid(in: nodes) }) else {
                        throw .invalidReference
                    }

                case .mapping(let entries):
                    guard
                        entries.allSatisfy({
                            $0.key.isValid(in: nodes) && $0.value.isValid(in: nodes)
                        })
                    else { throw .invalidReference }
                }
            }
            var builder = Graph_Sequential_Primitives.Graph.Sequential<Node, Node>.Builder()
            for node in nodes {
                _ = builder.allocate(node)
            }
            self.root = root
            self.storage = builder.build()
        }
    }
}

extension YAML.Representation.Graph {
    public subscript(
        identifier: YAML.Representation.Node.Identifier
    ) -> YAML.Representation.Node? {
        guard identifier < storage.count.map(Ordinal.init) else {
            return nil
        }
        return storage[identifier]
    }
}
