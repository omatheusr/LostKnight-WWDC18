import Foundation


public class Position {
    // MARK: - Operators
    public static func + (lhs: Position, rhs: Move) -> Position {
        return Position(row: lhs.row + rhs.x, column: lhs.column + rhs.y)
    }
    public static func + (lhs: Move, rhs: Position) -> Position {
        return Position(row: rhs.row + lhs.x, column: rhs.column + lhs.y)
    }
    
    // MARK: - Properties
    public let row : Int
    public let column : Int
    
    public weak var previousPosition : Position?
    
    // MARK: - Computable variables
    public var isValid : Bool {
        return !(row < 0) && (row < Config.sizeOfMap) && !(column < 0) && (column < Config.sizeOfMap)
    }
    
    public var isCorner : Bool {
        return (row == 0) || (column == 0) || (row == Config.sizeOfMap-1) || (column == Config.sizeOfMap-1)
    }
    
    public var rowIdentifier : String {
        if row == (Config.sizeOfMap-1) || row == 0 {
            return "@"
        } else if let unicode = UnicodeScalar(64 + row) {
            return String(describing: unicode)
        }
        return "error"
    }
    public var columnIdentifier : String {
        if column == (Config.sizeOfMap-1) || column == 0 {
            return "@"
        }
        return "\(column)"
    }
    
    public var rcIdentifier : String {
        return "\(rowIdentifier)\(columnIdentifier)"
    }
    
    public var rcNumericIdentifier : String {
        return "(\(row),\(column))"
    }
    
    
    // MARK: - Initializers
    public init (row r: Int, column c: Int) {
        row = r
        column = c
    }
    
    // MARK: - Object functions
    public func getValidPositionsForMoves(moves : [Move]) -> [Position] {
        var positions : [Position] = []
        for move in moves {
            let nPos = self + move
            if nPos.isValid {
                positions.append(nPos)
            }
        }
        return positions
    }
    public func getPathToPositionWithMove(_ move: Move) -> [Position] {
        
        var positions : [Position] = []
        
        var x = move.x
        var y = move.y
        
        let moveAxis : (_ n : inout Int)->() = { n in
            while (n != 0) {
                positions.append(Position(row: self.row - x, column: self.column - y))
                if n > 0 { n -= 1 } else { n += 1 }
            }
        }
        
        if abs(y) > abs(x) {
            moveAxis(&x)
            moveAxis(&y)
        } else {
            moveAxis(&y)
            moveAxis(&x)
        }
        
        positions.reverse()
        
        return positions
    }
    
    public static func getRandomValidPosition() -> Position {
        var rand : Position!
        repeat {
            rand = Position(row: Int.getRandom(from: 0, to: Config.sizeOfMap-1), column: Int.getRandom(from: 0, to: Config.sizeOfMap-1))
        } while !rand.isValid || rand.isCorner
        return rand
    }
    public static func getRandomValidPosition(otherThan: Position) -> Position {
        var rand : Position!
        repeat {
            rand = Position.getRandomValidPosition()
        } while rand == otherThan
        return rand
    }
}

extension Position : Equatable {
    public static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
}
extension Position : Hashable {
    public var hashValue: Int {
        guard let h = Int("\(row)\(column)") else { return -1 }
        return h
    }
}

