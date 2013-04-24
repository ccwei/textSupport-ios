//
//  HeartView.m
//  TextSupport
//
//  Created by Chih-Chiang Wei on 4/18/13.
//
//

#import "SaturationView.h"

@implementation SaturationView

-(void)setSaturation:(float)saturation
{
    _saturation = saturation;
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor]; // else background is black
        self.saturation = 1;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height); // flip image right side up
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, rect, self.image.CGImage);
    CGContextSetBlendMode(context, kCGBlendModeSaturation);
    CGContextClipToMask(context, self.bounds, self.image.CGImage); // restricts drawing to within alpha channel
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1 - self.saturation);
    CGContextFillRect(context, rect);
    
    CGContextRestoreGState(context); // restore state to reset blend mode

}


@end
