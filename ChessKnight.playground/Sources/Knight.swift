import SpriteKit

public protocol KnightDelegate : class {
    func knight(_ knight: Knight, willMoveFrom from: Position, to: Position)
    func knight(_ knight: Knight, didMoveTo to: Position)
}

public class Knight : SKSpriteNode {
    
    public weak var delegate : KnightDelegate?
    
    // MARK: - Properties
    private var _currentPosition : Position
    private var _isAnimating : Bool
    
    // MARK: - Computable variables
    public var currentPosition : Position { return _currentPosition }
    public var isAnimating : Bool { return _isAnimating }
    
    // MARK: - Initializers
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    required public init (initialPosition p: Position) {
        _currentPosition = p
        _isAnimating = false
        
        let texture = Resources.Image.knight1.getTexture()
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        anchorPoint = CGPoint.zero
        zPosition = Config.ZPosition.knight
        alpha = 0
    }
    
    
    // MARK: - Basic Functions
    public func reset(completion: @escaping ()->()) {
        teleportKnightTo(point: Config.knightStartPosition, completion: completion)
    }
    private func isValidMoveForPosition(_ position : Position) -> Bool{
        return position.isValid && !position.isCorner && Config.knightMoves.contains(where: { return $0 == Move(from: currentPosition, to: position) })
    }
    
    
    
    // MARK: - Knight Position Functions
    public func setPosition(_ newPosition: Position, force: Bool = false, completion: (()->())? = nil) {
        if force {
            teleportKnightTo(newPosition: newPosition, completion: completion)
        }else if isValidMoveForPosition(newPosition) {
            animateKnightMovesTo(newPosition: newPosition, completion: completion)
        }
    }
    // MARK: Autocomplete
    public func moveToPosition(_ newPosition : Position){
        var path = Knight.BFS(origin: currentPosition, destination: newPosition)
        path.removeFirst()
        
        var actions : [SKAction] = []
        var cPosition : Position = currentPosition
        
        for positionInPath in path {
            actions.append(SKAction.run({
                self.delegate?.knight(self, willMoveFrom: cPosition, to: positionInPath)
            }))
            actions.append(SKAction.wait(forDuration: 0.15))
            actions += getActionsForMovesToPosition(positionInPath, from: cPosition)
            actions.append(SKAction.run({
                self._currentPosition = positionInPath
                self.delegate?.knight(self, didMoveTo: positionInPath)
            }))
            actions.append(SKAction.wait(forDuration: 1))
            
            cPosition = positionInPath
        }
        
        removeAllActions()
        run(SKAction.sequence(actions))
    }
    
    // MARK: Move Knight
    private func animateKnightMovesTo(newPosition: Position, completion: (()->())? = nil){
        if _isAnimating { return }
        
        delegate?.knight(self, willMoveFrom: currentPosition, to: newPosition)
        animateMovesToPosition(newPosition, completion:{
            [weak self] in
            defer { completion?() }
            guard let knight = self else { return }
            
            knight._currentPosition = newPosition
            knight.delegate?.knight(knight, didMoveTo: newPosition)
        })
    }
    
    // MARK: Teleport Knight
    private func teleportKnightTo(newPosition: Position, completion: (()->())? = nil) {
        if _isAnimating { return }
        
        var point = Tile.getTilePointForPosition(newPosition)
        point.y += 11
        
        delegate?.knight(self, willMoveFrom: currentPosition, to: newPosition)
        teleportKnightTo(point: point, completion: { [weak self] in
            defer { completion?() }
            
            guard let knight = self else { return }
            knight._currentPosition = newPosition
            knight.delegate?.knight(knight, didMoveTo: newPosition)
        })
    }
    private func teleportKnightTo(point: CGPoint, completion: @escaping ()->()) {
        if _isAnimating { return }
        _isAnimating = true
        
        fadeWithAction({ [weak self] in
            guard let knight = self else { return }
            knight.position = point
        }, completion: { [weak self] in
            defer { completion() }
            
            guard let knight = self else { return }
            knight._isAnimating = false
        })
    }
    
    
    // MARK: - Animations
    private func fadeWithAction(_ action : @escaping ()->(), completion: @escaping ()->()){
        let sequence = SKAction.sequence([
            SKAction.fadeAlpha(to: 0, duration: 0.7),
            SKAction.run(action, queue: DispatchQueue.main),
            SKAction.fadeAlpha(to: 1, duration: 0.7),
            SKAction.run(completion, queue: DispatchQueue.main)
            ])
        
        removeAllActions()
        run(sequence)
    }
    private func animateMovesToPosition(_ newPosition: Position, completion: @escaping ()->()) {
        if _isAnimating { return }
        _isAnimating = true
        
        delegate?.knight(self, willMoveFrom: currentPosition, to: newPosition)
        
        // Create knight animation of movement for valid position
        let actions : [SKAction] = getActionsForMovesToPosition(newPosition, from: currentPosition)
        
        removeAllActions()
        run(SKAction.sequence(actions), completion: { [weak self] in
            defer { completion() }
            
            guard let knight = self else { return }
            knight._isAnimating = false
        })
    }
    private func getActionsForMovesToPosition(_ newPosition: Position, from: Position) -> [SKAction] {
        let move = Move(from: from, to: newPosition)
        let path = from.getPathToPositionWithMove(move)
        
        var actions : [SKAction] = []
        var nextPoint : CGPoint = CGPoint.zero
        
        for positionInPath in path {
            nextPoint = Tile.getTilePointForPosition(positionInPath)
            nextPoint.y += 11
            
            actions.append(SKAction.move(to: nextPoint, duration: 0.5))
        }
        
        return actions
    }
    
    // MARK: - BFS Algorithm
    public static func BFS(origin: Position, destination: Position) -> [Position] {
        
        var visited : [Position : Bool] = [:]
        var queue : [Position] = []
        var path : [Position] = []
        
        queue.append(origin)
        
        while !queue.isEmpty {
            let currentPosition = queue.removeFirst()
            
            if currentPosition == destination {
                var p : Position? = currentPosition
                while let pos = p {
                    path.append(pos)
                    p = pos.previousPosition
                }
                
                path.reverse()
                return path
            }
            
            if let _ = visited[currentPosition] { continue }
            visited[currentPosition] = true
            
            for kMove in Config.knightMoves {
                let newPos = currentPosition + kMove
                if newPos.isValid && !newPos.isCorner {
                    newPos.previousPosition = currentPosition
                    queue.append(newPos)
                }
            }
        }
        return path
    }
}
