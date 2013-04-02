//
//  FaceView.h
//  Happiness
//
//  Created by Chih-Chiang Wei on 3/24/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FaceView;

@protocol FaceViewDataSource
- (float)smileForFaceView:(FaceView *)sender;
@end

@interface FaceView : UIView
- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@property (nonatomic) CGFloat scale;
@property (nonatomic, weak) IBOutlet id <FaceViewDataSource> dataSource;
@end
