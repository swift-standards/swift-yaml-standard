public import Lexer_Primitives

extension YAML.Serialization {
    @frozen
    public enum Event: Sendable, Equatable {
        case streamStart(Lexer.Position)
        case streamEnd(Lexer.Position)
        case documentStart(
            explicit: Bool,
            directives: [YAML.Presentation.Directive],
            mark: Lexer.Position
        )
        case documentEnd(explicit: Bool, mark: Lexer.Position)
        case scalar(
            content: String,
            anchor: Anchor?,
            tag: YAML.Tag,
            style: YAML.Presentation.Style,
            mark: Lexer.Position
        )
        case sequenceStart(
            anchor: Anchor?,
            tag: YAML.Tag,
            style: YAML.Presentation.Style,
            mark: Lexer.Position
        )
        case sequenceEnd(Lexer.Position)
        case mappingStart(
            anchor: Anchor?,
            tag: YAML.Tag,
            style: YAML.Presentation.Style,
            mark: Lexer.Position
        )
        case mappingEnd(Lexer.Position)
        case alias(Anchor, Lexer.Position)
    }
}
