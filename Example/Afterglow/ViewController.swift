//
//  ViewController.swift
//  Afterglow
//
//  Created by Vien Van Nguyen on 09/02/2016.
//  Copyright (c) 2016 Vien Van Nguyen. All rights reserved.
//

import UIKit
import Afterglow
import RandomColorSwift

class ViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var frontImage: UIImageView!
    
    @IBOutlet weak var buddhaToggle: UIButton!
    @IBOutlet weak var backgroudToggle: UIButton!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    var numberOfLeaf = 40
    var numberOfLine = 15
    var speed = 10
    var background = UIColor.blackColor()
    var hue: Hue = .Pink
    
    var afterglow: (UIView, UIView)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorCollectionView.pagingEnabled = true
        colorCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        afterglow = containerView.addAfterglow()
    }
    
    @IBAction func hideBuddha(sender: AnyObject) {
        buddhaToggle.selected = !buddhaToggle.selected
        frontImage.hidden = buddhaToggle.selected
    }
    
    func resetAfterglow() {
        afterglow?.0.removeFromSuperview()
        afterglow?.1.removeFromSuperview()
        afterglow = containerView.addAfterglowWith(numberOfLeaf, line: numberOfLine, speed: speed, backgroundColor: background, hue: hue)
    }
}


// MARK: Seting afterglow
extension ViewController {
    @IBAction func leafChange(sender: UISlider) {
        numberOfLeaf = Int(sender.value)
        resetAfterglow()
    }
    @IBAction func lineChange(sender: UISlider) {
        numberOfLine = Int(sender.value)
        resetAfterglow()
    }
    @IBAction func speedChange(sender: UISlider) {
        speed = Int(sender.value)
        resetAfterglow()
    }
    @IBAction func changeBackground(sender: AnyObject) {
        backgroudToggle.selected = !backgroudToggle.selected
        background = backgroudToggle.selected ? UIColor.whiteColor() : UIColor.blackColor()
        resetAfterglow()
    }
}

// MARK: Implement color collecion view delegate
extension ViewController: UICollectionViewDelegate {
}
extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.backgroundColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
            break
        case 1:
            cell.backgroundColor = UIColor(red:0.96, green:0.19, blue:0.09, alpha:1.0)
            break
        case 2:
            cell.backgroundColor = UIColor(red:0.93, green:0.44, blue:0.08, alpha:1.0)
            break
        case 3:
            cell.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.14, alpha:1.0)
            break
        case 4:
            cell.backgroundColor = UIColor(red:0.29, green:0.86, blue:0.22, alpha:1.0)
            break
        case 5:
            cell.backgroundColor = UIColor(red:0.03, green:0.82, blue:0.93, alpha:1.0)
            break
        case 6:
            cell.backgroundColor = UIColor(red:0.59, green:0.02, blue:0.95, alpha:1.0)
            break
        case 7:
            cell.backgroundColor = UIColor(red:0.97, green:0.29, blue:0.97, alpha:1.0)
            break
        default:
            cell.backgroundColor = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)
            break
        }
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            hue = .Monochrome
            break
        case 1:
            hue = .Red
            break
        case 2:
            hue = .Orange
            break
        case 3:
            hue = .Yellow
            break
        case 4:
            hue = .Green
            break
        case 5:
            hue = .Blue
            break
        case 6:
            hue = .Purple
            break
        case 7:
            hue = .Pink
            break
        default:
            hue = .Random
            break
        }
        
        resetAfterglow()
    }
}
