//
//  SearchViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/15/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import UIKit
import Toast_Swift
import Hero
import FeedKit
import WebKit

enum RouteDate: String, CaseIterable {
    typealias BaseType = String
    case today, tomorrow, everyday
    
    func value() -> String {
        switch self {
        case .today:
            return "сегодня".localized
        case .tomorrow:
            return "завтра".localized
        case .everyday:
            return "на все дни".localized
        }
    }
}

enum DirectionViewType {
    case toView
    case fromView
}

protocol SearchViewControllerInteractor: class {
    var fromData: AutocompleteAPIElement? { get set }
    var toData: AutocompleteAPIElement? { get set }
    var newsItems: [RSSFeedItem]? { get }
    func configureSearchButtonState(with elements: [AutocompleteAPIElement?]) -> Bool
}

protocol SearchViewControllerCoordinator: class {
    func showResult(vc: UIViewController, from: AutocompleteAPIElement, to: AutocompleteAPIElement, date: String)
    func showStationsList(vc: UIViewController, for typeView: DirectionViewType?)
    func showCalendar(currentDate: Date, completion: @escaping (_ selectedDate: Date) -> Void)
}

class SearchViewController: UIViewController, WKUIDelegate {
    
    var interactor: SearchViewControllerInteractor!
    var coordinator: SearchViewControllerCoordinator?
    
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsPageControl: UIPageControl!
    @IBOutlet weak var newsView: UIView!
    private var webView: WKWebView!
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var additionalFromLabel: UILabel! {
        didSet {
            additionalFromLabel.isHidden = true
        }
    }
    @IBOutlet weak var additionalToLabel: UILabel! {
        didSet {
            additionalToLabel.isHidden = true
        }
    }
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.isEnabled = false
        }
    }
    
    var directionView: DirectionViewType?

    private let heroTransition = HeroTransition()
    private var isChangeDirectionTapped = false
    private var routeElements = [AutocompleteAPIElement?](repeating: nil, count: 2) //[from, to]
    private var date: String = "everyday"
    private var newsRSS = [RSSFeedItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.delegate = self
        self.navigationController?.hero.navigationAnimationType = .fade
        
        if #available(iOS 10.3, *) {
            RateManager.showRatesController()
        }

        guard let newsItems = interactor.newsItems else {
            newsPageControl.isHidden = true
            return
        }
        addWebView()
        newsRSS = newsItems
        newsPageControl.numberOfPages = newsItems.count
        configureNewsGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let fromData = interactor.fromData {
            additionalFromLabel.isHidden = false
            fromLabel.text = fromData.value?.uppercased()
            routeElements[0] = fromData
        }
        if let toData = interactor.toData {
            additionalToLabel.isHidden = false
            toLabel.text = toData.value?.uppercased()
            routeElements[1] = toData
        }
        
        self.searchButton.isEnabled = self.interactor.configureSearchButtonState(with: self.routeElements)
    }
    
    private func addWebView() {
        createWebView()
        configureWebView()
        newsView.addSubview(webView)
        webView.topAnchor.constraint(equalTo: newsView.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: newsView.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: newsView.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: newsView.bottomAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: newsView.heightAnchor).isActive = true
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let firstElement = routeElements.first, let fromAddress = firstElement,
            let lastElement = routeElements.last, let toAddress = lastElement else { return }
        CoreDataManager.shared().saveRouteWith(from: fromAddress, to: toAddress)
        coordinator?.showResult(vc: self, from: fromAddress, to: toAddress, date: self.date)
    }
    
    @IBAction func tapOnView(_ sender: Any) {
        if let info = sender as? UITapGestureRecognizer {
            directionView = info.view == fromView ? .fromView : .toView
            coordinator?.showStationsList(vc: self, for: directionView)
        }
    }

    @IBAction func changeDirectionTapped(_ sender: Any) {
        
        isChangeDirectionTapped = !isChangeDirectionTapped
        let countEmpty = routeElements.reduce(0) { $1 == nil ? $0 + 1 : $0 }

        switch countEmpty {
        case 0:
            fromLabel.text = routeElements[1]?.value?.uppercased()
            toLabel.text = routeElements[0]?.value?.uppercased()
            routeElements.swapAt(1, 0)
        case 1:
            if routeElements[0]?.value != nil {
                additionalFromLabel.isHidden = true
                fromLabel.text = "Откуда".localized.uppercased()
                additionalToLabel.isHidden = false
                toLabel.isHidden = false
                toLabel.text = routeElements[0]?.value?.uppercased()
            } else {
                additionalFromLabel.isHidden = false
                fromLabel.isHidden = false
                additionalToLabel.isHidden = true
                toLabel.text = "Куда".localized.uppercased()
                fromLabel.text = routeElements[1]?.value?.uppercased()
            }
            routeElements.swapAt(0, 1)
        default:
            return
        }
    }
    
    @IBAction func calendarTapped(_ sender: Any) {
        coordinator?.showCalendar(currentDate: Date()) { [weak self] date in
            guard let `self` = self else { return }
            let newDate = Date.format(date: date, dateFormat: Date.LABEL_DATE_FORMAT)
            let searchDate = Date.format(date: date, dateFormat: Date.COMMON_DATE_FORMAT)
            self.dateButton.setTitle(newDate, for: .normal)
            self.date = searchDate
        }
    }
    
    @IBAction func dayTapped(_ sender: Any) {
        guard let element = (sender as? UIButton)?.currentTitle, let selectedDayType = RouteDate.find(element) else { return }
        self.dateButton.setTitle(selectedDayType.value(), for: .normal)
        date = selectedDayType.rawValue
    }
    
    private func configureNewsGestureRecognizer() {
        
        let swipeGestureLeft = UISwipeGestureRecognizer()
        let swipeGestureRight = UISwipeGestureRecognizer()
        
        // set gesture direction
        swipeGestureLeft.direction = UISwipeGestureRecognizer.Direction.left
        swipeGestureRight.direction = UISwipeGestureRecognizer.Direction.right
        
        // add gesture target
        swipeGestureLeft.addTarget(self, action: #selector(handleSwipeLeft(_:)))
        swipeGestureRight.addTarget(self, action: #selector(handleSwipeRight(_:)))
        
        // add gesture in to view
        self.view.addGestureRecognizer(swipeGestureLeft)
        self.view.addGestureRecognizer(swipeGestureRight)
        
        // set current page number label.
        self.setCurrentPageLabel()
    }
    
    private func createWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let customFrame = CGRect.init(origin: .zero, size: CGSize.init(width: 0.0, height: newsView.frame.size.height))
        webView = WKWebView(frame: customFrame, configuration: webConfiguration)
    }
    
    private func configureWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
    }
    
    // increase page number on swift left
    @objc func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        if self.newsPageControl.currentPage < newsRSS.count {
            self.newsPageControl.currentPage += 1
            self.setCurrentPageLabel()
        }
    }
    
    // reduce page number on swift right
    @objc func handleSwipeRight(_ gesture: UISwipeGestureRecognizer) {
        if self.newsPageControl.currentPage != 0 {
            self.newsPageControl.currentPage -= 1
            self.setCurrentPageLabel()
        }
    }
    
    private func setCurrentPageLabel() {
        self.newsTitleLabel.text = newsRSS[newsPageControl.currentPage].title
        if let newsText = newsRSS[newsPageControl.currentPage].description {
            self.webView.isHidden = false
            self.webView.loadHTMLString(newsText, baseURL: nil)
        } else {
            self.webView.isHidden = true
            self.newsTitleLabel.text = newsRSS[newsPageControl.currentPage].title
        }
        
    }
    
}

extension SearchViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return heroTransition.navigationController(navigationController, interactionControllerFor: animationController)
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return heroTransition.navigationController(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
    }
}
