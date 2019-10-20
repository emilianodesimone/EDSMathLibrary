import Foundation

public struct Matrix<S>: MatrixType where S: Field & CustomStringConvertible {
    
    public typealias T = S
    
    public let rows: Int, columns: Int
    public let grid: [S]
    
    public init(rows: Int, values: [S]) {
        var columns = (values.count - (values.count % rows)) / rows
        if values.count % rows != 0 { columns = columns + 1 }
        self.init(rows: rows, columns: columns, values: values)
    }
    
    public init(rows: Int, columns: Int, values: [S]) {
        precondition(values.count == rows * columns)
        self.rows = rows
        self.columns = columns
        let limit = Swift.min(rows*columns, values.count)
        //let zeroFillArray = Array(repeating: 0.0 + 0.i, count: Swift.max(rows*columns - values.count,0))
        self.grid = Array(values.prefix(limit))// + zeroFillArray
    }
}

extension Matrix {
    
    func asSquareMatrix() -> SquareMatrix<S>? {
        guard rows == columns, grid.count == rows*rows else { return nil }
        return SquareMatrix(rows: self.rows, values: self.grid)
    }
    
    func matrixByRemoveColumn(_ j: Int) -> Matrix {
        let indecesToRemove: [Int] = (0...self.rows - 1).map{j + $0 * self.columns}
        let newArray = grid.enumerated().compactMap { indecesToRemove.contains($0.0) ? nil : $0.1 }
        return Matrix(rows: self.rows, values: newArray)
        
    }
    
    func matrixByRemoveRow(_ j: Int) -> Matrix {
        let indecesToRemove: [Int] = (0...self.columns - 1).map{$0 + j * self.columns}
        let newArray = grid.enumerated().compactMap { indecesToRemove.contains($0.0) ? nil : $0.1 }
        return Matrix(rows: self.rows - 1, values: newArray)
        
    }
    
    static public func *(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.columns == rhs.rows && lhs.columns > 0) else { return nil }
        let newGrid: [S] = (0..<lhs.rows*rhs.columns).map {
            let j = $0%rhs.columns
            let i = Int(($0 - $0%rhs.columns)/rhs.columns)
            return (lhs.row(i) ** rhs.column(j))!
        }
        return Matrix(rows: lhs.rows, columns: rhs.columns, values: newGrid)
    }
    
    static public func +(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.rows == rhs.rows && lhs.columns == rhs.columns) else { return nil }
        let newArray = (0..<lhs.rows*lhs.columns).map { lhs.grid[$0] + rhs.grid[$0] }
        return Matrix(rows: lhs.rows, columns: lhs.columns, values: newArray)
    }
}

typealias ComplexMatrix = Matrix<CompNumb>

extension ComplexMatrix: ComplexMatrixType {
    public func isInvertible() -> Bool {
        guard let squareMatrix = self.asSquareMatrix() else { return false }
        
        return squareMatrix.isInvertible()
    }
    
    func isUnitary() -> Bool {
        guard let squareMatrix = self.asSquareMatrix() else { return false }
        
        return squareMatrix.isUnitary()
    }
    
    
    func determinant() -> CompNumb? {
        guard let squareMatrix = self.asSquareMatrix() else { return nil }
        
        return squareMatrix.determinant()
    }
}







