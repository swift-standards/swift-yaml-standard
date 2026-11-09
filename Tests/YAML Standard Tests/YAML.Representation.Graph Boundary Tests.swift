import Testing
import YAML_Standard

enum `YAML.Representation.Graph Boundary Tests` {}

extension `YAML.Representation.Graph Boundary Tests` {
    @Suite
    struct `Representation graph boundaries` {
        private static func scalar(_ text: String) -> YAML.Representation.Node {
            .init(tag: .string, kind: .scalar(text))
        }

        @Test
        func `defining a node twice is refused`() throws {
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            try builder.define(root, as: Self.scalar("a"))
            #expect(throws: YAML.Representation.Graph.Error.duplicateDefinition(root)) {
                try builder.define(root, as: Self.scalar("b"))
            }
        }

        @Test
        func `defining an identifier from another builder is refused`() {
            var other = YAML.Representation.Graph.Builder()
            _ = other.reserve()
            let foreign = other.reserve()
            var builder = YAML.Representation.Graph.Builder()
            _ = builder.reserve()
            #expect(throws: YAML.Representation.Graph.Error.invalidReference) {
                try builder.define(foreign, as: Self.scalar("x"))
            }
        }

        @Test
        func `a root outside the graph is refused`() throws {
            var other = YAML.Representation.Graph.Builder()
            _ = other.reserve()
            let foreign = other.reserve()
            var builder = YAML.Representation.Graph.Builder()
            let only = builder.reserve()
            try builder.define(only, as: Self.scalar("x"))
            #expect(throws: YAML.Representation.Graph.Error.invalidRoot(foreign)) {
                _ = try builder.finalize(root: foreign)
            }
        }

        @Test
        func `a dangling sequence element is refused`() throws {
            var other = YAML.Representation.Graph.Builder()
            _ = other.reserve()
            let foreign = other.reserve()
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            try builder.define(root, as: .init(tag: .sequence, kind: .sequence([foreign])))
            #expect(throws: YAML.Representation.Graph.Error.invalidReference) {
                _ = try builder.finalize(root: root)
            }
        }

        @Test
        func `a dangling mapping key is refused`() throws {
            var other = YAML.Representation.Graph.Builder()
            _ = other.reserve()
            _ = other.reserve()
            let foreign = other.reserve()
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            let value = builder.reserve()
            try builder.define(value, as: Self.scalar("v"))
            try builder.define(root, as: .init(tag: .mapping, kind: .mapping([.init(key: foreign, value: value)])))
            #expect(throws: YAML.Representation.Graph.Error.invalidReference) {
                _ = try builder.finalize(root: root)
            }
        }

        @Test
        func `a mapping whose key and value are the same node is kept`() throws {
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            let shared = builder.reserve()
            try builder.define(shared, as: Self.scalar("k"))
            try builder.define(root, as: .init(tag: .mapping, kind: .mapping([.init(key: shared, value: shared)])))
            let graph = try builder.finalize(root: root)
            #expect(graph[root]?.kind == .mapping([.init(key: shared, value: shared)]))
        }

        @Test
        func `a mapping with the same key node twice is refused`() throws {
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            let key = builder.reserve()
            let first = builder.reserve()
            let second = builder.reserve()
            try builder.define(key, as: Self.scalar("k"))
            try builder.define(first, as: Self.scalar("1"))
            try builder.define(second, as: Self.scalar("2"))
            try builder.define(
                root,
                as: .init(tag: .mapping, kind: .mapping([.init(key: key, value: first), .init(key: key, value: second)]))
            )
            #expect(throws: YAML.Representation.Graph.Error.duplicateKey(key)) {
                _ = try builder.finalize(root: root)
            }
        }

        @Test
        func `a mapping with two equal scalar keys is refused`() throws {
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            let a = builder.reserve()
            let b = builder.reserve()
            let value = builder.reserve()
            try builder.define(a, as: Self.scalar("k"))
            try builder.define(b, as: Self.scalar("k"))
            try builder.define(value, as: Self.scalar("v"))
            try builder.define(
                root,
                as: .init(tag: .mapping, kind: .mapping([.init(key: a, value: value), .init(key: b, value: value)]))
            )
            #expect(throws: YAML.Representation.Graph.Error.duplicateKey(b)) {
                _ = try builder.finalize(root: root)
            }
        }

        @Test
        func `a mapping with two equal sequence keys is refused`() throws {
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            let item = builder.reserve()
            let a = builder.reserve()
            let b = builder.reserve()
            try builder.define(item, as: Self.scalar("x"))
            try builder.define(a, as: .init(tag: .sequence, kind: .sequence([item])))
            try builder.define(b, as: .init(tag: .sequence, kind: .sequence([item])))
            try builder.define(
                root,
                as: .init(tag: .mapping, kind: .mapping([.init(key: a, value: item), .init(key: b, value: item)]))
            )
            #expect(throws: YAML.Representation.Graph.Error.duplicateKey(b)) {
                _ = try builder.finalize(root: root)
            }
        }

        @Test
        func `keys with equal text but different tags are distinct`() throws {
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            let a = builder.reserve()
            let b = builder.reserve()
            try builder.define(a, as: .init(tag: .string, kind: .scalar("1")))
            try builder.define(b, as: .init(tag: .integer, kind: .scalar("1")))
            try builder.define(
                root,
                as: .init(tag: .mapping, kind: .mapping([.init(key: a, value: a), .init(key: b, value: b)]))
            )
            let graph = try builder.finalize(root: root)
            #expect(graph[root]?.kind == .mapping([.init(key: a, value: a), .init(key: b, value: b)]))
        }
    }
}
