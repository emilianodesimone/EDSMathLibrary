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
    
    func asMatrix() -> Matrix<S> {
        return Matrix(grid: grid)
    }
}

typealias ComplexSquareMatrix = SquareMatrix<CompNumb>

extension ComplexSquareMatrix: ComplexMatrixType {
    
    public func isInvertible() -> Bool {
        return (self.determinant() != 0) ? true : false
    }
    
    public func isIdentity() -> Bool {
        var isIdentity = true
        for (index, row) in grid.enumerated() { if row[index] != 1 { isIdentity = false } }
        return isIdentity
    }
    
    public func isUnitary() -> Bool {
        return ((self * self.transposed()).isIdentity())
    }
    
    func minor(_ row: Int, column: Int) -> SquareMatrix {
        let squareMatrix = asMatrix().matrixByRemoveColumn(column).matrixByRemoveRow(row).asSquareMatrix()
        precondition(squareMatrix != nil)
        return squareMatrix!
    }
    
    public func determinant() -> CompNumb {
        if self.rows == 1 {
            return self[1,1]
        } else {
            var determinant: CompNumb = 0
            for k in 1...columns {
                let sign: CompNumb = (k % 2 != 0) ? 1 : -1
                determinant = determinant + sign * self[1,k] * (self.minor(1, column: k).determinant())
            }
            return determinant
        }
    }
}

extension SquareMatrix: Ring where S == CompNumb {
    
    static public func *(lhs: SquareMatrix, rhs: SquareMatrix) -> SquareMatrix {
        precondition(lhs.rows == rhs.rows, "You can only multiply square matrices of the same size")
        let newGrid: [[S]] = (1...lhs.rows).map { i -> [S] in
            return (1...rhs.columns).map { j in
                return (lhs.row(i) ** rhs.column(j))!
            }
        }
        return SquareMatrix(grid: newGrid)
    }
    
    static public func +(lhs: SquareMatrix, rhs: SquareMatrix) -> SquareMatrix {
        assert(lhs.rows == rhs.columns, "You can only sum matrices of the same size")
        let newGrid: [[S]] = (1...lhs.rows).map { i -> [S] in
            return (1...rhs.columns).map { j in
                return (lhs[i,j] + rhs[i,j])
            }
        }
        return SquareMatrix(grid: newGrid)
    }
}

extension SquareMatrix: Field where S == CompNumb {
    
}

extension SquareMatrix: AssociativeAlgebra where S == CompNumb {
    /// TODO: give a proper multiplicative inverse to square matrices
    public func multInverse() -> Self {
        return SquareMatrix(grid: [])
    }

    public func addInverse() -> Self {
        return SquareMatrix(grid: self.grid.map{$0.map { $0.addInverse() } })
    }
    
    public static func *(lhs:CompNumb, rhs: SquareMatrix) -> Self {
        let newGrid = rhs.grid.map { $0.map { lhs*$0 } }
        return SquareMatrix(grid: newGrid)
    }
    public static func *(lhs:SquareMatrix, rhs: CompNumb) -> Self {
        return rhs*lhs
    }
}



