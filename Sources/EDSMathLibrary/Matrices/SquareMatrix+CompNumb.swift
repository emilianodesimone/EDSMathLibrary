//
//  File.swift
//  
//
//  Created by De Simone, Emiliano on 30.4.2021.
//

import Foundation

public typealias ComplexSquareMatrix = SquareMatrix<CompNumb>

public extension ComplexSquareMatrix {
    func conjugated() -> Self {
        let newGrid = self.grid.map{ $0.map{ $0.conjugated() } }
        
        return Self(grid: newGrid)
    }
    
    func isHermitian() -> Bool {
        return self == self.transposed().conjugated()
    }
    
}
