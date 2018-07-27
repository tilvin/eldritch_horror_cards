import UIKit
import SnapKit

class MonstersViewController: JFCardSelectionViewController {
    
    private var monsterProvider = DI.providers.resolve(MonsterDataProviderProtocol.self)!
    private var monsters: [Monster] = []
	
	private lazy var menuButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "menu_button")!, for: .normal)
		button.addTarget(self, action: #selector(MonstersViewController.menuButtonAction), for: .touchUpInside)
		return button
	}()
	
	private lazy var menuContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	
	
	var menuContainerView: UIView { return self.menuContainer }
	var menuAction: CommandWith<Command>!
	
	
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        selectionAnimationStyle = .slide
        super.viewDidLoad()
		self.navigationController?.isNavigationBarHidden = true
		addSubViews()
		makeConstraints()
		
        setupMenu()
        navigationController?.setNavigationBarHidden(true, animated: false)
        monsterProvider.load()  { (success) in
            if success {
                Log.writeLog(logLevel: .debug, message: "Monster is load!")
            }
            else {
                Log.writeLog(logLevel: .error, message: "Something gone wrong!")
            }
        }
        
        monsters = monsterProvider.monsters
        reloadData()
		view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusbar(with: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1))
    }
	
	
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
        if let userDetailVC = segue.destination as? MonsterDetailViewController {
            guard let indexPath = sender as? IndexPath else { return }
            userDetailVC.monster = monsters[indexPath.row]
        }
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
			make.top.equalToSuperview().inset(30)
			make.width.height.equalTo(70)
		}
	}
	
	@objc func menuButtonAction(_ sender: UIButton) {
		print("menu execute!")
		let reloadCmd = Command {  (_) in
			Log.writeLog(logLevel: .info, message: "reload view!")
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
        let card = monsters[indexPath.row]
        if let action = card.action, action.title == cardAction.title {
            print("----------- \nCard action fired! \nAction Title: \(cardAction.title) \nIndex Path: \(indexPath)")
        }
    }
    
    func cardSelectionViewController(_ cardSelectionViewController: JFCardSelectionViewController, didSelectDetailActionForCardAtIndexPath indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowUserDetailVC", sender: indexPath)
    }
}

extension MonstersViewController: MenuEmbedProtocol { }
