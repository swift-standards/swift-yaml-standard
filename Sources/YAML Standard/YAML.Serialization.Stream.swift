// Licensed under Apache License v2.0.

extension YAML.Serialization {
    @frozen
    public struct Stream: Sendable, Equatable {
        public let events: [Event]

        public init(events: [Event]) {
            self.events = events
        }
    }
}
