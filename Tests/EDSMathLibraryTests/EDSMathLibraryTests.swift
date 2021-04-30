import XCTest
@testable import EDSMathLibrary

final class EDSMathLibraryTests: XCTestCase {
    
    var testRealMatrix: Matrix<CompNumb>!
    var testRealMatrixTransposed: Matrix<CompNumb>!
    var testComplexSquareMatrix: SquareMatrix<CompNumb>!
    var squareMatrixInDisguise: Matrix<CompNumb>!
    var idMatrix: SquareMatrix<CompNumb>!
    var squareMatrix: SquareMatrix<CompNumb>!
    var hermitianMatrix: SquareMatrix<CompNumb>!
    var testMatrixToInvert: SquareMatrix<CompNumb>!
    var testMatrixInverted: SquareMatrix<CompNumb>!
    
    override func setUp() {
        super.setUp()
        testRealMatrix = Matrix(grid: [[0,1],[2,1],[3,5]])
        testRealMatrixTransposed = Matrix(grid: [[0,2,3],[1,1,5]])
        testComplexSquareMatrix = SquareMatrix(grid: [[2 - 8.i, 3.i], [1, 0 - 4.i]])
        squareMatrixInDisguise = Matrix(grid: [[0,1,2],[1,3,5], [4, 2, 3]])
        idMatrix = SquareMatrix(grid: [[1,0,0],[0,1,0],[0,0,1]])
        squareMatrix = SquareMatrix(grid: [[2,3],[1,4]])
        hermitianMatrix = SquareMatrix(grid: [[1, 1 + 2.i, 2 + 3.i], [1 - 2.i, 3, 4 - 2.i], [2 - 3.i, 4 + 2.i, 3]])
        testMatrixToInvert = SquareMatrix<CompNumb>(grid: [[4,7],[2,6]])
        testMatrixInverted = SquareMatrix<CompNumb>(grid: [[0.6,-0.7],[-0.2,0.4]])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        testRealMatrix = nil
        testRealMatrixTransposed = nil
        testComplexSquareMatrix = nil
        idMatrix = nil
        squareMatrix = nil
        squareMatrixInDisguise = nil
        hermitianMatrix = nil
    }
    
    
    func testDeterminant() {
        XCTAssertNil(testRealMatrix.determinant(), "The determinant of a non-square matrix has to be nil")
        XCTAssertNotNil(squareMatrixInDisguise, "A matrix of class 'Matrix', if it's square, has to have a determinant")
        XCTAssertEqual(idMatrix.determinant(), 1, "The determinant of the Identity has to be equal to 1")
        XCTAssertEqual(squareMatrix.determinant(), 5, "The determinant of this test SquareMatrix has to be equal to 5")
        XCTAssertEqual(testComplexSquareMatrix.determinant(), -32 - 11.i , "The determinant of this test SquareMatrix has to be equal to \(-32 - 11.i) and not \(testComplexSquareMatrix.determinant())")
    }
    
    func testHermitian() {
        XCTAssertTrue(hermitianMatrix.isHermitian(), "An hermitian matrix has to be recognised as such.")
        XCTAssertTrue(idMatrix.isHermitian(), "The identity matrix is hermitian.")
    }
    
    func testInverse() {
        XCTAssertEqual(idMatrix.multInverse(), idMatrix, "The inverse of the identity has to be itself")
        XCTAssertEqual(testMatrixToInvert.multInverse(), testMatrixInverted, "The inverse of testMatrixToInvert has to be \(testMatrixInverted.grid), not \(testMatrixToInvert.multInverse().grid)")
        XCTAssertEqual(testRealMatrix, testRealMatrix)
    }
    
    func testIdentity() {
        XCTAssertTrue(idMatrix.isIdentity(), "The identity matrix has to be recognised as such.")
        XCTAssertFalse(squareMatrix.isIdentity(), "A matrix different from the Identity matrix cannot be recognised as such.")
    }
    
    func testTransposition() {
        XCTAssertEqual(testRealMatrix.transposed(), testRealMatrixTransposed, "The matrix returned by the transpose() function called by the first matrix should be equal to the second matrix.")
    }
    
    func testSizes() {
        
        XCTAssertEqual(testRealMatrix.matrixByRemoveRow(1).rows, testRealMatrix.rows - 1, "When removing a row, the resulting Matrix has to be a number of rows equal to the original minus one.")
        XCTAssertEqual(testRealMatrix.matrixByRemoveColumn(2).columns, testRealMatrix.columns - 1, "When removing a column, the resulting Matrix has to be a number of columns equal to the original minus one.")
        XCTAssertNotNil(squareMatrix.minor(1, column: 1).determinant(), "A minor of a square matrix has to have a determinant as well")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }
}
