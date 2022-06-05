import DAF
import Foundation

do {
    if let path = Bundle.main.path(forResource: "de421", ofType: "bsp") {
        let file = try File.open(path)
        print(file)
        print()

        print(try file.loadComments())
        print()

        for summary in try file.loadSummaries() where summary.integerComponents[3] == 2 {
            print(summary)
            
            let elements = try summary.loadElements()
            let directory = Array(elements[elements.index(elements.endIndex, offsetBy: -4)...])
            print(directory)
        }

        try file.close()
    }
} catch {
    print(error)
}
