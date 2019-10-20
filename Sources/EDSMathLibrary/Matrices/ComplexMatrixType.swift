import Foundation

protocol ComplexMatrixType: MatrixType where T == CompNumb {
    func isInvertible() -> Bool
    func isUnitary() -> Bool
}

extension ComplexMatrixType {
    func conjugated() -> Self {
        let newGrid = self.grid.map{$0.conjugated()}
        
        return Self(rows: rows, values: newGrid)
    }
    
    func isHermitian() -> Bool {
        return self == self.transposed().conjugated()
    }
    
}

