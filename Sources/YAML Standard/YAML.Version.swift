// Licensed under Apache License v2.0.

extension YAML {
    @frozen
    public struct Version: Sendable, Equatable, Hashable {
        public let major: UInt
        public let minor: UInt

        public init(major: UInt, minor: UInt) {
            self.major = major
            self.minor = minor
        }

    }
}

extension YAML.Version {
    public static let version12 = Self(major: 1, minor: 2)
}
