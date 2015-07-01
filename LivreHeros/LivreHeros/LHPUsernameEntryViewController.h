//
//  LHPUsernameEntryViewController.h
//  LivreHeros
//
//  Created by Ancil on 7/1/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LHPUsernameEntryViewController : UIViewController
@property (nonatomic,assign) NSUInteger score;
@property (nonatomic,strong) NSString* username;
-(instancetype)initWithScore:(NSUInteger)score NS_DESIGNATED_INITIALIZER;
@end
