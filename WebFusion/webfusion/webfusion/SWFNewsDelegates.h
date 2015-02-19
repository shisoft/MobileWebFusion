//
//  SWFNewsDelegates.h
//  webfusion
//
//  Created by Jack Shi on 13-8-11.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWFADBannerDelagates.h"

typedef id (^getNewsBlock)(void);
typedef void (^loadCompletedBlock)(void);

@interface SWFNewsDelegates : NSObject <UIWebViewDelegate, UIActionSheetDelegate>

@property BOOL isFirstTime;
@property UIViewController *viewController;
@property UIRefreshControl *refreshControl;
@property NSString* activeNewsId;
@property UIActionSheet* actionSheet;
@property UIWebView *newsWebView;
@property BOOL busy;
@property BOOL isEmpty;
@property BOOL toTail;
@property NSInteger*  currentPage;
@property NSDate*     latestNewsDate;
@property NSDate*     pageLastNewsDate;
@property (nonatomic, strong) getNewsBlock getNews;
@property (nonatomic, strong) loadCompletedBlock loadCompleted;
@property SWFADBannerDelagates* adDelegates;
@property NSString* delegateName;
@property NSString* cachedFile;

-(SWFNewsDelegates*) initWithWebView:(UIWebView*)newsWebView ViewController:(UIViewController*)vc getNews:(getNewsBlock)getNews name:(NSString*)name;

- (void)loadNews;
- (void)resetParameteres;
- (void)manualBottomInsets;

@end
