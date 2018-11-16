//
//  CalendarViewInteractor.swift
//  RWBelarus
//
//  Created by Vadzim Mikalayeu on 10/26/18.
//  Copyright © 2018 mikalayeu. All rights reserved.
//

import Foundation

class CalendarViewInteractor: NSObject, CalendarViewControllerInteractor {
    let minDate: Date
    let maxDate: Date
    var beginPeriodDate: Date?
    var endPeriodDate: Date?
    
    @objc dynamic var changed: Bool = true
    
    private let isMultiselectAvailable: Bool
    
    private class var dateFormatter: DateFormatter {
        get {
            let _dateFormatter = DateFormatter()
            _dateFormatter.dateFormat = "dd.MM.yyyy"
            _dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            return _dateFormatter
        }
    }
    
    private class var defaultFutureDate: Date {
        get {
            let currentYear = Calendar.current.dateComponents([.year], from: Date())
            return dateFormatter.date(from: "31.12.\((currentYear.year ?? 2024) + 1)") ?? Date()
        }
    }
    
    private class var defaultPastDate: Date {
        get {
            let currentYear = Calendar.current.dateComponents([.year], from: Date())
            //FIXIT: only next days
            return dateFormatter.date(from: "01.01.\((currentYear.year ?? 2018) - 1)") ?? Date()
        }
    }
    
    init(config: CalendarConfig?) {
        isMultiselectAvailable = config == nil ? false : config!.isMultiSelectionAvailable
        minDate = config?.minimumAvailableDate ?? CalendarViewInteractor.defaultPastDate
        maxDate = config?.maximumAvailableDate ?? CalendarViewInteractor.defaultFutureDate
        super.init()
        beginPeriodDate = config?.beginDate
        endPeriodDate = config?.endDate
        if isMultiselectAvailable == false {
            endPeriodDate = beginPeriodDate
        }
        notify()
    }
    
    func selectDate(_ date: Date) {
        guard selectionAvailableForDate(date) else { return }
        if (beginPeriodDate == nil && endPeriodDate == nil) || isMultiselectAvailable == false {
            beginPeriodDate = date
            endPeriodDate = date
        } else {
            if beginPeriodDate?.compare(date) == ComparisonResult.orderedDescending {
                beginPeriodDate = date
            } else if endPeriodDate?.compare(date) == ComparisonResult.orderedAscending {
                endPeriodDate = date
            } else {
                let toStart = beginPeriodDate!.timeIntervalSince(date)
                let toEnd = -endPeriodDate!.timeIntervalSince(date)
                
                if toStart < toEnd {
                    beginPeriodDate = date
                } else {
                    endPeriodDate = date
                }
            }
        }
        notify()
    }
    
    func deselectDate(_ date: Date) {
        if beginPeriodDate != nil && endPeriodDate != nil {
            if beginPeriodDate!.compare(endPeriodDate!) == ComparisonResult.orderedSame {
                beginPeriodDate = nil
                endPeriodDate = nil
                notify()
            } else {
                if dateSelected(date) {
                    let toStart = -beginPeriodDate!.timeIntervalSince(date)
                    let toEnd = endPeriodDate!.timeIntervalSince(date)
                    
                    if toStart < toEnd {
                        if beginPeriodDate == date {
                            beginPeriodDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
                        } else {
                            beginPeriodDate = date
                        }
                    } else {
                        if endPeriodDate == date {
                            endPeriodDate = Calendar.current.date(byAdding: .day, value: -1, to: date)
                        } else {
                            endPeriodDate = date
                        }
                    }
                    notify()
                }
            }
        }
    }
    
    func dateSelected(_ date: Date) -> Bool {
        if let begin = beginPeriodDate, let end = endPeriodDate {
            return begin.compare(date) != ComparisonResult.orderedDescending &&
                end.compare(date) != ComparisonResult.orderedAscending
        } else {
            return false
        }
    }
    
    func shouldSelectDate(_ date: Date) -> Bool {
        return  minDate.compare(date) != ComparisonResult.orderedDescending &&
            maxDate.compare(date) != ComparisonResult.orderedAscending
    }
    
    private func selectionAvailableForDate(_ date: Date) -> Bool {
        return  minDate.compare(date) != ComparisonResult.orderedDescending &&
            maxDate.compare(date) != ComparisonResult.orderedAscending && dateSelected(date) == false
    }
    
    func subscribe(observer: NSObject) {
        addObserver(observer, forKeyPath: #keyPath(changed), options: .new, context: nil)
    }
    
    func unsubscribe(observer: NSObject) {
        removeObserver(observer, forKeyPath: #keyPath(changed))
    }
    
    private func notify() {
        changed = !changed
    }
    
}
