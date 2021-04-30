import Foundation

public struct Matrix<S>: MatrixType where S: Field & CustomStringConvertible {
    
    public typealias T = S
    
    public let rows: Int, columns: Int
    public let grid: [[S]]
    
    public init(grid: [[S]]) {
        precondition({
            guard let firstRow = grid.first else { return (false) }
            var precondition = true
            grid.forEach { row in
                if row.count != firstRow.count { precondition = false }
            }
            return precondition
        }())
        self.rows = grid.count
        self.columns = grid[0].count
        self.grid = grid
    }
}

public extension Matrix {
    
    func asSquareMatrix() -> SquareMatrix<S>? {
        guard rows == columns else { return nil }
        return SquareMatrix(grid: self.grid)
    }
    
    func matrixByRemoveColumn(_ j: Int) -> Matrix {
        let newGrid = grid.map{ row -> [S] in
            var newRow = row
            newRow.remove(at: j - 1)
            return newRow
        }
        return Matrix(grid: newGrid)
        
    }
    
    func matrixByRemoveRow(_ j: Int) -> Matrix {
        var newGrid = grid
        newGrid.remove(at: j - 1)
        return Matrix(grid: newGrid)
        
    }
    
    static func *(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.columns == rhs.rows && lhs.columns > 0) else { return nil }
        let newGrid: [[S]] = (1...lhs.rows).map { i -> [S] in
            return (1...rhs.columns).map { j in
                return (lhs.row(i) ** rhs.column(j))!
            }
        }
        return Matrix(grid: newGrid)
    }
    
    static func +(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.rows == rhs.rows && lhs.columns == rhs.columns) else { return nil }
        let newGrid: [[S]] = (1...lhs.rows).map { i -> [S] in
            return (1...rhs.columns).map { j in
                return (lhs[i,j] + rhs[i,j])
            }
        }
        return Matrix(grid: newGrid)
    }
}

public extension Matrix where S: Field {
    
    static func *(lhs:S, rhs: Matrix) -> Self {
        let newGrid = rhs.grid.map { $0.map { lhs*$0 } }
        return Matrix(grid: newGrid)
    }
    static func *(lhs:Matrix, rhs: S) -> Self {
        return rhs*lhs
    }
    static func *(lhs:Matrix, rhs: [S]) -> [S?] {
        return lhs.grid.map { $0 ** rhs }
    }
    
}







