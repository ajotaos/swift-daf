import SystemPackage

func unpackComments(fileRecord: File.Record, descriptor: FileDescriptor) throws -> String {
    var comments = ""

    for commentRecordNumber in 2..<fileRecord.initialSummaryRecordNumber {
        let commentRecordBuffer = try descriptor.readDAFRecord(number: commentRecordNumber)

        guard
            let comment = commentRecordBuffer.readString(
                fromOffset: 0, count: 1_000, decoder: .isoLatin1)
        else { throw Error.decodingFailed }

        comments.append(contentsOf: comment)
    }

    let endIndex = comments.firstIndex(of: "\u{0004}") ?? comments.endIndex

    return comments[..<endIndex].replacingOccurrences(of: "\0", with: "\n").trimmingCharacters(
        in: .whitespacesAndNewlines)
}
