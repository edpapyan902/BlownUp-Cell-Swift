//
//  ScheduleAddVC.swift
//  BlownUp-Cell-Swift
//
//  Created by Dove on 03/05/2021.
//

import Foundation
import UIKit
import VACalendar

class ScheduleAddVC: BaseVC, VAMonthHeaderViewDelegate, VADayViewAppearanceDelegate, VAMonthViewAppearanceDelegate, VACalendarViewDelegate {
    func didTapNextMonth() {
        
    }
    
    func didTapPreviousMonth() {
        
    }

    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let appereance = VAMonthHeaderViewAppearance(
                previousButtonImage: UIImage(named:"ic_arrow_left")!,
                nextButtonImage: UIImage(named:"ic_arrow_left")!,
                dateFormatter: DateFormatter()
            )
            monthHeaderView.delegate = self
            monthHeaderView.appearance = appereance
        }
    }
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    var calendarView: VACalendarView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let calendar = VACalendar(calendar: defaultCalendar)
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .multi
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .horizontal
        calendarView.tintColor = UIColor.init(named: "colorPrimary")
        view.addSubview(calendarView)
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            if calendarView.frame == .zero {
                calendarView.frame = CGRect(
                    x: 0,
                    y: weekDaysView.frame.maxY,
                    width: view.frame.width,
                    height: view.frame.height * 0.6
                )
                calendarView.setup()
            }
        }
}
