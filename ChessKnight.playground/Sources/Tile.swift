import SpriteKit

public class Tile : SKSpriteNode {
    // MARK: - Properties
    public let pos : Position
    
    // MARK: - Initializers
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    required public init (row r: Int, column c: Int) {
        pos = Position(row: r, column: c)
        
        let texture = Tile.getTextureFor(row: r, column: c)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        position = Tile.getTilePointForPosition(pos)
        zPosition = 1000 - CGFloat((pos.row * 100) + pos.column)
        anchorPoint = CGPoint.zero
        
        // Draws the shape of the tile (for debug purposes)
        if Config.shouldDrawTilePath {
            let shape = SKShapeNode(path: Config.tilePath)
            shape.strokeColor = UIColor.blue
            shape.lineWidth = 1
            shape.position = CGPoint.zero
            addChild(shape)
        }
        
        // Adds labels (A, B, C...) to the corners
        if pos.isCorner {
            var cLabelPosition = CGPoint.zero
            var cLabelText = String()
            
            if (pos.row != 0 && pos.row != (Config.sizeOfMap-1) && pos.column == 0) {
                cLabelText = pos.rowIdentifier
                cLabelPosition = CGPoint(x: 18, y: 8)
            }else if (pos.row == 0 && pos.column != (Config.sizeOfMap-1) && pos.column != 0) {
                cLabelText = pos.columnIdentifier
                cLabelPosition = CGPoint(x: 46, y: 8)
            }
            
            if !cLabelText.isEmpty{
                let label = Resources.getLabel(text: cLabelText, size: 7, position: cLabelPosition, alpha: 0.25)
                 label.zPosition = 9999
                
                addChild(label)
            }
        }
    }
    
    // MARK: - Object functions
    public func contains(touch: UITouch) -> Bool {
        return Config.tilePath.contains(touch.location(in: self))
    }
    
    // MARK: - Static functions
    public static func getTilePointForPosition(_ pos: Position) -> CGPoint {
        let x = (pos.column * Config.sizeOfTile) - (pos.row * Config.sizeOfTile)
        let y = (Config.sizeOfTile/2 * pos.column) + (Config.sizeOfTile * pos.row) - (Config.sizeOfTile/2 * pos.row)
        
        return CGPoint(x: x, y: y)
    }
    
    private static func getTextureFor(row: Int, column: Int) -> SKTexture {
        switch (row, column) {
        case (let r, let c) where (r+c) == 0:
            return Resources.Image.tileCorner1.getTexture()
        case (let r, let c) where (r+c) == (Config.sizeOfMap-1) * 2:
            return Resources.Image.tileCorner2.getTexture()
        case (let r, let c) where r == (Config.sizeOfMap-1) && c == 0:
            return Resources.Image.tileCorner3.getTexture()
        case (let r, let c) where r == 0 && c == (Config.sizeOfMap-1):
            return Resources.Image.tileCorner4.getTexture()
            
        case (let r, _) where r == 0:
            return Resources.Image.tileSide1.getTexture()
        case (let r, _) where r == (Config.sizeOfMap-1):
            return Resources.Image.tileSide1.getTexture()
        case (_, let c) where c == 0:
            return Resources.Image.tileSide2.getTexture()
        case (_, let c) where c == (Config.sizeOfMap-1):
            return Resources.Image.tileSide2.getTexture()
            
        default:
            if (row+column) % 2 == 0 {
                return Resources.Image.tileGroundDark.getTexture()
            }else{
                return Resources.Image.tileGroundLight.getTexture()
            }
        }
    }
}
