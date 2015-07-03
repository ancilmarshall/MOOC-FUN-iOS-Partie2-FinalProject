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
    
    UIFont* font = [UIFont systemFontOfSize:20.0];
    NSDictionary *attrsDictionary =
    [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString* attrString;
    NSString* str;
    
    switch (count) {
            
        case 5:
            score = (LHPScore*)scores[4];
            
            str = [NSString stringWithFormat:@"%@: %tu",score.username,score.score];
            attrString = [[NSAttributedString alloc] initWithString:str attributes:attrsDictionary];
            self.score5label.text = [attrString string];
            
        case 4:
            score = (LHPScore*)scores[3];
            str = [NSString stringWithFormat:@"%@: %tu",score.username,score.score];
            attrString = [[NSAttributedString alloc] initWithString:str attributes:attrsDictionary];
            self.score4label.text = [attrString string];

        case 3:
            score = (LHPScore*)scores[2];
            str = [NSString stringWithFormat:@"%@: %tu",score.username,score.score];
            attrString = [[NSAttributedString alloc] initWithString:str attributes:attrsDictionary];
            self.score3label.text = [attrString string];
        
        case 2:
            score = (LHPScore*)scores[1];
            str = [NSString stringWithFormat:@"%@: %tu",score.username,score.score];
            attrString = [[NSAttributedString alloc] initWithString:str attributes:attrsDictionary];
            self.score2label.text = [attrString string];

        case 1:
            score = (LHPScore*)scores[0];
            str = [NSString stringWithFormat:@"%@: %tu",score.username,score.score];
            attrString = [[NSAttributedString alloc] initWithString:str attributes:attrsDictionary];
            self.score1label.text = [attrString string];
            
        case 0:
        default:
            break;
    }
    
}

@end
