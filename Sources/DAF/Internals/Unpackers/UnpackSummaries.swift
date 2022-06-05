import SystemPackage

func unpackSummaries(fileRecord: File.Record, descriptor: FileDescriptor) throws -> [Summary] {
    var summaries: [Summary] = []

    var summaryRecordNumber = fileRecord.initialSummaryRecordNumber
    while summaryRecordNumber != 0 {
        let nameRecordNumber = summaryRecordNumber + 1

        let summaryRecordBuffer = try descriptor.readDAFRecord(number: summaryRecordNumber)
        let nameRecordBuffer = try descriptor.readDAFRecord(number: nameRecordNumber)

        let nextSummaryRecordNumber = Int(
            summaryRecordBuffer.readDAFDoublePrecision(
                fromOffset: 0, endianness: fileRecord.endianness))
        defer { summaryRecordNumber = nextSummaryRecordNumber }

        let summariesCount = Int(
            summaryRecordBuffer.readDAFDoublePrecision(
                fromOffset: 16, endianness: fileRecord.endianness))

        let summaryByteCount =
            8 * fileRecord.doublePrecisionComponentsCount + 4 * fileRecord.integerComponentsCount
        let summaryByteStride =
            summaryByteCount + (summaryByteCount.isMultiple(of: 8) ? 0 : (8 - 8 % summaryByteCount))

        let summaryByteOffsets = stride(
            from: 24, to: 24 + summaryByteStride * summariesCount, by: summaryByteStride)
        let nameByteOffsets = stride(
            from: 0, to: summaryByteStride * summariesCount, by: summaryByteStride)

        for (summaryByteOffset, nameByteOffset) in zip(summaryByteOffsets, nameByteOffsets) {
            let doublePrecisionComponentsByteOffset = summaryByteOffset
            let doublePrecisionComponents = Array(
                summaryRecordBuffer.readDAFDoublePrecisions(
                    fromOffset: doublePrecisionComponentsByteOffset,
                    count: fileRecord.doublePrecisionComponentsCount,
                    endianness: fileRecord.endianness))

            let integerComponentsByteOffset =
                doublePrecisionComponentsByteOffset + 8 * doublePrecisionComponents.count
            let integerComponents = Array(
                summaryRecordBuffer.readDAFIntegers(
                    fromOffset: integerComponentsByteOffset,
                    count: fileRecord.integerComponentsCount - 2, endianness: fileRecord.endianness)
            )

            let initialElementAddressByteOffset =
                integerComponentsByteOffset + 4 * integerComponents.count
            let initialElementAddress = summaryRecordBuffer.readDAFInteger(
                fromOffset: initialElementAddressByteOffset, endianness: fileRecord.endianness)

            let finalElementAddressByteOffset = initialElementAddressByteOffset + 4
            let finalElementAddress = summaryRecordBuffer.readDAFInteger(
                fromOffset: finalElementAddressByteOffset, endianness: fileRecord.endianness)

            guard
                let name = nameRecordBuffer.readString(
                    fromOffset: nameByteOffset, count: fileRecord.characterComponentsCount,
                    decoder: .isoLatin1)
            else { throw Error.decodingFailed }

            summaries.append(
                .init(
                    record: .init(
                        name: name, doublePrecisionComponents: doublePrecisionComponents,
                        integerComponents: integerComponents,
                        initialElementAddress: initialElementAddress,
                        finalElementAddress: finalElementAddress), fileRecord: fileRecord,
                    descriptor: descriptor))
        }
    }

    return summaries
}
