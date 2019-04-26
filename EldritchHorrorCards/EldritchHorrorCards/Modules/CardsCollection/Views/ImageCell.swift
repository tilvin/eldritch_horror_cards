
import UIKit

extension ImageCell {
	
	struct Appearance {
		let spacing: CGFloat = 10
	}
}

final class ImageCell: BaseCollectionViewCell {
	var cardType = ""
	
	private let appearance = Appearance()
	
	//MARK: -
	
	private lazy var imageView: UIImageView = {
		let view = UIImageView()
		view.setContentHuggingPriority(.required, for: .horizontal)
		view.setContentCompressionResistancePriority(.required, for: .horizontal)
		view.contentMode = .scaleAspectFill
		return view
	}()
	
	private lazy var typeLabel: UILabel = {
		let view = UILabel(font: .regular18, textColor: UIColor.darkGreenBlue)
		view.setContentHuggingPriority(.defaultLow, for: .horizontal)
		view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
		view.textAlignment = .center
		return view
	}()
	
	private lazy var stackView: UIStackView = {
		let view = UIStackView()
		view.axis = .vertical
		view.alignment = .center
		view.distribution = .fill
		view.spacing = appearance.spacing
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
		self.typeLabel.numberOfLines = 0
	}
	
	//MARK: - Public
	
	public func update(with viewModel: CardCellViewModel) {
		imageView.image = viewModel.image
		typeLabel.text = viewModel.title.localized
		cardType = viewModel.title.uppercased()
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		stackView.addArrangedSubview(typeLabel)
		stackView.addArrangedSubview(imageView)
		addSubview(stackView)
	}
	
	private func makeConstraints() {
		stackView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		typeLabel.snp.makeConstraints { (make) in
			make.width.equalTo(imageView.snp.width)
		}
	}
}
