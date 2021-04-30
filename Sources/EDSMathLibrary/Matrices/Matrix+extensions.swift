import Foundation

typealias ComplexMatrix = Matrix<CompNumb>
typealias RealMatrix = Matrix<Double>

extension Matrix {
    
    public func isInvertible() -> Bool {
        guard let squareMatrix = self.asSquareMatrix() else { return false }
        return squareMatrix.isInvertible()
    }
    
    func isUnitary() -> Bool {
        guard let squareMatrix = self.asSquareMatrix() else { return false }
        return squareMatrix.isUnitary()
    }
    
    func determinant() -> S? {
        guard let squareMatrix = self.asSquareMatrix() else { return nil }
        return squareMatrix.determinant()
    }
}
