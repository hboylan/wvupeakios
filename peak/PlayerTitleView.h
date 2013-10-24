//
//  PlayerTitleView.h
//  WVUpeak
//
//  Created by Hugh Boylan on 9/13/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKSong.h"
#import "RKVideo.h"

@interface PlayerTitleView : UIView {
    UILabel *_song;
    UILabel *_artist;
    UILabel *_album;
}
- (id)initWithWidth:(CGFloat)width;
- (void)reloadWithSong:(RKSong*)song;
- (void)reloadWithVideo:(RKVideo*)video;
@end
