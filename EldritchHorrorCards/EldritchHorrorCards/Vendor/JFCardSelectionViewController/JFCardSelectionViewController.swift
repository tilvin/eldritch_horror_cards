import UIKit

public struct CardAction {
	public let title: String
	
	public init?(title: String) {
		self.title = title
	}
}

public protocol CardPresentable {
	var imageURLString: String { get }
	var placeholderImage: UIImage? { get }
	var nameText: String { get }
	var score: Int { get }
	var dialLabel: String { get }
	var detailText: String { get }
	var action: CardAction? { get }
}

public enum JFCardSelectionViewSelectionAnimationStyle {
	case fade, slide
}

public protocol JFCardSelectionViewControllerDelegate {
	func cardSelectionViewController(_ cardSelectionViewController: JFCardSelectionViewController, didSelectCardAction cardAction: CardAction, forCardAtIndexPath indexPath: IndexPath) -> Void
	func cardSelectionViewController(_ cardSelectionViewController: JFCardSelectionViewController, didSelectDetailActionForCardAtIndexPath indexPath: IndexPath) -> Void
}

public protocol JFCardSelectionViewControllerDataSource {
	func numberOfCardsForCardSelectionViewController(_ cardSelectionViewController: JFCardSelectionViewController) -> Int
	func cardSelectionViewController(_ cardSelectionViewController: JFCardSelectionViewController, cardForItemAtIndexPath indexPath: IndexPath) -> CardPresentable
}

open class JFCardSelectionViewController: UIViewController {
	
	/// This will be the UIImage behind a UIVisualEffects view that will be used to add a blur effect to the background. If this isn't set, the photo of the selected CardPresentable will be used.
	open var backgroundImage: UIImage? {
		didSet {
			bgImageView.image = backgroundImage
			UIView.animate(withDuration: 0.3, animations: {
				self.bgImageView.alpha = 1
				self.bgImageViewTwo.alpha = 0
			}, completion: { (finished) -> Void in
				if finished {
					self.bgImageViewTwo.image = nil
					self.showingImageViewOne = true
				}
			})
		}
	}
	
	open var delegate: JFCardSelectionViewControllerDelegate?
	open var dataSource: JFCardSelectionViewControllerDataSource?
	open var selectionAnimationStyle: JFCardSelectionViewSelectionAnimationStyle = .fade
	
	var previouslySelectedIndexPath: IndexPath?
	let focusedView = JFFocusedCardView.loadNib()
	let focusedViewTwo = JFFocusedCardView.loadNib()
	let dialView = DialView()
	let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: JFCardSelectionViewFlowLayout())
	
	fileprivate var bgImageView = UIImageView()
	fileprivate var bgImageViewTwo = UIImageView()
	fileprivate var showingImageViewOne = true
	fileprivate var focusedViewHConstraints = [NSLayoutConstraint]()
	fileprivate var focusedViewTwoHConstraints = [NSLayoutConstraint]()
	fileprivate let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
	fileprivate let blurEffectViewTwo = UIVisualEffectView(effect: UIBlurEffect(style: .light))
	fileprivate let bottomCircleView = UIView()
	fileprivate let bottomCircleOutlineView = UIView()
	fileprivate let topSpace: CGFloat = 74
	fileprivate let bottomSpace: CGFloat = 20
	fileprivate let horizontalSpace: CGFloat = 75
	fileprivate var focusedViewMetrics: [String: CGFloat] {
		let width = view.frame.width - (horizontalSpace * 2)
		return [
			"maxX": view.frame.maxX,
			"minX": view.frame.minX - (width),
			"width": width,
			"topSpace": topSpace,
			"bottomSpace": bottomSpace,
			"horizontalSpace": horizontalSpace
		]
	}
	
	fileprivate var focusedViewViews: [String: UIView] {
		return [
			"focusedView": focusedView,
			"focusedViewTwo": focusedViewTwo,
			"collectionView": collectionView
		]
	}
	
	// MARK: - Lifecycle
	
	deinit {
		collectionView.removeObserver(self, forKeyPath: "contentOffset")
	}
	
	open override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		buildCardSelectionUI()
		buildFocusedCardUI()
		view.layoutIfNeeded()
	}
	
	open override var shouldAutorotate : Bool {
		return false
	}
	
	open func reloadData() {
		collectionView.reloadData()
	}
	
	fileprivate func buildBGUI() {
		bgImageView.image = backgroundImage ?? nil
		bgImageView.translatesAutoresizingMaskIntoConstraints = false
		blurEffectView.translatesAutoresizingMaskIntoConstraints = false
		bgImageView.addSubview(blurEffectView)
		view.addSubview(bgImageView)
		bgImageViewTwo.translatesAutoresizingMaskIntoConstraints = false
		blurEffectViewTwo.translatesAutoresizingMaskIntoConstraints = false
		bgImageViewTwo.addSubview(blurEffectViewTwo)
		bgImageViewTwo.alpha = 0
		view.insertSubview(bgImageViewTwo, belowSubview: bgImageView)
		
		let views = ["bgImageView": bgImageView, "blurEffectView": blurEffectView, "bgImageViewTwo": bgImageViewTwo, "blurEffectViewTwo": blurEffectViewTwo] as [String : Any]
		for val in ["V", "H"] {
			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "\(val):|[bgImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
			view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "\(val):|[bgImageViewTwo]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
			bgImageView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "\(val):|[blurEffectView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
			bgImageViewTwo.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "\(val):|[blurEffectViewTwo]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
		}
		view.layoutIfNeeded()
	}
	
	fileprivate func buildCardSelectionUI() {
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.showsHorizontalScrollIndicator = false
		let bundle = Bundle(for: JFCardSelectionCell.self)
		collectionView.register(UINib(nibName: JFCardSelectionCell.reuseIdentifier, bundle: bundle), forCellWithReuseIdentifier: JFCardSelectionCell.reuseIdentifier)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = UIColor.clear
		view.addSubview(collectionView)
		let height = UIScreen.main.bounds.height / 3
		var metrics = ["height": height]
		let views = ["collectionView": collectionView]
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[collectionView(==height)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
		view.layoutIfNeeded()
		
		var width = view.frame.width
		var y = view.frame.maxY - 40
		
		dialView.translatesAutoresizingMaskIntoConstraints = false
		view.insertSubview(dialView, belowSubview: collectionView)
		metrics = ["width": view.frame.width, "y": view.frame.maxY - 60]
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(y)-[dialView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["dialView": dialView]))
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dialView(==width)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["dialView": dialView]))
		view.layoutIfNeeded()
		
		bottomCircleOutlineView.backgroundColor = UIColor.clear
		view.insertSubview(bottomCircleOutlineView, belowSubview: dialView)
		width += 15
		y -= 27.5
		bottomCircleOutlineView.frame = CGRect(x: 0, y: y, width: width, height: width)
		let trackingLine = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
		trackingLine.makeRoundWithBorder(width: 2, color: UIColor.white.withAlphaComponent(0.5))
		bottomCircleOutlineView.addSubview(trackingLine)
		bottomCircleOutlineView.center.x = view.center.x
		
		var x = (bottomCircleOutlineView.frame.width / CGFloat(Double.pi * 2)) - 9.5
		y = x
		let trackingIndicatorInner = UIView(frame: CGRect(x: x, y: y, width: 10, height: 10))
		trackingIndicatorInner.makeRound()
		trackingIndicatorInner.backgroundColor = UIColor.white
		
		x -= 2.5
		y -= 2.5
		bottomCircleOutlineView.addSubview(trackingIndicatorInner)
		
		collectionView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
	}
	
	fileprivate func buildFocusedCardUI() {
		focusedView.delegate = self
		focusedViewTwo.delegate = self
		focusedView.layer.cornerRadius = 20
		focusedView.shadowRadius = 4
		focusedView.shadowOpacity = 1
		
		focusedViewTwo.layer.cornerRadius = 20
		focusedViewTwo.shadowRadius = 4
		focusedViewTwo.shadowOpacity = 1
		
		focusedView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(focusedView)
		focusedViewTwo.translatesAutoresizingMaskIntoConstraints = false
		view.insertSubview(focusedViewTwo, belowSubview: focusedView)
		
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(topSpace)-[focusedView]-(bottomSpace)-[collectionView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews))
		focusedViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(horizontalSpace)-[focusedView]-(horizontalSpace)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
		view.addConstraints(focusedViewHConstraints)
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(topSpace)-[focusedViewTwo]-(bottomSpace)-[collectionView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews))
		
		switch selectionAnimationStyle {
		case .fade:
			focusedViewTwo.alpha = 0
			focusedViewTwoHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(horizontalSpace)-[focusedViewTwo]-(horizontalSpace)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			view.addConstraints(focusedViewTwoHConstraints)
		case .slide:
			focusedViewTwo.isHidden = true
			focusedViewTwoHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(maxX)-[focusedViewTwo]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			view.addConstraints(focusedViewTwoHConstraints)
		}
		
		let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(JFCardSelectionViewController.previousCard))
		swipeRightGesture.direction = .right
		view.addGestureRecognizer(swipeRightGesture)
		
		let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(JFCardSelectionViewController.nextCard))
		swipeLeftGesture.direction = .left
		view.addGestureRecognizer(swipeLeftGesture)
		
		view.layoutIfNeeded()
	}
	
	func updateUIForCard(_ card: CardPresentable, atIndexPath indexPath: IndexPath) {
		collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
		
		if !showingImageViewOne {
			if backgroundImage == nil {
				bgImageView.image = UIImage(named: card.imageURLString)
			}
			focusedView.configureForCard(card)
		} else {
			if backgroundImage == nil {
				bgImageView.image = UIImage(named: card.imageURLString)
			}
			focusedViewTwo.configureForCard(card)
		}
		
		switch selectionAnimationStyle {
		case .fade:
			fade()
		case .slide:
			slideToIndexPath(indexPath)
		}
		
		showingImageViewOne = !showingImageViewOne
	}
	
	@objc func previousCard() {
		let generator = UIImpactFeedbackGenerator(style: .medium)
		generator.impactOccurred()
		
		let count = dataSource?.numberOfCardsForCardSelectionViewController(self) ?? 0
		let row = (previouslySelectedIndexPath?.row ?? 0) - 1
		let section = previouslySelectedIndexPath?.section ?? 0
		if row >= 0 && row < count {
			let indexPath = IndexPath(row: row, section: section)
			guard let card = dataSource?.cardSelectionViewController(self, cardForItemAtIndexPath: indexPath) else {
				return
			}
			collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
			updateUIForCard(card, atIndexPath: indexPath)
			previouslySelectedIndexPath = indexPath
		}
	}
	
	@objc func nextCard() {
		let generator = UIImpactFeedbackGenerator(style: .medium)
		generator.impactOccurred()
		
		let count = dataSource?.numberOfCardsForCardSelectionViewController(self) ?? 0
		let row = (previouslySelectedIndexPath?.row ?? 0) + 1
		let section = previouslySelectedIndexPath?.section ?? 0
		if row < count {
			let indexPath = IndexPath(row: row, section: section)
			guard let card = dataSource?.cardSelectionViewController(self, cardForItemAtIndexPath: indexPath) else {
				return
			}
			collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
			updateUIForCard(card, atIndexPath: indexPath)
			previouslySelectedIndexPath = indexPath
		}
	}
	
	func fade() {
		UIView.animate(withDuration: 0.5, animations: { () -> Void in
			if self.backgroundImage == nil {
				self.bgImageView.alpha = !self.showingImageViewOne ? 1 : 0
				self.bgImageViewTwo.alpha = self.showingImageViewOne ? 1 : 0
			}
			self.focusedView.alpha = !self.showingImageViewOne ? 1 : 0
			self.focusedViewTwo.alpha = self.showingImageViewOne ? 1 : 0
		}, completion: { finished in
			self.finishAnimations()
		})
	}
	
	func finishAnimations() {
		if self.showingImageViewOne {
			if self.backgroundImage == nil {
				self.bgImageViewTwo.image = nil
			}
			self.focusedViewTwo.configureForCard(nil)
		}
		else {
			if self.backgroundImage == nil {
				self.bgImageView.image = nil
			}
			self.focusedView.configureForCard(nil)
		}
	}
	
	func shake() {
		var startX: CGFloat = self.showingImageViewOne ? self.focusedView.center.x : self.focusedViewTwo.center.x
		
		UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: { () -> Void in
			UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.125) {
				if self.showingImageViewOne {
					self.focusedView.center.x += 10
				}
				else {
					self.focusedViewTwo.center.x += 10
				}
			}
			
			UIView.addKeyframe(withRelativeStartTime: 0.125, relativeDuration: 0.125) {
				if self.showingImageViewOne {
					self.focusedView.center.x -= 10
				}
				else {
					self.focusedViewTwo.center.x -= 10
				}
			}
			
			UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.125) {
				if self.showingImageViewOne {
					self.focusedView.center.x -= 10
				}
				else {
					self.focusedViewTwo.center.x -= 10
				}
			}
			
			UIView.addKeyframe(withRelativeStartTime: 0.375, relativeDuration: 0.125) {
				if self.showingImageViewOne {
					self.focusedView.center.x = startX
				}
				else {
					self.focusedViewTwo.center.x = startX
				}
			}
			
		}) { (finished) -> Void in
			
		}
	}
	
	func slideToIndexPath(_ indexPath: IndexPath) {
		var scrollLeft = true
		if let _previousIndexPath = previouslySelectedIndexPath {
			scrollLeft = indexPath.row > _previousIndexPath.row
		}
		
		// Moves views into starting position
		if showingImageViewOne {
			focusedViewTwo.isHidden = true
			view.removeConstraints(focusedViewTwoHConstraints)
			if scrollLeft {
				focusedViewTwoHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(maxX)-[focusedViewTwo(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			} else {
				focusedViewTwoHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(minX)-[focusedViewTwo(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			}
			view.addConstraints(focusedViewTwoHConstraints)
			view.layoutIfNeeded()
			focusedViewTwo.isHidden = false
			
			view.removeConstraints(focusedViewHConstraints)
			view.removeConstraints(focusedViewTwoHConstraints)
			focusedViewTwoHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(horizontalSpace)-[focusedViewTwo]-(horizontalSpace)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			if scrollLeft {
				focusedViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(minX)-[focusedView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			} else {
				focusedViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(maxX)-[focusedView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			}
			view.addConstraints(focusedViewHConstraints)
			view.addConstraints(focusedViewTwoHConstraints)
		} else {
			focusedView.isHidden = true
			view.removeConstraints(focusedViewHConstraints)
			if scrollLeft {
				focusedViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(maxX)-[focusedView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			} else {
				focusedViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(minX)-[focusedView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			}
			view.addConstraints(focusedViewHConstraints)
			view.layoutIfNeeded()
			focusedView.isHidden = false
			
			view.removeConstraints(focusedViewHConstraints)
			view.removeConstraints(focusedViewTwoHConstraints)
			focusedViewHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(horizontalSpace)-[focusedView]-(horizontalSpace)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			if scrollLeft {
				focusedViewTwoHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(minX)-[focusedViewTwo(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			} else {
				focusedViewTwoHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(maxX)-[focusedViewTwo(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
			}
			view.addConstraints(focusedViewHConstraints)
			view.addConstraints(focusedViewTwoHConstraints)
		}
		
		// Animates views into final position
		UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: UIViewAnimationOptions(), animations: { () -> Void in
			self.view.layoutIfNeeded()
			if self.backgroundImage == nil {
				self.bgImageView.alpha = !self.showingImageViewOne ? 1 : 0
				self.bgImageViewTwo.alpha = self.showingImageViewOne ? 1 : 0
			}
		}) { finished in
			self.finishAnimations()
		}
	}
	
	var rotation: CGFloat = 0
	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		
		guard let offset = (change?[NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue else { return }
		guard let flowLayout = collectionView.collectionViewLayout as? JFCardSelectionViewFlowLayout else { return }
		let w = ((collectionView.contentSize.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right))) / CGFloat(Double.pi / 2)
		rotation = (offset.x / w)
		bottomCircleOutlineView.transform = CGAffineTransform(rotationAngle: rotation)
	}
}
