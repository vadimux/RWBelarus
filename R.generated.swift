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
  
  /// This `R.image` struct is generated, and contains static references to 17 images.
  struct image {
    /// Image `basicCalendar`.
    static let basicCalendar = Rswift.ImageResource(bundle: R.hostingBundle, name: "basicCalendar")
    /// Image `bzhd_0`.
    static let bzhd_0 = Rswift.ImageResource(bundle: R.hostingBundle, name: "bzhd_0")
    /// Image `city`.
    static let city = Rswift.ImageResource(bundle: R.hostingBundle, name: "city")
    /// Image `crossIcon`.
    static let crossIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "crossIcon")
    /// Image `international`.
    static let international = Rswift.ImageResource(bundle: R.hostingBundle, name: "international")
    /// Image `interregionalBusiness`.
    static let interregionalBusiness = Rswift.ImageResource(bundle: R.hostingBundle, name: "interregionalBusiness")
    /// Image `interregionalEconomy`.
    static let interregionalEconomy = Rswift.ImageResource(bundle: R.hostingBundle, name: "interregionalEconomy")
    /// Image `leftArrow`.
    static let leftArrow = Rswift.ImageResource(bundle: R.hostingBundle, name: "leftArrow")
    /// Image `logo`.
    static let logo = Rswift.ImageResource(bundle: R.hostingBundle, name: "logo")
    /// Image `rails`.
    static let rails = Rswift.ImageResource(bundle: R.hostingBundle, name: "rails")
    /// Image `regionBusiness`.
    static let regionBusiness = Rswift.ImageResource(bundle: R.hostingBundle, name: "regionBusiness")
    /// Image `region`.
    static let region = Rswift.ImageResource(bundle: R.hostingBundle, name: "region")
    /// Image `rightArrow`.
    static let rightArrow = Rswift.ImageResource(bundle: R.hostingBundle, name: "rightArrow")
    /// Image `setting`.
    static let setting = Rswift.ImageResource(bundle: R.hostingBundle, name: "setting")
    /// Image `station`.
    static let station = Rswift.ImageResource(bundle: R.hostingBundle, name: "station")
    /// Image `train`.
    static let train = Rswift.ImageResource(bundle: R.hostingBundle, name: "train")
    /// Image `upDownArrow`.
    static let upDownArrow = Rswift.ImageResource(bundle: R.hostingBundle, name: "upDownArrow")
    
    /// `UIImage(named: "basicCalendar", bundle: ..., traitCollection: ...)`
    static func basicCalendar(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.basicCalendar, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "bzhd_0", bundle: ..., traitCollection: ...)`
    static func bzhd_0(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.bzhd_0, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "city", bundle: ..., traitCollection: ...)`
    static func city(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.city, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "crossIcon", bundle: ..., traitCollection: ...)`
    static func crossIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.crossIcon, compatibleWith: traitCollection)
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
    
    /// `UIImage(named: "leftArrow", bundle: ..., traitCollection: ...)`
    static func leftArrow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.leftArrow, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "logo", bundle: ..., traitCollection: ...)`
    static func logo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.logo, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "rails", bundle: ..., traitCollection: ...)`
    static func rails(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.rails, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "region", bundle: ..., traitCollection: ...)`
    static func region(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.region, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "regionBusiness", bundle: ..., traitCollection: ...)`
    static func regionBusiness(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.regionBusiness, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "rightArrow", bundle: ..., traitCollection: ...)`
    static func rightArrow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.rightArrow, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "setting", bundle: ..., traitCollection: ...)`
    static func setting(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.setting, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "station", bundle: ..., traitCollection: ...)`
    static func station(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.station, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "train", bundle: ..., traitCollection: ...)`
    static func train(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.train, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "upDownArrow", bundle: ..., traitCollection: ...)`
    static func upDownArrow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.upDownArrow, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 1 nibs.
  struct nib {
    /// Nib `CarriageHeader`.
    static let carriageHeader = _R.nib._CarriageHeader()
    
    /// `UINib(name: "CarriageHeader", in: bundle)`
    static func carriageHeader(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.carriageHeader)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 8 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `CalendarCell`.
    static let calendarCell: Rswift.ReuseIdentifier<CalendarCell> = Rswift.ReuseIdentifier(identifier: "CalendarCell")
    /// Reuse identifier `autocompleteCell`.
    static let autocompleteCell: Rswift.ReuseIdentifier<AutocompleteCell> = Rswift.ReuseIdentifier(identifier: "autocompleteCell")
    /// Reuse identifier `carriageSchemeCell`.
    static let carriageSchemeCell: Rswift.ReuseIdentifier<CarriageSchemeCell> = Rswift.ReuseIdentifier(identifier: "carriageSchemeCell")
    /// Reuse identifier `fullRouteCell`.
    static let fullRouteCell: Rswift.ReuseIdentifier<FullRouteCell> = Rswift.ReuseIdentifier(identifier: "fullRouteCell")
    /// Reuse identifier `headerResultCell`.
    static let headerResultCell: Rswift.ReuseIdentifier<HeaderResultCell> = Rswift.ReuseIdentifier(identifier: "headerResultCell")
    /// Reuse identifier `searchResultCell`.
    static let searchResultCell: Rswift.ReuseIdentifier<SearchResultCell> = Rswift.ReuseIdentifier(identifier: "searchResultCell")
    /// Reuse identifier `stationScheduleCell`.
    static let stationScheduleCell: Rswift.ReuseIdentifier<StationScheduleCell> = Rswift.ReuseIdentifier(identifier: "stationScheduleCell")
    /// Reuse identifier `ticketInfoCell`.
    static let ticketInfoCell: Rswift.ReuseIdentifier<TicketInfoCell> = Rswift.ReuseIdentifier(identifier: "ticketInfoCell")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 7 storyboards.
  struct storyboard {
    /// Storyboard `Favorite`.
    static let favorite = _R.storyboard.favorite()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `RouteResult`.
    static let routeResult = _R.storyboard.routeResult()
    /// Storyboard `Search`.
    static let search = _R.storyboard.search()
    /// Storyboard `Setting`.
    static let setting = _R.storyboard.setting()
    /// Storyboard `Station`.
    static let station = _R.storyboard.station()
    
    /// `UIStoryboard(name: "Favorite", bundle: ...)`
    static func favorite(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.favorite)
    }
    
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
    
    /// `UIStoryboard(name: "Setting", bundle: ...)`
    static func setting(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.setting)
    }
    
    /// `UIStoryboard(name: "Station", bundle: ...)`
    static func station(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.station)
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
    struct _CarriageHeader: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "CarriageHeader"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> CarriageHeader? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? CarriageHeader
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try routeResult.validate()
      try main.validate()
      try search.validate()
      try station.validate()
      try launchScreen.validate()
    }
    
    struct favorite: Rswift.StoryboardResourceType {
      let bundle = R.hostingBundle
      let name = "Favorite"
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if UIKit.UIImage(named: "logo") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'logo' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
      }
      
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
      let carriageSchemeViewController = StoryboardViewControllerResource<CarriageSchemeViewController>(identifier: "CarriageSchemeViewController")
      let fullRouteViewController = StoryboardViewControllerResource<FullRouteViewController>(identifier: "FullRouteViewController")
      let name = "RouteResult"
      let routeResultNavigationController = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "RouteResultNavigationController")
      let routeResultViewController = StoryboardViewControllerResource<RouteResultViewController>(identifier: "RouteResultViewController")
      
      func carriageSchemeViewController(_: Void = ()) -> CarriageSchemeViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: carriageSchemeViewController)
      }
      
      func fullRouteViewController(_: Void = ()) -> FullRouteViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: fullRouteViewController)
      }
      
      func routeResultNavigationController(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: routeResultNavigationController)
      }
      
      func routeResultViewController(_: Void = ()) -> RouteResultViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: routeResultViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "rails") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'rails' is used in storyboard 'RouteResult', but couldn't be loaded.") }
        if UIKit.UIImage(named: "bzhd_0") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'bzhd_0' is used in storyboard 'RouteResult', but couldn't be loaded.") }
        if _R.storyboard.routeResult().routeResultViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'routeResultViewController' could not be loaded from storyboard 'RouteResult' as 'RouteResultViewController'.") }
        if _R.storyboard.routeResult().routeResultNavigationController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'routeResultNavigationController' could not be loaded from storyboard 'RouteResult' as 'UIKit.UINavigationController'.") }
        if _R.storyboard.routeResult().fullRouteViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'fullRouteViewController' could not be loaded from storyboard 'RouteResult' as 'FullRouteViewController'.") }
        if _R.storyboard.routeResult().carriageSchemeViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'carriageSchemeViewController' could not be loaded from storyboard 'RouteResult' as 'CarriageSchemeViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct search: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController
      
      let bundle = R.hostingBundle
      let calendarViewController = StoryboardViewControllerResource<CalendarViewController>(identifier: "CalendarViewController")
      let name = "Search"
      let searchAutocompleteViewController = StoryboardViewControllerResource<SearchAutocompleteViewController>(identifier: "SearchAutocompleteViewController")
      let searchNavigationController = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "SearchNavigationController")
      let searchViewController = StoryboardViewControllerResource<SearchViewController>(identifier: "SearchViewController")
      
      func calendarViewController(_: Void = ()) -> CalendarViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: calendarViewController)
      }
      
      func searchAutocompleteViewController(_: Void = ()) -> SearchAutocompleteViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: searchAutocompleteViewController)
      }
      
      func searchNavigationController(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: searchNavigationController)
      }
      
      func searchViewController(_: Void = ()) -> SearchViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: searchViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "rightArrow") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'rightArrow' is used in storyboard 'Search', but couldn't be loaded.") }
        if UIKit.UIImage(named: "train") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'train' is used in storyboard 'Search', but couldn't be loaded.") }
        if UIKit.UIImage(named: "upDownArrow") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'upDownArrow' is used in storyboard 'Search', but couldn't be loaded.") }
        if UIKit.UIImage(named: "basicCalendar") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'basicCalendar' is used in storyboard 'Search', but couldn't be loaded.") }
        if UIKit.UIImage(named: "rails") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'rails' is used in storyboard 'Search', but couldn't be loaded.") }
        if UIKit.UIImage(named: "leftArrow") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'leftArrow' is used in storyboard 'Search', but couldn't be loaded.") }
        if _R.storyboard.search().searchAutocompleteViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'searchAutocompleteViewController' could not be loaded from storyboard 'Search' as 'SearchAutocompleteViewController'.") }
        if _R.storyboard.search().searchViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'searchViewController' could not be loaded from storyboard 'Search' as 'SearchViewController'.") }
        if _R.storyboard.search().calendarViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'calendarViewController' could not be loaded from storyboard 'Search' as 'CalendarViewController'.") }
        if _R.storyboard.search().searchNavigationController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'searchNavigationController' could not be loaded from storyboard 'Search' as 'UIKit.UINavigationController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct setting: Rswift.StoryboardResourceType {
      let bundle = R.hostingBundle
      let name = "Setting"
      
      fileprivate init() {}
    }
    
    struct station: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController
      
      let bundle = R.hostingBundle
      let name = "Station"
      let scheduleStationNavigationController = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "ScheduleStationNavigationController")
      let scheduleStationViewController = StoryboardViewControllerResource<ScheduleStationViewController>(identifier: "ScheduleStationViewController")
      
      func scheduleStationNavigationController(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: scheduleStationNavigationController)
      }
      
      func scheduleStationViewController(_: Void = ()) -> ScheduleStationViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: scheduleStationViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "station") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'station' is used in storyboard 'Station', but couldn't be loaded.") }
        if _R.storyboard.station().scheduleStationNavigationController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'scheduleStationNavigationController' could not be loaded from storyboard 'Station' as 'UIKit.UINavigationController'.") }
        if _R.storyboard.station().scheduleStationViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'scheduleStationViewController' could not be loaded from storyboard 'Station' as 'ScheduleStationViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
