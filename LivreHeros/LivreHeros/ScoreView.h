//
//  ScoreView.h
//  LivreHeros
//
//  Created by Ancil on 6/30/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ScoreView : UIView
-(void)initialize;
@property (nonatomic,weak) IBOutlet UILabel* currentScoreLabel;
@property (nonatomic,weak) IBOutlet UILabel* top5HeadingLabel;
@property (nonatomic,weak) IBOutlet UILabel* score1label;
@property (nonatomic,weak) IBOutlet UILabel* score2label;
@property (nonatomic,weak) IBOutlet UILabel* score3label;
@property (nonatomic,weak) IBOutlet UILabel* score4label;
@property (nonatomic,weak) IBOutlet UILabel* score5label;
@end
