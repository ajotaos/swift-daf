import Bytes
import SystemPackage

private let dafRecordByteCount = 1_024

extension FileDescriptor {
    func readDAFRecord(number: Int, retryOnInterrupt: Bool = true) throws
        -> ByteBuffer
    {
        try read(
            fromAbsoluteOffset: .init(dafRecordByteCount * (number - 1)), count: dafRecordByteCount,
            retryOnInterrupt: retryOnInterrupt)
    }

    func readDAFElements(fromAddress initialAddress: Int, count: Int, retryOnInterrupt: Bool = true)
        throws -> ByteBuffer
    {
        try read(
            fromAbsoluteOffset: .init(8 * (initialAddress - 1)), count: 8 * count,
            retryOnInterrupt: retryOnInterrupt)
    }

    private func read(fromAbsoluteOffset offset: Int64, count: Int, retryOnInterrupt: Bool = true)
        throws -> ByteBuffer
    {
        var buffer = ByteBuffer(capacity: count)

        _ = try buffer.writeWithUnsafeMutableBytes(
            count: count,
            {
                try read(
                    fromAbsoluteOffset: .init(offset), into: $0, retryOnInterrupt: retryOnInterrupt)
            })

        return buffer
    }
}
