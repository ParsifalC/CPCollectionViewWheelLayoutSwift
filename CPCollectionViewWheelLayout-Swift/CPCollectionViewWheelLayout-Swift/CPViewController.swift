//
//  CPViewController.swift
//  CPCollectionViewWheelLayout-Swift
//
//  Created by Parsifal on 2016/12/29.
//  Copyright © 2016年 Parsifal. All rights reserved.
//

import UIKit

class CPViewController: UIViewController, UICollectionViewDataSource {
    
    fileprivate let reuseIdentifier = "CPCollectionViewCell"
    var colletionView:UICollectionView?
    open var wheelType = CPWheelLayoutType.CPWheelLayoutLeftBottom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup views
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 100, height: 100)
        layout.scrollDirection = .vertical
        let configuration = CPWheelLayoutConfiguration.init(withCellSize: CGSize.init(width: 100, height: 100), radius: 200, angular: 20, wheelType:wheelType)
        let wheelLayout = CPCollectionViewWheelLayout.init(withConfiguration: configuration)
        colletionView = UICollectionView.init(frame: view.frame, collectionViewLayout:wheelLayout)
        colletionView?.showsVerticalScrollIndicator = false
        colletionView?.showsHorizontalScrollIndicator = false
        colletionView?.backgroundColor = .white
        colletionView?.register(CPCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        colletionView?.dataSource = self
        view.addSubview(colletionView!)
        view.sendSubview(toBack: colletionView!)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CPCollectionViewCell
        cell.textLabel.text = String(indexPath.row)
        return cell
    }
    
    @IBAction func cellSizeChanged(_ sender: UISlider) {
        var configuration = (colletionView?.collectionViewLayout as! CPCollectionViewWheelLayout).configuration
        configuration.cellSize = CGSize.init(width: Double(sender.value), height: Double(sender.value))
        updateCollectionView(withLayoutConfiguration: configuration)
    }

    @IBAction func angularViewChanged(_ sender: UISlider) {
        var configuration = (colletionView?.collectionViewLayout as! CPCollectionViewWheelLayout).configuration
        configuration.angular = Double(sender.value)
        updateCollectionView(withLayoutConfiguration: configuration)
    }
    
    @IBAction func radiusValueChanged(_ sender: UISlider) {
        var configuration = (colletionView?.collectionViewLayout as! CPCollectionViewWheelLayout).configuration
        configuration.radius = Double(sender.value)
        updateCollectionView(withLayoutConfiguration: configuration)
    }
    
    func updateCollectionView(withLayoutConfiguration configuration:CPWheelLayoutConfiguration) {
        let newLayout = CPCollectionViewWheelLayout.init(withConfiguration: configuration)
        colletionView?.collectionViewLayout.invalidateLayout()
        colletionView?.collectionViewLayout = newLayout
        colletionView?.reloadData()
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }
}
