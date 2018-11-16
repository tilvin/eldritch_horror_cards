
import UIKit

final class ImageCell: UICollectionViewCell {
	var cardType = ""
	
    //MARK: -
    
    lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var typeLabel: UILabel = {
       return UILabel(font: .regular18, textColor: UIColor.darkGreenBlue)
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(tapRecognizer)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadowOffset = CGPoint.zero
        self.shadowOpacity = 1
        self.shadowRadius = 4
        self.shadowColor = UIColor.darkGray
    }
    
    //MARK: - Public
    
    public func update(with viewModel: CardCellViewModel) {
        imageView.image = viewModel.image
        typeLabel.text = viewModel.title.localized
        cardType = viewModel.title.uppercased()
    }
    
    //MARK: - Private
    
    private func addSubviews() {
        addSubview(typeLabel)
        addSubview(imageView)
    }
    
    private func makeConstraints() {
        typeLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(typeLabel.snp.bottom)
        }
    }
    
    //MARK: - Handlers
    
	@objc func imageTapped(sender: UIImageView) {
		var provider = DI.providers.resolve(ExpeditionDataProviderProtocol.self)!
		let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
		provider.expeditionType = cardType
		provider.load(gameId: gameProvider.game.id, type: cardType ) {  (success) in
			if success {
				let controller = ExpeditionViewController()
				controller.modalTransitionStyle = .crossDissolve
				DI.providers.resolve(NavigatorProtocol.self)?.go(controller: controller, mode: .push)
			}
			else {
				print("error!")
			}
		}
	}
}
