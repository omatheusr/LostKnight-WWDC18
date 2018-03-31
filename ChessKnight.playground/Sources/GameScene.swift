import SpriteKit

public class GameScene: SKScene {
    
    fileprivate let menu : Menu
    fileprivate let board : Chessboard
    fileprivate let knight : Knight
    
    private var gameplay : Gameplay?
    
    public required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    public override init(size: CGSize) {
        menu = Menu()
        board = Chessboard(rowsAndColumns: Config.sizeOfMap)
        knight = Knight(initialPosition: Position(row: 1, column: 1))
        
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.45, y: 0)
        backgroundColor = .black
        
        menu.delegate = self
        knight.delegate = self
        
        board.position = CGPoint(x: 0, y: 34)
    }
    public override func didMove(to view: SKView) {
        menu.zPosition = Config.ZPosition.menu
        board.zPosition = Config.ZPosition.board
        
        addChild(menu)
        addChild(board)
        board.addChild(knight)
        
        menu.playBackgroundMusic()
        
        board.reset()
        menu.state = .idle(true)
        knight.reset(completion: { [weak self] in
            self?.menu.state = .stopped
        })
    }
    
    // MARK: - Touch Events
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        
        for node in nodes(at: touch.location(in: self)) {
            if let button = node as? MenuButton, button.isEnabled {
                button.touchBegan()
            } else { continue }
            return
        }
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        
        for node in nodes(at: touch.location(in: self)) {
            if let button = node as? MenuButton, button.isEnabled {
                button.touchCanceled()
            } else { continue }
            return
        }
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else { return }
        
        for node in nodes(at: touch.location(in: self)) {
            if let button = node as? MenuButton, button.isEnabled {
                button.touchEnded()
            } else if let gameplay = gameplay, gameplay.state == .started,
                let tile = node as? Tile, tile.contains(touch: touch) {
                knight.setPosition(tile.pos)
            } else { continue }
            return
        }
    }
    
    fileprivate func setupNewGameplay() {
        if let _ = gameplay { return }
        
        let newGameplay = Gameplay()
        newGameplay.delegate = self
        newGameplay.state = .starting
        
        gameplay = newGameplay
    }
}

// MARK: - Menu Delegate Extension
extension GameScene : MenuDelegate {
    public func menu(_ menu: Menu, didTouchMenuButton menuButton: MenuButton) {
        switch (menuButton.icon) {
        case .iconPlay:
            if let _ = gameplay { return }
            setupNewGameplay()
        case .iconStop:
            if let gameplay = gameplay {
                gameplay.state = .stopped
            }
            gameplay = nil
        case .iconReplay:
            menu.state = .idle(false)
            gameplay = nil
            
            board.reset()
            setupNewGameplay()
        case .iconForward:
            guard let gameplay = gameplay else { return }
            gameplay.state = .autosolving
        default: break
        }
    }
}

// MARK: - Gameplay Delegate Extension
extension GameScene : GameplayDelegate {
    public func gameplay(_ gameplay: Gameplay, didUpdateState state: Gameplay.State) {
        
        switch state {
        case .starting:
            menu.state = .idle(false)
            knight.setPosition(gameplay.startPosition, force: true, completion: {
                self.board.addDestinationHighlight(position: gameplay.destinationPosition)
                gameplay.state = .started
                self.menu.state = .playing
            })
        case .started: break
        case .won:
            menu.state = .finished(true)
        case .failed:
            menu.state = .finished(false)
        case .autosolving:
            menu.state = .autosolving
            knight.moveToPosition(gameplay.destinationPosition)
        case .stopped:
            menu.state = .idle(true)
            board.reset()
            knight.reset(completion: { [weak self] in
                self?.menu.state = .stopped
            })
            menu.infosText = nil
        default: break
        }
        
    }
    public func gameplay(_ gameplay: Gameplay, didUpdatePositions positions: [Position]) {
        let infosText = "Moves needed: \(gameplay.minMoves-1)  |  Moves allowed: \(gameplay.maxMoves)  |  Moves performed: \(positions.count-1)  |  Moves needed from current position: \(gameplay.neededMoves)  |  Moves left: \(gameplay.maxMoves-positions.count+1)"
        
        menu.infosText = infosText
    }
}

// MARK: - Knight Delegate Extension
extension GameScene : KnightDelegate {
    public func knight(_ knight: Knight, willMoveFrom from: Position, to: Position) {
        board.removePossibleMovesHighlights()
    }
    public func knight(_ knight: Knight, didMoveTo to: Position) {
        guard let gameplay = gameplay else { return }
        
        if ![.won, .failed].contains(gameplay.state) && gameplay.destinationPosition != knight.currentPosition {
            board.addPossibleMovesHighlights(positions: to.getValidPositionsForMoves(moves: Config.knightMoves))
        }
        gameplay.addPosition(to)
    }
}
