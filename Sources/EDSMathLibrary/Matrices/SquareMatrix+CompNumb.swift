//
//  File.swift
//  
//
//  Created by De Simone, Emiliano on 30.4.2021.
//

import Foundation

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
    
    public static func *(lhs:CompNumb, rhs: SquareMatrix) -> Self? {
        return (lhs * rhs.asMatrix()).asSquareMatrix()
    }
    public static func *(lhs:SquareMatrix, rhs: CompNumb) -> Self? {
        return (lhs.asMatrix()*rhs).asSquareMatrix()
    }
    public static func *(lhs:SquareMatrix, rhs: [CompNumb]) -> [CompNumb?] {
        return (lhs.asMatrix() * rhs)
    }
}

extension SquareMatrix: Field where S == CompNumb {
    
}

extension SquareMatrix: AssociativeAlgebra where S == CompNumb {
    
    public static func *(lhs:CompNumb, rhs: SquareMatrix) -> Self {
        let newGrid = rhs.grid.map { $0.map { lhs*$0 } }
        return SquareMatrix(grid: newGrid)
    }
    public static func *(lhs:SquareMatrix, rhs: CompNumb) -> Self {
        return rhs*lhs
    }
}

extension SquareMatrix where S == CompNumb {
    public func multInverse() -> Self {
        let determinant = self.determinant()
        let minorsGrid: [[S]] = (1...rows).map {i in
            (1...columns).map {j in
                let sign: CompNumb = i % 2 == j % 2 ? 1 : -1
                return sign * (self.minor(i, column: j).determinant())
            }
        }
        
        let minorMatrix = SquareMatrix(grid: minorsGrid).transposed()
        return minorMatrix/determinant
    }
    
    public func addInverse() -> Self {
        return SquareMatrix(grid: self.grid.map{$0.map { $0.addInverse() } })
    }
}
