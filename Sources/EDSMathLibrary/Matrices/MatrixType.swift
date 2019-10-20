import Foundation

public protocol MatrixType: CustomStringConvertible, Equatable, Sequence {
    associatedtype T: Field, CustomStringConvertible
    typealias Vector = [T]
    var rows: Int {get}
    var columns: Int {get}
    var grid: Vector {get}
    
    init(rows: Int, values: Vector)
    
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
    
    public static func ==(lhs:Self, rhs: Self) -> Bool {
        
        return (lhs.grid.count == rhs.grid.count && lhs.grid == rhs.grid)
    }
}

extension MatrixType {

    public func makeIterator() -> IndexingIterator<Vector> {
        return grid.makeIterator()
    }
}

public extension MatrixType {
    
    var entriesMaxNumberOfCharacters: Int  {
        return grid.map {
            $0.description
            }.reduce(0) { (tempMax, nextString) -> Int in
                return Swift.max(tempMax, nextString.count)
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
    
    subscript(row: Int, column: Int) -> T {
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
    
    typealias MatrixEntry = (row: Int, column:Int)
    
    func submatrix(_ fromEntry: MatrixEntry, toEntry: MatrixEntry) -> Self {
        assert(self.indexIsValidForRow(fromEntry.row, column: fromEntry.column) && self.indexIsValidForRow(toEntry.row, column: toEntry.column) && fromEntry.row <= toEntry.row && fromEntry.column <= toEntry.column, "Incorrect indeces")
        
        let newRows: Int = toEntry.row - fromEntry.row + 1
        
        var newValues: Vector = []
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
}
