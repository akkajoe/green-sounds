import com.hamoid.*;
VideoExport videoExport;

// Sunflower Parameters
float growth = 0; // Growth progress of the sunflower
float swayAngle = 0; // Current sway angle
float swaySpeed = 0.05; // Speed of sway
int petalCount = 20; // Number of petals
float maxGrowth = 200; // Maximum growth height for sunflower
float fadeOut = 255; // Opacity for sunflower fade-out
float leafGrowth = 0; // Growth progress of sunflower leaves
boolean sunflowerGrown = false; // Track if sunflower has fully grown
boolean sunflowerFading = false; // Track if sunflower is fading out
boolean cactusGrowing = false; // Track if cactus is growing

// Cactus Parameters
float cactusGrowth = 0; // Growth progress of the cactus
float cactusMaxGrowth = 150; // Maximum height for the cactus
float branchProgress1 = 0;
float branchProgress2 = 0;
float branchProgress3 = 0;
float branchProgress4 = 0;
float cactusFadeOut = 255; // Opacity for cactus fade-out
boolean cactusFading = false; // Track if cactus is fading out

// Oak Tree Parameters
int maxDepth = 10; // Maximum depth for the tree
float trunkThickness = 60; // Initial trunk thickness
float growthSpeed = 0.01; // Slower speed of growth (smaller value for slower growth)
boolean oakTreeGrowing = false; // Track if the oak tree is growing
int oakGrowthFrame = 0; // Frame counter for oak tree growth
float oakFadeOut = 255; // Opacity for oak tree fade-out
boolean oakTreeFading = false; // Track if oak tree is fading out

// Ivy Parameters
float ivyGrowth = 0; // Growth progress of the ivy
float maxIvyGrowth = 400; // Maximum ivy growth length
boolean ivyGrowing = false; // Track if ivy is growing
float ivyFadeOut = 255; // Opacity for ivy fade-out
boolean ivyFading = false; // Track if ivy is fading out

// New state for individual ivy animation
boolean individualIvyGrowing = false;
int oakIvyStartTime = -1; // Start time for growOakAndIvyTogether


void setup() {
    fullScreen();
    frameRate(60);
    videoExport = new VideoExport(this, "output_video.mp4");
    videoExport.startMovie();
}

void draw() {
    background(135, 206, 250); // Light blue sky

    // Ground
    fill(34, 139, 34);
    rect(0, height - 50, width, 50);

    // Plant growth sequence
    if (!sunflowerGrown) {
        growSunflower(); // Grow sunflower
    } else if (sunflowerFading) {
        fadeOutSunflower(); // Fade out sunflower
    } else if (cactusGrowing) {
        growCactus(); // Grow cactus
    } else if (cactusFading) {
        fadeOutCactus(); // Fade out cactus
    } else if (individualIvyGrowing) {
        growIndividualIvy(); // Grow individual ivy
    } else if (oakTreeGrowing) {
        pushMatrix();
        translate(width / 2, height - 50); // Center position for individual oak tree
        growOakTree(); // Grow oak tree
        popMatrix();
    } else if (oakTreeFading) {
        fadeOutOakTree(); // Fade out oak tree
    } else if (ivyGrowing) {
        pushMatrix();
        translate(width / 2, height - 50); // Center position for individual ivy
        growIvy(); // Grow ivy
        popMatrix();
    } else if (ivyFading) {
        fadeOutIvy(); // Fade out ivy
    } else if (oakTreeGrowing || ivyGrowing){
        growOakAndIvyTogether(); // Display oak tree and ivy together with spacing
    } else if (oakIvyStartTime == -1) {
    oakIvyStartTime = millis(); // Start the timer for growOakAndIvyTogether
    growOakAndIvyTogether();
} else if (millis() - oakIvyStartTime <= 6000) { // 10 seconds in milliseconds
    growOakAndIvyTogether(); // Continue displaying growOakAndIvyTogether for 10 seconds
} else {
    displayOakIvyCactusTogether(); // Display all three plants together
}
}

// Sunflower Functions
void growSunflower() {
    if (growth < maxGrowth) {
        growth += 1; // Sunflower grows gradually
        if (leafGrowth < 1) leafGrowth += 0.01; // Leaves grow proportionally
    } else {
        sunflowerGrown = true; // Mark sunflower as fully grown
        sunflowerFading = true; // Start fading out
    }

    pushMatrix();
    translate(width / 2, height - 50); // Move to the base of the sunflower
    rotate(swayAngle); // Apply sway to the sunflower
    drawSmoothWavyStem(255); // Draw stem with full opacity
    drawLeaves(255); // Draw leaves with full opacity
    drawSunflower(255); // Draw sunflower with full opacity
    popMatrix();
}

void fadeOutSunflower() {
    if (fadeOut > 0) {
        fadeOut -= 2; // Gradually decrease opacity
        pushMatrix();
        translate(width / 2, height - 50); // Move to the base of the sunflower
        rotate(swayAngle); // Apply sway to the sunflower
        drawSmoothWavyStem(fadeOut); // Draw stem with fade-out
        drawLeaves(fadeOut); // Draw leaves with fade-out
        drawSunflower(fadeOut); // Draw sunflower with fade-out
        popMatrix();
    } else {
        sunflowerFading = false; // Sunflower fully faded out
        cactusGrowing = true; // Start cactus growth
    }
}

void drawSmoothWavyStem(float alpha) {
    stroke(34, 139, 34, alpha); // Green with fade-out
    strokeWeight(10);
    noFill();

    beginShape();
    for (float i = 0; i < growth; i += 4) {
        float xOffset = sin(i * 0.1 + swayAngle) * 5; // Smooth sway motion
        vertex(xOffset, -i); // Draw stem vertex
    }
    endShape();
}

void drawLeaves(float alpha) {
    float firstLeafPosition = growth / 3; // Position for the first leaf
    float secondLeafPosition = growth * 2 / 3; // Position for the second leaf

    if (growth > maxGrowth / 5) { // Ensure leaves appear only after some stem growth
        drawPointedLeaf(-15, -firstLeafPosition, 100 * leafGrowth, 50 * leafGrowth, alpha);
        drawPointedLeaf(15, -firstLeafPosition, 100 * leafGrowth, 50 * leafGrowth, alpha);
        drawPointedLeaf(-15, -secondLeafPosition, 100 * leafGrowth, 50 * leafGrowth, alpha);
        drawPointedLeaf(15, -secondLeafPosition, 100 * leafGrowth, 50 * leafGrowth, alpha);
    }
}

void drawSunflower(float alpha) {
    pushMatrix();
    translate(0, -growth);
    drawPetals(alpha);
    drawCenter(alpha);
    popMatrix();
}

void drawPetals(float alpha) {
    for (int i = 0; i < petalCount; i++) {
        float angle = TWO_PI / petalCount * i;
        rotate(angle);
        drawSharpPetal(0, -80, 160, 200, alpha);
    }
}

void drawCenter(float alpha) {
    fill(139, 69, 19, alpha); // Brown with fade-out
    noStroke();
    ellipse(0, 0, 100, 100);
}

void drawSharpPetal(float x, float y, float w, float h, float alpha) {
    fill(255, 165, 0, alpha); // Orange with fade-out
    noStroke();
    beginShape();
    vertex(x, y);
    bezierVertex(x - w / 2, y + h / 2, x + w / 2, y + h / 2, x, y);
    endShape(CLOSE);
}

void drawPointedLeaf(float x, float y, float w, float h, float alpha) {
    fill(34, 139, 34, alpha); // Green with fade-out
    noStroke();
    beginShape();
    vertex(x, y);
    bezierVertex(x - w / 2, y + h / 2, x + w / 2, y + h / 2, x, y);
    bezierVertex(x + w / 3, y - h / 3, x - w / 3, y - h / 3, x, y);
    endShape(CLOSE);
}

// Individual Ivy Animation Function
void growIndividualIvy() {
    if (ivyGrowth < maxIvyGrowth) {
        ivyGrowth += 0.5; // Incrementally grow the ivy
        drawIvy(width / 2, height - 50, ivyGrowth, 255); // Draw the ivy as it grows
    } else {
        individualIvyGrowing = false; // Mark individual ivy growth as completed
        oakTreeGrowing = true; // Transition to growing the oak tree
    }
}

// Cactus Functions
void growCactus() {
    if (cactusGrowth < cactusMaxGrowth) {
        cactusGrowth += 0.5;

        if (branchProgress1 < 1 && cactusGrowth > cactusMaxGrowth / 4) branchProgress1 += 0.01;
        if (branchProgress2 < 1 && cactusGrowth > cactusMaxGrowth / 3) branchProgress2 += 0.01;
        if (branchProgress3 < 1 && cactusGrowth > cactusMaxGrowth / 2) branchProgress3 += 0.01;
        if (branchProgress4 < 1 && cactusGrowth > 3 * cactusMaxGrowth / 4) branchProgress4 += 0.01;
    } else {
        cactusGrowing = false;
        cactusFading = true;
    }

    pushMatrix();
    translate(width / 2, height - 50);
    fill(34, 139, 34);
    rect(-10, -cactusGrowth, 20, cactusGrowth);
    drawThorns(-10, -cactusGrowth, 20, cactusGrowth);
    drawBranches(255);
    popMatrix();
}

void fadeOutCactus() {
    if (cactusFadeOut > 0) {
        cactusFadeOut -= 2;

        pushMatrix();
        translate(width / 2, height - 50);
        fill(34, 139, 34, cactusFadeOut);
        rect(-10, -cactusGrowth, 20, cactusGrowth);
        drawThorns(-10, -cactusGrowth, 20, cactusGrowth);
        drawBranches(cactusFadeOut);
        popMatrix();
    } else {
        cactusFading = false;
        individualIvyGrowing = true; // Transition to individual ivy growth
    }
}

void drawBranches(float alpha) {
    drawThickLShapedBranch(-10, -cactusGrowth / 4, true, branchProgress1, alpha);
    drawThickLShapedBranch(10, -cactusGrowth / 3, false, branchProgress2, alpha);
    drawThickLShapedBranch(-10, -cactusGrowth / 2, true, branchProgress3, alpha);
    drawThickLShapedBranch(10, -3 * cactusMaxGrowth / 4, false, branchProgress4, alpha);
}

void drawThickLShapedBranch(float startX, float startY, boolean left, float branchProgress, float alpha) {
    pushMatrix();
    translate(startX, startY);
    fill(34, 139, 34, alpha);

    float horizontal = left ? -30 : 30;
    float vertical = -40;

    float tipX = lerp(0, horizontal, branchProgress);
    float tipY = lerp(0, vertical, branchProgress);

    if (branchProgress > 0.5) {
        rect(0, -5, tipX, 10);
    }

    rect(tipX - (left ? 10 : 0), tipY, 10, -tipY);
    drawThorns(tipX - (left ? 10 : 0), tipY, 10, -tipY);

    // Draw flower on branch tips
    if (branchProgress >= 1) {
        drawFlower(tipX, tipY, alpha);
    }
    popMatrix();
}

void drawThorns(float startX, float startY, float width, float height) {
    fill(255);
    for (float i = startY; i < startY + height; i += 10) {
        triangle(startX - 5, i, startX, i + 5, startX + 5, i);
        triangle(startX + width - 5, i + 5, startX + width, i, startX + width + 5, i + 5);
    }
}

void drawFlower(float x, float y, float alpha) {
    fill(255, 20, 147, alpha); // Pink flower
    noStroke();
    ellipse(x, y, 15, 15);
    fill(255, 105, 180, alpha); // Inner circle
    ellipse(x, y, 8, 8);
}

// Oak Tree and Ivy Together Functions
void growOakAndIvyTogether() {
    pushMatrix();
    translate(width / 3, height - 50); // Left position for oak tree
    growOakTree();
    popMatrix();

    pushMatrix();
    translate(2 * width / 3, height - 50); // Right position for ivy
    growIvy();
    popMatrix();
}

// Oak Tree Functions
void growOakTree() {
    oakGrowthFrame++;
    int currentDepth = min(oakGrowthFrame / (int)(1 / growthSpeed), maxDepth);
    drawTree(0, 0, -PI / 2, 150, currentDepth, trunkThickness);

    if (currentDepth >= maxDepth) {
        oakTreeGrowing = false;
    }
}

void fadeOutOakTree() {
    if (oakFadeOut > 0) {
        oakFadeOut -= 2;
        drawTree(width / 2, height - 50, -PI / 2, 150, maxDepth, trunkThickness * oakFadeOut / 255);
    } else {
        oakTreeFading = false;
        ivyGrowing = true;
    }
}

void drawTree(float x, float y, float angle, float length, int depth, float thickness) {
    if (depth == 0) return;

    thickness = max(thickness, 1);
    float x2 = x + cos(angle) * length;
    float y2 = y + sin(angle) * length;

    stroke(0);
    strokeWeight(thickness);
    line(x, y, x2, y2);

    float newThickness = thickness * 0.7;
    drawTree(x2, y2, angle - PI / 6, length * 0.8, depth - 1, newThickness);
    drawTree(x2, y2, angle + PI / 6, length * 0.8, depth - 1, newThickness);

    if (depth < 4) {
        for (int i = 0; i < 5; i++) {
            float leafX = x2 + random(-20, 20);
            float leafY = y2 + random(-20, 20);
            fill(34, random(120, 160), 34, 200);
            noStroke();
            ellipse(leafX, leafY, random(15, 30), random(15, 30));
        }
    }
}

// Ivy Functions
void growIvy() {
    if (ivyGrowth < maxIvyGrowth) {
        ivyGrowth += 0.5;
    } else {
        ivyGrowing = false;
    }
    drawIvy(0, 0, ivyGrowth, 255);
}

void fadeOutIvy() {
    if (ivyFadeOut > 0) {
        ivyFadeOut -= 2;
        drawIvy(width / 2, height - 50, maxIvyGrowth, ivyFadeOut);
    } else {
        ivyFading = false;
    }
}

void drawIvy(float x, float y, float growth, float alpha) {
    pushMatrix();
    translate(x, y);
    stroke(34, 139, 34, alpha);
    strokeWeight(3);
    noFill();

    float segmentLength = 40; // Length of each segment
    int segmentCount = int(growth / segmentLength);

    float currentX = 0;  // Start position (centered)
    float currentY = 0;

    for (int i = 0; i < segmentCount; i++) {
        float nextX = currentX + sin(i * 0.15) * 15; // Reduced frequency and amplitude // Add horizontal twist
        float nextY = currentY - segmentLength; // Grow upwards

        // Bezier control points for twisting stems
        float controlX1 = currentX + random(-10, 10); // Random for natural wobble
        float controlY1 = currentY - segmentLength / 2;
        float controlX2 = nextX + random(-15, 15);
        float controlY2 = nextY - segmentLength / 2;

        // Draw the curve
        beginShape();
        vertex(currentX, currentY);
        bezierVertex(controlX1, controlY1, controlX2, controlY2, nextX, nextY);
        endShape();

        // Attach leaves to the curve
        drawIvyLeaf(controlX1, controlY1, alpha); // Left leaf
        drawIvyLeaf(controlX2, controlY2, alpha); // Right leaf

        // Update current position
        currentX = nextX;
        currentY = nextY;
    }
    popMatrix();
}



void drawIvyLeaf(float x, float y, float alpha) {
    pushMatrix();
    translate(x, y);
    rotate(atan2(y, x) + PI / 2); // Rotate leaf to follow stem direction
    fill(34, 139, 34, alpha);
    noStroke();
    beginShape();
    vertex(0, 0);
    bezierVertex(-10, -20, -10, -40, 0, -50); // Leaf shape
    bezierVertex(10, -40, 10, -20, 0, 0);
    endShape(CLOSE);
    popMatrix();
}
void displayOakIvyCactusTogether() {
    background(135, 206, 250); // Light blue sky
    fill(34, 139, 34);
    rect(0, height - 50, width, 50); // Ground

    // Display Oak Tree on the left
    pushMatrix();
    translate(width / 4, height - 50); // Position for the oak tree
    drawTree(0, 0, -PI / 2, 150, maxDepth, trunkThickness); // Full oak tree
    popMatrix();

    // Display Ivy in the middle
    pushMatrix();
    translate(width / 2, height - 50); // Center position for ivy
    drawIvy(0, 0, maxIvyGrowth, 255); // Full ivy
    popMatrix();

    // Display Cactus on the right
    pushMatrix();
    translate(3 * width / 4, height - 50); // Position for the cactus
    fill(34, 139, 34, 255); // Full opacity
    rect(-10, -cactusMaxGrowth, 20, cactusMaxGrowth); // Main cactus
    drawThorns(-10, -cactusMaxGrowth, 20, cactusMaxGrowth); // Thorns
    drawBranches(255); // Cactus branches
    popMatrix();
}
