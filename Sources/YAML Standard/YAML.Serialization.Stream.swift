extension YAML.Serialization {
    @frozen
    public struct Stream: Sendable, Equatable {
        public let events: [Event]

        public init(events: [Event]) {
            self.events = events
        }
    }
}
