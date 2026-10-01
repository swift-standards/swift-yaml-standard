import Testing
import YAML_Standard

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
}
