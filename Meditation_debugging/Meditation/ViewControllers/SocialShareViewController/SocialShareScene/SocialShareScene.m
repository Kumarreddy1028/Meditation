//
//  SocialShareScene.m
//  SpriteKitDemo
//
//  Created by Jitender Kumar on 20/04/16.
//  Copyright © 2016 Jitender Kumar. All rights reserved.
//

#import "SocialShareScene.h"
#import <AudioToolbox/AudioServices.h>

@interface SocialShareScene()
@property (nonatomic) SKSpriteNode *node;
@property (nonatomic) SKTextureAtlas *TextureAtlas;

@end

@implementation SocialShareScene
NSMutableArray *skSpriteNodeNameArray;

-(void) willMoveFromView:(SKView *)view
{  [self removeAllActions];
    
    [self removeAllChildren];

}
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
//    SKSpriteNode *backround = [SKSpriteNode spriteNodeWithImageNamed:@"bg"];
//    backround.size = self.size;
//    backround.zPosition = -5;
//    backround.anchorPoint = CGPointMake(0, 0);
//    [self addChild:backround];
  
    [self setBackgroundColor:[UIColor clearColor]];
    self.physicsWorld.gravity = CGVectorMake(0.0f, -0.0f);
    self.physicsWorld.contactDelegate = self;
    
    skSpriteNodeNameArray = [NSMutableArray arrayWithObjects:@"facebook_big",@"twitter_big",@"linkedin_big",@"email_big",@"whatsapp_big", nil];
    
    
    for (int j = 0; j < 4; j++){
        NSString *node_name = [NSString stringWithFormat:@"SKSpriteNode_%d",j];
        SKSpriteNode *node = (SKSpriteNode *)[self childNodeWithName:node_name];
        [self addPhysicsBody:node];
    }
    
    for (int i = 0; i < skSpriteNodeNameArray.count; i++) {
        SKSpriteNode *spriteNode = (SKSpriteNode *)[self childNodeWithName:skSpriteNodeNameArray[i]];
        [self setProperties:spriteNode];
        SKAction *action;
        if ([[[UIDevice currentDevice]systemVersion] integerValue] >= 9.0) {
            action = [SKAction applyImpulse:CGVectorMake(-10, -10) duration:0.00001];
            [spriteNode runAction:[SKAction repeatActionForever:action]];
        }
    }
    
}

- (void)addPhysicsBody:(SKSpriteNode *)node{
    
    [node setColor:[UIColor clearColor]];
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.frame.size];
    //node.physicsBody.categoryBitMask = socialWallCategory;
    node.physicsBody.collisionBitMask = 0;
    node.physicsBody.friction = 0;
    node.physicsBody.affectedByGravity = YES;
    node.physicsBody.dynamic = YES;
    node.physicsBody.allowsRotation = NO;
}

- (void)setProperties:(SKSpriteNode *)node
{
    node.physicsBody.allowsRotation = NO;
    node.physicsBody.friction = 0;
    node.physicsBody.restitution = 1;
    node.physicsBody.linearDamping = -0.2;
    node.physicsBody.angularDamping = 0;
    node.physicsBody.affectedByGravity = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node  = [self nodeAtPoint:location];
    if (node.name) {
//        [self runAction:[SKAction playSoundFileNamed:@"Plop.wav" waitForCompletion:NO]];
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"sound"])
        {
            NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"sound"];
            if ([value isEqualToString:@"on"])
            {
                [self runAction:[SKAction playSoundFileNamed:@"Plop.wav" waitForCompletion:NO]];
            }
        }
        else
        {
            [self runAction:[SKAction playSoundFileNamed:@"Plop.wav" waitForCompletion:NO]];
        }
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"viberate"])
        {
            NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"viberate"];
            if ([value isEqualToString:@"on"])
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
        }
        else
        {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        

        [self.delegate actionOnNode:node.name];
        
    }
}

@end
