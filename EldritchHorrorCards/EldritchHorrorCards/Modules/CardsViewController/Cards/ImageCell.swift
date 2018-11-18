
import UIKit

final class ImageCell: BaseCollectionViewCell {
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
       let view = UILabel(font: .regular18, textColor: UIColor.darkGreenBlue)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
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
}
