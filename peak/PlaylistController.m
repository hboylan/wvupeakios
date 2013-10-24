//
//  PlaylistController.m
//  WVUpeak
//
//  Created by Hugh Boylan on 9/13/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "PlaylistController.h"
#import "AppDelegate.h"
#import "MediaController.h"

@interface PlaylistController ()

@end

@implementation PlaylistController

- (id)initWithPlayer:(RKPlayer *)player
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _player = player;
        _selected = [[SelectedCell alloc] init];
        _selected.row = player.position.intValue;
    }
    return self;
}

- (void)update:(RKPlayer *)player
{
    NSLog(@"update playlist");
    _player = player;
    _selected.row = player.position.intValue;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate styleSecondaryTableView:self.tableView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.5;
    [self.tableView addGestureRecognizer:longPress];
}

- (void)handleLongPress:(UIGestureRecognizer*)recognizer
{
    if(recognizer.state == UIGestureRecognizerStateBegan) [self setEditing:!self.editing animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [AppDelegate secondaryHeaderSection:section setLabel:^NSString* {
        return @"Now Playing";
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [AppDelegate secondaryHeaderHeight:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _player.playlist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaylistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){ //create new
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [AppDelegate selectedCellBackground];
        cell.textLabel.font = [UIFont flatFontOfSize:12];
    }
    //refresh data
    cell.textLabel.text = [[_player.playlist objectAtIndex:indexPath.row] valueForKey:@"label"];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *dur = (UILabel*)cell.accessoryView;
    if(indexPath.row == _selected.row){
        cell.textLabel.textColor = [UIColor whiteColor];
        dur.textColor = [UIColor whiteColor];
        cell.selected = YES;
    }else{
        cell.textLabel.textColor = [UIColor secondaryBackground];
        dur.textColor = [UIColor asbestosColor];
        cell.selected = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selected.row = indexPath.row;
    
    //play song, close viewdeck, reloadData
    [APIManager getRequest:[NSString stringWithFormat:@"/xbmc/playlist/%i/%i", _player.playlistid.intValue, indexPath.row] withParams:@{} andCallback:^(BOOL success, NSDictionary *json){
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app.deckController closeRightViewAnimated:YES completion:^(IIViewDeckController *deck, BOOL success){}];
    } andIndeterminateHUDInView:nil];
}

#pragma mark - TableView edit mode
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return indexPath.row != _player.position.intValue;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete && _player.position.intValue != indexPath.row)
        [APIManager getRequest:[NSString stringWithFormat:@"/xbmc/remove/0/%i", indexPath.row] withParams:@{} andCallback:^(BOOL success, NSDictionary *res){
            [_player.playlist removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } andIndeterminateHUDInView:nil];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [APIManager getRequest:[NSString stringWithFormat:@"/xbmc/swap/%i/%i/%i", _player.playlistid.intValue, fromIndexPath.row, toIndexPath.row] withParams:@{} andCallback:^(BOOL success, NSDictionary *res){
        [_player.playlist exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    } andIndeterminateHUDInView:nil];
}

@end
