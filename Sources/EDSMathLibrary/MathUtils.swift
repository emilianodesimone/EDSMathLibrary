import Foundation



public func factorial(_ k: Int) -> Int {
    if k == 1 { return 1 }
    else {
        return k * factorial(k-1)
    }
}

public func exp<T: AssociativeAlgebra>(_ x :T, _ exponent: Int) -> T {
    guard exponent > 0 else { return x*x.multInverse() }
    guard exponent > 1 else { return x }
    var result = x
    for _ in 2...exponent {
        result = result * x
    }
    return result
}


public func e<T: AssociativeAlgebra>(_ x: T, order: Int = 15) -> T {
    
    var eSeries = [T]()
    let initial = x*x.multInverse()
    for k in 1...order {
        let z : CompNumb = CompNumb(integerLiteral: factorial(k))
        eSeries.append(exp(x,k)/z)
    }

    return eSeries.reduce(initial, +)
    
}

public protocol Ring: Equatable {
    static func +(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
}

public protocol Field: Ring {
    
    func multInverse() -> Self
    func addInverse() -> Self
}

public protocol AssociativeAlgebra: Field {
    
    static func *(lhs:CompNumb, rhs: Self) -> Self
    static func *(lhs:Self, rhs: CompNumb) -> Self
    
}

extension AssociativeAlgebra {
    static func /(lhs: Self, rhs: CompNumb) -> Self {
        return lhs*rhs.multInverse()
    }
}

public protocol Normable {
    func norm() -> Double
}

public extension Double {
    var i:CompNumb {
        return CompNumb(real: 0, imaginary: self)
    }
}

public extension Int {
    var i:CompNumb {
        return CompNumb(real: 0, imaginary: Double(self))
    }
}

public extension Float {
    var i:CompNumb {
        return CompNumb(real: 0, imaginary: Double(self))
    }
}


extension Double: Field {
    public func multInverse() -> Double {
        return Double(1/self)
    }
    
    public func addInverse() -> Double {
        return -self
    }
}


extension Float: Field {

    public func multInverse() -> Float {
        return Float(1/self)
    }
    
    public func addInverse() -> Float {
        return -self
    }
}

infix operator ** : MultiplicationPrecedence


func **<T>(lhs: [T], rhs: [T]) -> T? where T: Field {
    guard lhs.count == rhs.count && lhs.count > 0 else { return nil }
    let vectorOfProducts = (1..<lhs.count).map{lhs[$0]*rhs[$0]}
    return vectorOfProducts.reduce(lhs[0]*rhs[0]) {$0 + $1}
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
