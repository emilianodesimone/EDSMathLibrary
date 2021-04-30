import Foundation

typealias ComplexMatrix = Matrix<CompNumb>

extension ComplexMatrix: ComplexMatrixType {
    
    func asSquareMatrix() -> ComplexSquareMatrix? {
        guard rows == columns else { return nil }
        return ComplexSquareMatrix(grid: self.grid)
    }
    
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
