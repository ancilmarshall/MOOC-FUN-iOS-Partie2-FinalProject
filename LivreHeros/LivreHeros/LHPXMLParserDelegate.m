//
//  LHPXMLParserDelegate.m
//  LivreHeros
//
//  Created by Ancil on 6/27/15.
//  Copyright (c) 2015 Ancil Marshall. All rights reserved.
//

/*
 *                       NOTE
 *  This is my quick implementation. A more elegant, robust and flexible solution is 
 *  described in "Programming iOS 7" by Matt Neuburg
 */

/*
 The XML format is as follows:
 =============================
 <histoire>
    <etape>
        <id>1</id>
        <texte>Question goes here</texte>
        <oui>2</oui>
        <non>3</non>
    </etape>
 </histoire>
 */

#import "LHPXMLParserDelegate.h"
#import "LHPBook+LHPExtensions.h"
#import "LHPQuestion+LHPExtensions.h"

NSString* const kLHPXMLParserDeletageCompletionNotification =
    @"LHPXMLParserDelegateCompletionNotification";

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
        _currentParserTag = kLHPXMLParserTagNone;
    }
    
    return self;
}

#pragma mark - NSXMLParserDelegate methods

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString* )qualifiedName attributes:(NSDictionary*)attributeDict;
{
    if ([elementName isEqualToString:@"histoire"]){
        NSLog(@"Parsing started...");
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
    
    switch (self.currentParserTag) {
        case kLHPXMLParserTagNone:
            break;
            
        case kLHPXMLParserTagBook:
            NSLog(@"Parsing complete, posting notification");
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kLHPXMLParserDeletageCompletionNotification
             object:nil];
            
            break;
            
        case kLHPXMLParserTagQuestion:
            [self.book addQuestion:self.text index:self.index yes:self.yesIndex no:self.noIndex];
            self.currentParserTag = kLHPXMLParserTagBook;
            //Need to reset to parent element here which will now be the expected closing
            //element the next time this function is run
            break;
            
        case kLHPXMLParserTagId:
            self.index = [self.foundText integerValue];
            self.currentParserTag = kLHPXMLParserTagNone;
            break;
            
        case kLHPXMLParserTagText:
            self.text = self.foundText;
            self.currentParserTag = kLHPXMLParserTagNone;
            break;

        case kLHPXMLParserTagYes:
            self.yesIndex = [self.foundText integerValue];
            self.currentParserTag = kLHPXMLParserTagNone;
            break;
            
        case kLHPXMLParserTagNo:
            self.noIndex = [self.foundText integerValue];
            self.currentParserTag = kLHPXMLParserTagQuestion;
            //Need to reset to parent element here which will now be the expected closing
            //element the next time this function is run
            break;
            
        default:
            break;
    }
    
    //reset the self.foundText to the empty string
    self.foundText = @"";
    
    //self.currentParserTag = kLHPXMLParserTagNone;
    // NOTE: Needed to reset the currentParseTag here to some nil value since the
    // -parser:foundCharacters: was being called even after the end tag was observed
    // and this was found to add erroneous characters (blanks, \n) to self.foundText
    
//    NOTE: Another implementation is to use if/else statements comparing the elementName to the
//    expected string value. Would have made the code simpler.
//    if ([elementName isEqualToString:@"historire"]){
//        //do nothing
//    } else if ([elementName isEqualToString:@"etape"]){
//        [self.book addQuestion:self.text index:self.index yes:self.yesIndex no:self.noIndex];
//    } else if ([elementName isEqualToString:@"id"]){
//        self.index = [self.foundText integerValue];
//    } else if ([elementName isEqualToString:@"texte"]){
//        self.text = self.foundText;
//    } else if ([elementName isEqualToString:@"oui"]){
//        self.yesIndex = [self.foundText integerValue];
//    } else if ([elementName isEqualToString:@"non"]){
//        self.noIndex = [self.foundText integerValue];
//    }

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
