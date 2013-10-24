//
//  SpeakerController.m
//  peak
//
//  Created by Hugh Boylan on 8/22/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "SpeakerController.h"
#import "AppDelegate.h"
#import "MediaCell.h"

@implementation SpeakerController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [APIManager mappedRequest:@"/audio" withCallback:^(BOOL success, RKMappingResult *res){
            _zones = [res array];
            [self.tableView reloadData];
        } andIndeterminateHUDInView:nil];
        _openZones = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AppDelegate stylePrimaryTableView:self.tableView];
    [self setTitle:@"Speakers"];
    
    self.navigationItem.leftBarButtonItem = [CustomBarBtn create];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"XBMC" style:UIBarButtonItemStylePlain target:self action:@selector(showUsage)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_zones count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MediaCell"];
    if(cell == nil) cell = [[MediaCell alloc] init];
    [cell setAudio:[_zones objectAtIndex:indexPath.section] andOpen:[_openZones containsObject:@(indexPath.section)]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_openZones containsObject:@(indexPath.section)]? 80+44:44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaCell *cell = (MediaCell*)[tableView cellForRowAtIndexPath:indexPath];
    if([_openZones containsObject:@(indexPath.section)]){//close
        [cell toggle:NO animated:YES];
        [_openZones removeObject:@(indexPath.section)];
    }else{ //open
        [cell toggle:YES animated:YES];
        [_openZones addObject:@(indexPath.section)];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}

@end
