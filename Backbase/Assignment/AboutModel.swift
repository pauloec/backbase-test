import Foundation

// MARK: - AboutModel protocol

public protocol AboutModel {
    func loadAboutInfo(with presenter: AboutPresenter)
}

// MARK: - Model class implementation

public class Model: NSObject, AboutModel {
    public override init() {
        super.init()
    }
    
    public func loadAboutInfo(with presenter: AboutPresenter) {
        guard
            let path = Bundle.main.path(forResource: "aboutInfo", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let decoded = try? JSONDecoder().decode(AboutInfo.self, from: data)
            else {
                presenter.aboutInfoDidFailLoading(error: ModelError.failedLoading)
                return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            presenter.aboutInfoDidLoad(aboutInfo: decoded)
        }
    }
}

// MARK: - Custom ModelError object

public enum ModelError: Error {
    case failedLoading
}

extension ModelError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedLoading: return "Failed to load About information."
        }
    }
}
