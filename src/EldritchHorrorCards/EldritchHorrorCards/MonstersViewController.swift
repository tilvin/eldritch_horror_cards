import Fakery

class MonstersViewController: JFCardSelectionViewController {
    
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        selectionAnimationStyle = .slide
        
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
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

// Mock Data
extension MonstersViewController {
    
    var monsters: [Monster] {
        let faker = Faker()
        let urls = ["https://i.pinimg.com/564x/c0/7e/c0/c07ec05cac80e099374f30c2f646b7be.jpg",
                    "https://i.pinimg.com/564x/ba/57/2a/ba572a66a1e61809e16ca9d1c5eca3d7.jpg",
                    "https://i.pinimg.com/564x/e3/69/35/e36935a809f267e4cdfbfbdca77fed44.jpg",
                    "https://i.pinimg.com/564x/d4/a3/b0/d4a3b0bf8de28c5b9bc46fdda6e5be63.jpg",
                    "https://i.pinimg.com/564x/17/ed/8f/17ed8f43cfc10fb58e421ec58d4d13a4.jpg",
                    "https://i.pinimg.com/564x/4a/75/82/4a75823f9749871596d3dd374305f0a3.jpg",
                    "https://i.pinimg.com/564x/72/6d/66/726d668ef6cef76e5f2e9c33d9e827a7.jpg",
                    "https://i.pinimg.com/564x/c4/83/6b/c4836bbdbee9b54a63385ce4c305dba6.jpg",
                    "https://i.pinimg.com/564x/a3/94/fc/a394fcd0a59ecd0d809a73d7e7691fd3.jpg",
                    "https://i.pinimg.com/564x/a3/94/fc/a394fcd0a59ecd0d809a73d7e7691fd3.jpg",
                    "https://i.pinimg.com/564x/f6/3e/6a/f63e6aab699d121d86c0e0dd8ec4e869.jpg",
                    "https://i.pinimg.com/564x/dc/4e/19/dc4e19cf51c7ea9ebb24a35a39e78446.jpg",
                    "https://i.pinimg.com/564x/e6/10/bc/e610bc6e3fed833744470c5adc36ee91.jpg",
                    "https://i.pinimg.com/564x/2a/84/05/2a8405ac23f1d6136a5b9ad2171b972a.jpg",
                    "https://i.pinimg.com/564x/54/c4/e0/54c4e0e4e535a88ca0f4ed15dc852268.jpg",
                    "https://i.pinimg.com/564x/f6/6b/0d/f66b0d6a47012fdef19084e73e983062.jpg",
                    "https://i.pinimg.com/564x/4e/04/9e/4e049ef5f46ab895fd2002412194af69.jpg",
                    "https://i.pinimg.com/564x/58/0b/d5/580bd5fd213ee93e7a2b84af93efb34f.jpg",
                    "https://i.pinimg.com/564x/d4/d3/3a/d4d33a346d294ec12acec7da856d7781.jpg"]
        return [
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[0],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[1],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[2],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[3],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[4],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[5],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[6],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[7],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[8],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[9],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[10],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[11],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[12],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[13],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[14],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[15],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[16],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[17],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16)),
            Monster(name: faker.lorem.words(amount:2),
                    imageURLString: urls[18],
                    detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                    score: faker.number.randomInt(min: 10, max: 16))
        ]
    }
}

//----------------

struct Monster {
    var name: String
    var imageURLString: String
    var detail: String
    var score: Int
}

extension Monster: CardPresentable {
    
    var placeholderImage: UIImage? {
        return #imageLiteral(resourceName: "placeholder_image")
    }
    
    var nameText: String {
        return name
    }
    
    var dialLabel: String {
        guard let char = nameText.first else { return "A" }
        return String(char).capitalized
    }
    
    var detailText: String {
        return detail
    }
    
    var action: CardAction? {
        return CardAction(title: "call_monster".localized)
    }
}

