public import Graph
import Index
public import Tagged

extension YAML.Representation {
    public struct Graph: Sendable {
        public let root: Node.Identifier
        private let storage: Graph::Graph.Sequential<Node, Node>

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
            for node in nodes {
                guard case .mapping(let entries) = node.kind else { continue }
                for (position, entry) in entries.enumerated() {
                    for earlier in entries[..<position]
                    where Self.equal(earlier.key, entry.key, in: nodes) {
                        throw .duplicateKey(entry.key)
                    }
                }
            }
            var builder = Graph::Graph.Sequential<Node, Node>.Builder()
            for node in nodes {
                _ = builder.allocate(node)
            }
            self.root = root
            self.storage = builder.build()
        }
    }
}

extension YAML.Representation.Graph {
    private static func equal(
        _ left: YAML.Representation.Node.Identifier,
        _ right: YAML.Representation.Node.Identifier,
        in nodes: [YAML.Representation.Node]
    ) -> Bool {
        var assumed: [(YAML.Representation.Node.Identifier, YAML.Representation.Node.Identifier)] = []
        return equal(left, right, in: nodes, assuming: &assumed)
    }

    private static func equal(
        _ left: YAML.Representation.Node.Identifier,
        _ right: YAML.Representation.Node.Identifier,
        in nodes: [YAML.Representation.Node],
        assuming assumed: inout [(YAML.Representation.Node.Identifier, YAML.Representation.Node.Identifier)]
    ) -> Bool {
        if left == right || assumed.contains(where: { $0.0 == left && $0.1 == right }) {
            return true
        }
        guard let first = left.value(in: nodes), let second = right.value(in: nodes),
            first.tag == second.tag
        else {
            return false
        }
        let mark = assumed.count
        assumed.append((left, right))
        let result: Bool
        switch (first.kind, second.kind) {
        case (.scalar(let a), .scalar(let b)):
            result = a == b

        case (.sequence(let a), .sequence(let b)):
            result =
                a.count == b.count
                && zip(a, b).allSatisfy { equal($0, $1, in: nodes, assuming: &assumed) }

        case (.mapping(let a), .mapping(let b)):
            result =
                a.count == b.count
                && a.allSatisfy { x in
                    b.contains { y in
                        equal(x.key, y.key, in: nodes, assuming: &assumed)
                            && equal(x.value, y.value, in: nodes, assuming: &assumed)
                    }
                }

        default:
            result = false
        }
        if !result {
            assumed.removeSubrange(mark...)
        }
        return result
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
