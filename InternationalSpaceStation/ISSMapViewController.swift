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
    let favoriteLocation = ISSFavoriteLocation.sharedInstance

    var selectedAnnotation: MKAnnotation?

    //MARK: - IBOutlet
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addFavoriteLocationButton: UIButton!


    //MARK: - IBAction
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


    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)

        if favoriteLocation.favoriteLocation.isEmpty
        {
            return
        }

        mapView.addAnnotations(favoriteLocation.favoriteLocation)
    }


    //MARK: - MapDelegate
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
            return spaceStationPosition(positiionAnnotation)
        }

        return favoriteAnnotation(annotation)
    }

    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        selectedAnnotation = view.annotation
        addFavoriteLocationButton.hidden = true
    }

    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView)
    {
        selectedAnnotation = nil 
    }

    func spaceStationPosition(annotation: MKAnnotation) -> MKAnnotationView
    {
        let issAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "ISSPositationView")

        issAnnotationView.image = UIImage(named: "spaceStationIcon")
        issAnnotationView.canShowCallout = true

        return issAnnotationView
    }

    func favoriteAnnotation(annotation: MKAnnotation) -> MKAnnotationView
    {
        let favoriteAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "FavoriteLocation")

        favoriteAnnotation.image = UIImage(named: "favoriteLocation")
        favoriteAnnotation.canShowCallout = true

        let button = UIButton(type: UIButtonType.DetailDisclosure)
        button.addTarget(self, action: "buttonClicked", forControlEvents: UIControlEvents.TouchUpInside)

        favoriteAnnotation.rightCalloutAccessoryView = button

        return favoriteAnnotation
    }

    func buttonClicked()
    {
        guard let _ = self.selectedAnnotation else
        {
            return
        }

        self.performSegueWithIdentifier("SegueToAddFavorite", sender: nil)
    }

    func displayCurrentISSPosition()
    {
        self.issNetwork.getCurrentISSLocation { [weak self] (position) in

            guard let strongSelf = self else
            {
                return
            }

            if let currentPosition = position,
                coordinate = currentPosition.coordinate
            {
                let issPositionPin = ISSPositionAnnotation(issPosition: currentPosition, title: "SpaceStation")

                strongSelf.mapView.addAnnotation(issPositionPin)
                strongSelf.mapView.centerCoordinate = coordinate
            }
            
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let addFavoriteViewController = segue.destinationViewController as? ISSAddFavoriteViewController
        {
            if let savedCoordinate = selectedAnnotation?.coordinate
            {
                addFavoriteViewController.favoriteCoordinate = savedCoordinate
                addFavoriteViewController.savedLocation = true
            }
            else
            {
                addFavoriteViewController.favoriteCoordinate = mapView.centerCoordinate
                addFavoriteViewController.savedLocation = false
            }
        }

    }
}

