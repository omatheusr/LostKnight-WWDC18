import Foundation

public protocol GameplayDelegate : class {
    func gameplay(_ gameplay: Gameplay, didUpdatePositions positions: [Position])
    func gameplay(_ gameplay: Gameplay, didUpdateState state: Gameplay.State)
}

public class Gameplay {
    public enum State {
        case instantiated
        case starting
        case started
        case stopped
        case autosolving
        case won
        case failed
    }
    
    public weak var delegate : GameplayDelegate?
    
    // MARK: - Properties
    public let startPosition : Position
    public let destinationPosition : Position
    
    public var state : State {
        didSet {
            if state == oldValue { return }
            delegate?.gameplay(self, didUpdateState: state)
        }
    }
    
    private var _neededMoves : Int = 0
    private var _positions : [Position] {
        didSet {
            guard let currentPosition = currentPosition else { return }
            
            _neededMoves = Knight.BFS(origin: currentPosition, destination: destinationPosition).count-1
            
            delegate?.gameplay(self, didUpdatePositions: _positions)
            
            // Update status according to position (Won/Failed)
            if currentPosition == destinationPosition {
                state = .won
            } else if currentPosition != destinationPosition && (_positions.count > maxMoves || neededMoves > (maxMoves-(_positions.count-1))) {
                state = .failed
            }
        }
    }

    
    // MARK: - Computable variables
    public let minMoves : Int
    public var maxMoves : Int { return (minMoves-1) * 2 }
    public var neededMoves : Int { return _neededMoves }
    
    public var positions : [Position] { return _positions }
    public var currentPosition : Position? { return _positions.last }
    
    
    // MARK: - Initializers
    public init() {
        state = .instantiated
        startPosition = Position.getRandomValidPosition()
        destinationPosition = Position.getRandomValidPosition(otherThan: startPosition)
        
        minMoves = Knight.BFS(origin: startPosition, destination: destinationPosition).count
        
        _positions = []
    }
    
    // MARK: - Positions Handler Functions
    public func addPosition(_ pos: Position) {
        _positions.append(pos)
    }
}
