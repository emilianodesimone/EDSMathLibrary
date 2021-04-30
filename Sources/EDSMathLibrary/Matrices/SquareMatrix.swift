import Foundation

public struct SquareMatrix<S>: MatrixType where S: Field & CustomStringConvertible {
    
    public let rows: Int
    public var columns: Int {
        return rows
    }
    public let grid: [[S]]
    
    public init(grid: [[S]]) {
        precondition({
            let firstRow = grid[0]
            var precondition = true
            guard grid.count > 0, grid.count == firstRow.count else { return false }
            grid.enumerated().forEach { offset, row in
                if row.count != firstRow.count  { precondition = false }
            }
            return precondition
        }())
        self.rows = grid.count
        self.grid = grid
    }
    
    public func asMatrix() -> Matrix<S> {
        return Matrix(grid: grid)
    }
}
