extension YAML {
    @frozen
    public enum Tag: Sendable, Equatable, Hashable {
        case nonSpecific
        case string
        case sequence
        case mapping
        case null
        case boolean
        case integer
        case floating
        case global(String)
    }
}
