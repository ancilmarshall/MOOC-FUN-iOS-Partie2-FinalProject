//
//  LHPQuestion+LHPExtensions.h
//  LivreHeros
//
//  Created by Ancil on 6/25/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

#import "LHPQuestion.h"

@interface LHPQuestion (LHPExtensions)
@property (nonatomic,assign) NSUInteger qid;
@property (nonatomic,assign) NSUInteger no;
@property (nonatomic,assign) NSUInteger yes;

+(void)insertQuestion:(NSString*)question qid:(NSUInteger)qid yes:(NSUInteger)yes no:(NSUInteger)no;


@end
