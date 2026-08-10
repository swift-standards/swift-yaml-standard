// Licensed under Apache License v2.0.

extension YAML.Serialization {
    @frozen
    public struct Anchor: Sendable, Equatable, Hashable {
        public let name: String

        public init(_ name: String) {
            self.name = name
        }
    }
}
