//
//  File.swift
//  
//
//  Created by De Simone, Emiliano on 30.4.2021.
//

import Foundation

public extension SquareMatrix where S: Field {
    
    func minor(_ row: Int, column: Int) -> SquareMatrix {
        let squareMatrix = asMatrix().matrixByRemoveColumn(column).matrixByRemoveRow(row).asSquareMatrix()
        precondition(squareMatrix != nil)
        return squareMatrix!
    }
    
    func determinant() -> S {
        if self.rows == 1 {
            return self[1,1]
        } else {
            var determinant: S = S.zero
            for k in 1...columns {
                let sign: Bool = (k % 2 != 0) ? true : false
                let element = sign ? self[1,k] : self[1,k].addInverse()
                determinant = determinant + element * (self.minor(1, column: k).determinant())
            }
            return determinant
        }
    }
    
    func isInvertible() -> Bool {
        return (self.determinant() != S.zero) ? true : false
    }
    
    func isIdentity() -> Bool {
        var isIdentity = true
        for (index, row) in grid.enumerated() { if row[index] != S.one { isIdentity = false } }
        return isIdentity
    }
    
    func isUnitary() -> Bool {
        return ((self * self.transposed()).isIdentity())
    }
    
    static func *(lhs: SquareMatrix, rhs: SquareMatrix) -> SquareMatrix {
        precondition(lhs.rows == rhs.rows, "You can only multiply square matrices of the same size")
        let newGrid: [[S]] = (1...lhs.rows).map { i -> [S] in
            return (1...rhs.columns).map { j in
                return (lhs.row(i) ** rhs.column(j))!
            }
        }
        return SquareMatrix(grid: newGrid)
    }
    static func +(lhs: SquareMatrix, rhs: SquareMatrix) -> SquareMatrix {
        assert(lhs.rows == rhs.columns, "You can only sum matrices of the same size")
        let newGrid: [[S]] = (1...lhs.rows).map { i -> [S] in
            return (1...rhs.columns).map { j in
                return (lhs[i,j] + rhs[i,j])
            }
        }
        return SquareMatrix(grid: newGrid)
    }
    
    static func *(lhs:S, rhs: SquareMatrix) -> Self? {
        return (lhs * rhs.asMatrix()).asSquareMatrix()
    }
    static func *(lhs:SquareMatrix, rhs: S) -> Self? {
        return (lhs.asMatrix()*rhs).asSquareMatrix()
    }
    static func *(lhs:SquareMatrix, rhs: [S]) -> [S?] {
        return (lhs.asMatrix() * rhs)
    }
    
    static func *(lhs:S, rhs: SquareMatrix) -> Self {
        let newGrid = rhs.grid.map { $0.map { lhs*$0 } }
        return SquareMatrix(grid: newGrid)
    }
    static func *(lhs:SquareMatrix, rhs: S) -> Self {
        return rhs*lhs
    }
    
    func multInverse() -> Self {
        let determinant = self.determinant()
        let minorsGrid: [[S]] = (1...rows).map {i in
            (1...columns).map {j in
                let sign: S = i % 2 == j % 2 ? S.one : S.one.addInverse()
                return sign * (self.minor(i, column: j).determinant())
            }
        }
        
        let minorMatrix = SquareMatrix(grid: minorsGrid).transposed()
        return minorMatrix/determinant
    }
    
    func addInverse() -> Self {
        return SquareMatrix(grid: self.grid.map{$0.map { $0.addInverse() } })
    }
    
    static func /(lhs: Self, rhs: S) -> Self {
        return lhs*rhs.multInverse()
    }
}
