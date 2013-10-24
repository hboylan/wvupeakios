//
//  PlayerTitleView.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/13/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "PlayerTitleView.h"
#import "UIFont+FlatUI.h"

@implementation PlayerTitleView

- (id)initWithWidth:(CGFloat)width
{
    self = [super initWithFrame:CGRectMake(50, 0, width, 44)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        BOOL landscape = UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
        CGFloat height = 44/3;
        CGFloat top = landscape? 5:0;
        
        _song = [[UILabel alloc] initWithFrame:CGRectMake(0, top, width, height)];
        _song.backgroundColor = [UIColor clearColor];
        _song.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _song.font = [UIFont boldFlatFontOfSize:12];
        _song.textColor = [UIColor whiteColor];
        _song.textAlignment = NSTextAlignmentCenter;
        
        _artist = [[UILabel alloc] initWithFrame:CGRectMake(0, top+height, width, height)];
        _artist.backgroundColor = [UIColor clearColor];
        _artist.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _artist.font = [UIFont flatFontOfSize:12];
        _artist.textColor = [UIColor whiteColor];
        _artist.textAlignment = NSTextAlignmentCenter;
        
        _album = [[UILabel alloc] initWithFrame:CGRectMake(0, height*2, width, height)];
        _album.backgroundColor = [UIColor clearColor];
        _album.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _album.font = [UIFont flatFontOfSize:12];
        _album.textColor = [UIColor whiteColor];
        _album.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_song];
        [self addSubview:_artist];
        if(!landscape) [self addSubview:_album];
    }
    return self;
}

- (void)reloadWithSong:(RKSong*)song
{
    _song.text = song.label;
    _artist.text = [song.artist firstObject];
    _album.text = song.album;
    
    //Only show label and artist in landscape orientation
    BOOL landscape = UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
    CGRect frame = self.frame;
    frame.origin.y = landscape? 2:0;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.frame = frame;
        _album.hidden = landscape;
    } completion:nil];
}

- (void)reloadWithVideo:(RKVideo*)video
{
    _song.text = @"";
    _artist.text = video.label;
    _album.text = @"";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
