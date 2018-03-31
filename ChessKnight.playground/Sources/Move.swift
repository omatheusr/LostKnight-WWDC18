import Foundation

public struct Move {
    // MARK: - Properties
    public let x : Int
    public let y : Int
    
    // MARK: - Initializers
    public init(x _x: Int, y _y: Int) {
        x = _x
        y = _y
    }
    public init(from: Position, to: Position) {
        x = from.row - to.row
        y = from.column - to.column
    }
}
extension Move : Equatable {
    public static func == (lhs: Move, rhs: Move) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
