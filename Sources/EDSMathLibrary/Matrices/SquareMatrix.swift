import Foundation

public struct SquareMatrix<S>: MatrixType where S: Field & CustomStringConvertible {
    
    public let rows: Int
    public var columns: Int {
        return rows
    }
    public let grid: [S]
    
    public init(rows: Int, values: [S]) {
        precondition(values.count == rows*rows)
        self.rows = rows
        let limit = rows*rows
        self.grid = Array(values.prefix(limit))
    }
    
    func asMatrix() -> Matrix<S> {
        return Matrix(rows: self.rows, values: self.grid)
    }
}

typealias ComplexSquareMatrix = SquareMatrix<CompNumb>

extension ComplexSquareMatrix: ComplexMatrixType {
    
    public func isInvertible() -> Bool {
        return (self.determinant() != 0) ? true : false
    }
    
    public func isIdentity() -> Bool {
        for (index, value) in grid.enumerated() {
            if rowIndexForGridIndex(index) == columnIndexForGridIndex(index)  {
                if value != 1 { return false }
            } else {
                if value != 0 { return false }
            }
        }
        return true
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
            return self[0,0]
        } else {
            var determinant: CompNumb = 0
            for k in 0...columns-1 {
                let sign: CompNumb = (k % 2 == 0) ? 1 : -1
                determinant = determinant + sign * self[0,k] * (self.minor(0, column: k).determinant())
            }
            return determinant
        }
    }
}

extension SquareMatrix: Ring where S == CompNumb {
    
    static public func *(lhs: SquareMatrix, rhs: SquareMatrix) -> SquareMatrix {
        let newGrid: [CompNumb] = (0..<lhs.rows*rhs.columns).map {
            let j = $0%rhs.columns
            let i = Int(($0 - $0%rhs.columns)/rhs.columns)
            return (lhs.row(i) ** rhs.column(j))!
        }
        return SquareMatrix(rows: lhs.rows, values: newGrid)
    }
    
    static public func +(lhs: SquareMatrix, rhs: SquareMatrix) -> SquareMatrix {
        assert(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "You can only sum matrices of the same size")
        let newArray = (0..<lhs.rows*lhs.columns).map { lhs.grid[$0] + rhs.grid[$0] }
        return SquareMatrix(rows: lhs.rows, values: newArray)
    }
}

extension SquareMatrix: Field where S == CompNumb {
    
}

extension SquareMatrix: AssociativeAlgebra where S == CompNumb {
    /// TODO: give a proper multiplicative inverse to square matrices
    public func multInverse() -> Self {
        return SquareMatrix(rows: 0, values: [])
    }

    public func addInverse() -> Self {
        return SquareMatrix(rows: self.rows, values: self.grid.map{$0.addInverse()})
    }
    
    public static func *(lhs:CompNumb, rhs: SquareMatrix) -> Self {
        let newGrid = rhs.grid.map { lhs*$0 }
        return SquareMatrix(rows: rhs.rows, values: newGrid)
    }
    public static func *(lhs:SquareMatrix, rhs: CompNumb) -> Self {
        return rhs*lhs
    }
}



