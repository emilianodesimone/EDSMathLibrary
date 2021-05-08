//
//  File.swift
//  
//
//  Created by De Simone, Emiliano on 30.4.2021.
//

import Foundation

public struct LinearSystem {
    let matrix: Matrix<Double>
    let coefficients: [Double]
    var solutions: [Double?] {
        if let squareMatrix = matrix.asSquareMatrix() {
            return squareMatrix.multInverse() * coefficients
        }
        return []
    }
    
    public init(matrix: Matrix<Double>, coefficients: [Double]) {
        self.matrix = matrix
        self.coefficients = coefficients
    }
}
