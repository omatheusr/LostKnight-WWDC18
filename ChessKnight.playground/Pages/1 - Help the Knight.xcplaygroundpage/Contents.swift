/*:
 
 # Lost Knight

_This playground was created to show the usage of the Breadth-first search algorithm (BFS) to solve the Chess Knight problem._

**_Author:_ Matheus Rabelo.**
 
 - Important:
 _Open the **Assistant editor** and enable the **Live View** to see/play the game._

 - - -
 
 * Callout(The Knight Problem:):
 **What's the shortest path for a Knight to get from a given source position to a given target position in a chessboard?**
 
 - - -
 
 * Note:
 ![Play](Images/Icons/icon_play.png) Play
 \
 You can play the game and try to find the path that the Knight needs to take to get to his destination by yourself.
 \
 ![Autosolve](Images/Icons/icon_forward.png) Autosolve
 \
 Use this option to let the BFS algorithm solve the problem for you.
 \
 _* note that to use this option you need to start the game by pressing the play button first._
 \
 ![The real head of the household?](Images/Icons/icon_hint.png) Hint
 \
 If you're trying to help the Knight by yourself use this button to get a hint on where the knight should go next.
 
 1. The green highlighted squares in the chessboard shows the Knight possible moves;
 2. The red highlighted square in the chessboard show the Knight destination;
 3. You will lose the game if:
    - you perform the maximum amount of steps allowed and you do not reach the destination;
    - your amount of moves left are less than the amount of moves needed to reach the destination from your current position.

 - - -
 
 * Callout(1. Chess Knight Movements:):
 \
 The Knight is a piece of the chess game that can only move to a square that is two squares away horizontally and one square vertically, or two squares vertically and one square horizontally. 
 \
 ![Knight Moves](Images/Util/knight_moves.png)
\
 For more information, see [Knight (chess) on Wikipedia](https://en.wikipedia.org/wiki/Knight_(chess))
 
 - - -
 
 * Callout(2. The BFS Algorithm:):
 The Breadth-first search (BFS) is an algorithm for traversing or searching tree or graph data structures. It starts at the tree root (or some arbitrary node of a graph) and explores the neighbor nodes first, before moving to the next level neighbours.
 \
 ![Knight Moves](Images/Util/bfs_animated.gif)
 \
 For more information, see [Breadth-First Search on Wikipedia](https://en.wikipedia.org/wiki/Breadth-first_search)
 \
 Also, give a look at the [Next Page](@next) of this Playground to see the BFS algorithm used in this game commented line by line.
 */
/*:
 # Start the game:
 - - -
 */
import PlaygroundSupport
import SpriteKit

let scene = GameScene(size: Config.sizeOfScreen)
scene.scaleMode = .aspectFill

let sceneView = SKView(frame: CGRect(origin: CGPoint.zero, size: Config.sizeOfScreen))
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
