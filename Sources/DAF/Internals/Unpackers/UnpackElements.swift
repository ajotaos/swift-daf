import Bytes
import SystemPackage

func unpackElements(
    summaryRecord: Summary.Record, fileRecord: File.Record, descriptor: FileDescriptor
) throws -> AnyRandomAccessCollection<Double> {
    try .init(
        descriptor.readDAFElements(
            fromAddress: summaryRecord.initialElementAddress, count: summaryRecord.elementsCount
        ).readDAFDoublePrecisions(
            fromOffset: 0, count: summaryRecord.elementsCount, endianness: fileRecord.endianness))
}
