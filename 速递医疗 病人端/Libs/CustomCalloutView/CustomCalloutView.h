//
//  CustomCalloutView.h
//  PatientClient
//
//  Created by victor on 2018/3/15.
//  Copyright © 2018年 victor. All rights reserved.
//

#ifndef CustomCalloutView_h
#define CustomCalloutView_h

#import <UIKit/UIKit.h>
@interface CustomCalloutView : UIView

@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;

-(void)setTitle:(NSString *)title;

-(void)setSubtitle:(NSString *)subtitle;

-(void)setImage:(UIImage *)image;


@end
#endif /* CustomCalloutView_h */
