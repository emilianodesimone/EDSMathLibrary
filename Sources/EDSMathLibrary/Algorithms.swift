//
//  Algorithms.swift
//  MathLibraries
//
//  Created by De Simone, Emiliano on 15/04/2018.
//  Copyright © 2018 EmilianoDeSimoneSoftware. All rights reserved.
//

import Foundation

public func findMinimumOrderForTaylorLn(at x: Double, precision: Double, maxTrialOrder: Int) -> Int? {
    var N = 1
    let y = x - 1
    var sum: Double = 0
    var power = y
    var term = y
    var sign: Double = -1
    
    while N <= maxTrialOrder {
        sign = -sign
        sum = sum + sign * term
        power = power * y
        term = power/Double(N+1)
        if max(term, -term) < precision {
            return N
        }
        N = N+1
    }
    
    return nil
}

public typealias realFunction = (Double) -> Double

public func bisectionZeroes(of f: realFunction, from leftExtreme: Double, to rightExtreme: Double, tolerance TOL: Double, maxIterations: Int) -> Double? {
    var i = 1
    var a = leftExtreme
    var b = rightExtreme
    var fLeft = f(a)
    while i <= maxIterations {
        let p = a + (b-a)/2 //compute p_i
        let fMiddle = f(p)
        if fMiddle == 0 || (b-a)/2 < TOL {
            return p //Procedure completed succesfully
        }
        i = i+1
        //Compute a_i, b_i
        if fLeft * fMiddle > 0 {
            a = p
            fLeft = fMiddle
        } else {
            b = p // fLeft is unchanged
        }
    }
    
    print("The method failed after \(maxIterations).")
    return nil
}

public func squareRoot(_ x: Double) -> Double? {
    return bisectionZeroes(of: {$0*$0 - x}, from: 0, to: x*x, tolerance: 0.0001, maxIterations: 50)
}

//public func newtonZeroes(of f: realFunction, initialApproximation: Double, tolerance TOL: Double, maxIterations: Int) -> Double? {
//    var i = 1
//    var p_0 = initialApproximation
//    while i <= maxIterations {
//        let p = p_0 - f(p_0)/
//    }
//    print("The method failed after \(maxIterations).")
//    return nil
//}

public func secantZeroes(of f: realFunction, initialApproximation0: Double, initialApproximation1: Double, tolerance TOL: Double, maxIterations: Int) -> Double? {
    var i = 2
    var p_0 = initialApproximation0
    var p_1 = initialApproximation1
    var q_0 = f(p_0)
    var q_1 = f(p_1)
    while i <= maxIterations {
        let p = p_1 - q_1*(p_1 - p_0)/(q_1 - q_0)
        if abs(p-p_1) < TOL {
            return p
        }
        i = i+1
        p_0 = p_1
        q_0 = q_1
        p_1 = p
        q_1 = f(p)
    }
    
    print("The method failed after \(maxIterations).")
    return nil
}

public func falsePositionZeroes(of f: realFunction, initialApproximation0: Double, initialApproximation1: Double, tolerance TOL: Double, maxIterations: Int) -> Double? {
    var i = 2
    var p_0 = initialApproximation0
    var p_1 = initialApproximation1
    var q_0 = f(p_0)
    var q_1 = f(p_1)
    while i <= maxIterations {
        let p = p_1 - q_1*(p_1 - p_0)/(q_1 - q_0)
        if abs(p-p_1) < TOL {
            return p
        }
        i = i+1
        let q = f(p)
        
        if q*q_1 < 0 {
            p_0 = p_1
            q_0 = q_1
        }
        p_1 = p
        q_1 = q
    }
    
    print("The method failed after \(maxIterations).")
    return nil
}

public func findFixedPoint(of f: realFunction, initialApproximation: Double, tolerance TOL: Double, maxIterations: Int) -> Double? {
    var i = 1
    var p_0 = initialApproximation
    while i <= maxIterations {
        let p = f(p_0)
        if abs(p - p_0) < TOL {
            return p
        }
        i = i+1
        p_0 = p
    }
    print("The method failed after \(maxIterations).")
    return nil
}
