//
//  ScoreView.m
//  LivreHeros
//
//  Created by Ancil on 6/30/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPScore+LHPExtensions.h"
#import "ScoreView.h"
@implementation ScoreView

-(void)initialize;
{
    //set up and configure the IBOutlets
    [self updateUI];
}

-(void)updateUI;
{
    NSArray* scores = [LHPScore fetchScores];
    
    NSInteger count = [scores count];
    LHPScore* score;
    
    switch (count) {
        case 5:
            score = (LHPScore*)scores[4];
            self.score5label.text = [NSString stringWithFormat:@"%@: %tu",score.username,score.score];

        case 4:
            score = (LHPScore*)scores[3];
            self.score4label.text = [NSString stringWithFormat:@"%@: %tu",score.username,score.score];

        case 3:
            score = (LHPScore*)scores[2];
            self.score3label.text = [NSString stringWithFormat:@"%@: %tu",score.username,score.score];
        
        case 2:
            score = (LHPScore*)scores[1];
            self.score2label.text = [NSString stringWithFormat:@"%@: %tu",score.username,score.score];

        case 1:
            score = (LHPScore*)scores[0];
            self.score1label.text = [NSString stringWithFormat:@"%@: %tu",score.username,score.score];

        case 0:
        default:
            break;
    }
    
}

@end
