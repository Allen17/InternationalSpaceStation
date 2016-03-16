//
//  ISSMapViewController.swift
//  InternationalSpaceStation
//
//  Created by Allen Wong on 3/16/16.
//  Copyright © 2016 Allen Wong. All rights reserved.
//

import UIKit
import MapKit

class ISSMapViewController: UIViewController, MKMapViewDelegate
{
    let issNetwork = ISSNetwork()
    @IBOutlet weak var mapView: MKMapView!

    @IBAction func reloadISSBarButtonAction(sender: UIBarButtonItem)
    {
        let currentAnnotationPin = self.mapView.annotations.filter({$0.title! == "SpaceStation"})

        self.mapView.removeAnnotations(currentAnnotationPin)

        self.issNetwork.getCurrentISSLocation { [weak self] (position) in

            guard let strongSelf = self else
            {
                return
            }
	
            if let currentPosition = position,
                     issCoordinate = currentPosition.coordinate
            {
                let issPositionPin = ISSPositionAnnotation(coordinate: issCoordinate, title: "SpaceStation")

                strongSelf.mapView.addAnnotation(issPositionPin)
            }
        }
    }


}

class ISSPositionAnnotation: MKPointAnnotation
{
    init(coordinate: CLLocationCoordinate2D, title: String)
    {
        super.init()
        self.coordinate = coordinate
        self.title = title
    }
}

