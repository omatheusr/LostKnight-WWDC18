import SpriteKit

public protocol MenuDelegate : class {
    func menu(_ menu : Menu, didTouchMenuButton menuButton: MenuButton)
}
public class Menu : SKSpriteNode {
    public enum State {
        case idle(Bool)
        case playing
        case stopped
        case autosolving
        case finished(Bool)
    }
    
    // MARK: - Menu item positions
    // MARK: Buttons positions
    private static let buttonPlayStopPosition   = CGPoint(x: 150,y: 410)
    private static let buttonForwardPosition    = CGPoint(x: 210,y: 410)
    private static let buttonHintPosition       = CGPoint(x: 270,y: 410)
    
    // MARK: Label positions
    private static let labelTitlePosition       = CGPoint(x: -252, y: 410)
    private static let labelSubtitlePosition    = CGPoint(x: -242, y: 380)
    
    // MARK: - Delegate
    public weak var delegate: MenuDelegate?
    
    // MARK: - Menu items
    private let buttonPlayStop : MenuButton
    private let buttonForward : MenuButton
    private let buttonHint : MenuButton
    
    private let labelTitle : SKLabelNode
    private let labelSubtitle : SKLabelNode
    
    private let infosBackground : SKSpriteNode
    private let labelInfos : SKLabelNode
    
    private let audioNode : SKAudioNode
    
    private let overlay : SKSpriteNode
    private let overlayLabel : SKLabelNode
    
    // MARK: - Calculated properties
    var buttons : [MenuButton] {
        return [buttonPlayStop, buttonForward, buttonHint]
    }
    var labels : [SKLabelNode] {
        return [labelTitle, labelSubtitle, labelInfos]
    }
    
    // MARK: - State Handlers
    private var isDisplayingOverlay : Bool = false {
        didSet{
            if oldValue == isDisplayingOverlay { return }
            overlay.removeAllActions()
            
            if isDisplayingOverlay {
                overlay.alpha = 0
                overlay.run(SKAction.fadeAlpha(to: 0.6, duration: 0.2))
            }else{
                overlay.run(SKAction.fadeAlpha(to: 0, duration: 0.2))
            }
        }
    }
    private var overlayLabelText : String? {
        didSet {
            guard let text = overlayLabelText else {
                overlayLabel.alpha = 0
                return
            }
            overlayLabel.text = text
            overlayLabel.alpha = 1
        }
    }
    public var infosText : String? {
        didSet{
            guard let infosText = infosText else {
                labelInfos.text = Config.presentation
                return
            }
            labelInfos.text = infosText
        }
    }
    public var state : State = .stopped {
        didSet {
            switch state {
            case .idle(let overlay):
                isDisplayingOverlay = overlay
                overlayLabelText = nil
                
                buttonPlayStop.isEnabled = false
                buttonForward.isEnabled = false
                buttonHint.isEnabled = false
            case .playing:
                buttonPlayStop.icon = Resources.Image.iconStop
                
                isDisplayingOverlay = false
                overlayLabelText = nil
                
                buttonPlayStop.isEnabled = true
                buttonForward.isEnabled = true
                buttonHint.isEnabled = true
            case .stopped:
                buttonPlayStop.icon = Resources.Image.iconPlay
                
                isDisplayingOverlay = true
                overlayLabelText = nil
                
                buttonPlayStop.isEnabled = true
                buttonForward.isEnabled = false
                buttonHint.isEnabled = false
            case .finished(let won):
                buttonPlayStop.icon = Resources.Image.iconReplay
                
                isDisplayingOverlay = true
                overlayLabelText = won ? Config.youWin : Config.youLose
                
                if won {
                    playSound(Resources.soundClosure)
                }else{
                    playSound(Resources.soundCrash)
                }
                
                buttonPlayStop.isEnabled = true
                buttonForward.isEnabled = false
                buttonHint.isEnabled = false
            case .autosolving:
                buttonPlayStop.isEnabled = false
                buttonForward.isEnabled = false
                buttonHint.isEnabled = false
            }
        }
    }
    
    // MARK: - Initializers
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    required public init() {
        // Chessboard Overlay
        overlay = SKSpriteNode(color: UIColor.black, size: Config.sizeOfScreen)
        
        // Infos Background
        infosBackground = SKSpriteNode(color: UIColor.white, size: CGSize(width: Config.sizeOfScreen.width, height: 30))
        
        // Audio Node
        audioNode = Resources.audioNode
        
        // Instantiate menu buttons
        buttonPlayStop = MenuButton(icon: Resources.Image.iconPlay,
                                    position: Menu.buttonPlayStopPosition)
        buttonForward = MenuButton(icon: Resources.Image.iconForward,
                                   position: Menu.buttonForwardPosition)
        buttonHint = MenuButton(icon: Resources.Image.iconInfo,
                                position: Menu.buttonHintPosition)
        
        
        // Instantiate menu labels
        labelTitle = Resources.getLabel(text: Config.title,
                                        size: 58,
                                        position: Menu.labelTitlePosition,
                                        font: .lobster,
                                        alpha: 1)
        
        labelSubtitle = Resources.getLabel(text: Config.subtitle,
                                           size: 15,
                                           position: Menu.labelSubtitlePosition,
                                           font: .lifeSavers,
                                           alpha: 1)
        
        labelInfos = Resources.getLabel(text: Config.presentation,
                                        size: 10,
                                        position: CGPoint(x: -240, y: 10),
                                        font: .lato,
                                        alpha: 1)
        
        overlayLabel = Resources.getLabel(text: "nil",
                                          size: 55,
                                          position: CGPoint(x: 20, y: 200),
                                          font: .lobster,
                                          alpha: 1)
        
        // Initiate Menu
        let texture = SKTexture()
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        // Add all labels to Menu sprite
        for label in labels {
            label.zPosition = Config.ZPosition.menuLabels
            addChild(label)
        }
        
        // Add all buttons to Menu sprite
        for button in buttons {
            button.zPosition = Config.ZPosition.menuButtons
            button.delegate = self
            addChild(button)
        }
        
        // Setup Overlay
        overlay.anchorPoint = CGPoint(x: 0.45, y: 0)
        overlay.position = CGPoint.zero
        overlay.zPosition = Config.ZPosition.menuOverlay
        overlay.alpha = 1
        addChild(overlay)
        
        // Infos Background
        labelInfos.zPosition = Config.ZPosition.menuInfosLabel
        
        infosBackground.anchorPoint = CGPoint(x: 0.45, y: 0)
        infosBackground.position = CGPoint.zero
        infosBackground.alpha = 0.1
        infosBackground.zPosition = Config.ZPosition.menuInfosBackground
        addChild(infosBackground)
        
        // Setup Overlay Label
        overlayLabel.zPosition = Config.ZPosition.menuOverlayLabel
        overlayLabel.horizontalAlignmentMode = .center
        overlayLabel.alpha = 0
        addChild(overlayLabel)
        
        // Setup Background Music
        audioNode.autoplayLooped = true
        addChild(audioNode)
    }
    
    // MARK: - Audio
    public func playBackgroundMusic() {
        audioNode.run(SKAction.sequence([
            SKAction.changeVolume(to: 0, duration: 0),
            SKAction.play(),
            SKAction.changeVolume(to: 1, duration: 5)
        ]))
    }
    private func playSound(_ action: SKAction) {
        audioNode.run(SKAction.sequence([
            SKAction.changeVolume(to: 0.1, duration: 0.4),
            action,
            SKAction.changeVolume(to: 1, duration: 0.4)
        ]))
    }
}
// MARK: - MenuButton Delegate
extension Menu : MenuButtonDelegate {
    public func menuButtonTouchBegan(menuButton: MenuButton) {
        
    }
    public func menuButtonTouchEnded(menuButton: MenuButton) {
        delegate?.menu(self, didTouchMenuButton: menuButton)
    }
}
