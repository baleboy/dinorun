import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
import Toybox.System;
import Toybox.Lang;
import Toybox.Application;

/**
 * Game manager class
 */
class Game {

    // Constants
    const RUN_SPEED = 0.15;
    const BACKDROP_SPEED = 0.01;
    const CLOUD_SPEED = 0.002;
    const VOLCANO_Y = 24;
    const CACTUS_Y = 75;
    const TERRAIN_Y = 155;

    // Game states
    enum {STATE_START_SCREEN, STATE_GAME, STATE_GAME_OVER}

    var state = STATE_START_SCREEN;
    var buttonPressed = false;

    // Title texts
    var titleText;
    var subtitleText1;
    var subtitleText2;
    var subtitleText3;
    var gameOverText;
    var scoreText;
    var highScoreText;
    var newHighScoreText;

    // Game objects
    var player;
    var volcano;
    var clouds;
    var terrain;
    var cactus;

    var highScore = 0;
    var newHighScore = false;

    function initTexts() {
        titleText = new WatchUi.Text({
            :text=>"Dino Run",
            :color=>Graphics.COLOR_YELLOW,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>10
        });

        subtitleText1 = new WatchUi.Text({
            :text=>"Game design: Leonardo",
            :color=>Graphics.COLOR_YELLOW,
            :font=>Graphics.FONT_SMALL,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>40
        });

        subtitleText2 = new WatchUi.Text({
            :text=>"Code: Francesco",
            :color=>Graphics.COLOR_YELLOW,
            :font=>Graphics.FONT_SMALL,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>60
        });

        subtitleText3 = new WatchUi.Text({
            :text=>"Graphics: Leonardo",
            :color=>Graphics.COLOR_YELLOW,
            :font=>Graphics.FONT_SMALL,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>80
        });


        gameOverText = new WatchUi.Text({
            :text=>"Game Over",
            :color=>Graphics.COLOR_RED,
            :font=>Graphics.FONT_LARGE,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>40
        });

        scoreText = new WatchUi.Text({
            :text=>"Score: 0",
            :color=>Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_SMALL,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>20
        });

        highScoreText = new WatchUi.Text({
            :text=>"High score: 0",
            :color=>Graphics.COLOR_YELLOW,
            :font=>Graphics.FONT_SMALL,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>130
        });

        newHighScoreText = new WatchUi.Text({
            :text=>"New high score!",
            :color=>Graphics.COLOR_YELLOW,
            :font=>Graphics.FONT_MEDIUM,
            :locX =>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>70
        });
    }

    function loadResources(dc) {
        initTexts();

        player = new Player();

        var volcanoResource = [Rez.Drawables.volcano];
        volcano = new ScrollingObject(dc.getWidth(), VOLCANO_Y, volcanoResource, 1, BACKDROP_SPEED);
        volcano.loopTo(dc.getWidth());

        var terrain_resources = [Rez.Drawables.snake, Rez.Drawables.bones];
        terrain = new ScrollingObject(dc.getWidth() - 100, TERRAIN_Y, terrain_resources, 2, RUN_SPEED);
        terrain.loopTo(dc.getWidth());

        var cactus_resources = [Rez.Drawables.cactus1, Rez.Drawables.cactus2, Rez.Drawables.cactus3];
        cactus = new Obstacle(dc.getWidth(), CACTUS_Y, cactus_resources, 3, RUN_SPEED);
        cactus.loopTo(dc.getWidth());

        var cloud_positions = [[10,30], [110,60], [200,10]];
        var cloud_resource = [Rez.Drawables.cloud];

        clouds = new [3];

        for (var i = 0; i < 3; i++) {
            clouds[i] = new ScrollingObject(cloud_positions[i][0], cloud_positions[i][1], cloud_resource, 1, CLOUD_SPEED);
            clouds[i].loopTo(dc.getWidth());
        }

        if (AppBase.getProperty("highScore") != null) {
            highScore = AppBase.getProperty("highScore");
        }
    }

    function drawStartScreen(dc) {
       titleText.draw(dc);
        subtitleText1.draw(dc);
        subtitleText2.draw(dc);
        subtitleText3.draw(dc);
    }

    function drawGameOver(dc) {
        gameOverText.draw(dc);
    }

    function drawScore(score, dc) {
        scoreText.setText("Score: " + score);
        scoreText.draw(dc);
    }

    function drawHighScore(highScore, dc) {
        highScoreText.setText("High score: " + highScore);
        highScoreText.draw(dc);
    }

    function drawBackground(dc) {
        // Draw sky
        dc.setColor(Graphics.COLOR_DK_BLUE, Graphics.COLOR_DK_BLUE);
        dc.clear();

        // Draw ground
        dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_GREEN);
        dc.fillRectangle(0, 125, dc.getWidth(), dc.getHeight() - 125);
    }

    function updateClouds(dt) {
        for (var i = 0; i < 3; i++) {
            clouds[i].update(dt);
        }
    }

    function drawClouds(dc) {
        for (var i = 0; i < 3; i++) {
            clouds[i].draw(dc);
        }
    }

    function updateProps(dt, dc) {
        terrain.update(dt);
        volcano.update(dt);
        cactus.update(dt);
    }

    function drawProps(dc) {
        terrain.draw(dc);
        volcano.draw(dc);
        cactus.draw(dc);
    }
    
    function resetGame(dc) {
        cactus.reset();
        volcano.reset();
        terrain.reset();
        terrain.place(dc.getWidth() - 100, TERRAIN_Y);
        player.stand();
        newHighScore = false;
    }

    function pressButton() {
        buttonPressed = true;
    }

    function draw(dc) {

        drawBackground(dc);  
        drawClouds(dc);
        drawProps(dc);
        player.draw(dc);

        switch(state) {
            case STATE_GAME:
                drawScore(cactus.getPassed(), dc);
                break;
            case STATE_START_SCREEN:
                drawStartScreen(dc);
                if (highScore != 0) {
                    drawHighScore(highScore, dc);
                }
                break;

            case STATE_GAME_OVER:
                drawScore(cactus.getPassed(), dc);
                drawGameOver(dc);
                if (newHighScore) {
                    newHighScoreText.draw(dc);
                }
                break;
            default:
        }
    }

    function update(dc, dt) {

        switch(state) {
            case STATE_START_SCREEN:
                updateClouds(dt);
                player.update(dt);

                if (buttonPressed) {
                    state = STATE_GAME;
                    player.run();
                    buttonPressed = false;
                }
                break;

            case STATE_GAME:
                updateProps(dt, dc);
                updateClouds(dt);
                player.update(dt);

                if (buttonPressed) {
                    player.jump();
                    buttonPressed = false;
                }

                if (player.isColliding(cactus)) {
                    state = STATE_GAME_OVER;
                    player.die();
                    if (cactus.getPassed() > highScore) {
                        highScore = cactus.getPassed();
                        newHighScore = true;
                        AppBase.setProperty("highScore", highScore);
                    }
                }
                break;

            case STATE_GAME_OVER:

                if (buttonPressed) {
                    resetGame(dc);
                    state = STATE_START_SCREEN;
                    buttonPressed = false;

                }
                break;
            default:
        }
    }
}