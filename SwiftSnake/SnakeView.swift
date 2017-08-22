import UIKit

protocol SnakeViewDelegate {
	func snakeForSnakeView(_ view:SnakeView) -> Snake?
	func pointOfFruitForSnakeView(_ view:SnakeView) -> Point?
}

class SnakeView : UIView {
	var delegate:SnakeViewDelegate?

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.backgroundColor = UIColor.white
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.white
	}

	override func draw(_ rect: CGRect) {
		super.draw(rect)

        UIColor.lightGray.set()
        UIBezierPath(rect: rect).fill()

		if let snake:Snake = delegate?.snakeForSnakeView(self) {
			let worldSize = snake.worldSize
            let tileSize = self.bounds.size.height

			if worldSize <= 0 {
				return
			}

			let w = Int(Float(tileSize) / Float(worldSize))
			let h = Int(Float(tileSize) / Float(worldSize))

			UIColor.black.set()
			let points = snake.points
			for point in points {
				let rect = CGRect(x: point.x * w, y: point.y * h, width: w, height: h)
				UIBezierPath(rect: rect).fill()
			}

			if let fruit = delegate?.pointOfFruitForSnakeView(self) {
				UIColor.red.set()
				let rect = CGRect(x: fruit.x * w, y: fruit.y * h, width: w, height: h)
				UIBezierPath(ovalIn: rect).fill()
			}
		}
	}
}
