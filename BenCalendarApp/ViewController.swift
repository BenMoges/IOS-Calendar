//
//  ViewController.swift
//  BenCalendarApp
//
//  Created by Ben M on 11/19/19.
//  Copyright © 2019 BenM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// outlet for the tableview to display the selected month
    @IBOutlet weak var monthTableView: UITableView!
    
    /// outlet for the label that will display the month and year currently selected
    @IBOutlet weak var monthYearLabel: UILabel!
    
    /// number of days the selected date (month) has
    var numberOfDays = 0
    
    /// date currently selected, by default set it for today
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthTableView.reloadData()
    }
     
    @IBAction func backPressed(_ sender: Any) {
        // since back has been pressed get the previous month based on the currently selected date
        guard let date = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) else { return }
        selectedDate = date
        
        // reload the tableview after the selected date has been changed
        monthTableView.reloadData()
    }
    
    @IBAction func forwardPressed(_ sender: Any) {
        // since forward has been pressed get the next month based on the currently selected date
        guard let date = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) else { return }
        selectedDate = date
        
        // reload the tableview after the selected date has been changed
        monthTableView.reloadData()
    }
    
}

// MARK: UITableView Delegate and Data Source
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthCell", for: indexPath) as! MonthCell
            
        // get the month and year of the selected date
        let month = Calendar.current.component(.month, from: selectedDate)
        let year = Calendar.current.component(.year, from: selectedDate)
        
        // format the date to get the month in letters ex. January
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        // set the label ex. "November 2019"
        monthYearLabel.text = "\(dateFormatter.string(from: selectedDate)) \(year)"
        
        let dateComponents = DateComponents(year: year, month: month)
        let date = Calendar.current.date(from: dateComponents)!

        // get the number of days based on the selected date's month
        let range = Calendar.current.range(of: .day, in: .month, for: date)!
        numberOfDays = range.count
        
        // set the collection view datasource and delegate
        cell.daysCollectionView.delegate = self
        cell.daysCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        cell.daysCollectionView.dataSource = self
        cell.daysCollectionView.reloadData()
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // set the height of the month cell to be the size of the full user's phone screen
        return tableView.frame.height
    }

}

// MARK: UICollectionView Delegate, Data Source, and FlowLayout Delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // get the number of days based on the selected date's month
        let month = Calendar.current.component(.month, from: selectedDate)
        let year = Calendar.current.component(.year, from: selectedDate)
        
        let dateComponents = DateComponents(year: year, month: month, day: 1)
        let date = Calendar.current.date(from: dateComponents)!
        
        // get the weekday for the selected date then -1 since the values for weekday start at 1 instead of 0 like indexPath does
        let weekday = Calendar.current.component(.weekday, from: date) - 1
        
        // adding the number of days plus the weekday value so we can place the first of the month on the current weekday.
        // Ex. if numberOfDays is 30 and weekday is (1) Monday (which is 2 but we need to minus 1 since it doesnt start from 0)
        return numberOfDays + weekday
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = view.frame.width / 7.2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
              
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        
        let month = Calendar.current.component(.month, from: selectedDate)
        let year = Calendar.current.component(.year, from: selectedDate)
                        
        let dateComponents = DateComponents(year: year, month: month, day: 1)
        let date = Calendar.current.date(from: dateComponents)!
        
        let weekday = Calendar.current.component(.weekday, from: date) - 1
        
        // if the row is less than the weekday value leave a blank text so we can place the first of the month on the correct day
        if indexPath.row < weekday {
            cell.textLabel.text = ""
        } else {
            cell.textLabel.text = String(describing: (indexPath.row - weekday) + 1)
        }
                
        return cell
    }
    
}

