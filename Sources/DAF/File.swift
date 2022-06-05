import Bytes
import SystemPackage

public typealias IntegerComponent = UInt32
public typealias DoublePrecisionComponent = Double

public final class File {
    public var name: String { record.name }
    public var architecture: String { record.architecture }

    public var doublePrecisionComponentsCount: Int {
        record.doublePrecisionComponentsCount
    }
    public var integerComponentsCount: Int { record.integerComponentsCount }

    public var initialSummaryRecordNumber: Int { record.initialSummaryRecordNumber }
    public var finalSummaryRecordNumber: Int { record.finalSummaryRecordNumber }

    public var firstFreeAddress: Int { record.firstFreeAddress }

    public var endianness: Endianness { record.endianness }

    private let record: Record
    private let descriptor: FileDescriptor

    init(record: Record, descriptor: FileDescriptor) {
        self.record = record
        self.descriptor = descriptor
    }
}

extension File {
    public static func open(_ path: String) throws -> File {
        try .open(.init(path))
    }

    public static func open(_ path: FilePath) throws -> File {
        try unpackFile(
            descriptor: .open(
                path, .readWrite, options: [.create, .append], permissions: .ownerReadWrite))
    }

    public func close() throws {
        try descriptor.close()
    }
}

extension File {
    public func loadComments() throws -> String {
        try unpackComments(fileRecord: record, descriptor: descriptor)
    }

    public func loadSummaries() throws -> [Summary] {
        try unpackSummaries(fileRecord: record, descriptor: descriptor)
    }
}

extension File {
    public struct Record {
        public var name: String
        public var architecture: String

        public var doublePrecisionComponentsCount: Int
        public var integerComponentsCount: Int
        public var characterComponentsCount: Int {
            8 * (doublePrecisionComponentsCount + (integerComponentsCount + 1) / 2)
        }

        public var initialSummaryRecordNumber: Int
        public var finalSummaryRecordNumber: Int

        public var firstFreeAddress: Int

        public var endianness: Endianness

        public init(
            name: String, architecture: String, doublePrecisionComponentsCount: Int,
            integerComponentsCount: Int, initialSummaryRecordNumber: Int,
            finalSummaryRecordNumber: Int, firstFreeAddress: Int, endianness: Endianness
        ) {
            self.name = name
            self.architecture = architecture
            self.doublePrecisionComponentsCount = doublePrecisionComponentsCount
            self.integerComponentsCount = integerComponentsCount
            self.initialSummaryRecordNumber = initialSummaryRecordNumber
            self.finalSummaryRecordNumber = finalSummaryRecordNumber
            self.firstFreeAddress = firstFreeAddress
            self.endianness = endianness
        }
    }
}

extension File: CustomStringConvertible {
    public var description: String {
        """
        Contents of DAF File
        ==================================================================
        Internal Name (IFNAME):                 \(name)
        Architecture (IDWORD):                  \(architecture)
        # of Double Precision Components (ND):  \(doublePrecisionComponentsCount)
        # of Integer Components (NI):           \(integerComponentsCount)
        Initial Record Number (RI):             \(initialSummaryRecordNumber)
        Final Record Number (RF):               \(finalSummaryRecordNumber)
        First Free Address (FFA):               \(firstFreeAddress)
        Endianness:                             \(endianness.rawValue)
        ==================================================================
        """
    }
}
