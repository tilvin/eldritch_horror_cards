import UIKit
import SnapKit

protocol MonstersViewControllerDelegate: class {
	func call(monster: Monster)
	func showDetail(monster: Monster)
}

final class MonstersViewController: JFCardSelectionViewController {
    
    //MARK: - Public variables
    
	public var menuContainerView: UIView { return self.menuContainer }
	public var menuAction: CommandWith<Command>!
	public var monsterDelegate: MonstersViewControllerDelegate?
    public var showMessageHandler: ShowErrorHandler?
    
    //MARK: - Private variables
    
	private var monsterProvider = DI.providers.resolve(MonsterDataProviderProtocol.self)!
	private var monsters: [Monster] = []
    private let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
    
    //MARK: - Private lazy variables
    
	private lazy var menuButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.menuButton, for: .normal)
		button.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
		return button
	}()
	
	private lazy var menuContainer: UIView = {
		return UIView(backgroundColor: .clear)
	}()
	
	override func viewDidLoad() {
		dataSource = self
		delegate = self
		selectionAnimationStyle = .slide
		super.viewDidLoad()
		navigationController?.isNavigationBarHidden = true
		addSubViews()
		makeConstraints()
		setupMenu()
		navigationController?.setNavigationBarHidden(true, animated: false)
        view.showProccessing()
        monsterProvider.load(gameId: gameProvider.game.id) { [weak self] (result) in
            guard let sSelf = self else { return }
			sSelf.view.hideProccessing()
			
			switch result {
			case .success(let monsters):
				sSelf.monsters = monsters
				sSelf.reloadData()
			case .failure(let error):
				sSelf.showMessageHandler?(error.message)
			}
        }
		reloadData()
		view.layoutIfNeeded()
	}
	
	private func addSubViews() {
		view.addSubview(menuButton)
		view.addSubview(menuContainer)
	}
	
	private func makeConstraints() {
		menuContainer.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		menuButton.snp.makeConstraints { (make) in
			make.left.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.width.height.equalTo(DefaultAppearance.menuButtonWidthHeight)
		}
	}
	
	@objc private func menuButtonPressed() {
		let reloadCmd = Command {  (_) in
			print("reload view!")
		}
		menuAction?.perform(with: reloadCmd)
	}
}

extension MonstersViewController: JFCardSelectionViewControllerDataSource {
	
	func numberOfCardsForCardSelectionViewController(_ cardSelectionViewController: JFCardSelectionViewController) -> Int {
		return monsters.count
	}
	
	func cardSelectionViewController(_ cardSelectionViewController: JFCardSelectionViewController, cardForItemAtIndexPath indexPath: IndexPath) -> CardPresentable {
		return monsters[indexPath.row]
	}
}

extension MonstersViewController: JFCardSelectionViewControllerDelegate {
	
	func cardSelectionViewController(_ cardSelectionViewController: JFCardSelectionViewController, didSelectCardAction cardAction: CardAction, forCardAtIndexPath indexPath: IndexPath) {
		let monster = monsters[indexPath.row]
		self.monsterDelegate?.call(monster: monster)
	}
	
	func cardSelectionViewController(_ cardSelectionViewController: JFCardSelectionViewController, didSelectDetailActionForCardAtIndexPath indexPath: IndexPath) {
		let monster = monsters[indexPath.row]
		self.monsterDelegate?.showDetail(monster: monster)
	}
}

extension MonstersViewController: MenuEmbedProtocol { }
