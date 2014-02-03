//
//  SWFAvatarHelper.m
//  webfusion
//
//  Created by Jack Shi on 13-7-15.
//  Copyright (c) 2013年 Shisoft Corporation. All rights reserved.
//

#import "SWFAvatarHelper.h"
#import "UIImage+SWFUtilities.h"
#import "NSString+URLEncode.h"

NSMutableDictionary *SWFAvatarQueues;

@implementation SWFAvatarHelper

+(UIImage*) displayAvatar : (NSURL*) avatarURL callback: (void (^)(id))callback{
    return [self displayAvatar:avatarURL callback:callback roundCorner:YES];
}

+(UIImage*) displayAvatar : (NSURL*) avatarURL callback: (void (^)(id))callback roundCorner : (BOOL) roundCorner{
    return [self displayAvatar:avatarURL callback:callback roundCorner:roundCorner size:CGSizeMake(64, 64)];
}

+(UIImage*) displayAvatar : (NSURL*) avatarURL callback: (void (^)(id))callback roundCorner : (BOOL) roundCorner size : (CGSize) size
{
    NSString *imgSvrUrl =[NSString stringWithFormat:@"http://imgsvr.shisoft.net/scale?scale=64&retina=true&url=%@",[[avatarURL absoluteString] urlencode]];
    avatarURL = [[NSURL alloc] initWithString:imgSvrUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:avatarURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    NSURLCache *cache = [NSURLCache sharedURLCache];
    __block NSCachedURLResponse *cachedResponse = [cache cachedResponseForRequest:request];
    if (!cachedResponse){
        dispatch_group_async([SWFAppDelegate getDefaultInstance].SWFBackgroundTasks,SWFDispatchQueueForHost([avatarURL host]),^{
            
            NSURLResponse *response = nil;
            NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                        error:NULL];
            if (data)
            {
                cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response
                                                                          data:data];
                [cache storeCachedResponse:cachedResponse
                                forRequest:request];
            }
        
            dispatch_async(dispatch_get_main_queue(), ^{
                callback([self imageFromCacheResponse:cachedResponse roundCorner:roundCorner size:size]);
            });
        });
    }
    return [self  imageFromCacheResponse:cachedResponse roundCorner:roundCorner size:size];
}

+(UIImage*) imageFromCacheResponse:(NSCachedURLResponse*) cachedResponse  roundCorner : (BOOL) roundCorner size : (CGSize) size{
    UIImage *image = [UIImage imageWithData:[cachedResponse data]];
    if (!image)
    {
        image = [UIImage imageNamed:@"default-user"];
    }
    image = [image scaledImageToSize:size];
    if (roundCorner){
        image = [image roundedImageWithRadius:10];
    }
    return image;
}

dispatch_queue_t SWFDispatchQueueForHost(NSString *host)
{
    if (!host)
        host = @"";
    
    if (!SWFAvatarQueues)
        SWFAvatarQueues = [NSMutableDictionary dictionary];
    
    if (!SWFAvatarQueues[host])
        SWFAvatarQueues[host] = (__bridge id)(dispatch_queue_create([[NSString stringWithFormat:@"net.shisoft.webfusion.avatar.%@",
                                                       host] cStringUsingEncoding:NSUTF8StringEncoding], 0));
    
    return (__bridge dispatch_queue_t)(SWFAvatarQueues[host]);
}

@end
