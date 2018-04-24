import SpriteKit

public class Resources {
    
    // MARK: - Audio
    public static var audioNode : SKAudioNode {
        return SKAudioNode(fileNamed: "Sounds/Salgre.mp3")
    }
    public static var soundCrash : SKAction {
        return SKAction.playSoundFileNamed("Sounds/Crash.mp3", waitForCompletion: true)
    }
    public static var soundClosure : SKAction {
        return SKAction.playSoundFileNamed("Sounds/Closure.mp3", waitForCompletion: true)
    }
    
    // MARK: - Fonts & Labels
    public static var _registeredFonts : [Font] = []
    
    public enum Font : String {
        case lato           = "Lato-Bold"
        case lobster        = "Lobster Two"
        case lifeSavers     = "Life Savers"
        
        func fileName() -> String {
            switch self {
            case .lobster:      return "LobsterTwo-Regular"
            case .lifeSavers:   return "LifeSavers-Regular"
            default:            return self.rawValue
            }
        }
    }
    
    private static func registerFontsForURLIfNeeded(font: Font) {
        if Resources._registeredFonts.contains(font) { return }
        
        let cfURL = Bundle.main.url(forResource: "Fonts/\(font.fileName())", withExtension: "ttf") as! CFURL
        CTFontManagerRegisterFontsForURL(cfURL, CTFontManagerScope.process, nil)
        
        Resources._registeredFonts.append(font)
    }
    
    public static func getLabel(text: String, size: CGFloat, position: CGPoint = CGPoint.zero, font: Resources.Font = .lato, alpha : CGFloat = 1) -> SKLabelNode {
        Resources.registerFontsForURLIfNeeded(font: font)
        
        let lbl = SKLabelNode(text: text)
        lbl.fontName = font.rawValue
        lbl.fontSize = size
        lbl.alpha = alpha
        lbl.position = position
        lbl.horizontalAlignmentMode = .left
        
        return lbl
    }
    
    // MARK: - Images & Textures
    public enum Image : String {
        case tileCorner1        = "tile_corner_c1"
        case tileCorner2        = "tile_corner_c2"
        case tileCorner3        = "tile_corner_c3"
        case tileCorner4        = "tile_corner_c4"
        case tileSide1          = "tile_corner_l1"
        case tileSide2          = "tile_corner_l2"
        case tileGroundDark     = "tile_ground_dark"
        case tileGroundLight    = "tile_ground_light"
        
        case iconPlay       = "icon_play"
        case iconStop       = "icon_stop"
        case iconForward    = "icon_forward"
        case iconHint       = "icon_hint"
        case iconReplay     = "icon_replay"
        
        case knight1 = "knight_1"
        
        private func getImageName() -> String {
            switch self {
            case .iconPlay, .iconStop, .iconForward, .iconHint, .iconReplay:
                return "Images/Icons/\(self.rawValue)"
            case .tileCorner1, .tileCorner2, .tileCorner3, .tileCorner4, .tileSide1, .tileSide2, .tileGroundDark, .tileGroundLight:
                return "Images/Tiles/\(self.rawValue)"
            case .knight1:
                return "Images/Knight/\(self.rawValue)"
            }
        }
        public func getTexture() -> SKTexture {
            return SKTexture(imageNamed: self.getImageName())
        }
    }
}
