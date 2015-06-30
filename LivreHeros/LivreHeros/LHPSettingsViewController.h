//
//  LHPSettingsViewController.h
//  LivreHeros
//
//  Created by Ancil on 6/29/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LHPSettingsDelegateProtocol;

@interface LHPSettingsViewController : UIViewController
@property (nonatomic,weak) id<LHPSettingsDelegateProtocol> delegate;
@end


@protocol LHPSettingsDelegateProtocol <NSObject>

-(void)backgroundColorDidUpdate:(UIColor*)color;

@end