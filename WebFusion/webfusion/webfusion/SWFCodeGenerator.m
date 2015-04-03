//
//  SWFNewsDisplayCodeGenerator.m
//  webfusion
//
//  Created by Jack Shi on 13-7-2.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFCodeGenerator.h"
#import "SWFNews.h"
#import "SWFPost.h"
#import "SWFUniversalContact.h"
#import "SWFMedia.h"
#import "SWFPOI.h"
#import "CLLocation+CGIPersistance.h"
#import "NSString+URLEncode.h"

@implementation SWFCodeGenerator

static NSMutableString *newsListTemplate = nil;
static NSMutableString *newsItemTemplate = nil;
static NSMutableString *postPageTemplate = nil;
static NSMutableString *postItemTemplate = nil;
static NSMutableString *convItemTemplate = nil;
static NSMutableString *convPageTemplate = nil;

+ (void)readyForTemplate{
    if(newsListTemplate == nil || newsItemTemplate == nil || postPageTemplate == nil || postItemTemplate == nil || convItemTemplate == nil || convPageTemplate == nil){
        newsListTemplate = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"newsList" withExtension:@"html"] encoding:NSUTF8StringEncoding error:NULL];
        newsItemTemplate = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"newsItem" withExtension:@"html"] encoding:NSUTF8StringEncoding error:NULL];
        postPageTemplate = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"postPage" withExtension:@"html"] encoding:NSUTF8StringEncoding error:NULL];
        postItemTemplate = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"postItem" withExtension:@"html"] encoding:NSUTF8StringEncoding error:NULL];
        convItemTemplate = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"convItem" withExtension:@"html"] encoding:NSUTF8StringEncoding error:NULL];
        convPageTemplate = [NSMutableString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"convList" withExtension:@"html"] encoding:NSUTF8StringEncoding error:NULL];
    }
}

+ (NSString*)generateForNews:(SWFNews*)newsItem level:(int)level{
    if(![newsItem isKindOfClass:[SWFNews class]]){
        return @"";
    }
    [self readyForTemplate];
    NSMutableString *nItemTemplate = [NSMutableString stringWithString:newsItemTemplate];
    NSMutableString *refer = [NSMutableString stringWithString:@""];
    if([newsItem.refer isKindOfClass:[SWFNews class]]){
        level++;
        if (level < 2) {
            [refer appendString:@"<blockquote>"];
            [refer appendString:[self generateForNews:newsItem.refer level:level]];
            [refer appendString:@"</blockquote>"];
        } else if (level == 2) {
            NSArray *referedNews = [self flattenReferedNews:newsItem levels:[[NSMutableArray alloc] init]];
            if ([referedNews count] != nil) {
                [refer appendFormat:@"<a href='javascript:dispChain(\"%@\")'>%@</a>", newsItem.ID, [NSString stringWithFormat:NSLocalizedString(@"ui.moreRefer", @""), [referedNews count]]];
                [refer appendString:[NSString stringWithFormat:@"<div style='display: none' class='newsChain' id='divNewsChan%@'>", newsItem.ID]];
                for (SWFNews *news in referedNews) {
                    [refer appendString:[self generateForNews:news level:level + 1]];
                }
                [refer appendString:@"</div>"];
            }
        }
    }
    NSDictionary *vars = @{
            @"avatar":   [[newsItem.authorUC.avatar absoluteString] urlencode],
            @"author":   [self authorDescription:newsItem.authorUC],
            @"title":    [self titleDescription:newsItem.title],
            @"time":     [self timeDescription:newsItem.publishTime],
            @"timestamp":[NSString stringWithFormat:@"%f",[newsItem.publishTime timeIntervalSince1970]  * 1000],
            @"content":  [self contentFromNews:newsItem],
            @"refer":    refer,
            @"id":       newsItem.ID,
            @"svr":      [newsItem.svr lowercaseString]
    };
    for (NSString *var in vars)
    {
        NSString *value = vars[var];

        [nItemTemplate replaceOccurrencesOfString:[NSString stringWithFormat:@"$(%@)", [var uppercaseString]]
                                       withString:value
                                          options:0
                                            range:NSMakeRange(0, [nItemTemplate length])];
    }
    return nItemTemplate;
}

+ (NSString*)generateForConversationPOST: (SWFPost*) post {
    [self readyForTemplate];
    NSString *title = [self getPostTitle:post];
    NSString *content = post.content;
    if ([title length]==0 && [post.content length]>0) {
        title = post.content;
    }
    if ([title isEqualToString:content]){
        content = nil;
    }
    NSMutableString *itemHTML = [NSMutableString stringWithString:convItemTemplate];
    NSDictionary *vars = @{
            @"avatar":   [([post.authorUC.avatar absoluteString]?[post.authorUC.avatar absoluteString]:@"default-user.png") urlencode],
            @"author":   [self authorDescription:post.authorUC],
            @"title":    (title?title:@""),
            @"time":     [self timeDescription:post.posttime],
            @"timestamp":[NSString stringWithFormat:@"%f",[post.posttime timeIntervalSince1970]  * 1000],
            @"content":  [self contentFromPost:content news:post.news],
            @"id":       post.ID,
            @"side":     [[post.authorUC.svr lowercaseString] isEqualToString:@"user"] ? @"right" : @"left"
    };
    for (NSString *var in vars)
    {
        NSString *value = vars[var];

        [itemHTML replaceOccurrencesOfString:[NSString stringWithFormat:@"$(%@)", [var uppercaseString]]
                                  withString:value
                                     options:0
                                       range:NSMakeRange(0, [itemHTML length])];
    }
    return itemHTML;
}

+ (NSMutableArray*)flattenReferedNews:(SWFNews *)news levels:(NSMutableArray*)levels{
    if([news.refer isKindOfClass:[SWFNews class]]){
        [levels addObject:news.refer];
        levels = [self flattenReferedNews:news.refer levels:levels];
    }
    return levels;
}

+ (NSString*)generateForPostPage : (SWFPost*) post{
    [self readyForTemplate];
    NSMutableString *html = [NSMutableString stringWithString:postPageTemplate];
    [html replaceOccurrencesOfString:@"$(LIST)" withString:[self generateForPost:post] options:0 range:NSMakeRange(0, [html length])];
    return html;

}

+ (NSString*)hideHideTags : (NSString*) str{
    NSMutableString *rstr = [[NSMutableString alloc] initWithString:str];
    [rstr replaceOccurrencesOfString:@"$(hidden)" withString:@"hide" options:0 range:NSMakeRange(0, [rstr length])];
    return rstr;
}

+ (NSString*)generateForPost : (SWFPost*) post{
    [self readyForTemplate];
    NSString *title = [self getPostTitle:post];
    NSString *content = post.content;
    NSString *subpost = @"";
    if ([title length]==0 && [post.content length]>0) {
        title = post.content;
    }
    if ([title isEqualToString:content]){
        content = nil;
    }
    if([post.reply intValue] > 0){
        NSString *subPostFormat = NSLocalizedString(@"ui.subPosts", @"");
        subpost =  [NSString stringWithFormat:subPostFormat,[post.reply intValue]];
    }
    NSMutableString *itemHTML = [NSMutableString stringWithString:postItemTemplate];
    NSDictionary *vars = @{
            @"avatar":   [([post.authorUC.avatar absoluteString]?[post.authorUC.avatar absoluteString]:@"default-user.png") urlencode],
            @"author":   [self authorDescription:post.authorUC],
            @"title":    (title?title:@""),
            @"time":     [self timeDescription:post.posttime],
            @"timestamp":[NSString stringWithFormat:@"%f",[post.posttime timeIntervalSince1970]  * 1000],
            @"content":  [self contentFromPost:content news:post.news],
            @"refer":    @"",
            @"id":       post.ID,
            @"subpost":  subpost
    };
    for (NSString *var in vars)
    {
        NSString *value = vars[var];

        [itemHTML replaceOccurrencesOfString:[NSString stringWithFormat:@"$(%@)", [var uppercaseString]]
                                  withString:value
                                     options:0
                                       range:NSMakeRange(0, [itemHTML length])];
    }
    return itemHTML;
}

+ (NSString *)contentFromPost : (NSString*) content news:(SWFNews*)news{
    NSMutableString *r = [NSMutableString stringWithString:@""];
    if([content isKindOfClass:[NSString class]]){
        [r appendString:content];
    }
    if([news isKindOfClass:[SWFNews class]]){
        [r appendString:[self contentFromNews:news]];
        if([news.refer  isKindOfClass:[SWFNews class]]){
            [r appendString:[self generateForNews:news.refer level:0]];
        }
    }
    return r;
}

+ (NSString*)generateForNewsArray:(NSArray*)news{

    if(![news isKindOfClass:[NSArray class]]){
        return [NSString stringWithFormat: @"<div style='text-align:center'>%@</div>",NSLocalizedString(@"err.no-server", @"")];
    }

    [self readyForTemplate];

    NSMutableString *items = [NSMutableString stringWithString:@""];
    for (SWFNews *newsItem in news)
    {
        [items appendString:[self generateForNews:newsItem level:0]];

    }
    NSMutableString *list = [NSMutableString stringWithString:newsListTemplate];
    [list replaceOccurrencesOfString:@"$(LIST)" withString:items options:0 range:NSMakeRange(0, [list length])];
    return list;
}

+ (NSString*)generateForConvPostArray:(NSArray*)posts{
    [self readyForTemplate];
    if(![posts isKindOfClass:[NSArray class]]){
        return [NSString stringWithFormat: @"<div style='text-align:center'>%@</div>",NSLocalizedString(@"err.no-server", @"")];
    }

    [self readyForTemplate];

    NSMutableString *items = [NSMutableString stringWithString:@""];
    for (SWFPost *postItem in [posts reverseObjectEnumerator])
    {
        [items appendString:[self generateForConversationPOST:postItem]];

    }
    NSMutableString *list = [NSMutableString stringWithString:convPageTemplate];
    [list replaceOccurrencesOfString:@"$(LIST)" withString:items options:0 range:NSMakeRange(0, [list length])];
    return list;
}

+ (NSString *)contentFromNews:(SWFNews *)news
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"<div>%@</div>\n", news.content];
    for (SWFMedia *media in news.medias)
    {
        if (media.href == nil || ![[media.href absoluteString] length]) {
            media.href = media.picThumbnail;
        }
        [string appendFormat:@"<div style=\"text-align: center; margin-top: 10px\"><a href=\"%@\"><img src=\"http://imgsvr.shisoft.net/scale?scale=250&retina=true&url=%@\" style=\" max-height: 200px; max-width: 100%% \"/></a></div>\n", [media.href absoluteString], [[media.picThumbnail absoluteString] urlencode]];
    }
    if ([[news.href absoluteString] length])
    {
        [string appendFormat:NSLocalizedString(@"html.accessHref", @""), [news.href absoluteString]];
    }
    if (![news.location isEqual:[NSNull null]]) {
        CLLocationCoordinate2D cl2d = news.location.coordinate;
        if (![news.POI isEqual:[NSNull null]]) {
            [string appendFormat:NSLocalizedString(@"html.lbsPlace", @""), cl2d.latitude, cl2d.longitude, news.POI.name];
        }else{
            [string appendFormat:NSLocalizedString(@"html.lbsCoordinate", @""), cl2d.latitude, cl2d.longitude, cl2d.longitude, cl2d.latitude];
        }
    }else if (![news.POI isEqual:[NSNull null]]){
        [string appendFormat:NSLocalizedString(@"html.lbsPlace", @""), news.POI.location.coordinate.latitude, news.POI.location.coordinate.longitude, news.POI.name];
    }
    if (news.abuse) {
        [string appendFormat:NSLocalizedString(@"ui.abuseTag", @""), news.abuse];
    }
    return string;
}

+ (NSString *)timeDescription:(NSDate*)date
{
    // Set up display time:
    NSTimeInterval timediff = fabs([date timeIntervalSinceNow]);
    if (timediff < 60.0)
    {
        return [NSString stringWithFormat:@"%.0lf %@",
                                          timediff,
                        NSLocalizedString(@"ui.secs-ago",
                                @"secs ago")];
    }
    else if (timediff < 3600.0)
    {
        return [NSString stringWithFormat:@"%.0lf %@",
                                          timediff / 60.0,
                        NSLocalizedString(@"ui.minutes-ago",
                                @"mins ago")];
    }
    else if (timediff < 86400.0)
    {
        return [NSString stringWithFormat:@"%.0lf %@",
                                          timediff / 3600.0,
                        NSLocalizedString(@"ui.hours-ago",
                                @"hrs ago")];
    }
    else if (timediff < 172400.0)
    {
        return NSLocalizedString(@"ui.yesterday",
                @"yesterday");
    }
    else if (timediff < 604800.0)
    {
        return [NSString stringWithFormat:@"%.0lf %@",
                                          timediff / 86400.0,
                        NSLocalizedString(@"ui.days-ago",
                                @"days ago")];;
    }
    else if (timediff < 2592000.0)
    {
        return [NSString stringWithFormat:@"%.0lf %@",
                                          timediff / 604800.0,
                        NSLocalizedString(@"ui.weeks-ago",
                                @"days ago")];
    }else if (timediff < 29030400.0){
        return [NSString stringWithFormat:@"%.0lf %@",
                                          timediff / 2419200.0,
                        NSLocalizedString(@"ui.month-ago",
                                @"month ago")];
    }else if (timediff < 2903040000.0){
        return [NSString stringWithFormat:@"%.0lf %@",
                                          timediff / 29030400.0,
                        NSLocalizedString(@"ui.years-ago",
                                @"years ago")];
    }else if (timediff < 58060800000.0){
        return [NSString stringWithFormat:@"%.0lf %@",
                                          timediff / 2903040000.0,
                        NSLocalizedString(@"ui.centries-ago",
                                @"centries ago")];
    }

    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        return [formatter stringFromDate:date];
    }
}

+ (NSString *)authorDescription:(SWFUniversalContact*)authorUC
{
    // Set up author name:
    if ([authorUC.dispName length] &&
            [authorUC.scrName length] &&
            ![authorUC.dispName isEqualToString:authorUC.scrName])
    {
        return [NSString stringWithFormat:@"%@ (%@)",
                                          authorUC.dispName,
                                          authorUC.scrName];
    }
    else if ([authorUC.dispName length])
    {
        return authorUC.dispName;
    }
    else if ([authorUC.scrName length])
    {
        return authorUC.scrName;
    }
    else
    {
        return NSLocalizedString(@"ui.no-name",
                @"Unnamed");
    }
}

+ (NSString *)titleDescription:(NSString *)title
{
    // Set up title
    @try {
        if ([title length]) {
            return title;
        }
    }
    @catch (NSException *exception) {

    }
    @finally {

    }
    return NSLocalizedString(@"ui.no-title",
            @"Untitled");
}

+ (NSString *) getPostTitle : (SWFPost*) post{
    if ([post.news isKindOfClass:[SWFNews class]]){
        if ([post.news.title isKindOfClass:[NSString class]] ? [post.news.title length] : NO){
            return post.news.title;
        }else if ([post.news.content isKindOfClass:[NSString class]] ? [post.news.content length] : NO){
            return post.news.content;
        }
    }else{
        if ([post.title isKindOfClass:[NSString class]] ? [post.title length] : NO){
            return post.title;
        }else if ([post.content isKindOfClass:[NSString class]] ? [post.content length] : NO){
            return post.content;
        }
    }
    return NSLocalizedString(@"ui.no-title", @"");
}

@end
