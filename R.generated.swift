//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 colors.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 0 files.
  struct file {
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 6 images.
  struct image {
    /// Image `city`.
    static let city = Rswift.ImageResource(bundle: R.hostingBundle, name: "city")
    /// Image `international`.
    static let international = Rswift.ImageResource(bundle: R.hostingBundle, name: "international")
    /// Image `interregionalBusiness`.
    static let interregionalBusiness = Rswift.ImageResource(bundle: R.hostingBundle, name: "interregionalBusiness")
    /// Image `interregionalEconomy`.
    static let interregionalEconomy = Rswift.ImageResource(bundle: R.hostingBundle, name: "interregionalEconomy")
    /// Image `regionBusiness`.
    static let regionBusiness = Rswift.ImageResource(bundle: R.hostingBundle, name: "regionBusiness")
    /// Image `region`.
    static let region = Rswift.ImageResource(bundle: R.hostingBundle, name: "region")
    
    /// `UIImage(named: "city", bundle: ..., traitCollection: ...)`
    static func city(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.city, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "international", bundle: ..., traitCollection: ...)`
    static func international(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.international, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "interregionalBusiness", bundle: ..., traitCollection: ...)`
    static func interregionalBusiness(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.interregionalBusiness, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "interregionalEconomy", bundle: ..., traitCollection: ...)`
    static func interregionalEconomy(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.interregionalEconomy, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "region", bundle: ..., traitCollection: ...)`
    static func region(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.region, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "regionBusiness", bundle: ..., traitCollection: ...)`
    static func regionBusiness(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.regionBusiness, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 0 nibs.
  struct nib {
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 3 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `autocompleteCell`.
    static let autocompleteCell: Rswift.ReuseIdentifier<AutocompleteCell> = Rswift.ReuseIdentifier(identifier: "autocompleteCell")
    /// Reuse identifier `searchResultCell`.
    static let searchResultCell: Rswift.ReuseIdentifier<SearchResultCell> = Rswift.ReuseIdentifier(identifier: "searchResultCell")
    /// Reuse identifier `ticketInfoCell`.
    static let ticketInfoCell: Rswift.ReuseIdentifier<TicketInfoCell> = Rswift.ReuseIdentifier(identifier: "ticketInfoCell")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 4 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `RouteResult`.
    static let routeResult = _R.storyboard.routeResult()
    /// Storyboard `Search`.
    static let search = _R.storyboard.search()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    /// `UIStoryboard(name: "RouteResult", bundle: ...)`
    static func routeResult(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.routeResult)
    }
    
    /// `UIStoryboard(name: "Search", bundle: ...)`
    static func search(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.search)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 2 localization tables.
  struct string {
    /// This `R.string.launchScreen` struct is generated, and contains static references to 0 localization keys.
    struct launchScreen {
      fileprivate init() {}
    }
    
    /// This `R.string.main` struct is generated, and contains static references to 0 localization keys.
    struct main {
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try routeResult.validate()
      try main.validate()
      try search.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = TabsViewController
      
      let bundle = R.hostingBundle
      let name = "Main"
      let tabsViewController = StoryboardViewControllerResource<TabsViewController>(identifier: "TabsViewController")
      
      func tabsViewController(_: Void = ()) -> TabsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: tabsViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.main().tabsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'tabsViewController' could not be loaded from storyboard 'Main' as 'TabsViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct routeResult: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let name = "RouteResult"
      let routeResultNavigationController = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "RouteResultNavigationController")
      let routeResultViewController = StoryboardViewControllerResource<RouteResultViewController>(identifier: "RouteResultViewController")
      
      func routeResultNavigationController(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: routeResultNavigationController)
      }
      
      func routeResultViewController(_: Void = ()) -> RouteResultViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: routeResultViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.routeResult().routeResultViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'routeResultViewController' could not be loaded from storyboard 'RouteResult' as 'RouteResultViewController'.") }
        if _R.storyboard.routeResult().routeResultNavigationController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'routeResultNavigationController' could not be loaded from storyboard 'RouteResult' as 'UIKit.UINavigationController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct search: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController
      
      let bundle = R.hostingBundle
      let name = "Search"
      let searchNavigationController = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "SearchNavigationController")
      let searchViewController = StoryboardViewControllerResource<SearchViewController>(identifier: "SearchViewController")
      
      func searchNavigationController(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: searchNavigationController)
      }
      
      func searchViewController(_: Void = ()) -> SearchViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: searchViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.search().searchViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'searchViewController' could not be loaded from storyboard 'Search' as 'SearchViewController'.") }
        if _R.storyboard.search().searchNavigationController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'searchNavigationController' could not be loaded from storyboard 'Search' as 'UIKit.UINavigationController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
