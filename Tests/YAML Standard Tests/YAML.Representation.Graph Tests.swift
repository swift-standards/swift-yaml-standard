import Testing
import YAML_Standard

extension YAML.Representation.Graph {
    @Suite struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}

        @Test func `builder preserves a self cycle`() throws {
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            try builder.define(root, as: .init(tag: .sequence, kind: .sequence([root])))
            let graph = try builder.finalize(root: root)
            #expect(graph[root]?.kind == .sequence([root]))
        }

        @Test func `builder preserves shared identity`() throws {
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            let child = builder.reserve()
            try builder.define(root, as: .init(tag: .sequence, kind: .sequence([child, child])))
            try builder.define(child, as: .init(tag: .string, kind: .scalar("value")))
            let graph = try builder.finalize(root: root)
            #expect(graph[root]?.kind == .sequence([child, child]))
        }

        @Test func `builder rejects an incomplete node`() throws {
            var builder = YAML.Representation.Graph.Builder()
            let root = builder.reserve()
            #expect(throws: YAML.Representation.Graph.Error.incompleteNode(root)) {
                _ = try builder.finalize(root: root)
            }
        }
    }
}
