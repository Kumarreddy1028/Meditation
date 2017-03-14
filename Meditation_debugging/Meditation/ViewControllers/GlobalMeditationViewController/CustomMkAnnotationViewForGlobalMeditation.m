//
//  CustomMkAnnotationViewForGlobalMeditation.m
//  Meditation
//
//  Created by IOS-2 on 17/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import "CustomMkAnnotationViewForGlobalMeditation.h"

@implementation CustomMkAnnotationViewForGlobalMeditation

-(id)initWithTitle:(NSString *)newtitle Location:(CLLocationCoordinate2D)location
{
    self=[super init];
    
    if (self)
    {
        self.title=newtitle;
        self.coordinate=location;
    }
    return self;
}

//-(MKAnnotationView *)annotationView
//{
//    MKAnnotationView *annotationView=[[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"myPin"];
//    annotationView.enabled=YES;
//    annotationView.canShowCallout=YES;
//    annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    
//    return annotationView;
//}


@end
