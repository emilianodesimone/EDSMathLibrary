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
        let squareMatrix = SquareMatrix(rows: 3, values: [2,0,0,0,2,0,0,0,2])
        XCTAssertEqual(squareMatrix.determinant(), 8)
        XCTAssertTrue(squareMatrix.isInvertible())
        XCTAssertFalse(squareMatrix.isIdentity())
    }

    static var allTests = [
        ("testExample", testMatrix),
    ]
}
