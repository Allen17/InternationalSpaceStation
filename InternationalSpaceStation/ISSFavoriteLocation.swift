//
//  ISSFavoriteLocation.swift
//  InternationalSpaceStation
//
//  Created by Allen Wong on 3/17/16.
//  Copyright © 2016 Allen Wong. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation


class ISSFavoriteLocation
{
    static let sharedInstance = ISSFavoriteLocation()

    var favoriteLocation: [MKPointAnnotation] = []

    func addNewFavoriteLocation(coordinate: CLLocationCoordinate2D?)
    {
        guard let favoriteCoordinate = coordinate else
        {
            return
        }

        if favoriteLocation.filter({$0.coordinate.latitude == favoriteCoordinate.latitude  && $0.coordinate.longitude == favoriteCoordinate.longitude}).isEmpty
        {
            let newFaovriateLocation = MKPointAnnotation()
            newFaovriateLocation.coordinate = favoriteCoordinate
            newFaovriateLocation.title = "lat: \(favoriteCoordinate.latitude), lng: \(favoriteCoordinate.longitude)"

            favoriteLocation.append(newFaovriateLocation)
        }
    }

}