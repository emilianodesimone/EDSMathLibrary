import XCTest
@testable import EDSMathLibrary

final class EDSMathLibraryTests: XCTestCase {
    
    func testComplexNumbers() {
        let a = CompNumb(real: 2.0, imaginary: 3.0)
        let b = 3.i + 4
        
        XCTAssertEqual(a + b, 6 + 6.i)
        XCTAssertEqual(a * b, -1 + 18.i)
        XCTAssertEqual((a + b).norm(), sqrt(72))
        
    }
    
    func testMatrix() {
        let matrix = ComplexMatrix(rows: 3, values: [2,0,0,0,2,0,0,0,2])
        XCTAssertNotNil(matrix.asSquareMatrix())
        if let squareMatrix = matrix.asSquareMatrix() {
            XCTAssertEqual(squareMatrix.determinant(), 8)
            XCTAssertTrue(squareMatrix.isInvertible())
            XCTAssertFalse(squareMatrix.isIdentity())
        }
        let identityMatrix = ComplexSquareMatrix(rows: 3, values: [1,0,0,0,1,0,0,0,1])
        XCTAssertEqual(identityMatrix.determinant(), 1)
        XCTAssertTrue(identityMatrix.isIdentity())
        let nonSquareMatrix = ComplexMatrix(rows: 3, values: [2,1,0,1,4,4])
        XCTAssertNil(nonSquareMatrix.asSquareMatrix())
        XCTAssertNil(nonSquareMatrix.determinant())
        
        XCTAssertEqual(exp(identityMatrix, 3), identityMatrix)
        XCTAssertEqual(exp(matrix.asSquareMatrix()!, 3), ComplexSquareMatrix(rows: 3, values: [8,0,0,0,8,0,0,0,8]))
    }

    static var allTests = [
        ("testExample", testMatrix),
    ]
}
