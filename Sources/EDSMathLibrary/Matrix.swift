//
//  Matrix.swift
//  MathLibrary
//
//  Created by Emiliano De Simone on 10/09/16.
//  Copyright © 2016 EmilianoDeSimoneSoftware. All rights reserved.
//

import Foundation

public typealias Vector = [CompNumb]

public protocol MatrixType: CustomStringConvertible, Equatable {
    var rows: Int {get}
    var columns: Int {get}
    var grid: [CompNumb] {get}
    
    static func randomMatrix(rows: Int, columns: Int, maxReal: Double, maxIm: Double) -> Self
    
    init(rows: Int, values: [CompNumb])
    
}

extension MatrixType {
    public var description: String {
        get {
            var descriptionString: String = ""
            for i in 0...self.rows-1 {
                descriptionString = descriptionString + (i == 0 ? "\n⎛" : (i == self.rows-1 ? "⎝" : "⎢"))
                for j in 0...self.columns-1 {
                    descriptionString = descriptionString + justifiedEntry((i * self.columns) + j)
                }
                descriptionString = descriptionString + ( i == 0 ? "⎞\n" : (i == self.rows-1 ? "⎠\n" : "⎥\n"))
            }
            return descriptionString
        }
    }
    
    func justifiedEntry(_ value: Int) -> String {
        let stringToJustify = "\(grid[value])"
        let blanksToFill = entriesMaxNumberOfCharacters - stringToJustify.count
        var justifiedString: String = ""
        for _ in (0..<blanksToFill/2) {
            justifiedString.append(" ")
        }
        justifiedString.append(stringToJustify)
        for _ in (0..<(blanksToFill - blanksToFill/2)) {
            justifiedString.append(" ")
        }
        return justifiedString
    }
    
    static public func randomMatrix(rows: Int, columns: Int, maxReal: Double, maxIm: Double) -> Self {
        let matrixRandomArray = (0..<(Int(rows*columns))).map{_ in
            CompNumb.randomCompNumb(maxReal: maxReal, maxIm: maxIm)
        }
        return Self(rows: rows, values: matrixRandomArray)
        
    }
    
    public static func ==(lhs:Self, rhs: Self) -> Bool {
        
        return (lhs.grid.count == rhs.grid.count && lhs.grid == rhs.grid)
    }
}

public extension MatrixType {
    
    var entriesMaxNumberOfCharacters: Int  {
        return grid.map {
            $0.description
            }.reduce(0) { (tempMax, nextString) -> Int in
                return max(tempMax, nextString.count)
            } + 2
    }
    
    func row(_ j:Int) -> Vector {
        return (0...self.columns - 1).map{grid[$0 + j * self.rows]}
    }
    
    func column(_ j:Int) -> Vector {
        return (0...self.rows - 1).map{grid[j + $0 * self.columns]}
    }
    
    func columnIndexForGridIndex(_ index: Int) -> Int {
        return index % columns
    }
    
    func rowIndexForGridIndex(_ index: Int) -> Int {
        return (index - index % columns) / columns
    }
    
    var allColumns: [Vector] {
        return (0..<columns).map{self.column($0)}
    }
    
    var allRows: [Vector] {
        return (0..<rows).map{self.row($0)}
    }
    
    func indexIsValidForRow(_ row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    subscript(row: Int, column: Int) -> CompNumb {
        get {
            return grid[((row) * columns) + column]
        }
    }
    
    func transposed() -> Self {
        
        let newGrid = (0..<columns).map {
            return column($0)
            }.flatMap { $0 }
        
        return Self(rows: columns, values: newGrid)
    }
    
    func conjugated() -> Self {
        let newGrid = self.grid.map{$0.conjugated()}
        
        return Self(rows: rows, values: newGrid)
    }
    
    func matrixByRemoveColumn(_ j: Int) -> Matrix {
        let indecesToRemove: [Int] = (0...self.rows - 1).map{j + $0 * self.columns}
        let newArray = grid.enumerated().compactMap { indecesToRemove.contains($0.0) ? nil : $0.1 }
        return Matrix(rows: self.rows, values: newArray)
        
    }
    
    func matrixByRemoveRow(_ j: Int) -> Matrix {
        let indecesToRemove: [Int] = (0...self.columns - 1).map{$0 + j * self.columns}
        let newArray = grid.enumerated().compactMap { indecesToRemove.contains($0.0) ? nil : $0.1 }
        return Matrix(rows: self.rows - 1, values: newArray)
        
    }
    
    func minor(_ row: Int, column: Int) -> Matrix {
        return self.matrixByRemoveColumn(column).matrixByRemoveRow(row)
    }
    
    typealias MatrixEntry = (row: Int, column:Int)
    
    func submatrix(_ fromEntry: MatrixEntry, toEntry: MatrixEntry) -> Self {
        assert(self.indexIsValidForRow(fromEntry.row, column: fromEntry.column) && self.indexIsValidForRow(toEntry.row, column: toEntry.column) && fromEntry.row <= toEntry.row && fromEntry.column <= toEntry.column, "Incorrect indeces")
        
        let newRows: Int = toEntry.row - fromEntry.row + 1
        
        var newValues: [CompNumb] = []
        for j in fromEntry.row...toEntry.row {
            for i in fromEntry.column...toEntry.column {
                newValues.append(self[j,i])
            }
        }
        
        return Self(rows: newRows, values: newValues)
    }

    func isSymmetric() -> Bool {
        return self == self.transposed()
    }
    
    func isHermitian() -> Bool {
        return self == self.transposed().conjugated()
    }
}


public struct Matrix: MatrixType {
    
    public let rows: Int, columns: Int
    public let grid: [CompNumb]
    
    public init(rows: Int, values: [CompNumb]) {
        var columns = (values.count - (values.count % rows)) / rows
        if values.count % rows != 0 { columns = columns + 1 }
        self.init(rows: rows, columns: columns, values: values)
    }
    
    public init(rows: Int, columns: Int, values: [CompNumb]) {
        self.rows = rows
        self.columns = columns
        let limit = min(rows*columns, values.count)
        let zeroFillArray = Array(repeating: 0.0 + 0.i, count: max(rows*columns - values.count,0))
        self.grid = Array(values.prefix(limit)) + zeroFillArray
    }
    
    public init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    
    fileprivate func asSquareMatrix() -> SquareMatrix? {
        guard self.rows == self.columns, self.grid.count == rows*rows else { return nil }
        return SquareMatrix(rows: self.rows, values: self.grid)
    }
    
    
}

extension Matrix {
    public func isInvertible() -> Bool {
        guard let squareMatrix = self.asSquareMatrix() else { return false }
        
        return squareMatrix.isInvertible()
    }
    
    public func isUnitary() -> Bool {
        guard let squareMatrix = self.asSquareMatrix() else { return false }
        
        return squareMatrix.isUnitary()
    }
    
    
    public func determinant() -> CompNumb? {
        guard let squareMatrix = self.asSquareMatrix() else { return nil }
        
        return squareMatrix.determinant()
    }
    
    static public func *(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.columns == rhs.rows && lhs.columns > 0) else { return nil }
        let newGrid: [CompNumb] = (0..<lhs.rows*rhs.columns).map {
            let j = $0%rhs.columns
            let i = Int(($0 - $0%rhs.columns)/rhs.columns)
            return (lhs.row(i) ** rhs.column(j))!
        }
        return Matrix(rows: lhs.rows, columns: rhs.columns, values: newGrid)
    }
    
    static public func +(lhs: Matrix, rhs: Matrix) -> Matrix? {
        guard (lhs.rows == rhs.rows && lhs.columns == rhs.columns) else { return nil }
        let newArray = (0..<lhs.rows*lhs.columns).map { lhs.grid[$0] + rhs.grid[$0] }
        return Matrix(rows: lhs.rows, columns: lhs.columns, values: newArray)
    }
}

public struct SquareMatrix: MatrixType {
    
    public let rows: Int
    public var columns: Int {
        return rows
    }
    public let grid: [CompNumb]
    
    public init(rows: Int, values: [CompNumb]) {
        self.rows = rows
        let limit = min(rows*rows, values.count)
        let zeroFillArray = Array(repeating: 0.0 + 0.i, count: max(rows*rows - values.count,0))
        self.grid = Array(values.prefix(limit)) + zeroFillArray
    }
    
    public init(rows: Int) {
        self.rows = rows
        grid = Array(repeating: 0.0, count: rows * rows)
    }
    
    static public func randomMatrix(rows: Int, maxReal: Double, maxIm: Double) -> SquareMatrix {
        let matrixRandomArray = (0..<(Int(rows*rows))).map{_ in
            CompNumb.randomCompNumb(maxReal: maxReal, maxIm: maxIm)
        }
        return SquareMatrix(rows: rows, values: matrixRandomArray)
        
    }
    
    public func isInvertible() -> Bool {
        return (self.determinant() != 0) ? true : false
    }
    
    public func isIdentity() -> Bool {
        
        for (index, value) in grid.enumerated() {
            if rowIndexForGridIndex(index) == columnIndexForGridIndex(index)  {
                if value != 1 { return false }
            } else {
                if value != 0 { return false }
            }
        }
        return true
    }
    
    public func isUnitary() -> Bool {
        return ((self * self.transposed()).isIdentity())
    }
    
    
    public func determinant() -> CompNumb {
        if self.rows == 1 {
            return self[0,0]
            
        } else {
            var determinant: CompNumb = 0
            for k in 0...columns-1 {
                let sign: CompNumb = (k % 2 == 0) ? 1 : -1
                determinant = determinant + sign * self[0,k] * (self.minor(0, column: k).determinant())!
            }
            return determinant
        }
        
    }


}


extension SquareMatrix: Ring {

    
    static public func *(lhs: SquareMatrix, rhs: SquareMatrix) -> SquareMatrix {
        let newGrid: [CompNumb] = (0..<lhs.rows*rhs.columns).map {
            let j = $0%rhs.columns
            let i = Int(($0 - $0%rhs.columns)/rhs.columns)
            return (lhs.row(i) ** rhs.column(j))!
        }
        return SquareMatrix(rows: lhs.rows, values: newGrid)
    }
    
    static public func +(lhs: SquareMatrix, rhs: SquareMatrix) -> SquareMatrix {
        assert(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "You can only sum matrices of the same size")
        let newArray = (0..<lhs.rows*lhs.columns).map { lhs.grid[$0] + rhs.grid[$0] }
        return SquareMatrix(rows: lhs.rows, values: newArray)
    }
}


extension SquareMatrix: AssociativeAlgebra {
    /// TODO: give a proper multiplicative inverse to square matrices
    public func multInverse() -> SquareMatrix {
        return SquareMatrix(rows: 0, values: [])
    }

    public func addInverse() -> SquareMatrix {
        return SquareMatrix(rows: self.rows, values: self.grid.map{$0.addInverse()})
    }
    
    public static func *(lhs:CompNumb, rhs: SquareMatrix) -> SquareMatrix {
        let newGrid = rhs.grid.map { lhs*$0 }
        return SquareMatrix(rows: rhs.rows, values: newGrid)
    }
    public static func *(lhs:SquareMatrix, rhs: CompNumb) -> SquareMatrix {
        return rhs*lhs
    }
}


infix operator ** : MultiplicationPrecedence


func **(lhs: Vector, rhs: Vector) -> CompNumb? {
    if(lhs.count == rhs.count && lhs.count > 0) {
        return (0..<lhs.count).map{lhs[$0]*rhs[$0]}.reduce(0.0) {$0 + $1}
    } else {
        return nil
    }
    
}



extension Array {
    func norm() -> Double {
        return sqrt(self.map {
            switch $0 {
            case let someInt as Int:
                return Double(someInt)
            case let someDouble as Double:
                return someDouble
            case let someFloat as Float:
                return Double(someFloat)
            default:
                return 0.0
            }
            }.reduce(0.0) {$0 + $1*$1})
    }
}





