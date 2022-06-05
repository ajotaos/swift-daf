import Bytes
import BytesFoundationCompatibility
import SystemPackage

private let ftpValidationString = "FTPSTR:\r:\n:\r\n:\r\u{0000}:\u{0081}:\u{0010}\u{00ce}:ENDFTP"

func unpackFile(descriptor: FileDescriptor) throws -> File {
    let fileRecordBuffer = try descriptor.readDAFRecord(number: 1)

    guard
        let architecture = fileRecordBuffer.readString(
            fromOffset: 0, count: 8, decoder: .isoLatin1)?.trimmingCharacters(
                in: .whitespacesAndNewlines)
    else { throw Error.decodingFailed }

    guard architecture.starts(with: "DAF/") else { throw Error.unknownArchitecture }

    guard
        let ftpString = fileRecordBuffer.readString(fromOffset: 699, count: 28, decoder: .isoLatin1)
    else { throw Error.decodingFailed }

    guard ftpString == ftpValidationString else { throw Error.ftpValidationFailed }

    guard
        let name = fileRecordBuffer.readString(fromOffset: 16, count: 60, decoder: .isoLatin1)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
    else { throw Error.decodingFailed }

    guard
        let endianness = fileRecordBuffer.readString(fromOffset: 88, count: 8, decoder: .isoLatin1)
            .flatMap({ Endianness(rawValue: $0) })
    else { throw Error.decodingFailed }

    let doublePrecisionComponentsCount = fileRecordBuffer.readDAFInteger(
        fromOffset: 8, endianness: endianness)
    let integerComponentsCount = fileRecordBuffer.readDAFInteger(
        fromOffset: 12, endianness: endianness)

    let initialSummaryRecordNumber = fileRecordBuffer.readDAFInteger(
        fromOffset: 76, endianness: endianness)
    let finalSummaryRecordNumber = fileRecordBuffer.readDAFInteger(
        fromOffset: 80, endianness: endianness)

    let firstFreeAddress = fileRecordBuffer.readDAFInteger(fromOffset: 84, endianness: endianness)

    return .init(
        record: .init(
            name: name, architecture: architecture,
            doublePrecisionComponentsCount: doublePrecisionComponentsCount,
            integerComponentsCount: integerComponentsCount,
            initialSummaryRecordNumber: initialSummaryRecordNumber,
            finalSummaryRecordNumber: finalSummaryRecordNumber, firstFreeAddress: firstFreeAddress,
            endianness: endianness), descriptor: descriptor)
}
