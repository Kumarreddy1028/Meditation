//
//  GameScene.h
//  SpriteKitDemo
//

//  Copyright (c) 2016 Jitender Kumar. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
static const uint8_t ballCategory = 1;
static const uint8_t wallCategory = 1;

@protocol DashBoardActionDelegate <NSObject>

- (void)actionOnNode:(NSString *)nodeName;
-(BOOL) checkforinfoview :(UITouch *) touch;
@end
@interface GameScene : SKScene<SKPhysicsContactDelegate>
@property (weak, nonatomic) id <DashBoardActionDelegate>delegate;
-(void)timeUpdate;
@end
