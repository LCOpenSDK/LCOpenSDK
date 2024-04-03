//
//  LCVisualTalkPreviewView.h
//  LCNewLivePreviewModule
//
//  Created by dahua on 2024/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LCVisualTalkPreviewView : UIView
@property (nonatomic,strong) CALayer *previewLayer;

-(void) addPreviewLayer: (CALayer *)previewLayer;

@end

NS_ASSUME_NONNULL_END
