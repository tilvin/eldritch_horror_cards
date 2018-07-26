import UIKit

class MonstersViewController: JFCardSelectionViewController {
	
	private var monsterProvider = DI.providers.resolve(MonsterDataProviderProtocol.self)!
	private var monsters: [Monster] = []
	
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        selectionAnimationStyle = .slide
		
        super.viewDidLoad()
		
        navigationController?.setNavigationBarHidden(true, animated: false)
		monsterProvider.load()
		monsters = monsterProvider.monsters
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIViewController.setStatusbar(with: #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userDetailVC = segue.destination as? MonsterDetailViewController {
            guard let indexPath = sender as? IndexPath else { return }
            userDetailVC.monster = monsters[indexPath.row]
        }
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
