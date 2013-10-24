//
//  GraphPlotter.m
//  WVUpeak
//
//  Created by Hugh Boylan on 10/1/13.
//  Copyright (c) 2013 wvu. All rights reserved.
//

#import "GraphPlotter.h"
#import "FlatUIKit/UIColor+FlatUI.h"
#import "FlatUIKit/UIFont+FlatUI.h"

@implementation GraphPlotter

#pragma mark - Chart behavior
-(id)initPlotWithFrame:(CGRect)frame
{
    self = [GraphPlotter new];
    
	self.hostView = [[CPTGraphHostingView alloc] initWithFrame:frame];
    self.hostView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self configureGraph];
    
    return self;
}


- (void)setData:(NSArray*)data withAction:(NSString *)action andRefresh:(BOOL)refresh
{
    _yStep = [action isEqualToString:@"weight"]? 40.0f:0.5f;
    BOOL isSleep = [action isEqualToString:@"sleep"];
    
    _values = [[NSMutableArray alloc] init];
    _labels = [[NSMutableArray alloc] init];
    _yMax = 0;
    for(NSDictionary *next in data)
    {
        NSString *date = [next valueForKey:@"dateTime"];
        float val = [[next valueForKey:@"value"] floatValue];
        
        //convert sleep minutes->hours
        if(isSleep) val = val/60;
        
        //maintain maximum
        if(_yMax < val) _yMax = val;
        
        [_labels addObject:date];
        [_values addObject:@{@"X_VAL":date, @"Y_VAL":[NSNumber numberWithFloat:val]}];
    }
    _yMax = _yMax + _yStep;
    
    [self configurePlots];
    [self configureAxes];
    if(refresh) [self.hostView.hostedGraph reloadData];
}

-(void)configureGraph
{
	// Create the graph
	CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
	[graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    graph.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
    graph.plotAreaFrame.borderLineStyle = nil;
	self.hostView.hostedGraph = graph;
    
    graph.paddingLeft = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingBottom = 0.0f;
    
	// Set padding for plot area
	[graph.plotAreaFrame setPaddingLeft:30.0f];
	[graph.plotAreaFrame setPaddingRight:5.0f];
	[graph.plotAreaFrame setPaddingTop:10.0f];
	[graph.plotAreaFrame setPaddingBottom:30.0f];
    
	// Enable user interactions for plot space
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
	plotSpace.allowsUserInteraction = NO;
}

-(void)configurePlots
{
	// Get graph and plot space
	CPTGraph *graph = self.hostView.hostedGraph;
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0f) length:CPTDecimalFromInt(_values.count+2)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0f) length:CPTDecimalFromInt(_yMax)];
    
	// Create the plot
	CPTBarPlot *plot = [[CPTBarPlot alloc] init];
    plot.fill = [CPTFill fillWithColor:(CPTColor*)[UIColor pumpkinColor]];
    plot.lineStyle = nil;
	plot.dataSource = self;
    plot.plotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(1.0f) length:CPTDecimalFromInt(_values.count)];
    plot.barOffset = CPTDecimalFromFloat(0.0f);
    plot.baseValue = CPTDecimalFromString(@"0");
    plot.barWidth = CPTDecimalFromFloat(1.0f);
    plot.cornerRadius = 0.0f;
	[graph addPlot:plot];
}

-(void)configureAxes
{
    CPTTextStyle *defaultTextStyle = [CPTTextStyle textStyleWithAttributes:@{NSForegroundColorAttributeName:[UIColor asbestosColor], NSFontAttributeName:[UIFont flatFontOfSize:8]}];
    CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
    lineStyle.lineColor = (CPTColor*)[UIColor concreteColor];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.hostView.hostedGraph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.axisLineStyle = lineStyle;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPTDecimalFromString(@"1");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    x.labelTextStyle = defaultTextStyle;
    x.labelRotation = M_PI/4;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    NSArray *ticks = @[[NSDecimalNumber numberWithFloat:0.9f], [NSDecimalNumber numberWithFloat:2.0f], [NSDecimalNumber numberWithFloat:3.2f], [NSDecimalNumber numberWithFloat:4.4f], [NSDecimalNumber numberWithFloat:5.6f], [NSDecimalNumber numberWithFloat:6.7f], [NSDecimalNumber numberWithFloat:7.9f]];
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[_labels count]];
    for(int i = 0; i < _values.count; i++)
    {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[_labels objectAtIndex:i] textStyle:x.labelTextStyle];
        newLabel.tickLocation = [[ticks objectAtIndex:i] decimalValue];
        newLabel.offset = 4.0f;
        newLabel.rotation = -M_PI/_values.count;
        [customLabels addObject:newLabel];
    }
    x.axisLabels =  [NSSet setWithArray:customLabels];
    
    CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle = lineStyle;
    y.majorTickLineStyle = lineStyle;
    y.minorTickLineStyle = lineStyle;
    y.majorIntervalLength = CPTDecimalFromFloat(_yStep);
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
    y.labelTextStyle = defaultTextStyle;
    
    //horizontal lines (not working)
//    NSMutableArray *yTicks = [[NSMutableArray alloc] init];
//    for (int i=0; i<=_yMax; i=i+_yStep) [yTicks addObject:[NSDecimalNumber numberWithInt:i]];
//    y.majorTickLocations = [NSSet setWithArray:yTicks];
//    y.title = @"Work Status";
//    y.titleOffset = 40.0f;
//    y.titleLocation = CPTDecimalFromFloat(150.0f);
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return _values.count;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSDictionary *sample = [_values objectAtIndex:index];
    if (fieldEnum == CPTScatterPlotFieldX)
        return [NSNumber numberWithInteger:index];
    else
        return [sample valueForKey:@"Y_VAL"];
}
@end
