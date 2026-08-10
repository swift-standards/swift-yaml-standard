// Licensed under Apache License v2.0.

extension YAML.Presentation {
    @frozen
    public enum Directive: Sendable, Equatable, Hashable {
        case version(YAML.Version)
        case tag(handle: String, prefix: String)
        case reserved(name: String, parameters: [String])
    }
}
