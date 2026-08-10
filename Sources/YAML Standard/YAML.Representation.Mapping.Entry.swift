// Licensed under Apache License v2.0.

public import Graph_Sequential_Primitives

extension YAML.Representation.Mapping {
    @frozen
    public struct Entry: Sendable, Equatable {
        public let key: YAML.Representation.Node.Identifier
        public let value: YAML.Representation.Node.Identifier

        public init(
            key: YAML.Representation.Node.Identifier,
            value: YAML.Representation.Node.Identifier
        ) {
            self.key = key
            self.value = value
        }
    }
}
