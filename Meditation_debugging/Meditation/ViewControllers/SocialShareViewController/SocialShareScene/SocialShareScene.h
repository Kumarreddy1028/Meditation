//
//  SocialShareScene.h
//  SpriteKitDemo
//
//  Created by Jitender Kumar on 20/04/16.
//  Copyright © 2016 Jitender Kumar. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
static const uint8_t socialWallCategory = 1;

@protocol SocialShareActionDelegate <NSObject>

- (void)actionOnNode:(NSString *)nodeName;

@end

@interface SocialShareScene : SKScene<SKPhysicsContactDelegate>

@property (weak, nonatomic) id <SocialShareActionDelegate>delegate;

@end
