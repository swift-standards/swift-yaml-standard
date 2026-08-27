public import Graph_Sequential

extension YAML.Representation.Node {
    @frozen
    public enum Kind: Sendable, Equatable {
        case scalar(String)
        case sequence([Identifier])
        case mapping([YAML.Representation.Mapping.Entry])
    }
}
