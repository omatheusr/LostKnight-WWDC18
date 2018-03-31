import SpriteKit

public protocol MenuButtonDelegate : class {
    func menuButtonTouchBegan(menuButton: MenuButton)
    func menuButtonTouchEnded(menuButton: MenuButton)
}
public class MenuButton : SKSpriteNode {
    
    public weak var delegate : MenuButtonDelegate?
    
    // MARK: - Properties
    private var _icon : Resources.Image
    
    // MARK: - Computable variables
    public var icon : Resources.Image {
        get { return _icon }
        set {
            _icon = newValue
            texture = newValue.getTexture()
        }
    }
    
    public var isEnabled : Bool = true {
        didSet{
            if isEnabled == oldValue { return }
            if isEnabled {
                fade()
            } else {
                fade(to: 0.6)
            }
        }
    }
    
    // MARK: - Initializers
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    required public init(icon: Resources.Image, position pos: CGPoint) {
        _icon = icon
        
        let texture = icon.getTexture()
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        position = pos
    }
    
    // MARK: - Actions
    public func touchBegan() {
        if !isEnabled { return }
        
        animateTouchBegan()
        delegate?.menuButtonTouchBegan(menuButton: self)
        
    }
    public func touchEnded() {
        if !isEnabled { return }
        
        animateTouchEnded()
        fade()
        delegate?.menuButtonTouchEnded(menuButton: self)
    }
    public func touchCanceled() {
        if !isEnabled { return }
        animateTouchEnded()
    }
    
    // MARK: - Animations
    private func animateTouchBegan(){
        fade(to: 0.6)
    }
    private func animateTouchEnded(){
        fade()
    }
    private func fade(to: CGFloat = 1, duration: TimeInterval = 0.15) {
        run(SKAction.fadeAlpha(to: to, duration: duration))
    }
    
}
