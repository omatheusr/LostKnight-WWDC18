import SpriteKit

public class Chessboard : SKSpriteNode {
    // MARK: - Chessboard Items
    private var _possibleMovesHighlights : [Position : SKShapeNode] = [:]
    private var _endPositionHighlight : SKShapeNode?
    
    public let tiles : [[Tile]]
    
    // MARK: - Initializers
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    required public init(rows: Int, columns: Int) {
        
        // Instantiate all board tiles
        var t : [[Tile]] = []
        for r in 0..<rows{
            t.insert([], at: r)
            for c in 0..<columns{
                t[r].insert(Tile(row: r, column: c), at: c)
            }
        }
        tiles = t
        
        // Initiate Chessboard
        let texture = SKTexture()
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        // Place all tiles in the chessboard
        for tilesRow in tiles {
            for tile in tilesRow {
                addChild(tile)
            }
        }
    }
    
    convenience public init(rowsAndColumns rc: Int) {
        self.init(rows: rc, columns: rc)
    }
    
    // MARK: - Subscripts
    public subscript(row: Int) -> [Tile] {
        return tiles[row]
    }
    
    public subscript(row: Int, column: Int) -> Tile {
        return tiles[row][column]
    }
    
    public subscript(pos: Position) -> Tile {
        return tiles[pos.row][pos.column]
    }
    
    // MARK: - Status Handlers
    public func reset() {
        removePossibleMovesHighlights()
        removeDestinationHighlight()
    }
    
    // MARK: - Highlights Animations
    // MARK: * Hint Move
    public func animateHintForPosition(_ position: Position) {
        let actions : [SKAction] = [SKAction.fadeAlpha(to: 0, duration: 0.5),
                                    SKAction.wait(forDuration: 1),
                                    SKAction.fadeAlpha(to: 0.1, duration: 0.5)]
        let actionsForHint : [SKAction] = [SKAction.fadeAlpha(to: 0.3, duration: 0.5),
                                           SKAction.wait(forDuration: 1),
                                           SKAction.fadeAlpha(to: 0.1, duration: 0.5)]
        
        for (hPosition, highlight) in _possibleMovesHighlights {
            if hPosition != position {
                highlight.run(SKAction.sequence(actions))
            } else {
                highlight.run(SKAction.sequence(actionsForHint))
            }
        }
    }
    
    // MARK: * Possible Moves
    public func addPossibleMovesHighlights(positions: [Position]) {
        for p in positions where !p.isCorner {
            
            let shape = SKShapeNode(path: Config.tilePath)
            shape.fillColor = UIColor.green
            shape.alpha = 0
            
            self[p].addChild(shape)
            
            _possibleMovesHighlights[p] = shape
            
            shape.removeAllActions()
            shape.run(SKAction.fadeAlpha(to: 0.1, duration: 0.5))
        }
    }
    
    public func removePossibleMovesHighlights() {
        for highlight in _possibleMovesHighlights.values {
            highlight.removeAllActions()
            highlight.run(SKAction.fadeOut(withDuration: 0.5), completion: {
                highlight.removeFromParent()
            })
        }
        _possibleMovesHighlights.removeAll()
    }
    
    // MARK: * Destination Highlight
    public func addDestinationHighlight(position: Position) {
        if let _ = _endPositionHighlight { return }
        
        let shape = SKShapeNode(path: Config.tilePath)
        shape.fillColor = UIColor.red
        shape.alpha = 0
        
        _endPositionHighlight = shape
        self[position].addChild(shape)
        
        shape.removeAllActions()
        shape.run(SKAction.fadeAlpha(to: 0.2, duration: 0.5))
    }
    
    public func removeDestinationHighlight() {
        guard let endPositionHighlight = _endPositionHighlight else { return }
        endPositionHighlight.removeAllActions()
        endPositionHighlight.run(SKAction.fadeOut(withDuration: 0.5), completion: {
            endPositionHighlight.removeFromParent()
        })
        _endPositionHighlight = nil
    }
}
