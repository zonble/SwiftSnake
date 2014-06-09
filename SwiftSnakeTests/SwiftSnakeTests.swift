import XCTest

class SwiftSnakeTests: XCTestCase {

	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		super.tearDown()
	}

	func testSnakePoint() -> Void {
		let point:Point = Point(x:10, y:20)
		XCTAssertTrue(point.x == 10, "x must be 10")
		XCTAssertTrue(point.y == 20, "y must be 20")
	}

	func testHit() {
		let snake = Snake(inSize: WorldSize(width: 10, height: 10), length: 6)
		snake.changeDirection(.up)
		snake.move()
		snake.changeDirection(.right)
		snake.move()
		snake.changeDirection(.down)
		snake.move()
		XCTAssertTrue(snake.isHeadHitBody(), "head must hit body.")
	}
}
