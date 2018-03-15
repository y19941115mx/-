// //
////  CustomAnnotationView.m
////  PatientClient
////
////  Created by victor on 2018/3/15.
////  Copyright © 2018年 victor. All rights reserved.
////
//#define kCalloutWidth       200.0
//#define kCalloutHeight      70.0
//
//#import "CustomAnnotationView.h"
//@interface CustomAnnotationView ()
//
//@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;
//
//@end
//
//@implementation CustomAnnotationView
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    if (self.selected == selected)
//    {
//        return;
//    }
//
//    if (selected)
//    {
//        if (self.calloutView == nil)
//        {
//            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
//        }
//
//        self.calloutView.titleLabel = self.annotation
//        self.calloutView.subtitleLabel = self.annotation.subtitle;
//
//        [self addSubview:self.calloutView];
//    }
//    else
//    {
//        [self.calloutView removeFromSuperview];
//    }
//
//    [super setSelected:selected animated:animated];
//}
//
//@end
//
