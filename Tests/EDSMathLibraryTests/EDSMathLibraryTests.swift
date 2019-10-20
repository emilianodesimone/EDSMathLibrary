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
        let matrix = Matrix(rows: 3, values: [2,0,0,0,2,0,0,0,2])
        XCTAssertNotNil(matrix.asSquareMatrix())
        if let squareMatrix = matrix.asSquareMatrix() {
            XCTAssertEqual(squareMatrix.determinant(), 8)
            XCTAssertTrue(squareMatrix.isInvertible())
            XCTAssertFalse(squareMatrix.isIdentity())
        }
        let identityMatrix = SquareMatrix(rows: 3, values: [1,0,0,0,1,0,0,0,1])
        XCTAssertEqual(identityMatrix.determinant(), 1)
        XCTAssertTrue(identityMatrix.isIdentity())
        let nonSquareMatrix = Matrix(rows: 3, values: [2,1,0,1,4,4])
        XCTAssertNil(nonSquareMatrix.asSquareMatrix())
        XCTAssertNil(nonSquareMatrix.determinant())
        
    }

    static var allTests = [
        ("testExample", testMatrix),
    ]
}
