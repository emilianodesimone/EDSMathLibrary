//
//  Complex.swift
//  
//
//  Created by Emiliano De Simone on 10/09/16.
//
//

import Foundation

public struct CompNumb: Hashable, ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    
    public var real: Double
    public var im: Double
    
    public init(real: Double, imaginary: Double) {
        self.real = real
        self.im = imaginary
    }
    
    public init (integerLiteral value: IntegerLiteralType) {
        real = Double(value)
        im = 0.0
    }
    
    public init (floatLiteral value: FloatLiteralType) {
        real = value
        im = 0.0
    }
    
    public func conjugated() -> CompNumb {
        return CompNumb(real: self.real, imaginary: -self.im)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(real)
        hasher.combine(im)
    }


    static public func randomCompNumb(maxReal: Double, maxIm: Double) -> CompNumb {
        let realPart = drand48() * maxReal
        let imPart = drand48() * maxIm
        return CompNumb(real: realPart, imaginary: imPart)
    }
    
}

extension CompNumb: Equatable {
    static public func ==(lhs: CompNumb, rhs:CompNumb) -> Bool {
        return abs(lhs.real - rhs.real) + abs(lhs.im - rhs.im) < 0.0000001
    }
}

extension CompNumb: CustomStringConvertible {
    public var description: String {
        switch (self.real, self.im) {
        case (0, 0):
            return "0"
        case (_, 0):
            return prdouble(self.real)
        case (0, _):
            return prdouble(self.im)
        case (_, 1):
            return "\(prdouble(self.real)) + i"
        case (_, -1):
            return "\(prdouble(self.real)) - i"
        case (_, let value):
            if value > 0 {
                return "\(prdouble(self.real)) + i*\(prdouble(self.im))"
            } else {
                return "\(prdouble(self.real)) - i*\(prdouble(-self.im))"
            }
        }
    }
    
    private func prdouble(_ value: Double) -> String {
        if value == floor(value) {
            return "\(Int(value))"
        } else {
            return String(format: "%.2f", value)
        }
    }
}

extension CompNumb: Normable {
    public func norm() -> Double {
        return sqrt(real * real + im * im)
    }
}

extension CompNumb: Ring {
    
    static public func +(lhs:CompNumb, rhs: CompNumb) -> CompNumb {
        return CompNumb(real: lhs.real + rhs.real, imaginary: lhs.im + rhs.im)
    }
    
    static public func *(lhs:CompNumb, rhs: CompNumb) -> CompNumb {
        return CompNumb(real: lhs.real*rhs.real - lhs.im*rhs.im, imaginary: lhs.im*rhs.real + rhs.im*lhs.real)
    }

    static public func -(lhs:CompNumb, rhs: CompNumb) -> CompNumb {
        return CompNumb(real: lhs.real - rhs.real, imaginary: lhs.im - rhs.im)
    }
}

extension CompNumb: Field {
    public static var zero: CompNumb {
        return 0
    }
    
    public static var one: CompNumb {
        return 1
    }
    
    
    public func multInverse() -> CompNumb {
        return CompNumb(real: self.real/(self.real*self.real + self.im*self.im), imaginary: -self.im/(self.real*self.real + self.im*self.im))
    }
    
    public func addInverse() -> CompNumb {
        return CompNumb(real: -self.real, imaginary: -self.im)
    }
    
    static public func /(lhs: CompNumb, rhs: CompNumb) -> CompNumb {
        return lhs * rhs.multInverse()
    }
}



