//
//  MediaController.h
//  peak
//
//  Created by Hugh Boylan on 8/28/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit/FUISegmentedControl.h"
#import "PlayerTitleView.h"
#import "PlaylistController.h"
#import "MediaRemoteController.h"
#import "MBProgressHUD.h"

@interface MediaController : UITableViewController <MBProgressHUDDelegate, RemoteControllerDelegate, UIActionSheetDelegate>
{
    PlaylistController *_playlistController;
    RKSong *_queueingSong;
    NSArray *_songs;
    NSDictionary *_dictItems;
    BOOL _playing;
    BOOL _fullscreen;
    float _barHeight;
    
    UILabel *_navTitle;
    PlayerTitleView *_titleHeader;
    UIView *_progHeader;
    UIView *_controlView;
    UIImageView *_art;
    UIButton *_play;
    UISlider *_progress;
    UILabel *_current;
    UILabel *_duration;
    FUISegmentedControl *_filterBar;
}
@property (strong, nonatomic) RKPlayer *player;
@property (strong, nonatomic) RKSong *nowPlayingSong;
@property (strong, nonatomic) RKVideo *nowPlayingVideo;
- (void)updateProgressView;
+ (NSString*)durationString:(int)duration;

@end
