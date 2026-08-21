extension YAML.Representation {
    @frozen
    public struct Node: Sendable, Equatable {
        public let tag: YAML.Tag
        public let kind: Kind

        public init(tag: YAML.Tag, kind: Kind) {
            self.tag = tag
            self.kind = kind
        }
    }
}
