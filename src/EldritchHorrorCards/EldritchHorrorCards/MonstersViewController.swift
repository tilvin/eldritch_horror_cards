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
    if let action = card.actionOne, action.title == cardAction.title {
      print("----------- \nCard action fired! \nAction Title: \(cardAction.title) \nIndex Path: \(indexPath)")
    }
    if let action = card.actionTwo, action.title == cardAction.title {
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
    return [
      Monster(name: "Fog monster", photoIndex: "1", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: "Mountains of Madness", photoIndex: "2", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: faker.lorem.word().capitalized, photoIndex: "3", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: "Creepy monster", photoIndex: "4", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: "Cthulhu", photoIndex: "5", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: "Fang of Nuzlang", photoIndex: "6", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: "Brain Cylinder Mee-Go", photoIndex: "7", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: "Cosmic offspring", photoIndex: "8", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: "The Old People", photoIndex: "9", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: "Anteater", photoIndex: "10", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: faker.lorem.word().capitalized, photoIndex: "11", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: faker.lorem.word().capitalized, photoIndex: "12", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: faker.lorem.word().capitalized, photoIndex: "13", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: faker.lorem.word().capitalized, photoIndex: "14", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: faker.lorem.word().capitalized, photoIndex: "15", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: "Shub-niggurath", photoIndex: "16", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6))),
      Monster(name: "Flying polyp", photoIndex: "17", detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)))
    ]
  }
}

//----------------

struct Monster {
  var name: String
  var photoIndex: String
  var detail: String
}

extension Monster: CardPresentable {
  
  var image: UIImage? {
    return UIImage(named: self.photoIndex)
  }
  
  
  var imageURLString: String {
    return ""
  }
  
  var placeholderImage: UIImage? {
    return UIImage(named: "default")
  }
  
  var titleText: String {
    return name
  }
  
  var dialLabel: String {
    guard let lastString = titleText.components(separatedBy: " ").last else { return "" }
    return String(lastString[lastString.startIndex])
  }
  
  var detailTextLineOne: String {
    return "address"
  }
  
  var detailTextLineTwo: String {
    return "detail info..."
  }
  
  var actionOne: CardAction? {
    return CardAction(title: "Call")
  }
  
  var actionTwo: CardAction? {
    return CardAction(title: "Email")
  }
  
}

