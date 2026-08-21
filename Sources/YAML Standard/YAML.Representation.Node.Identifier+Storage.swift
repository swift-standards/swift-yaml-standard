private import Graph_Sequential_Primitives

extension YAML.Representation.Node.Identifier {
    package func isValid<Element>(in elements: [Element]) -> Bool {
        underlying < Ordinal(UInt(elements.count))
    }

    package func value<Element>(in elements: [Element]) -> Element? {
        isValid(in: elements) ? elements[Int(bitPattern: underlying)] : nil
    }

    package func replace<Element>(_ value: Element, in elements: inout [Element]) -> Bool {
        guard isValid(in: elements) else { return false }
        elements[Int(bitPattern: underlying)] = value
        return true
    }
}
