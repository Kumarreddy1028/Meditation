//
//  CustomMkAnnotationViewForGlobalMeditation.h
//  Meditation
//
//  Created by IOS-2 on 17/03/16.
//  Copyright © 2016 IOS-01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface CustomMkAnnotationViewForGlobalMeditation : NSObject<MKAnnotation>
@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(copy,nonatomic) NSString *title;
-(id)initWithTitle:(NSString *)newtitle Location:(CLLocationCoordinate2D)location;


//-(MKAnnotationView *)annotationView;

@end
