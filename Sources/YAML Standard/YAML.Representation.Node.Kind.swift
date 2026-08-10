// Licensed under Apache License v2.0.

public import Graph_Sequential_Primitives

extension YAML.Representation.Node {
    @frozen
    public enum Kind: Sendable, Equatable {
        case scalar(String)
        case sequence([Identifier])
        case mapping([YAML.Representation.Mapping.Entry])
    }
}
