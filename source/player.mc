import Toybox.Graphics;
import Toybox.WatchUi;

/**
 * Player class. Takes care of player state, movement, and animation.
 */
class Player {
    var standingAnimation;
    var runningAnimation;
    var jumpingFrame;
    var fallingFrame;
    var deadFrame;

    const JUMP_SPEED = 0.3;
    const FALL_SPEED = 0.15;
    const JUMP_HEIGHT = -25;

    const PLAYER_X = 10;
    const PLAYER_BB_MARGIN_X = 20;
    const PLAYER_BB_MARGIN_Y = 20;
    const PLAYER_Y = 75;

    const STATE_STANDING = 0;
    const STATE_RUNNING = 1;
    const STATE_JUMPING = 2;
    const STATE_FALLING = 3;
    const STATE_DEAD = 4;

    var state = STATE_STANDING;

    var boundingBox;

    var y = PLAYER_Y;

    function initialize() {
        // Standing animation data
        var standingFrames = new [2];
        standingFrames[0] = WatchUi.loadResource(Rez.Drawables.still_0);
        standingFrames[1] = WatchUi.loadResource(Rez.Drawables.still_1);

        standingAnimation = new Animation(standingFrames, 2, 4);

        // Running animation data
        var runningFrames = new [4];
        runningFrames[0] = WatchUi.loadResource(Rez.Drawables.run_0);
        runningFrames[1] = WatchUi.loadResource(Rez.Drawables.run_1);
        runningFrames[2] = WatchUi.loadResource(Rez.Drawables.run_3);
        runningFrames[3] = WatchUi.loadResource(Rez.Drawables.run_4);

        runningAnimation = new Animation(runningFrames, 4, 2);

        jumpingFrame = WatchUi.loadResource(Rez.Drawables.run_4);
        fallingFrame = WatchUi.loadResource(Rez.Drawables.run_0);
        deadFrame = WatchUi.loadResource(Rez.Drawables.still_0);

        boundingBox = new BoundingBox(PLAYER_X + PLAYER_BB_MARGIN_X, 
                                        y + PLAYER_BB_MARGIN_Y, 
                                        runningFrames[0].getWidth() - PLAYER_BB_MARGIN_X * 2, 
                                        runningFrames[0].getHeight() - PLAYER_BB_MARGIN_Y * 2);
    }

    function isColliding(obstacle) {
        return boundingBox.isColliding(obstacle.boundingBox);
    }

    function jump() {
        if (state == STATE_RUNNING) {
            state = STATE_JUMPING;
        }
    }

    function run() {
        if (state == STATE_STANDING) {
            state = STATE_RUNNING;
        }
    }

    function die() {
        state = STATE_DEAD;
    }

    function stand() {
        state = STATE_STANDING;
    }

    function update(dt) {
        switch(state) {
            case STATE_STANDING:
                standingAnimation.update();
                y = PLAYER_Y;
                break;
            case STATE_RUNNING:
                runningAnimation.update();
                y = PLAYER_Y;
                break;
            case STATE_JUMPING:
                if (y > JUMP_HEIGHT) {
                    y = y - dt * JUMP_SPEED;
                    boundingBox.y = y + PLAYER_BB_MARGIN_Y;
                } else {
                    state = STATE_FALLING;
                }
                break;
            case STATE_FALLING:
                if (y < 75) {
                    y = y + dt * FALL_SPEED;
                    boundingBox.y = y + PLAYER_BB_MARGIN_Y;
                } else {
                    state = STATE_RUNNING;
                }
            case STATE_DEAD:
                // frameIndex = 0;
                // frame = still[frameIndex];
                break;
            default:
        }
    }

    function draw(dc) {
        switch(state) {
            case STATE_STANDING:
                standingAnimation.draw(dc, PLAYER_X, y);
                break;
            case STATE_RUNNING:
                runningAnimation.draw(dc, PLAYER_X, y);
                y = PLAYER_Y;
                break;
            case STATE_JUMPING:
                dc.drawBitmap(PLAYER_X, y, jumpingFrame);
                break;
            case STATE_FALLING:
                dc.drawBitmap(PLAYER_X, y, fallingFrame);
                break;
            case STATE_DEAD:
                dc.drawBitmap(PLAYER_X, y, deadFrame);
                break;
            default:
        }
        if (SHOW_BOUNDING_BOXES) {
            boundingBox.draw(dc);
        }
    }
}