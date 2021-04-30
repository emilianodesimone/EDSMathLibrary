//
//  File.swift
//  
//
//  Created by De Simone, Emiliano on 30.4.2021.
//

import Foundation

struct LinearSystem {
    let matrix: Matrix<CompNumb>
    let coefficients: [CompNumb]
    var solutions: [CompNumb?] {
        if let squareMatrix = matrix.asSquareMatrix() {
            return squareMatrix.multInverse() * coefficients
        }
        return []
    }
}
