import SpriteKit

public class Config {
    // MARK: - Private configurations
    private static var _tilePath : CGPath?
    private static var _knightMoves : [Move]?
    
    // MARK: - Public configurations
    public static let presentation : String = "By: Matheus Rabelo 🙂"
    public static let title : String = "Lost Knight"
    public static let subtitle : String = "Help the knight reach his destination..."
    public static let youWin : String = "You win!"
    public static let youLose : String = "You lose!"
    
    public static let knightStartPosition : CGPoint = CGPoint(x: -16, y: 336)
    public static let sizeOfScreen : CGSize = CGSize(width: 640, height: 480)
    public static let sizeOfTile : Int = 32
    public static let sizeOfMap : Int = 10
    public static let shouldDrawTilePath : Bool = false
    
    // MARK: - Public access to private configurations (singletons)
    public static var tilePath : CGPath {
        guard let tilePath = Config._tilePath else {
            let path = CGMutablePath()
            
            path.move(to: CGPoint(x: 0, y: 24))
            path.addLine(to: CGPoint(x: 32, y: 40))
            path.addLine(to: CGPoint(x: 64, y: 24))
            path.addLine(to: CGPoint(x: 32, y: 8))
            path.closeSubpath()
            
            Config._tilePath = path
            return path
        }
        return tilePath
    }
    
    public static var knightMoves : [Move] {
        guard let knightMoves = Config._knightMoves else {
            let kMoves : [Move] = [
                Move(x:1 ,y:2),
                Move(x:-1 ,y:2),
                Move(x:2 ,y:1),
                Move(x:2 ,y:-1),
                Move(x:1 ,y:-2),
                Move(x:-1 ,y:-2),
                Move(x:-2 ,y:-1),
                Move(x:-2 ,y:1)
            ]
            Config._knightMoves = kMoves
            return kMoves
        }
        return knightMoves
    }
    
    // MARK: - ZPosition
    public class ZPosition {
        public static let board : CGFloat = 1000
        
        public static let knight : CGFloat = 1500
        
        public static let menu : CGFloat = 2000
        public static let menuOverlay : CGFloat = 2001
        public static let menuOverlayLabel : CGFloat = 2002
        public static let menuInfosBackground : CGFloat = 2003
        public static let menuInfosLabel : CGFloat = 2004
        public static let menuButtons : CGFloat = 2005
        public static let menuLabels : CGFloat = 2006
        
        
    }
}

