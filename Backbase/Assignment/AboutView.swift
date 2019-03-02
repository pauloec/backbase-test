import Foundation

// MARK: - AboutView protocol

public protocol AboutView: class {
    func configure(with aboutInfo: AboutInfoData)
    func display(error: ModelError)
    func setActivityIndicator(hidden: Bool)
}
