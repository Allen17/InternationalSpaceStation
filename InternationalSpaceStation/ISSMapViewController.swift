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

    @IBOutlet weak var addFavoriteLocationButton: UIButton!
    @IBAction func addFavoriteButtonAction(sender: UIButton)
    {
        addFavoriteLocationButton.hidden = true
        self.performSegueWithIdentifier("SegueToAddFavorite", sender: nil)
    }

    @IBAction func addFavoriteBarButton(sender: UIBarButtonItem)
    {
        addFavoriteLocationButton.hidden = false
    }

    @IBAction func reloadISSBarButtonAction(sender: UIBarButtonItem)
    {
        let currentAnnotationPin = self.mapView.annotations.filter({$0.title! == "SpaceStation"})

        self.mapView.removeAnnotations(currentAnnotationPin)
        self.displayCurrentISSPosition()
    }

    func mapViewDidFinishLoadingMap(mapView: MKMapView)
    {
        if mapView.annotations.filter({$0.title! == "SpaceStation"}).isEmpty
        {
            self.displayCurrentISSPosition()
        }
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        if let positiionAnnotation = annotation as? ISSPositionAnnotation
        {
            let issAnnotationView = MKAnnotationView(annotation: positiionAnnotation, reuseIdentifier: "ISSPositationView")

            issAnnotationView.image = UIImage(named: "spaceStationIcon")
            issAnnotationView.canShowCallout = true

            let button = UIButton(type: UIButtonType.DetailDisclosure)
            button.addTarget(self, action: "buttonClicked", forControlEvents: UIControlEvents.TouchUpInside)

            issAnnotationView.rightCalloutAccessoryView = button

            return issAnnotationView    
        }

        return nil
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let addFavoriteViewController = segue.destinationViewController as? ISSAddFavoriteViewController
        {
            addFavoriteViewController.favoriteCoordinate = mapView.centerCoordinate
        }

    }

    func displayCurrentISSPosition()
    {
        self.issNetwork.getCurrentISSLocation { [weak self] (position) in

            guard let strongSelf = self else
            {
                return
            }

            if let currentPosition = position where currentPosition.coordinate != nil
            {
                let issPositionPin = ISSPositionAnnotation(issPosition: currentPosition, title: "SpaceStation")

                strongSelf.mapView.addAnnotation(issPositionPin)
            }
        }
    }



    func buttonClicked()
    {
        self.mapView.annotations.filter({$0.title! == "SpaceStation"})

    }

}

