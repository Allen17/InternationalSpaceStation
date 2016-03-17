//
//  ISSPositionAnnotationView.swift
//  InternationalSpaceStation
//
//  Created by Allen Wong on 3/16/16.
//  Copyright © 2016 Allen Wong. All rights reserved.
//

import MapKit

class ISSPositionAnnotationView: MKAnnotationView
{

    override init(annotation: MKAnnotation?, reuseIdentifier: String?)
    {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)


    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(annotation: nil, reuseIdentifier: nil)
        fatalError("init(coder:) has not been implemented")
    }

    func buttonClicked()
    {

    }

}

class ISSPositionAnnotation: MKPointAnnotation
{
    var issPosition: ISSCurrentPosition?
    init(issPosition: ISSCurrentPosition, title: String)
    {
        super.init()

        self.issPosition = issPosition
        if let currentLocation = issPosition.coordinate
        {
            self.coordinate = currentLocation
            self.title = title
        }
    }
}
