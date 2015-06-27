//
//  LHPBook+LHPExtensions.h
//  LivreHeros
//
//  Created by Ancil on 6/26/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPBook.h"

@interface LHPBook (LHPExtensions)

typedef enum {
    kUserResponseNo = 0,
    kUserResponseYes
} UserResponse;


@property (nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic,assign) NSUInteger currentScore;
+(instancetype)sharedInstance;
-(void)addQuestion:(NSString*)text index:(NSUInteger)index yes:(NSUInteger)yesIndex no:(NSUInteger)noIndex;
-(NSString*)getNextQuestion:(UserResponse)response;
-(NSString*)getCurrentQuestion;
-(void)restart;

@end
