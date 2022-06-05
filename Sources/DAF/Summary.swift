import SystemPackage

public struct Summary {
    public var name: String { record.name }

    public var doublePrecisionComponents: [Double] { record.doublePrecisionComponents }
    public var integerComponents: [Int] { record.integerComponents }

    public var initialElementAddress: Int { record.initialElementAddress }
    public var finalElementAddress: Int { record.finalElementAddress }

    private let record: Summary.Record
    private let fileRecord: File.Record
    private let descriptor: FileDescriptor

    init(record: Summary.Record, fileRecord: File.Record, descriptor: FileDescriptor) {
        self.record = record
        self.fileRecord = fileRecord
        self.descriptor = descriptor
    }
}

extension Summary {
    public func loadElements() throws -> AnyRandomAccessCollection<Double> {
        try unpackElements(summaryRecord: record, fileRecord: fileRecord, descriptor: descriptor)
    }
}

extension Summary {
    public struct Record {
        public var name: String

        public var doublePrecisionComponents: [Double]
        public var integerComponents: [Int]

        public var initialElementAddress: Int
        public var finalElementAddress: Int

        public var elementsCount: Int { finalElementAddress - initialElementAddress + 1 }
    }
}

extension Summary: CustomStringConvertible {
    public var description: String {
        """
        Contents of DAF Summary
        ==================================================================
        Internal Name:                \(name)
        Double Precision Components:  \(doublePrecisionComponents)
        Integer Components:           \(integerComponents)
        Initial Element Address:      \(initialElementAddress)
        Final Element Address:        \(finalElementAddress)
        ==================================================================
        """
    }
}
