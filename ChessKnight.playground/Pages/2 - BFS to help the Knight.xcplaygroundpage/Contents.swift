/*:
 
 # BFS Algorithm commented line by line

 - - -
 
 ![BFS Demo](Images/Util/bfs_demo2.png)

 - - -
 */
import Foundation

func BFS(origin: Position, destination: Position) -> [Position] {

    // Queue of positions to be processed. Starts with the origin position and is incremented as the algorithm runs
    var queue : [Position] = [origin]
    
    // Dictionary that holds a boolean for a position that indicates if the position has been processed
    var visited : [Position : Bool] = [:]
    
    // Holds the final path found from the origin to the destination
    var path : [Position] = []
    
    // Interacts over the positions in the queue while there is a value
    while !queue.isEmpty {
        // Gets and removes the position currently being processed from the queue
        let currentPosition = queue.removeFirst()
        
        // Verifies if the position being processed is the destination
        if currentPosition == destination {
            
            // Interacts over the list of positions adding the positions to the path
            var p : Position? = currentPosition
            while let pos = p {
                path.append(pos)
                p = pos.previousPosition
            }
            
            // Reverse the path to show it from Origin to Destination
            path.reverse()
            
            // Returns an array of positions containing the path from the given origin to the given destination
            return path
        }
        
        // If the position being processed in this interaction has already been processed skips it, otherwise marks it as processed
        if let _ = visited[currentPosition] { continue }
        visited[currentPosition] = true
        
        // Interacts over all the possible movements of a Knight in the chessboard from current position being processed
        for move in Config.knightMoves {
            
            // Get the relative position of the move from the current position being processed
            let newPos = currentPosition + move
            
            // Verifies if the new position is valid
            if newPos.isValid && !newPos.isCorner {
                
                // Adds the current position as a previous position of the new one creating a list of previous nodes
                newPos.previousPosition = currentPosition
                
                // Adds the new valid position to the process queue
                queue.append(newPos)
            }
        }
    }
    // If it was not possible to get a path from the given origin and the given destination, returns an empty array
    return path
}
/*:
 
 ![BFS Demo](Images/Util/bfs_demo.gif)
 
 */
let originPosition = Position(row: 8, column: 1)
let destinationPosition = Position(row: 1, column: 8)

let path = BFS(origin: originPosition, destination: destinationPosition)

for (i, position) in path.enumerated() {
    print("\(i) -> \(position.rcIdentifier)")
}
/*:
 For more information, see [Breadth-First Search on Wikipedia](https://en.wikipedia.org/wiki/Breadth-first_search)
 
 [◀︎ Go back to the game](@previous)
 */
