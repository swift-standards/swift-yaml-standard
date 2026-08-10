// Licensed under Apache License v2.0.

extension YAML.Presentation {
    @frozen
    public enum Style: Sendable, Equatable, Hashable {
        case plain
        case singleQuoted
        case doubleQuoted
        case literal
        case folded
        case block
        case flow
    }
}
