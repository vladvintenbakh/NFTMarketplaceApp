// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum SGen {
  /// About author
  internal static let aboutAuthor = SGen.tr("Localizable", "aboutAuthor", fallback: "About author")
  /// Name
  internal static let byName = SGen.tr("Localizable", "byName", fallback: "Name")
  /// Localizable.strings
  ///   FakeNFT
  /// 
  ///   Created by Kirill Sklyarov on 07.06.2024.
  internal static let catalog = SGen.tr("Localizable", "catalog", fallback: "Catalog")
  /// Change photo
  internal static let changePhoto = SGen.tr("Localizable", "changePhoto", fallback: "Change photo")
  /// Cancel
  internal static let close = SGen.tr("Localizable", "close", fallback: "Cancel")
  /// Description
  internal static let description = SGen.tr("Localizable", "description", fallback: "Description")
  /// Favorites NFT
  internal static let favoritesNFT = SGen.tr("Localizable", "favoritesNFT", fallback: "Favorites NFT")
  /// My NFT
  internal static let myNFT = SGen.tr("Localizable", "myNFT", fallback: "My NFT")
  /// Name
  internal static let name = SGen.tr("Localizable", "name", fallback: "Name")
  /// Price
  internal static let price = SGen.tr("Localizable", "price", fallback: "Price")
  /// Profile
  internal static let profile = SGen.tr("Localizable", "profile", fallback: "Profile")
  /// Rating
  internal static let rating = SGen.tr("Localizable", "rating", fallback: "Rating")
  /// Sorting by
  internal static let sorting = SGen.tr("Localizable", "sorting", fallback: "Sorting by")
  /// Website
  internal static let website = SGen.tr("Localizable", "website", fallback: "Website")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension SGen {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
