//
//  MediaController.m
//  peak
//
//  Created by Hugh Boylan on 8/28/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "MediaController.h"
#import "AppDelegate.h"

@interface MediaController ()

@end

@implementation MediaController

#pragma mark - MediaController view
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //use for titleview height
    _barHeight = self.navigationController.navigationBar.frame.size.height+20;
    
    //Load view
    [AppDelegate stylePrimaryTableView:self.tableView];
    self.navigationItem.leftBarButtonItem = [CustomBarBtn create];
    self.title = @"Media Remote";
    
    //Progress header view
    _progHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    _progHeader.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //Progress View
    _art = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _art.backgroundColor = [UIColor secondaryBackground];
    _art.image = [UIImage imageNamed:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) isTablet]? @"empty-album@2x.png":@"empty-album.png"];
    
    float tile = _art.frame.size.width;
    float viewWidth = [[UIScreen mainScreen] bounds].size.width;
    _controlView = [[UIView alloc] initWithFrame:CGRectMake(tile, 0, viewWidth-tile, tile)];
    _controlView.backgroundColor = [UIColor clearColor];
    _controlView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _controlView.layer.anchorPoint = CGPointMake(viewWidth, 0);
    
    UIButton *prev = [[UIButton alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
    prev.backgroundColor = [UIColor clearColor];
    prev.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [prev setTitle:@"prev" forState:UIControlStateNormal];
    [prev setImage:[UIImage imageNamed:@"prev.png"] forState:UIControlStateNormal];
    [prev addTarget:self action:@selector(previousInPlaylist) forControlEvents:UIControlEventTouchUpInside];
    
    _play = [[UIButton alloc] initWithFrame:CGRectMake(75, 5, 30, 30)];
    _play.backgroundColor = [UIColor clearColor];
    _play.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [_play setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [_play addTarget:self action:@selector(togglePausePlay) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *next = [[UIButton alloc] initWithFrame:CGRectMake(120, 5, 30, 30)];
    next.backgroundColor = [UIColor clearColor];
    next.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [next setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [next addTarget:self action:@selector(nextInPlaylist) forControlEvents:UIControlEventTouchUpInside];
    
    FUIButton *controls = [[FUIButton alloc] initWithFrame:CGRectMake(165, 5, 30, 30)];
    controls.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    controls.buttonColor = [UIColor clearColor];
    controls.shadowHeight = 0;
    controls.cornerRadius = 0;
    controls.titleLabel.font = [UIFont fontWithName:@"linecons" size:22];
    controls.titleLabel.textAlignment = NSTextAlignmentCenter;
    [controls setTitleColor:[UIColor asbestosColor] forState:UIControlStateNormal];
    [controls setTitleColor:[UIColor asbestosColor] forState:UIControlStateHighlighted];
    [controls setTitle:@"" forState:UIControlStateNormal];
    [controls addTarget:self action:@selector(showControls) forControlEvents:UIControlEventTouchUpInside];
    
    _current = [[UILabel alloc] initWithFrame:CGRectMake(2, 58, 30, 60)];
    _current.backgroundColor = [UIColor clearColor];
    _current.font = [UIFont flatFontOfSize:12];
    _current.textAlignment = NSTextAlignmentCenter;
    _current.textColor = [UIColor asbestosColor];
    
    _duration = [[UILabel alloc] initWithFrame:CGRectMake(175, 58, 30, 60)];
    _duration.backgroundColor = [UIColor clearColor];
    _duration.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _duration.font = [UIFont flatFontOfSize:12];
    _duration.textAlignment = NSTextAlignmentCenter;
    _duration.textColor = [UIColor asbestosColor];
    
    _progress = [[UISlider alloc] initWithFrame:CGRectMake(5, 35, self.view.frame.size.width-90, 40)];
    _progress.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _progress.minimumValue = 0;
    [_progress addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    [_progress addTarget:self action:@selector(sliderFinished) forControlEvents:UIControlEventTouchUpInside];
    [_progress configureFlatSliderWithTrackColor:[UIColor concreteColor] progressColor:[UIColor pumpkinColor] thumbColor:[UIColor whiteColor]];
    
    _filterBar = [[FUISegmentedControl alloc] initWithItems:@[@"Music", @"Movies", @"Shows"]];
    _filterBar.selectedFont = [UIFont boldFlatFontOfSize:16];
    _filterBar.selectedFontColor = [UIColor primaryBackground];
    _filterBar.selectedColor = [UIColor pumpkinColor];
    _filterBar.deselectedFont = [UIFont flatFontOfSize:16];
    _filterBar.deselectedFontColor = [UIColor primaryBackground];
    _filterBar.deselectedColor = [UIColor concreteColor];
    _filterBar.dividerColor = [UIColor primaryBackground];
    _filterBar.cornerRadius = 0;
    _filterBar.selectedSegmentIndex = 0;
    _filterBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    _filterBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_filterBar addTarget:self action:@selector(filter) forControlEvents:UIControlEventValueChanged];
    
    [_controlView addSubview:prev];
    [_controlView addSubview:_play];
    [_controlView addSubview:next];
    [_controlView addSubview:controls];
    [_controlView addSubview:_current];
    [_controlView addSubview:_progress];
    [_controlView addSubview:_duration];
    [_progHeader addSubview:_art];
    [_progHeader addSubview:_controlView];
    self.tableView.tableHeaderView = _progHeader;
    
    
    //Contact XBMC
    [APIManager mappedRequest:@"/xbmc/songs" withCallback:^(BOOL success, RKMappingResult *res){
        if(!success) return;
        _songs = [res array];
        [self.tableView reloadData];
        [self getPlayerState];
    } andIndeterminateHUDInView:self.tableView];
}

- (void)getPlayerState
{
    //Check if something is playing
    [APIManager mappedRequest:@"/xbmc" withCallback:^(BOOL success, RKMappingResult *res){
        if([[res firstObject] isKindOfClass:[RKPlayer class]])
        {
            _player = [res firstObject];
            [self reloadPlaylist];
        }
        else //Nothing playing
        {
            _player = nil;
            _nowPlayingSong = nil;
            _nowPlayingVideo = nil;
            [self slowerNotifications];
            [self updateProgressView];
            [self emptyPlaylistView];
        }
    } andIndeterminateHUDInView:nil];
}

//- (RKSong*)songFromPlaylist:(id)source
//{
//    NSError *err = [[NSError alloc] init];
//    RKSong *dest = [RKSong new];
//    RKMappingOperation *op = [[RKMappingOperation alloc] initWithSourceObject:source destinationObject:dest mapping:[RKSong mappingFromPlaylist:YES]];
//    [op performMapping:&err];
//    return dest;
//}

- (void)reloadPlaylist
{
    int list = _player.playlistid.intValue;
    [APIManager mappedRequest:[NSString stringWithFormat:@"/xbmc/playlist/%i", list] withCallback:^(BOOL success, RKMappingResult *res)
    {
        BOOL createNew = _player.playlist == nil;
        _player.isSong = list == 0;
        _player.playlist = [NSMutableArray arrayWithArray:[res array]];
        if(_player.isSong)  _nowPlayingSong  = [_player.playlist objectAtIndex:_player.position.intValue];
        else                _nowPlayingVideo = [_player.playlist objectAtIndex:_player.position.intValue];
        [self updateProgressView];
        if(createNew) [self loadPlaylistView];
        else [((PlaylistController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).deckController.rightController) update:_player];
    } andIndeterminateHUDInView:nil];
}

- (void)loadPlaylistView
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    CGFloat ledge = [app isTablet]? IPAD_LEDGE:IPHONE_LEDGE;
    frame.origin.x = ledge-5;
    frame.size.width = frame.size.width-ledge;
    app.deckController.rightController = [[PlaylistController alloc] initWithPlayer:_player];
    app.deckController.rightController.view.frame = frame;
    
    //add toggle show playlist btn
    UIBarButtonItem *listBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:app.deckController action:@selector(toggleRightView)];
    [listBtn setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"linecons" size:22]} forState:UIControlStateNormal];
    [listBtn configureFlatButtonWithColor:[UIColor clearColor] highlightedColor:[UIColor clearColor] cornerRadius:0];
    [listBtn setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = listBtn;
}

- (void)emptyPlaylistView
{
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).deckController.rightController = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)slowerNotifications
{
    //dial back notification period
}

- (void)frequentNotifications
{
    
}

- (void)filter
{
    NSLog(@"filter");
//    if(_filterBar.selectedSegmentIndex == 0)
//    songs
//    else if(_filterBar.selectedSegmentIndex == 1)
//    artists
//    else
//    albums
    
}


#pragma mark - Player methods
- (void)playSong:(RKSong*)song
{
    //play next
    [APIManager getRequest:[NSString stringWithFormat:@"/xbmc/play/0/%i", song.songid.intValue] withParams:@{} andCallback:^(BOOL success, NSDictionary *res){
        [self getPlayerState];
    } andIndeterminateHUDInView:self.tableView];
}

- (void)enqueueSong:(RKSong*)song next:(BOOL)next
{
    [APIManager getRequest:[NSString stringWithFormat:@"/xbmc/insert/%i/%@/%i", _player.playlistid.intValue, next?@"next":@"last", song.songid.intValue] withParams:@{} andCallback:^(BOOL success, NSDictionary *res){
        [self getPlayerState];
    } andIndeterminateHUDInView:nil];
}

- (void)nextInPlaylist
{
    [APIManager postRequest:@"/xbmc" withParams:@{@"control":@"next"} andCallback:^(BOOL success, NSDictionary *res){
        [self getPlayerState];
    } andIndeterminateHUDInView:nil];
}

- (void)previousInPlaylist
{
    [APIManager postRequest:@"/xbmc" withParams:@{@"control":@"previous"} andCallback:^(BOOL success, NSDictionary *res){
        [self getPlayerState];
    } andIndeterminateHUDInView:nil];
}


- (void)togglePausePlay
{
    [APIManager postRequest:@"/xbmc" withParams:@{@"control":@"toggle"} andCallback:^(BOOL success, NSDictionary *res){
        [self getPlayerState];
    } andIndeterminateHUDInView:nil];
}

- (void)stop
{
    [APIManager postRequest:@"/xbmc" withParams:@{@"control":@"stop"} andCallback:^(BOOL success, NSDictionary *json){
        _nowPlayingSong = nil;
        _nowPlayingVideo = nil;
        [self getPlayerState];
    } andIndeterminateHUDInView:nil];
}

- (void)sliderChanged
{
    _current.text = [MediaController durationString:_player.progress.intValue];
    _duration.text = [MediaController durationString:_player.isSong? _nowPlayingSong.duration.intValue:_nowPlayingVideo.duration.intValue];
}

- (void)sliderFinished
{
    //update progress
}

- (void)showControls
{
    MediaRemoteController *controller = [[MediaRemoteController alloc] init];
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:controller animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }];
}

- (void)hideRemoteController:(MediaRemoteController *)controller
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) reloadCenter];
    }];
}

#pragma mark - NowPlaying header
- (void)updateProgressView
{
    [self updateNowPlayingTitle];
    _art.image = [UIImage imageNamed:[((AppDelegate*)[[UIApplication sharedApplication] delegate]) isTablet]? @"empty-album@2x.png":@"empty-album.png"];
    
    if(_nowPlayingSong == nil && _nowPlayingVideo == nil){
        _current.text = @"";
        _progress.value = 0;
        _duration.text = @"";
    }else{
        NSString *thumb;
        int duration;
        if(_nowPlayingSong != nil){
            thumb = _nowPlayingSong.thumbnail;
            duration = _nowPlayingSong.duration.intValue;
        }else if(_nowPlayingVideo != nil){
            thumb = _nowPlayingVideo.thumbnail;
            duration = _nowPlayingVideo.duration.intValue;
        }
        if(_progress.maximumValue > 0) _progress.maximumValue = duration;
        if(![thumb isEqualToString:@""] && ![thumb isEqualToString:@"image://DefaultAlbumCover.png/"])
        {
            //xbmc web hosted imgs
            NSString * urlToGrab = [[NSString stringWithFormat:@"http://192.168.1.116:8080/image/%@", thumb]
                                     stringByReplacingOccurrencesOfString:@"%2" withString:@"%252"];
            _art.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlToGrab]]];
        }
        _current.text = [MediaController durationString:_player.progress.intValue];
        _duration.text = [MediaController durationString:duration];
        [_progress setValue:_player.progress.floatValue animated:YES];
        [_play setImage:[UIImage imageNamed:_playing? @"pause.png":@"play.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - NowPlaying title
- (void)updateNowPlayingTitle
{
    if(_nowPlayingSong == nil && _nowPlayingVideo == nil) //Reset title
    {
        if(_titleHeader == nil) self.navigationItem.titleView = _navTitle;
        else _titleHeader = nil;
    }
    else if(_titleHeader == nil) //Initialize PlayerTitleView
    {
        _titleHeader = [[PlayerTitleView alloc] initWithWidth:self.view.frame.size.width-100];
        if(_player.isSong)
            [_titleHeader reloadWithSong:_nowPlayingSong];
        else
            [_titleHeader reloadWithVideo:_nowPlayingVideo];
        _navTitle = (UILabel*)self.navigationItem.titleView;
        self.navigationItem.titleView = _titleHeader;
    }
    else if(_player.isSong) //Reload song info and orientation layout
        [_titleHeader reloadWithSong:_nowPlayingSong];
    else
        [_titleHeader reloadWithVideo:_nowPlayingVideo];
}

#pragma mark - ActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 2) //Play
        [self playSong:_queueingSong];
    else if(buttonIndex == 1) //Queue Last
        [self enqueueSong:_queueingSong next:NO];
    else if(buttonIndex == 0) //Queue Next
        [self enqueueSong:_queueingSong next:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RKSong *song = [_songs objectAtIndex:indexPath.row];
    NSString *reuse = @"MediaControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        //Label
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont flatFontOfSize:16];
        cell.textLabel.textColor = [UIColor asbestosColor];
        //Artist
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.font = [UIFont flatFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor asbestosColor];
    }
    cell.textLabel.text = song.label;
    cell.detailTextLabel.text = [song.artist firstObject];
    
    //Duration
    UILabel *duration = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    duration.backgroundColor = [UIColor clearColor];
    duration.font = [UIFont boldFlatFontOfSize:12];
    duration.textColor = [UIColor asbestosColor];
    duration.text = [MediaController durationString:_player.isSong? _nowPlayingSong.duration.intValue:_nowPlayingVideo.duration.intValue];
    cell.accessoryView = duration;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    _queueingSong = [_songs objectAtIndex:indexPath.row];
    
    NSString *title = [_queueingSong.label stringByAppendingString:[NSString stringWithFormat:@"\n%@", [_queueingSong.artist firstObject]]];
    title = [title stringByAppendingString:[NSString stringWithFormat:@"\n%@", _queueingSong.album]];
    [[[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Queue Next", @"Queue Last", @"Play", nil] showInView:self.view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section? 0:_filterBar.frame.size.height;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return section? nil:_filterBar;
}

#pragma mark - UIScroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.y+scrollView.contentInset.top;
    if(offset > 80 && _fullscreen) //close header
    {
        self.tableView.contentInset = UIEdgeInsetsMake(_barHeight, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, 0);
        _art.frame = CGRectMake(0, 0, 80, 80);
        _fullscreen = NO;
    }
    else [self controlViewWithOffset:offset]; //scroll header
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if((scrollView.contentOffset.y+scrollView.contentInset.top)*(-1) > 80 && !_fullscreen) //open header
    {
        [UIView animateWithDuration:0.2 animations:^{
            CGSize size = [[UIScreen mainScreen] bounds].size;
            self.tableView.contentInset = UIEdgeInsetsMake(size.width-80+_barHeight, 0, 0, 0);
            self.tableView.contentOffset = CGPointMake(0, size.width-80+_barHeight);
            _art.frame = CGRectMake(0, 0, size.width, size.width);
        } completion:^(BOOL success){ _fullscreen = success; }];
    }
}

- (void)controlViewWithOffset:(float)offset
{
    CGRect artFrame = _art.frame;
    CGRect ctlFrame = _controlView.frame;
    float artMax = [[UIScreen mainScreen] bounds].size.width;
    float ctlMax = artMax-80;
    
    if(_fullscreen) offset = artMax*(-1);
    if(offset > 0)
    {
        artFrame.origin.y = 0;
        ctlFrame.size.width = ctlMax;
        ctlFrame.origin.x = 80;
        _controlView.backgroundColor = [UIColor clearColor];
    }
    else
    {
        float width = _fullscreen? artMax:80-offset;
        float artY = _fullscreen? (-1)*(artMax-80):offset;
        float ctlOffset = (artMax-offset)/(artMax/80)-80;
        artFrame = CGRectMake(0, artY, width, width);
        ctlFrame = CGRectMake(80-ctlOffset, 0, ctlMax+ctlOffset, 80);
        _controlView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:ctlOffset/120.0];
    }
    _art.frame = artFrame;
    _controlView.frame = ctlFrame;
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[hud removeFromSuperview];
	hud = nil;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    _barHeight = self.navigationController.navigationBar.frame.size.height+20;
    [self updateNowPlayingTitle];
}

+ (NSString*)durationString:(int)duration
{
    int hrs = 0;
    int mins = 0;
    int secs = duration;
    
    while(secs >= 3600){
        hrs = hrs + 1; secs = secs - 3600;
    }
    while(secs >= 60){
        mins = mins + 1; secs = secs - 60;
    }
    
    if(hrs){
        NSString *m = mins < 10? [NSString stringWithFormat:@":0%i", mins]:[NSString stringWithFormat:@":%i", mins];
        NSString *s = secs < 10? [NSString stringWithFormat:@":0%i", secs]:[NSString stringWithFormat:@":%i", secs];
        return [[[NSString stringWithFormat:@"%i", hrs] stringByAppendingString:m] stringByAppendingString:s];
    }
    NSString *s = secs < 10? [NSString stringWithFormat:@":0%i", secs]:[NSString stringWithFormat:@":%i", secs];
    return [[NSString stringWithFormat:@"%i", mins] stringByAppendingString:s];
}

@end
