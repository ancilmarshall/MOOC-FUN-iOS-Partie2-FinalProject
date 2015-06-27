//
//  LHPXMLParserDelegate.m
//  LivreHeros
//
//  Created by Ancil on 6/27/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//


/*
 The XML format is as follows:
 =============================
 <histoire>
    <etape>
        <id>1</id>
        <texte>Is blue the color of the sky?</texte>
        <oui>2</oui>
        <non>3</non>
    </etape>
 </histoire>
 */

#import "LHPXMLParserDelegate.h"
#import "LHPBook+LHPExtensions.h"
#import "LHPQuestion+LHPExtensions.h"

typedef enum {
    kLHPXMLParserTagNone = 0,
    kLHPXMLParserTagBook,
    kLHPXMLParserTagQuestion,
    kLHPXMLParserTagId,
    kLHPXMLParserTagText,
    kLHPXMLParserTagYes,
    kLHPXMLParserTagNo
} LHPXMLParserTag;


@interface LHPXMLParserDelegate() 

@property (nonatomic,strong) LHPBook* book;
@property (nonatomic,strong) LHPQuestion* question;
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,assign) NSUInteger yesIndex;
@property (nonatomic,assign) NSUInteger noIndex;
@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSString* foundText;
@property (nonatomic,assign) LHPXMLParserTag currentParserTag;


@end

@implementation LHPXMLParserDelegate

#pragma mark - Initialization
-(instancetype)init;
{
    self = [super init];
    if (self){
        _book = [LHPBook sharedInstance];
        _foundText = @"";
    }
    
    return self;
}

#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString* )qualifiedName attributes:(NSDictionary*)attributeDict;
{
    if ([elementName isEqualToString:@"historire"]){
        self.currentParserTag = kLHPXMLParserTagBook;
    } else if ([elementName isEqualToString:@"etape"]){
        self.currentParserTag = kLHPXMLParserTagQuestion;
    } else if ([elementName isEqualToString:@"id"]){
        self.currentParserTag = kLHPXMLParserTagId;
    } else if ([elementName isEqualToString:@"texte"]){
        self.currentParserTag = kLHPXMLParserTagText;
    } else if ([elementName isEqualToString:@"oui"]){
        self.currentParserTag = kLHPXMLParserTagYes;
    } else if ([elementName isEqualToString:@"non"]){
        self.currentParserTag = kLHPXMLParserTagNo;
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
    if ([elementName isEqualToString:@"historire"]){
        //do nothing
    } else if ([elementName isEqualToString:@"etape"]){
        [self.book addQuestion:self.text index:self.index yes:self.yesIndex no:self.noIndex];
    } else if ([elementName isEqualToString:@"id"]){
        self.index = [self.foundText integerValue];
    } else if ([elementName isEqualToString:@"texte"]){
        self.text = self.foundText;
    } else if ([elementName isEqualToString:@"oui"]){
        self.yesIndex = [self.foundText integerValue];
    } else if ([elementName isEqualToString:@"non"]){
        self.noIndex = [self.foundText integerValue];
    }

    self.foundText = @"";
    self.currentParserTag = kLHPXMLParserTagNone;
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
    //can be called several times
    switch (self.currentParserTag) {
        case kLHPXMLParserTagNone:
        case kLHPXMLParserTagBook:
        case kLHPXMLParserTagQuestion:
            break;
            
        case kLHPXMLParserTagYes:
        case kLHPXMLParserTagId:
        case kLHPXMLParserTagNo:
        case kLHPXMLParserTagText:
            self.foundText = [self.foundText stringByAppendingString:string];
            break;
            
        default:
            break;
    }
}

@end
