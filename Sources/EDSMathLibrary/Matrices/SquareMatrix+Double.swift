//
//  File.swift
//  
//
//  Created by De Simone, Emiliano on 30.4.2021.
//

import Foundation

extension SquareMatrix where S == Double {
    
    public static func *(lhs:Double, rhs: SquareMatrix) -> Self {
        let newGrid = rhs.grid.map { $0.map { lhs*$0 } }
        return SquareMatrix(grid: newGrid)
    }
    public static func *(lhs:SquareMatrix, rhs: Double) -> Self {
        return rhs*lhs
    }
    
    public static func *(lhs:Double, rhs: SquareMatrix) -> Self? {
        return (lhs * rhs.asMatrix()).asSquareMatrix()
    }
    public static func *(lhs:SquareMatrix, rhs: Double) -> Self? {
        return (lhs.asMatrix()*rhs).asSquareMatrix()
    }
    public static func *(lhs:SquareMatrix, rhs: [Double]) -> [Double?] {
        return (lhs.asMatrix() * rhs)
    }
}
