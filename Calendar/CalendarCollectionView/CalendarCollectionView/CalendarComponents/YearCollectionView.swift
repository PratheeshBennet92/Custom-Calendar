//
//  YearCollectionView.swift
//  CalendarCollectionView
//
//  Created by Christina Taflin on 17/09/19.
//  Copyright © 2019 tcs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "YearCell"
extension YearCollectionView{
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setSelectedItemFromScrollView(scrollView)
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setSelectedItemFromScrollView(scrollView)
    }
    func setSelectedItemFromScrollView(_ scrollView: UIScrollView) {
        if self.collectionView == scrollView {
            /*Getting the middle of the screen*/
            let center = CGPoint(x: self.view.frame.midX, y: scrollView.center.y /*+ scrollView.contentOffset.y*/)
            index = self.collectionView.indexPathForItem(at: self.view.convert(center, to: self.collectionView))
            if index != nil {
                self.collectionView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
                self.collectionView(self.collectionView, didSelectItemAt: index!)
            }
            else {
            }
        }
    }

    func reloadAllCells(index:IndexPath){
        for i in 0...4000{
            if(index.row != i){
                let indexPath = IndexPath(row: i, section: 0)
                let cell = self.collectionView.cellForItem(at: indexPath) as? YearCell
                UIView.animate(withDuration: 0.4) {
                    cell?.lblYear.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)//Scale la
                }
            }else{
                let indexPath = IndexPath(row: i, section: 0)
                let cell = self.collectionView.cellForItem(at: indexPath) as? YearCell
                self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                UIView.animate(withDuration: 0.4) {
                    cell?.lblYear.transform = CGAffineTransform(scaleX: 2.0, y: 2.0) //Scale la
                }
            }
        }
    }
}


class YearCollectionView: UICollectionViewController {
    typealias PassYearClosure = ((Int),(Int)?)-> Void
    var passYearClosure:PassYearClosure?
    private var year:Int!
    private var currentMonth:Int!
    private var currentYearIndex:IndexPath!
    private var index:IndexPath?
    private var arrYears = [Int]()
    private var startYear = 0
    private var isFirstLoad:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        isFirstLoad = true
        year = Calendar.current.component(.year, from: Date())
        currentMonth = Calendar.current.component(.month, from: Date())
        currentYearIndex = IndexPath(row: year, section: 0)
        print(year)
        generateYears()
        self.collectionView.register(UINib(nibName:reuseIdentifier, bundle: nil), forCellWithReuseIdentifier:reuseIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setSelectedItemFromScrollView(self.collectionView)
        self.collectionView.scrollToItem(at: currentYearIndex, at: .centeredHorizontally, animated: false)
        index = currentYearIndex
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrYears.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! YearCell
        cell.lblYear.text = "\(arrYears[indexPath.row])"
        cell.lblYear.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        if indexPath == index,isFirstLoad{
            cell.lblYear.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            passYearClosure?(arrYears[indexPath.row], currentMonth - 1)
            isFirstLoad = false
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        reloadAllCells(index: indexPath)
        passYearClosure!(arrYears[indexPath.row], nil)
    }
    
    private func generateYears(){
        years:for i in 0...4000{
            arrYears.append(startYear + i)
        }
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200, height: 200)
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
}
