//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Ding ZHAO on 2/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay{
    CCPhysicsNode *_physicsNode;
    CCNode *_catapultArm;
    CCNode *_levelNode;
    CCNode *_pullbackNode;
    CCNode *_mouseJointNode;
    CCPhysicsJoint *_mouseJoint;
    CCNode *_contentNode;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    
    // visualize physics bodies & joints
    _physicsNode.debugDraw = TRUE;
    
    // nothing shall collide with our invisible nodes
    _pullbackNode.physicsBody.collisionMask = @[];
    
    _mouseJointNode.physicsBody.collisionMask = @[];
}

// called on every touch in this scene-old version
/*
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    [self launchPenguin];
}*/

-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    // start catapult dragging when a touch inside of the catapult arm occurs
    if (CGRectContainsPoint([_catapultArm boundingBox], touchLocation))
    {
        // move the mouseJointNode to the touch position
        _mouseJointNode.position = touchLocation;
        
        // setup a spring joint between the mouseJointNode and the catapultArm
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 0) anchorB:ccp(34, 138) restLength:50.f stiffness:6000.f damping:300.f];
    }
}

// Whenever a touch moves, we need to update the position of the mouseJointNode,
// so that the catapult arm is dragged in the correct direction.

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // whenever touches move, update the position of the mouseJointNode to the touch position
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    _mouseJointNode.position = touchLocation;
}

// When a touch ends we want to destroy our joint and let the catapult snap.
- (void)releaseCatapult {
    if (_mouseJoint != nil)
    {
        // releases the joint and lets the catapult snap back
        [_mouseJoint invalidate];
        _mouseJoint = nil;
    }
}

-(void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // when touches end, meaning the user releases their finger, release the catapult
    [self releaseCatapult];
}

-(void) touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // when touches are cancelled, meaning the user drags their finger off the screen or onto something else, release the catapult
    [self releaseCatapult];
}
// called when press the "reset" button

- (void)retry {
    // reload this level
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}


- (void)launchPenguin {
    // loads the Penguin.ccb we have set up in Spritebuilder
    CCNode* penguin = [CCBReader load:@"Penguin"];
    // position the penguin at the bowl of the catapult
    penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));
    
    // add the penguin to the physicsNode of this scene (because it has physics enabled)
    [_physicsNode addChild:penguin];
    
    // manually create & apply a force to launch the penguin
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [penguin.physicsBody applyForce:force];
    
    // ensure followed object is in visible are when starting
    /*
    self.position = ccp(0, 0);
    CCActionFollow *follow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
    [self runAction:follow];*/
    
    
    // ensure followed object is in visible are when starting
    self.position = ccp(0, 0);
    CCActionFollow *follow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
}

@end
