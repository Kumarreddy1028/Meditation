
//
//  GameScene.m
//  SpriteKitDemo
//
//  Created by Jitender Kumar on 18/03/16.
//  Copyright (c) 2016 Jitender Kumar. All rights reserved.
//

#import "GameScene.h"
#import <AudioToolbox/AudioServices.h>

@interface GameScene()
{
    NSTimer *myTimer;
    NSString *serverDate;
    NSString *str;
    SKLabelNode *time_logo;
}
@property (nonatomic) SKSpriteNode *node;
@property (nonatomic) SKTextureAtlas *TextureAtlas;
@property (nonatomic,strong) NSMutableArray *textureArray;
@property (nonatomic) SKSpriteNode *bear;

@end

@implementation GameScene
CGPoint positionInScene;
NSMutableArray *spriteNodeNameArray;


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self serviceCallForGlobalTime];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGlobalMeditaionTime:)name:@"UpdateGlobalMeditaionTimeNotification" object:nil];
    [self setBackgroundColor:[UIColor clearColor]];
    self.physicsWorld.gravity = CGVectorMake(0.0f, -0.0f);
    self.physicsWorld.contactDelegate = self;
    spriteNodeNameArray = [NSMutableArray  arrayWithObjects:@"global_meditation",@"meditate_now",@"daily_quotes",@"daily_hunter",@"vedio",@"community",@"weekly_wisdom",@"Time_Logo", nil];
    SKSpriteNode *global_meditation = (SKSpriteNode *)[self childNodeWithName:[spriteNodeNameArray objectAtIndex:0]];

    time_logo = [SKLabelNode labelNodeWithFontNamed:@"Santana-Bold"];
    time_logo.name = @"Time_Logo";
    if ([Utility sharedInstance].isDeviceIpad)
    {
        time_logo.position = CGPointMake(2,-110);
        time_logo.fontSize = 24.0;
    }
    else
    {
        time_logo.position = CGPointMake(2,-40);
        time_logo.fontSize = 8.0;
    }
    time_logo.fontColor = [UIColor colorWithRed:0.0 green:255/205 blue:0.0 alpha:1.0];
    
    [global_meditation addChild:time_logo];
    
    for (int j = 0; j < 12; j++){
        NSString *node_name = [NSString stringWithFormat:@"SKSpriteNode_%d",j];
        SKSpriteNode *node = (SKSpriteNode *)[self childNodeWithName:node_name];
        [self addPhysicsBody:node];
    }
    
    for (int i = 0; i < spriteNodeNameArray.count; i++) {
        SKSpriteNode *spriteNode = (SKSpriteNode *)[self childNodeWithName:spriteNodeNameArray[i]];
        [self setProperties:spriteNode];
        
        
//        SKAction *action = [SKAction applyImpulse:CGVectorMake(5, -5) duration:0.0033];
      //  SKAction *action = [SKAction applyForce:CGVectorMake(5, -5) duration:0.0033];
    //    [spriteNode runAction:[SKAction repeatActionForever:action]];
        
        SKAction *action;
        if ([[[UIDevice currentDevice]systemVersion] integerValue] >= 9.0) {
            if ([Utility sharedInstance].isDeviceIpad)
                if ([spriteNode.name isEqualToString:@"meditate_now"] || [spriteNode.name isEqualToString:@"global_meditation"])
                {
                     action = [SKAction applyForce:CGVectorMake(25000,-25000) duration:0.01];
                    
                }
               else
                 action = [SKAction applyForce:CGVectorMake(2500,-2500) duration:0.01];
//                action = [SKAction applyImpulse:CGVectorMake(10, -10) duration:0.0033];
            
            else
            {
                if ([spriteNode.name isEqualToString:@"meditate_now"] || [spriteNode.name isEqualToString:@"global_meditation"])
                {
                      action = [SKAction applyForce:CGVectorMake(2500,-2500) duration:0.01];

                }
//                action = [SKAction applyImpulse:CGVectorMake(5, -5) duration:0.0033];
                else
                action = [SKAction applyForce:CGVectorMake(1000,-1000) duration:0.01];
            }
            [spriteNode runAction:[SKAction repeatActionForever:action]];
        }else{
           // action = [SKAction moveTo:CGPointMake(spriteNode.frame.origin.x, spriteNode.frame.origin.y) duration:0.0033];
        }
    }
}

-(void)updateGlobalMeditaionTime:(NSNotification *)notification
{
    [self serviceCallForGlobalTime];
}

- (void)addPhysicsBody:(SKSpriteNode *)node{
    
    [node setColor:[UIColor clearColor]];
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.frame.size];
    
    node.physicsBody.categoryBitMask = wallCategory;
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
    node.physicsBody.linearDamping = 0;
    node.physicsBody.angularDamping = 0;
    node.physicsBody.affectedByGravity = YES;
    node.physicsBody.allowsRotation = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    [touch locationInView:self.view];
    SKNode *node  = [self nodeAtPoint:location];
    NSLog(@"node %@", node.name);
    NSString *nodename = node.name;
    if (nodename == nil && [self.delegate respondsToSelector:@selector(checkforinfoview:)]) {
        NSLog(@"got it  %d", [self.delegate checkforinfoview:touch] );
        return;
    }
    if (nodename)
    {
        if ([spriteNodeNameArray containsObject:nodename])
        {
            
       
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

        [self.delegate actionOnNode:nodename];
        }
       // SKTransition *transition = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:1.0];

       // MyScene *view = [[MyScene alloc] initWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
         //   [self.scene.view presentScene:view transition:transition];
    }
}
//----- To play animation
- (void)runAnimation{
    _textureArray = [[NSMutableArray alloc] init];
    
    _TextureAtlas = [SKTextureAtlas atlasNamed:@"BearImages"];
    for (int i = 1; i <= _TextureAtlas.textureNames.count; i++) {
        NSString *Name = [NSString stringWithFormat:@"%s%d%s","bear",i,".png"];
        SKTexture *TextureSK =[SKTexture textureWithImageNamed:Name];
        [_textureArray addObject:TextureSK];
    }
    _bear = [SKSpriteNode spriteNodeWithImageNamed:_TextureAtlas.textureNames[0]];
    _bear.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:_bear];
    [self animateNode];

}

- (void)animateNode{
    SKAction *action = [SKAction animateWithTextures:_textureArray timePerFrame:0.1];
    [_bear runAction:[SKAction repeatActionForever:action]];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}
-(void)serviceCallForGlobalTime
{
    if (![Utility isNetworkAvailable])
    {
        return;
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"SERVICE_GLOBAL_START_DATE" forKey:@"REQUEST_TYPE_SENT"];
    [dict setObject:[[Utility sharedInstance] getDeviceToken] forKey:@"device_token"];
    [dict setObject:@"2" forKey:@"device_type"];
    NSMutableURLRequest *req= [Utility getRequestWithData:dict];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    manager.responseSerializer = [AFJSONResponseSerializer
                                  serializerWithReadingOptions:NSJSONReadingMutableContainers];
   
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse  * response, id  responseObject, NSError * error )
      {
          responseObject = [Utility convertIntoUTF8:[responseObject allValues] dictionary:responseObject];

          if (!error)
          {
              NSLog(@"Reply JSON: %@", responseObject);
              
              if ([responseObject isKindOfClass:[NSArray class]])
              {
                
              }
              else
              {
                if ([responseObject objectForKey:@"error_code"])
                 {
                    NSString *err=[responseObject objectForKey:@"error_desc"];
                   // [self.view makeToast:err];
                    NSLog(@"Error: %@", err);
                 }
                else if ([responseObject isKindOfClass:[NSDictionary class]])
                  {
                      serverDate=[responseObject objectForKey:@"start_date"];
                      
                      if ([serverDate isEqualToString:@"0"])
                      {
                          [myTimer invalidate];
                          time_logo.text = @"";
                          
                          NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                          
                          for (UILocalNotification *localNotification in arrayOfLocalNotifications)
                          {
                              
                              if ([localNotification.alertBody isEqualToString:@"The Pin Prick global meditation will begin in exact 24 hours from now."])
                              {
                                  NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                                  
                                  [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                              }
                              if ([localNotification.alertBody isEqualToString:@"Let’s meditate together! The Pin Prick global meditation will start in exact 60 minutes from now."])
                              {
                                  NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                                  
                                  [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                              }
                          }
                          
                      }
                
                      else
                      {
                      str = [Utility timeDifference:[NSDate date] ToDate:serverDate];
                      myTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeUpdate) userInfo:nil repeats:YES];
                          [myTimer fire];
                      }
                  }
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"start_Date"])
                {
                    NSString *value=[[NSUserDefaults standardUserDefaults] objectForKey:@"start_Date"];
                    if (![serverDate isEqualToString:value])
                    {
                        NSArray *arrayOfLocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications] ;
                        
                        for (UILocalNotification *localNotification in arrayOfLocalNotifications)
                        {
                            
                            if ([localNotification.alertBody isEqualToString:@"The Pin Prick global meditation will begin in exact 24 hours from now."])
                            {
                                NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                                
                                [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                            }
                            if ([localNotification.alertBody isEqualToString:@"Let’s meditate together! The Pin Prick global meditation will start in exact 60 minutes from now."])
                            {
                                NSLog(@"the notification this is canceld is %@", localNotification.alertBody);
                                
                                [[UIApplication sharedApplication] cancelLocalNotification:localNotification] ; // delete the notification from the system
                            }
                        }
                    }
                }
                  if ([serverDate isKindOfClass:[NSNull class]] || serverDate == nil)
                  {
                      
                  }
                  else
                  {
                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                      
                      [defaults setObject:serverDate forKey:@"start_Date"];
                      
                      [defaults synchronize];
                  }
              }
          }
          else
          {
              NSLog(@"Error: %@, %@, %@", error, response, responseObject);
          }
      }] resume];
}


-(void)timeUpdate
{
    if (![serverDate isEqualToString:@"0"])
    {
        if ([str isEqualToString:@"00:00:00:00"] || [str isEqualToString:@"00:00:00"])
        {
            time_logo.text = @"started";
            
            [myTimer invalidate];
            myTimer = nil;
        }
        else
        {
            str=[Utility timeDifference:[NSDate date] ToDate:serverDate];
            time_logo.text = [NSString stringWithFormat:@"in %@",[Utility changeTimeformat:str]];
        }
        
        if ([[Utility sharedInstance] isFinished]) {
            time_logo.text = @"Finished";
            [myTimer invalidate];
            myTimer = nil;
        }
    }
}


@end
