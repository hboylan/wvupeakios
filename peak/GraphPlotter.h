//
//  GraphPlotter.h
//  WVUpeak
//
//  Created by Hugh Boylan on 10/1/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CorePlot-CocoaTouch.h>

@interface GraphPlotter : NSObject <CPTPlotDataSource> {
    NSMutableArray *_values;
    NSMutableArray *_labels;
    int _yMax;
    float _yStep;
}
@property (nonatomic, strong) CPTGraphHostingView *hostView;

- (id)initPlotWithFrame:(CGRect)frame;
- (void)setData:(NSArray*)data withAction:(NSString*)action andRefresh:(BOOL)refresh;
@end
