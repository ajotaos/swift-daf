import Bytes

private let bigEndiannessRawValue = "BIG-IEEE"
private let littleEndiannessRawValue = "LTL-IEEE"

extension Endianness: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case bigEndiannessRawValue:
            self = .big
        case littleEndiannessRawValue:
            self = .little
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .big:
            return bigEndiannessRawValue
        case .little:
            return littleEndiannessRawValue
        }
    }
}
