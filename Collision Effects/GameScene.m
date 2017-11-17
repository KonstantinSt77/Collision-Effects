//
//  GameScene.m
//  Collision Effects
//
//  Created by Kostya on 17.11.2017.
//  Copyright © 2017 SKS. All rights reserved.
//

#import "GameScene.h"

@interface GameScene() <SKPhysicsContactDelegate>
@property SKSpriteNode *ball;
@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsWorld.contactDelegate = self;
    self.name = @"fence";
    
    _ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball.png"];
    _ball.name = @"ball";
    _ball.size = CGSizeMake(100, 100);
    _ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_ball.size.width/2];
    _ball.physicsBody.dynamic = YES;
    _ball.position = CGPointMake(80, 400);
    _ball.physicsBody.friction = 0.0;
    _ball.physicsBody.restitution = 1.0;
    _ball.physicsBody.linearDamping = 0.0;
    _ball.physicsBody.angularDamping = 0.0;
    _ball.physicsBody.allowsRotation = YES;
    _ball.physicsBody.mass = 1.0;
    _ball.physicsBody.affectedByGravity = YES;
    _ball.physicsBody.velocity = CGVectorMake(100, 0);
    _ball.physicsBody.contactTestBitMask = 0x1;
    _ball.zPosition = 1;

    [self addChild:_ball];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [self performSelector:@selector(stopBall) withObject:self afterDelay:6.0];
    NSString *magic = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
    SKEmitterNode *emMagic = [NSKeyedUnarchiver unarchiveObjectWithFile:magic];
    emMagic.position = CGPointMake(0, -10);
    [_ball addChild:emMagic];
    [self runAction:[SKAction playSoundFileNamed:@"ballcknock.aif" waitForCompletion:YES]];
    float grav = self.physicsWorld.gravity.dy - 0.8;
    [self.physicsWorld setGravity:CGVectorMake(0, grav)];
}
- (void)didEndContact:(SKPhysicsContact *)contact
{
    [self performSelector:@selector(remove) withObject:self afterDelay:0.3];
}
- (void)remove
{
    NSString *magic = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
    SKEmitterNode *emMagic = [NSKeyedUnarchiver unarchiveObjectWithFile:magic];
    emMagic.position = CGPointMake(0, -10);
    [_ball removeAllChildren];
}
- (void)stopBall
{
    [self.physicsWorld setGravity:CGVectorMake(0, -1)];
    [_ball removeAllChildren];
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
