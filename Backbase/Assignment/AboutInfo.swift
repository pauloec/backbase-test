import Foundation

// MARK: - AboutInfoData protocol

public protocol AboutInfoData {
    var companyName: String { get }
    var companyAddress: String  { get }
    var postalCode: String { get }
    var city: String { get }
    var details: String { get }
}

// MARK: - AboutInfo object

public struct AboutInfo: Codable, AboutInfoData {
    public let companyName: String
    public let companyAddress: String
    public let postalCode: String
    public let city: String
    public let details: String
}
