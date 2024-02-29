// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal enum Buttons {
      internal static let iconsBurger = ImageAsset(name: "Icons_burger")
      internal static let iconsProfile = ImageAsset(name: "Icons_profile")
    }
    internal enum Cities {
      internal enum Large {
        internal static let chelyabinsk = ImageAsset(name: "chelyabinsk")
        internal static let ekaterinburg = ImageAsset(name: "ekaterinburg")
        internal static let kazan = ImageAsset(name: "kazan")
        internal static let moscow = ImageAsset(name: "moscow")
        internal static let murmansk = ImageAsset(name: "murmansk")
        internal static let nizhniyNovgorod = ImageAsset(name: "nizhniyNovgorod")
        internal static let novosibirsk = ImageAsset(name: "novosibirsk")
        internal static let omsk = ImageAsset(name: "omsk")
        internal static let rostovOnDon = ImageAsset(name: "rostov-on-don")
        internal static let saintPetersburg = ImageAsset(name: "saintPetersburg")
        internal static let samara = ImageAsset(name: "samara")
      }
      internal enum Small {
        internal static let chelyabinskSmall = ImageAsset(name: "chelyabinsk_small")
        internal static let ekaterinburgSmall = ImageAsset(name: "ekaterinburg_small")
        internal static let kazanSmall = ImageAsset(name: "kazan_small")
        internal static let moscowSmall = ImageAsset(name: "moscow_small")
        internal static let murmanskSmall = ImageAsset(name: "murmansk_small")
        internal static let nizhniyNovgorodSmall = ImageAsset(name: "nizhniyNovgorod_small")
        internal static let novosibirskSmall = ImageAsset(name: "novosibirsk_small")
        internal static let omskSmall = ImageAsset(name: "omsk_small")
        internal static let rostovOnDon = ImageAsset(name: "rostov-on-don")
        internal static let saintPetersburgSmall = ImageAsset(name: "saintPetersburg_small")
        internal static let samaraSmall = ImageAsset(name: "samara_small")
      }
    }
    internal static let iconsArrowDown = ImageAsset(name: "Icons_arrow_down")
    internal static let iconsArrowRight = ImageAsset(name: "Icons_arrow_right")
    internal enum TabBarItems {
      internal static let iconsMain = ImageAsset(name: "Icons_main")
      internal static let iconsMap = ImageAsset(name: "Icons_map")
      internal static let iconsSearch = ImageAsset(name: "Icons_search")
      internal static let iconsSettings = ImageAsset(name: "Icons_settings")
    }
    internal enum Weather {
      internal enum Icons {
        internal static let iconsClear = ImageAsset(name: "Icons_clear")
        internal static let iconsCloudy = ImageAsset(name: "Icons_cloudy")
        internal static let iconsLittleRainy = ImageAsset(name: "Icons_little_rainy")
        internal static let iconsRainy = ImageAsset(name: "Icons_rainy")
        internal static let iconsSnow = ImageAsset(name: "Icons_snow")
        internal static let iconsSunny = ImageAsset(name: "Icons_sunny")
      }
      internal enum Images {
        internal static let dayRainy = ImageAsset(name: "Day_rainy")
        internal static let eveningClear = ImageAsset(name: "Evening_clear")
        internal static let nightClear = ImageAsset(name: "Night_clear")
        internal static let clear = ImageAsset(name: "clear")
        internal static let cloudy = ImageAsset(name: "cloudy")
        internal static let rain = ImageAsset(name: "rain")
        internal static let snow = ImageAsset(name: "snow")
        internal static let thunder = ImageAsset(name: "thunder")
      }
    }
  }
  internal enum Colors {
    internal static let customLightPurple = ColorAsset(name: "CustomLightPurple")
    internal static let customPurple = ColorAsset(name: "CustomPurple")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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
