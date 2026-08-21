extension YAML.Schema {
    @frozen
    public enum Identifier: Sendable, Equatable, Hashable {
        case failsafe
        case json
        case core
    }
}
