import UIKit

class ViewController: UIViewController, SnakeViewDelegate {
	@IBOutlet var startButton:UIButton?
	var snakeView:SnakeView?
	var timer:NSTimer?

	var snake:Snake?
	var fruit:Point?

	override func viewDidLoad() {
		super.viewDidLoad()

		self.snakeView = SnakeView(frame: self.view.bounds)
		self.snakeView!.autoresizingMask = .FlexibleWidth | .FlexibleHeight
		self.view.insertSubview(self.snakeView!, atIndex: 0)

		if let view = self.snakeView? {
			view.delegate = self
		}
		for direction in [UISwipeGestureRecognizerDirection.Right,
			UISwipeGestureRecognizerDirection.Left,
			UISwipeGestureRecognizerDirection.Up,
			UISwipeGestureRecognizerDirection.Down] {
				let gr = UISwipeGestureRecognizer(target: self, action: "swipe:")
				gr.direction = direction
				self.view.addGestureRecognizer(gr)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func swipe (gr:UISwipeGestureRecognizer) {
		let direction = gr.direction
		switch direction {
		case UISwipeGestureRecognizerDirection.Right:
			if (self.snake?.changeDirection(Direction.right) != nil) {
				self.snake?.lockDirection()
			}
		case UISwipeGestureRecognizerDirection.Left:
			if (self.snake?.changeDirection(Direction.left) != nil) {
				self.snake?.lockDirection()
			}
		case UISwipeGestureRecognizerDirection.Up:
			if (self.snake?.changeDirection(Direction.up) != nil) {
				self.snake?.lockDirection()
			}
		case UISwipeGestureRecognizerDirection.Down:
			if (self.snake?.changeDirection(Direction.down) != nil) {
				self.snake?.lockDirection()
			}
		default:
			assert(false, "This could not happen")
		}
	}

	func makeNewFruit() {
		srandomdev()
		let worldSize = self.snake!.worldSize
		var x = 0, y = 0
		while (true) {
			x = random() % worldSize.width
			y = random() % worldSize.height
			var isBody = false
			for p in self.snake!.points {
				if p.x == x && p.y == y {
					isBody = true
					break
				}
			}
			if !isBody {
				break
			}
		}
		self.fruit = Point(x: x, y: y)
	}

	func startGame() {
		if (self.timer != nil) {
			return
		}

		self.startButton!.hidden = true
		let worldSize = WorldSize(width: 24, height: 15)
		self.snake = Snake(inSize: worldSize, length: 2)
		self.makeNewFruit()
		self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerMethod:", userInfo: nil, repeats: true)
		self.snakeView!.setNeedsDisplay()
	}

	func endGame() {
		self.startButton!.hidden = false
		self.timer!.invalidate()
		self.timer = nil
	}

	func timerMethod(timer:NSTimer) {
		self.snake?.move()
		var headHitBody = self.snake?.isHeadHitBody()
		if headHitBody == true {
			self.endGame()
			return
		}

		let head = self.snake?.points[0]
		if head?.x == self.fruit?.x &&
			head?.y == self.fruit?.y {
				self.snake!.increaseLength(2)
				self.makeNewFruit()
		}

		self.snake?.unlockDirection()
		self.snakeView!.setNeedsDisplay()
	}

	@IBAction func start(sender:AnyObject) {
		self.startGame()
	}

	func snakeForSnakeView(view:SnakeView) -> Snake? {
		return self.snake
	}
	func pointOfFruitForSnakeView(view:SnakeView) -> Point? {
		return self.fruit
	}
}
