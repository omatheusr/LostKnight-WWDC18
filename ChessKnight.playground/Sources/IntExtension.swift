import Foundation

extension Int {
    public static func getRandom(from: Int, to: Int) -> Int {
        return from + Int(arc4random_uniform(UInt32(to-from)))
    }
    public static func getRandom(from: Int, to: Int, otherThan: Int) -> Int {
        var rand : Int!
        repeat {
            rand = Int.getRandom(from: from, to: to)
        } while rand == otherThan
        return rand
    }
}
