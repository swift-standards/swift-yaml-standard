// Licensed under Apache License v2.0.

extension YAML.Schema {
    @frozen
    public enum Identifier: Sendable, Equatable, Hashable {
        case failsafe
        case json
        case core
    }
}
