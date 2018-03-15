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
#import <MAMapKit/MAPinAnnotationView.h>

@interface CustomAnnotationView : MAPinAnnotationView

@property (nonatomic, readonly) CustomCalloutView *calloutView;
@property (nonatomic, strong) UIImage *pix;

@end
#endif /* CustomAnnotationView_h */
