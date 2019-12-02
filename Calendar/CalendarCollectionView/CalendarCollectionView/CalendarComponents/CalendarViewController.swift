//
//  CalendarViewController.swift
//  CalendarCollectionView
//
//  Created by 843832 on 16/09/19.
//  Copyright © 2019 tcs. All rights reserved.
//
import UIKit
let calendarCell = "CalendarCell"
let calendar = "Calendar"
let headerView = "HeaderView"
enum YearType:String{
    case leapCalendar = "LeapCalendar"
    case calendar = "Calendar"
}
enum Days:String,CaseIterable {
    case sunday = "Sun"
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
    static func getDays() -> [Days]{
        return Days.allCases
    }
}
enum Months:String, CaseIterable {
    case january = "January"
    case february = "February"
    case march = "March"
    case april = "April"
    case may = "May"
    case june = "June"
    case july = "July"
    case august = "August"
    case september = "September"
    case october = "October"
    case november = "November"
    case december = "December"
    static func getMonths() -> [Months]{
        return Months.allCases
    }
}
extension CalendarViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/8.0, height: 50)
    }
}
extension CalendarViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0...6:
            return
        default:
            let cell = calendarCollectionView.cellForItem(at: indexPath) as! CalendarCell
            let date = (cell.lblTest.text ?? "") + " " + Months.getMonths()[indexPath.section].rawValue + " " + "\(String(describing: selectedYear))"
            if !arrSelectedDates.contains(date){
                arrSelectedDates.append(date)
                cell.lblTest.layer.cornerRadius = cell.lblTest.frame.width/2
                cell.lblTest.layer.masksToBounds = true
                cell.lblTest.backgroundColor = .lightGray
            }else{
                arrSelectedDates = arrSelectedDates.filter({ (each) -> Bool in
                    each !=  date
                })
                cell.lblTest.backgroundColor = .clear
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerUIView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerView, for: indexPath) as! HeaderView
            headerUIView.lblMonth.text = Months.getMonths()[indexPath.section].rawValue
            return headerUIView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}
extension CalendarViewController:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Months.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (calendarDict[Months.getMonths()[section].rawValue]?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0...6:
            let day = Days.getDays()[indexPath.row].rawValue
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCell, for: indexPath) as? CalendarCell else{
                return UICollectionViewCell()
            }
            cell.lblTest.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.lblTest.text = day
            cell.lblTest.backgroundColor = .clear
            return cell
        case 7...:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCell, for: indexPath) as? CalendarCell else{
                return UICollectionViewCell()
            }
            let date = calendarDict[Months.getMonths()[indexPath.section].rawValue]![indexPath.row]
            cell.lblTest.font = UIFont(name:"HelveticaNeue-Neue", size: 16.0)
            cell.lblTest.text = date == 0 ? "" : "\(date)"
            let dates = (cell.lblTest.text ?? "") + " " + Months.getMonths()[indexPath.section].rawValue + " " + "\(String(describing: selectedYear))"
            if arrSelectedDates.contains(dates){
                arrSelectedDates.append(dates)
                cell.lblTest.layer.cornerRadius = cell.lblTest.frame.width/2
                cell.lblTest.layer.masksToBounds = true
                cell.lblTest.backgroundColor = .lightGray
            }else{
                arrSelectedDates = arrSelectedDates.filter({ (each) -> Bool in
                    each !=  dates
                })
                cell.lblTest.backgroundColor = .clear
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

class CalendarViewController: UIViewController {
    private lazy var arrSelectedDates = [String]()
    private var selectedYear:Int!
    private var calendarData:[String:[String]]?
    private var calendarDict:[String:[Int]]!
    private var startDateDict:[String:Days]!
    private var startDay:Days? = .tuesday
    private var lastDayOfPreviousMonth:Days? = .tuesday
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    private var yearCollectionView:YearCollectionView!
    private var numberOfDaysInMonth:Int? = 7
    private var yearType:YearType? = .calendar
    private var plistFilePath:String!
    private let yearViewHeight:CGFloat = 75
    fileprivate func calendarDataSetup() {
        startDateDict = getStartDay()
        calendarDict = formCalendarDataSource()
        calendarCollectionView.reloadData()
    }
    
    fileprivate func setupUICollectionView() {
        self.calendarCollectionView.delegate = self
        self.calendarCollectionView.dataSource = self
        self.calendarCollectionView.register(UINib(nibName: calendarCell, bundle: nil), forCellWithReuseIdentifier: calendarCell)
        calendarCollectionView.register(UINib(nibName: headerView, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:headerView)
        if let flowLayout = self.calendarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            flowLayout.headerReferenceSize = CGSize(width: self.calendarCollectionView.frame.size.width, height: 100)
        }
        calendarCollectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setUpYearView()
        setupUICollectionView()
        calendarDataSetup()
    }
    
    
    private func formCalendarDataSource() -> [String:[Int]]{
        var dictDataSource = [String:[Int]]()
        Months.allCases.forEach { (eachMonth) in
            var noOfDays:Int = 0
            let month = eachMonth.rawValue
            let path = Bundle.main.path(forResource: yearType?.rawValue, ofType: "plist")
            let calendarDict =  NSDictionary(contentsOfFile: path!) as? [String : Int]
            let totalDays = (calendarDict?[month])!
            var totalDaysArray =  Array(1...totalDays)
            let statDate = startDateDict[month]
            if let lastDayOfPrevMonth = statDate{
                let indexOfLastDay = Days.getDays().firstIndex { (each) -> Bool in
                    each == lastDayOfPrevMonth
                }
                noOfDays = indexOfLastDay!
            }
            for i in 0..<Days.allCases.count{
                totalDaysArray.insert(0, at: i)
            }
            for i in 0..<noOfDays{
                totalDaysArray.insert(0, at: i + Days.allCases.count)
            }
            dictDataSource[month] = totalDaysArray
        }
        return dictDataSource
    }
    
    func getStartDay() -> [String:Days]{
        var dictData = [String:Days]()
        Months.allCases.forEach { (month) in
            var noOfDays:Int = 0
            let monthStr = month.rawValue
            let path = Bundle.main.path(forResource: yearType?.rawValue, ofType: "plist")
            let calendarDict =  NSDictionary(contentsOfFile: path!) as? [String : Int]
            let totalDays = (calendarDict?[monthStr])!
            let totalDaysArray =  Array(1...totalDays)
            if let lastDayOfPrevMonth = startDay{
                let indexOfLastDay = Days.getDays().firstIndex { (each) -> Bool in
                    each == lastDayOfPrevMonth
                }
                noOfDays = indexOfLastDay!
            }
            let reminder = ((totalDaysArray.count % 7) + noOfDays) % 7
            dictData[monthStr] = startDay
            startDay = Days.getDays()[reminder]
        }
        return dictData
    }
    
    private func setUpYearView(){
        yearCollectionView = YearCollectionView.init(nibName: "YearCollectionView", bundle: nil)
        yearCollectionView.passYearClosure = { (year,month) in
            print(year)
            self.selectedYear = year
            let zellerResult = self.zellersFormula(forTheYear: year)
            self.startDay = zellerResult.0
            if zellerResult.1{
                self.yearType = YearType.leapCalendar
            }else{
                self.yearType = YearType.calendar
            }
            self.calendarDataSetup()
            if let monthUnwrapped = month{
                self.calendarCollectionView.scrollToItem(at: IndexPath(row: 0, section: monthUnwrapped), at: .top, animated: false)
            }
        }
        yearCollectionView.view.frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: yearViewHeight)
        self.addChild(yearCollectionView)
        self.view.addSubview(yearCollectionView.view)
        self.yearCollectionView.view.translatesAutoresizingMaskIntoConstraints  = false
        self.yearCollectionView.view.leadingAnchor.constraint(equalTo: self.calendarCollectionView.leadingAnchor, constant: 0).isActive = true
        self.yearCollectionView.view.trailingAnchor.constraint(equalTo: self.calendarCollectionView.trailingAnchor, constant: 0).isActive = true
        self.yearCollectionView.view.bottomAnchor.constraint(equalTo: self.calendarCollectionView.topAnchor, constant: 0).isActive = true
        self.yearCollectionView.view.heightAnchor.constraint(equalToConstant: yearViewHeight).isActive = true
        yearCollectionView.didMove(toParent: self)
    }
    
    //F = K + [(13xM – 1)/5] + D + [D/4] + [C/4] – 2C
    private func zellersFormula(forTheYear year:Int) -> (Days,Bool){
        let D = (year - 1).getLastTwoDigits()
        let C = (year - 1).getFirstTwoDigits()
        let F = (1 + ((13*11 - 1)/5))
        let F2 = F +  D! + (D!/4)
        let F3 = F2 +  (C!/4) - (2*C!)
        var day = F3 % 7
        if day < 0{
            day = day + 7
        }
        return (Days.getDays()[day],isLeapYear(year: year))
    }
    
    private func isLeapYear(year:Int) -> Bool{
        if year.getLastTwoDigits() == 00{
            return (year % 100 == 0 && year % 400 == 0) ?  true :  false
        }else{
            return year % 4 == 0
        }
    }
}

extension Int{
    func getFirstTwoDigits() -> Int?{
        let strInt = String(self)
        let firstTwoChars = strInt.prefix(2)
        return Int(firstTwoChars)
    }
    
    func getLastTwoDigits() -> Int?{
        let strInt = String(self)
        let lastTwoChars = strInt.suffix(2)
        return Int(lastTwoChars)
    }
}
