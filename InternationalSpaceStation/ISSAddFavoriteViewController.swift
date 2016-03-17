//
//  ISSAddFavoriteViewController.swift
//  InternationalSpaceStation
//
//  Created by Allen Wong on 3/16/16.
//  Copyright © 2016 Allen Wong. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class ISSAddFavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func addToFavoriteAction(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func dismissControllerAction(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    let newtwork = ISSNetwork()
    var favoriteCoordinate: CLLocationCoordinate2D?

    var passTimes: [ISSPassTime] = []
    {
        didSet
        {
            if passTimes.isEmpty
            {
                return
            }

            self.tableView.reloadData()
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        guard let coordinate = favoriteCoordinate else
        {
            return
        }

        latitudeLabel.text = "\(coordinate.latitude)"
        longitudeLabel.text = "\(coordinate.longitude)"
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)

        guard let coordinate = favoriteCoordinate else
        {
            return
        }

        newtwork.getPassTime(coordinate) { (passTimes: [ISSPassTime]?) -> () in

        }

    }

    //MARK: - TableView DataSource 
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return passTimes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let passTimeCell = tableView.dequeueReusableCellWithIdentifier("passTimeCell", forIndexPath: indexPath)

        return passTimeCell
    }
}