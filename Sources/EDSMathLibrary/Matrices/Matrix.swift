import Foundation

public struct Matrix<S>: MatrixType where S: Field & CustomStringConvertible {
    
    public typealias T = S
    
    public let rows: Int, columns: Int
    public let grid: [[S]]
    
    public init(grid: [[S]]) {
        precondition({
            guard grid.count > 0 else { return (false) }
            var precondition = true
            grid.enumerated().forEach { offset, row in
                if row.count != grid[0].count { precondition = false }
            }
            return precondition
        }())
        self.rows = grid.count
        self.columns = grid[0].count
        self.grid = grid
    }
}

extension Matrix {
    
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
    
    static public func *(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.columns == rhs.rows && lhs.columns > 0) else { return nil }
        let newGrid: [[S]] = (1...lhs.rows).map { i -> [S] in
            return (1...rhs.columns).map { j in
                return (lhs.row(i) ** rhs.column(j))!
            }
        }
        return Matrix(grid: newGrid)
    }
    
    static public func +(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.rows == rhs.rows && lhs.columns == rhs.columns) else { return nil }
        let newGrid: [[S]] = (1...lhs.rows).map { i -> [S] in
            return (1...rhs.columns).map { j in
                return (lhs[i,j] + rhs[i,j])
            }
        }
        return Matrix(grid: newGrid)
    }
}

extension Matrix where S == CompNumb {
    
    public static func *(lhs:CompNumb, rhs: Matrix) -> Self {
        let newGrid = rhs.grid.map { $0.map { lhs*$0 } }
        return Matrix(grid: newGrid)
    }
    public static func *(lhs:Matrix, rhs: CompNumb) -> Self {
        return rhs*lhs
    }
}

extension Matrix where S == Double {
    
    public static func *(lhs:Double, rhs: Matrix) -> Self {
        let newGrid = rhs.grid.map { $0.map { lhs*$0 } }
        return Matrix(grid: newGrid)
    }
    public static func *(lhs:Matrix, rhs: Double) -> Self {
        return rhs*lhs
    }
}







