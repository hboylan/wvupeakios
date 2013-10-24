//
//  SelectedCell.m
//  peak
//
//  Created by Hugh Boylan on 8/23/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "SelectedCell.h"

@implementation SelectedCell

+ (SelectedCell*)cellWithIndexPath:(NSIndexPath*)indexPath
{
    SelectedCell *cell = [[SelectedCell alloc] init];
    cell.section = indexPath.section;
    cell.row = indexPath.row;
    return cell;
}

+ (int)cellOpen:(NSArray *)list atIndexPath:(NSIndexPath *)indexPath
{
    for(int i=0; i<list.count; i++){
        SelectedCell *index = [list objectAtIndex:i];
        if(indexPath.section == index.section && indexPath.row == index.row)
            return i;
    }
    return -1;
}

@end
