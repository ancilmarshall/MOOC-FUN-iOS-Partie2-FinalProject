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

    self.score1label.translatesAutoresizingMaskIntoConstraints = NO;
    self.score2label.translatesAutoresizingMaskIntoConstraints = NO;
    self.score3label.translatesAutoresizingMaskIntoConstraints = NO;
    self.score4label.translatesAutoresizingMaskIntoConstraints = NO;
    self.score5label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self updateUI];
}

-(void)updateUI;
{
    NSArray* scores = [LHPScore fetchScores];
    
    NSInteger count = [scores count];
    LHPScore* score;
    
    UIFont* font = [UIFont systemFontOfSize:14.0];
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
            
            break;
        case 0:
        default:
            break;
    }
    
}

@end
