//
//  CustomAnnotationView.h
//  PatientClient
//
//  Created by victor on 2018/3/15.
//  Copyright © 2018年 victor. All rights reserved.
//

#ifndef CustomAnnotationView_h
#define CustomAnnotationView_h

#import "CustomCalloutView.h"
#import <MAMapKit/MAPointAnnotation.h>

@interface CustomAnnotationView : MAPointAnnotation

@property (nonatomic, readonly) CustomCalloutView *calloutView;

@end
#endif /* CustomAnnotationView_h */
