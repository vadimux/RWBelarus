//
//  CalendarViewController.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/26/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

protocol CalendarViewControllerCoordinator {
    func title() -> String?
    func applyPeriodFromDate( _ beginDate: Date?, endDate: Date?)
}

protocol CalendarViewControllerInteractor: ObservableProtocol {
    
    var minDate: Date { get }
    var maxDate: Date { get }
    
    var beginPeriodDate: Date? { get }
    var endPeriodDate: Date? { get }
    
    func selectDate(_ date: Date)
    func deselectDate(_ date: Date)
    
    func dateSelected(_ date: Date) -> Bool
    
    func shouldSelectDate(_ date: Date) -> Bool
}

protocol ObservableProtocol {
    func subscribe(observer: NSObject)
    func unsubscribe(observer: NSObject)
}

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var day1Label: UILabel!
    @IBOutlet weak var day2Label: UILabel!
    @IBOutlet weak var day3Label: UILabel!
    @IBOutlet weak var day4Label: UILabel!
    @IBOutlet weak var day5Label: UILabel!
    @IBOutlet weak var day6Label: UILabel!
    @IBOutlet weak var day7Label: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var calendarView: JTAppleCalendarView! {
        didSet {
            calendarView.calendarDataSource = self
            calendarView.calendarDelegate = self
        }
    }
    
    var coordinator: CalendarViewControllerCoordinator?
    var interactor: CalendarViewControllerInteractor? {
        willSet {
            interactor?.unsubscribe(observer: self)
        }
        didSet {
            interactor?.subscribe(observer: self)
            update()
        }
    }
    
    private lazy var labelDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.calendar = calendar
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.dateFormat = "MMMM, yyyy"
        return dateFormatter
    }()
    
    private lazy var calendar: Calendar = {
        var _calendar = Calendar.autoupdatingCurrent
        _calendar.locale = Locale.autoupdatingCurrent
        return _calendar
    }()
    
    private let kCornerRadius: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        interactor = nil
        coordinator = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        update()
    }
    
    private func update() {
        if let begin = interactor?.beginPeriodDate, let end = interactor?.endPeriodDate {
            var unselect = [Date]()
            calendarView?.selectedDates.forEach({ (date) in
                if interactor?.dateSelected(date) == false {
                    unselect.append(date)
                }
            })
            
            if unselect.isEmpty == false {
                calendarView?.deselect(dates: unselect)
            }
            
            calendarView?.selectDates(from: begin, to: end, triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
            
            if let beginCellState = calendarView?.cellStatus(for: begin), let _ = calendarView {
                if beginCellState.isSelected == false && calendarView!.selectedDates.count > 1 {
                    calendarView?.selectDates([begin])
                }
            }
            
            if let endCellState = calendarView?.cellStatus(for: end), let _ = calendarView {
                if endCellState.isSelected == false && calendarView!.selectedDates.count > 1 {
                    calendarView?.selectDates([end])
                }
            }
            
            doneButton?.isEnabled = true
            doneButton?.alpha = 1
        } else {
            calendarView?.deselectAllDates()
            doneButton?.isEnabled = false
            doneButton?.alpha = 0.6
        }
    }
    
    private func setupCalendar() {
        
        titleLabel.text = coordinator?.title()
        
        let labels = [day1Label, day2Label, day3Label, day4Label, day5Label, day6Label, day7Label]
        let firstDayIndex = 2
        
        calendarView.visibleDates { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
            for i in 0...6 {
                var labelIndex = visibleDates.monthDates[i].indexPath.row
                if labelIndex > 6 {
                    labelIndex -= 7
                }
                labels[labelIndex]?.textColor = self.calendar.isDateInWeekend(visibleDates.monthDates[i].date) ? UIColor.red : UIColor.black
            }
        }
        
        calendarView.isRangeSelectionUsed = true
        calendarView.allowsMultipleSelection = true
        
        var days = calendar.shortWeekdaySymbols
        let firstDay = days[firstDayIndex - 1]
        while days.first != firstDay {
            days.append(days.removeFirst())
        }
        
        labels.forEach { (label) in
            label?.text = days.removeFirst().localized
        }
        calendarView.scrollToDate(Date())
    }
    
    @IBAction private func prevMonthAction(sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }
    
    @IBAction private func nextMonthAction(sender: UIButton) {
        calendarView.scrollToSegment(.next)
    }
    
    @IBAction private func doneAction(sender: UIButton) {
        coordinator?.applyPeriodFromDate(interactor?.beginPeriodDate, endDate: interactor?.endPeriodDate)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupMonthLabel(date: Date) {
        monthLabel.text = labelDateFormatter.string(from: date)
        updateNavigationButtonsState(currentDate: date)
    }
    
    private func updateNavigationButtonsState(currentDate: Date) {
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate)!
        let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate)!
        
        let previousAvailable = interactor?.minDate.compare(previousMonth) == ComparisonResult.orderedAscending
        let nextAvailable = interactor?.maxDate.compare(nextMonth) == ComparisonResult.orderedDescending
        
        backButton.isEnabled = previousAvailable
        nextButton.isEnabled = nextAvailable
        
        backButton.tintColor = previousAvailable ? UIColor(rgb: 0x025C91) : UIColor.gray
        nextButton.tintColor = nextAvailable ? UIColor(rgb: 0x025C91) : UIColor.gray
    }
    
    private func handleConfiguration(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else { return }
        
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    private func handleCellColor(cell: CalendarCell, cellState: CellState) {
        if cellState.isSelected {
            cell.dateLabel.textColor = UIColor.white
        } else if cellState.dateBelongsTo == .thisMonth {
            if calendar.isDateInWeekend(cellState.date) {
                cell.dateLabel.textColor = UIColor.red
            } else {
                cell.dateLabel.textColor = UIColor.black
            }
        } else {
            if calendar.isDateInWeekend(cellState.date) {
                cell.dateLabel.textColor = UIColor.red
            } else {
                cell.dateLabel.textColor = UIColor.gray
            }
        }
    }
    
    private func handleCellSelection(cell: CalendarCell, cellState: CellState) {
        cell.selectedView.isHidden = !cellState.isSelected
        
        cell.contentView.layer.cornerRadius = 0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.borderWidth = 0
        
        if #available(iOS 11.0, *) {
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.borderWidth = 0
            switch cellState.selectedPosition() {
            case .left:
                cell.selectedView.layer.cornerRadius = kCornerRadius
                cell.selectedView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .middle:
                cell.selectedView.layer.cornerRadius = 0
                cell.selectedView.layer.maskedCorners = []
            case .right:
                cell.selectedView.layer.cornerRadius = kCornerRadius
                cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            case .full:
                cell.selectedView.layer.cornerRadius = kCornerRadius
                cell.selectedView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .none:
                if calendar.isDateInToday(cellState.date) {
                    cell.contentView.layer.cornerRadius = kCornerRadius
                    cell.contentView.layer.borderColor = UIColor(rgb: 0x025C91).cgColor
                    cell.contentView.layer.borderWidth = 3
                }
            }
        } else {
            let rect = cell.selectedView.frame
            let radius = CGSize.init(width: kCornerRadius, height: kCornerRadius)
            var corners: UIRectCorner?
            switch cellState.selectedPosition() {
            case .left:
                corners = UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topLeft.rawValue) | UInt8(UIRectCorner.bottomLeft.rawValue)))
            case .middle:
                break
            case .right:
                corners = UIRectCorner(rawValue: UIRectCorner.RawValue(UInt8(UIRectCorner.topRight.rawValue) | UInt8(UIRectCorner.bottomRight.rawValue)))
            case .full:
                corners = UIRectCorner.allCorners
            case .none:
                if calendar.isDateInToday(cellState.date) {
                    cell.contentView.layer.cornerRadius = kCornerRadius
                    cell.contentView.layer.borderColor = UIColor(rgb: 0x025C91).cgColor
                    cell.contentView.layer.borderWidth = 3
                }
            }
            
            if let _corners = corners {
                let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: _corners, cornerRadii: radius)
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                cell.contentView.layer.mask = mask
            } else {
                cell.contentView.layer.mask = nil
            }
        }
    }

}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
            return JTAppleCell()
        }
        cell.dateLabel.text = cellState.text
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        interactor?.selectDate(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        interactor?.deselectDate(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return interactor?.shouldSelectDate(date) ?? true
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let startDate = interactor?.minDate ?? Date()
        let endDate = interactor?.maxDate ?? Date()
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .monday)
        return parameter
    }
    
}

class CalendarCell: JTAppleCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.masksToBounds = false
        self.layer.masksToBounds = false
    }
}
