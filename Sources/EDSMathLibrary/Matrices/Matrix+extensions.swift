import Foundation

public typealias ComplexMatrix = Matrix<CompNumb>
public typealias RealMatrix = Matrix<Double>

public extension Matrix {
    
    func isInvertible() -> Bool {
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
