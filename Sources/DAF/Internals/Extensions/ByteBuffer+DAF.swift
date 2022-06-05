import Bytes

extension ByteBuffer {
    init?(dafInteger: Int, endianness: Endianness = .host) {
        guard let number = UInt32(exactly: dafInteger) else { return nil }

        self.init(number: number, endianness: endianness)
    }

    mutating func writeDAFInteger(_ dafInteger: Int, endianness: Endianness = .host) -> Int? {
        guard let number = UInt32(exactly: dafInteger) else { return nil }

        return writeNumber(number, endianness: endianness)
    }

    mutating func writeDAFInteger(
        toOffset offset: Int, _ dafInteger: Int, endianness: Endianness = .host
    ) -> Int? {
        guard let number = UInt32(exactly: dafInteger) else { return nil }

        return writeNumber(toOffset: offset, number, endianness: endianness)
    }

    mutating func readDAFInteger(endianness: Endianness = .host) -> Int {
        .init(readNumber(endianness: endianness, as: UInt32.self))
    }

    func readDAFInteger(fromOffset offset: Int, endianness: Endianness = .host) -> Int {
        .init(readNumber(fromOffset: offset, endianness: endianness, as: UInt32.self))
    }
}

extension ByteBuffer {
    init(dafDoublePrecision: Double, endianness: Endianness = .host) {
        self.init(number: dafDoublePrecision, endianness: endianness)
    }

    mutating func writeDAFDoublePrecision(_ dafDoublePrecision: Int, endianness: Endianness = .host)
        -> Int
    {
        writeNumber(dafDoublePrecision, endianness: endianness)
    }

    mutating func writeDAFDoublePrecision(
        toOffset offset: Int, _ dafDoublePrecision: Int, endianness: Endianness = .host
    ) -> Int {
        writeNumber(toOffset: offset, dafDoublePrecision, endianness: endianness)
    }

    mutating func readDAFDoublePrecision(endianness: Endianness = .host) -> Double {
        readNumber(endianness: endianness)
    }

    func readDAFDoublePrecision(fromOffset offset: Int, endianness: Endianness = .host) -> Double {
        readNumber(fromOffset: offset, endianness: endianness)
    }
}

extension ByteBuffer {
    init?(dafIntegers: [Int], endianness: Endianness = .host) {
        var numbers: [UInt32] = []

        for dafInteger in dafIntegers {
            guard let number = UInt32(exactly: dafInteger) else { return nil }

            numbers.append(number)
        }

        self.init(numbers: numbers)
    }

    mutating func writeDAFIntegers(_ dafIntegers: [Int], endianness: Endianness = .host) -> Int? {
        var numbers: [UInt32] = []

        for dafInteger in dafIntegers {
            guard let number = UInt32(exactly: dafInteger) else { return nil }

            numbers.append(number)
        }

        return writeNumbers(numbers, endianness: endianness)
    }

    mutating func writeDAFIntegers(
        toOffset offset: Int, _ dafIntegers: [Int], endianness: Endianness = .host
    ) -> Int? {
        var numbers: [UInt32] = []

        for dafInteger in dafIntegers {
            guard let number = UInt32(exactly: dafInteger) else { return nil }

            numbers.append(number)
        }

        return writeNumbers(toOffset: offset, numbers, endianness: endianness)
    }

    mutating func readDAFIntegers(count: Int, endianness: Endianness = .host) -> Collection<Int> {
        readSlice(count: 4 * count).map(stride: 4, { .init(UInt32(bytes: $0, endianness: endianness)) })
    }

    func readDAFIntegers(fromOffset offset: Int, count: Int, endianness: Endianness = .host)
        -> Collection<Int>
    {
        readSlice(fromOffset: offset, count: 4 * count).map(stride: 4, { .init(UInt32(bytes: $0, endianness: endianness)) })
    }
}

extension ByteBuffer {
    init?(dafDoublePrecisions: [Double], endianness: Endianness = .host) {
        self.init(numbers: dafDoublePrecisions)
    }

    mutating func writeDAFDoublePrecisions(
        _ dafDoublePrecisions: [Int], endianness: Endianness = .host
    ) -> Int {
        writeNumbers(dafDoublePrecisions, endianness: endianness)
    }

    mutating func writeDAFDoublePrecisions(
        toOffset offset: Int, _ dafDoublePrecisions: [Int], endianness: Endianness = .host
    ) -> Int {
        writeNumbers(toOffset: offset, dafDoublePrecisions, endianness: endianness)
    }

    mutating func readDAFDoublePrecisions(count: Int, endianness: Endianness = .host) -> Collection<
        Double
    > {
        readNumbers(count: count, endianness: endianness)
    }

    func readDAFDoublePrecisions(fromOffset offset: Int, count: Int, endianness: Endianness = .host)
        -> Collection<Double>
    {
        readNumbers(fromOffset: offset, count: count, endianness: endianness)
    }
}
