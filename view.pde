class HeaderView {

  private final PVector pos;
  
  public HeaderView(PVector newPos) {
    pos = newPos;
  }
  
  public void draw() {
    pushMatrix();
    pushStyle();
    
    translate(pos.x, pos.y);
    
    rectMode(CORNER);
    fill(VERY_LIGHT_GRAY);
    noStroke();
    rect(0, 0, width, HEADER_HEIGHT);
    
    fill(NEAR_BLACK);
    textFont(LARGE_FONT);
    textAlign(LEFT, CENTER);
    text("What parts of the tech community are satisfied and what do they care about in a job?", 10, HEADER_HEIGHT / 2);
    
    textAlign(RIGHT, CENTER);
    textFont(SMALL_FONT);
    text("Data Driven Empathy LLC (Aug 15, 2019)\nUses the Stack Overflow 2019 Developers Survey.\nGlobal. Respondents without satisfaction and dev type are removed.", width - 10, 24);
    
    noFill();
    stroke(MID_GRAY);
    line(0, HEADER_HEIGHT, width, HEADER_HEIGHT);
    
    popStyle();
    popMatrix();
  }

}


class DevTypeOverview {

  private final PVector pos;
  private final DataModel model;
  
  public DevTypeOverview(PVector newPos, DataModel newModel) {
    pos = newPos;
    model = newModel;
  }
  
  public void draw() {
    pushMatrix();
    pushStyle();
    
    translate(pos.x, pos.y);
    
    drawTitle();
    drawAxes();
    
    int i = 0;
    for (String devType : model.getDevTypesBySatisfaction()) {
      drawDevType(devType, i);
      i++;
    }
    
    drawGrid();
    
    popStyle();
    popMatrix();
  }
  
  private void drawTitle() {
    pushMatrix();
    pushStyle();
    
    noStroke();
    textAlign(RIGHT, CENTER);
    
    // Center
    textFont(MEDIUM_FONT_BOLD);
    fill(NEAR_BLACK);
    text("Discipline", -10, HEIGHT_PER_DEV_TYPE_LABEL / 2);
    
    // Top bar chart
    textFont(SMALL_FONT);
    text("Satisfaction Ratio", -10,  - HEIGHT_PER_DEV_TYPE_LABEL / 2 - 5);
    
    textFont(TINY_FONT);
    text("Satisfied over unsatisfied", -10,  - HEIGHT_PER_DEV_TYPE_LABEL / 2 + 7);
    
    // Bottom bar chart
    textFont(SMALL_FONT);
    text("Compensation", -10, HEIGHT_PER_DEV_TYPE_LABEL * 3 / 2 - 3);
    
    textFont(TINY_FONT);
    text("Median compensation\n(conv. annual USD) ", -10, HEIGHT_PER_DEV_TYPE_LABEL * 3 / 2 + 16);
    
    popStyle();
    popMatrix();
  }
  
  private void drawAxes() {
    pushMatrix();
    pushStyle();
    
    textAlign(LEFT, CENTER);
    textFont(TINY_FONT);
    noStroke();
    fill(TECH_GREEN);
    
    float labelX = BODY_WIDTH + 15;
    
    float startTopBarY = -DEV_BAR_LABEL_HEIGHT;
    text("1 (num sat. = dissat.)", labelX, startTopBarY);
    text(nfc(model.getMaxSatisfactionRatio(), 1), labelX, startTopBarY - DEV_BAR_HEIGHT_NO_LABEL);
    
    float startBottomBarY = HEIGHT_PER_DEV_TYPE_LABEL + DEV_BAR_LABEL_HEIGHT;
    text("0", labelX, startBottomBarY);
    text(nfc(model.getMaxDevTypeCompensation() / 1000.0, 1) + "k", labelX, startBottomBarY + DEV_BAR_HEIGHT_NO_LABEL);
    
    popStyle();
    popMatrix();
  }
  
  private void drawDevType(String devType, int offset) {
    pushMatrix();
    pushStyle();
    
    textFont(SMALL_FONT_BOLD);
    rectMode(CORNER);
    noStroke();
    textAlign(CENTER, CENTER);
    
    // Label
    fill(NEAR_BLACK);
    translate(WIDTH_PER_DEV_TYPE * offset, 0);
    
    int count = model.getCountForDevType(devType);
    String devTypeShort = getDevTypeShort(devType);
    text(devTypeShort, 0, 0, WIDTH_PER_DEV_TYPE - 5, HEIGHT_PER_DEV_TYPE_LABEL);
    
    // Ratio
    fill(TECH_GREEN);
    textFont(TINY_FONT);
    
    float satisfactionRatio = model.getSatisfactionRatio(devType);
    float barHeightSatisfaction = getSatisfactionHeight(satisfactionRatio);
    text(nfc(satisfactionRatio, 1), WIDTH_PER_DEV_TYPE / 2 - 2, -3);
    rect(
      WIDTH_PER_DEV_TYPE / 2 - 5,
      -DEV_BAR_LABEL_HEIGHT,
      5,
      -barHeightSatisfaction
    );
    
    // Comp
    float compensation = model.getCompensationForDevType(devType);
    float barHeightCount = getCompensationHeight(compensation);
    text(nfc(compensation / 1000.0, 1) + "K", WIDTH_PER_DEV_TYPE / 2 - 2, HEIGHT_PER_DEV_TYPE_LABEL + 3);
    rect(
      WIDTH_PER_DEV_TYPE / 2 - 5,
      HEIGHT_PER_DEV_TYPE_LABEL + DEV_BAR_LABEL_HEIGHT,
      5,
      barHeightCount
    );
    
    noFill();
    stroke(TECH_GREEN);
    float startDotY = HEIGHT_PER_DEV_TYPE_LABEL + DEV_BAR_LABEL_HEIGHT;
    float endDotY = HEIGHT_PER_DEV_TYPE_LABEL + DEV_BAR_HEIGHT;
    for (float y = startDotY; y < endDotY; y += 3) {
      point(WIDTH_PER_DEV_TYPE / 2 - 3, y);
    }
    
    popStyle();
    popMatrix();
  }
  
  void drawGrid() {
    pushMatrix();
    pushStyle();
    
    // Top sep grid
    stroke(WHITE);
    
    int maxRatioInteger = round(model.getMaxSatisfactionRatio());
    for (int i = 1; i < maxRatioInteger; i++) {
      float topMidHeight = getSatisfactionHeight(i);
      float topMidY = - DEV_BAR_LABEL_HEIGHT - topMidHeight;
      line(0, topMidY, BODY_WIDTH, topMidY);
    }
    
    popStyle();
    popMatrix();
  }
  
  private float getSatisfactionHeight(float satisfactionRatio) {
    return map(satisfactionRatio, 1, model.getMaxSatisfactionRatio(), 0, DEV_BAR_HEIGHT_NO_LABEL);
  }
  
  private float getCompensationHeight(float compensation) {
    return map(compensation, 0, model.getMaxDevTypeCompensation(), 0, DEV_BAR_HEIGHT_NO_LABEL);
  }
  
}


class FactorsView {
  
  private final PVector pos;
  private final DataModel model;
  private final Map<String, Integer> factorColorAssignment;
  
  public FactorsView(PVector newPos, DataModel newModel) {
    pos = newPos;
    model = newModel;
    
    factorColorAssignment = new HashMap<>();
    int i = 0;
    for (String factorName : model.getFactorsByPopulation()) {
      factorColorAssignment.put(factorName, FACTOR_COLORS.get(i));
      i++;
    }
  }
  
  public void draw() {
    pushMatrix();
    pushStyle();
    
    translate(pos.x, pos.y);
    drawTitle();
    drawFactorNames();
    drawRanks();
    drawRankLabels();
    drawAxis();
    
    popStyle();
    popMatrix();
  }
  
  private void drawTitle() {
    pushMatrix();
    pushStyle();
    
    noStroke();
    fill(NEAR_BLACK);
    textFont(MEDIUM_FONT);
    textAlign(RIGHT, CENTER);
    text("Important Factors", GUTTER_LEFT_X - 3, -22);
    
    textFont(TINY_FONT);
    text("People list 3 factors in deciding job", GUTTER_LEFT_X - 3, -9);
    
    noFill();
    stroke(NEAR_BLACK);
    line(3, -15, GUTTER_LEFT_X - 3, -15);
    
    popStyle();
    popMatrix();
  }
  
  private void drawFactorNames() {
    pushMatrix();
    pushStyle();
    
    textFont(SMALL_FONT);
    textAlign(RIGHT, CENTER);
    rectMode(CORNER);
    
    int offset = 0;
    int maxCount = model.getMaxFactorPopulation();
    for (String factorName : model.getFactorsByPopulation()) {
      int factorColor = factorColorAssignment.get(factorName);
      
      noStroke();
      fill(factorColor);
      int groupCount = model.getFactorCount(factorName);
      float y = FACTOR_HEIGHT * offset;
      
      String title = getShortFactorName(factorName) + " (" + round(groupCount / 1000) + "K)";
      text(title, 0, y, GUTTER_LEFT_X - 5, FACTOR_HEIGHT - 10);
      
      noFill();
      stroke(factorColor);
      float barWidth = map(groupCount, 0, maxCount, 0, FACTOR_BAR_MAX_WIDTH);
      line(GUTTER_LEFT_X - 10, y + 12, GUTTER_LEFT_X - barWidth - 10, y + 12);
      
      offset++;
    }
    
    popStyle();
    popMatrix();
  }
  
  private void drawRanks() {
    pushMatrix();
    pushStyle();
    
    noStroke();
    textFont(SMALL_FONT);
    textAlign(CENTER, CENTER);
    
    Map<String, Integer> lastRanking = new HashMap<>();
    int i = 0;
    for (String factorName : model.getFactorsByPopulation()) {
      lastRanking.put(factorName, i);
      i++;
    } 
    
    int devTypeCount = 0;
    for (String devType : model.getDevTypesBySatisfaction()) {
      float x = GUTTER_LEFT_X + WIDTH_PER_DEV_TYPE * devTypeCount + WIDTH_PER_DEV_TYPE / 2 - 3;
      
      Map<String, FactorRanking> factorRankings = model.getFactorRanking(devType);
      for (String factorName : factorRankings.keySet()) {
        FactorRanking factorRanking = factorRankings.get(factorName);
        float y = getYPosForRanking(factorRanking.getRanking());
        
        int factorColor = factorColorAssignment.get(factorName);
        
        noStroke();
        fill(factorColor);
        text(round(factorRanking.getScore() * 100) + "%", x, y);
        
        noFill();
        stroke(factorColor);
        int lastRank = lastRanking.get(factorName);
        float lastY = getYPosForRanking(lastRank);
        float lastLineX = devTypeCount == 0 ? GUTTER_LEFT_X : x - WIDTH_PER_DEV_TYPE + 12;
        float thisLineX = x - 12;
        line(lastLineX, lastY, thisLineX, y);
        
        lastRanking.put(factorName, factorRanking.getRanking());
      }
      
      devTypeCount++;
    }
    
    popStyle();
    popMatrix();
  }
  
  private void drawRankLabels() {
    pushMatrix();
    pushStyle();
    
    textFont(SMALL_FONT);
    textAlign(LEFT, CENTER);
    fill(MID_GRAY);
    
    for (int i = 0; i < 10; i++) {
      float y = getYPosForRanking(i);
      text("Rank " + (i + 1), GUTTER_RIGHT_X + 7, y);
    }
    
    pushMatrix();
    pushStyle();
    
    translate(GUTTER_RIGHT_X + 65, getYPosForRanking(5) - 10);
    rotate(HALF_PI);
    textAlign(CENTER, CENTER);
    text("Number is % respondents reporting factor", 0, 0);
    
    popStyle();
    popMatrix();
    
    popStyle();
    popMatrix();
  }
  
  private void drawAxis() {
    pushMatrix();
    pushStyle();
    
    noStroke();
    fill(MID_GRAY);
    textFont(TINY_FONT);
    textAlign(TOP, CENTER);
    text("0", GUTTER_LEFT_X - 10, FACTOR_HEIGHT * 9 + 20);
    text(
      nfc(model.getMaxFactorPopulation() / 1000.0, 1) + "k",
      GUTTER_LEFT_X - 10 - FACTOR_BAR_MAX_WIDTH,
      FACTOR_HEIGHT * 9 + 20
    );
    
    popStyle();
    popMatrix();
  }
  
  private float getYPosForRanking(int ranking) {
    return FACTOR_HEIGHT * ranking + 5;
  }
  
}


class DevTypeOverlapView {

  private final PVector pos;
  private final DataModel model;
  
  public DevTypeOverlapView(PVector newPos, DataModel newModel) {
    pos = newPos;
    model = newModel;
  }
  
  public void draw() {
    pushMatrix();
    pushStyle();
    
    translate(pos.x, pos.y);
    
    drawTitles();
    drawDevTypes();
    drawGrid();
    drawOverlaps();
    drawRatios();
    drawAxis();
    
    popStyle();
    popMatrix();
  }
  
  private void drawTitles() {
    pushMatrix();
    pushStyle();
    
    fill(NEAR_BLACK);
    noStroke();
    textFont(MEDIUM_FONT);
    textAlign(RIGHT, CENTER);
    text("Displine Overlap", GUTTER_LEFT_X - 3, -24);
    
    textFont(TINY_FONT);
    text("Amt overlapping people ( jaccard )", GUTTER_LEFT_X - 3, -11);
    
    noFill();
    stroke(NEAR_BLACK);
    line(3, -17, GUTTER_LEFT_X - 3, -17);
    
    textAlign(LEFT, CENTER);
    fill(NEAR_BLACK);
    noStroke();
    textFont(SMALL_FONT);
    text("Satisfaction ratio", GUTTER_RIGHT_X + 2, -27);
    
    fill(MID_GRAY);
    textFont(TINY_FONT);
    textAlign(CENTER, CENTER);
    text("1.0", GUTTER_RIGHT_X, -14);
    text(nfc(model.getMaxSatisfactionRatio(), 1), GUTTER_RIGHT_X + 62, -14);
    
    popStyle();
    popMatrix();
  }
  
  private void drawDevTypes() {
    pushMatrix();
    pushStyle();
    
    textAlign(RIGHT, CENTER);
    noStroke();
    fill(MID_GRAY);
    textFont(SMALL_FONT);
    
    int i = 0;
    for(String devType : model.getDevTypesBySatisfaction()) {
      text(getDevTypeShort(devType), GUTTER_LEFT_X, i * HEATMAP_ROW_HEIGHT);
      i++;
    }
    
    popStyle();
    popMatrix();
  }
  
  private void drawGrid() {
    int i = 0;
    stroke(LIGHT_GRAY);
    for(String devType : model.getDevTypesBySatisfaction()) {
      float y = i * HEATMAP_ROW_HEIGHT;
      if (i % 2 == 0) {
        for (float x = GUTTER_LEFT_X; x < GUTTER_RIGHT_X; x += 4) {
          point(x, y);
        }
      }
      i++;
    }
  }
  
  private void drawOverlaps() {
    pushMatrix();
    pushStyle();
    
    noStroke();
    ellipseMode(RADIUS);
    rectMode(RADIUS);
    
    int yIndex = 0;
    float maxArea = pow(HEATMAP_ROW_HEIGHT * 0.7, 2) * PI;
    float maxJobTypeJaccard = model.getMaxJobTypeJaccard();
    for(String devType1 : model.getDevTypesBySatisfaction()) {
      
      int xIndex = 0;
      for(String devType2 : model.getDevTypesBySatisfaction()) {
        float x = GUTTER_LEFT_X + xIndex * WIDTH_PER_DEV_TYPE + WIDTH_PER_DEV_TYPE / 2;
        float y = yIndex * HEATMAP_ROW_HEIGHT;
        float overlap = model.getOverlapJaccardForDevType(devType1, devType2);
        
        float circleArea = map(overlap, 0, maxJobTypeJaccard, 0, maxArea);
        float circleRadius = sqrt(circleArea / PI);
        
        if (devType1.equals(devType2)) {
          fill(MID_GRAY);
          rect(x, y, 3, 3);
        } else {
          fill(TECH_BLUE);
          ellipse(x, y, circleRadius, circleRadius);
        }
        
        xIndex++;
      }  
      
      yIndex++;
    }
    
    popStyle();
    popMatrix();
  }
  
  private void drawRatios() {
    pushMatrix();
    pushStyle();
    
    noStroke();
    rectMode(CORNER);
    textFont(TINY_FONT);
    textAlign(LEFT, CENTER);
    fill(LIGHT_GRAY);
    
    int yIndex = 0;
    for(String devType : model.getDevTypesBySatisfaction()) {
      float y = yIndex * HEATMAP_ROW_HEIGHT;
      float ratio = model.getSatisfactionRatio(devType);
      float barWidth = getSatisfactionRatioWidth(ratio);
      
      rect(GUTTER_RIGHT_X + 2, y - 2, barWidth, 5);
      text(nfc(ratio, 1), GUTTER_RIGHT_X + 4 + barWidth, y);
      
      yIndex++;
    }
    
    popStyle();
    popMatrix();
  }
  
  private void drawAxis() {
    pushMatrix();
    pushStyle();
    
    textFont(TINY_FONT);
    textAlign(CENTER, CENTER);
    
    float y = HEATMAP_ROW_HEIGHT * 24 + 20;
    float rightX = GUTTER_LEFT_X - 30;
    float leftX = rightX - 50;
    
    noStroke();
    fill(VERY_LIGHT_GRAY);
    ellipseMode(RADIUS);
    ellipse(leftX, y, HEATMAP_ROW_HEIGHT * 0.7, HEATMAP_ROW_HEIGHT * 0.7);
    
    noStroke();
    fill(MID_GRAY);
    text(nfc(model.getMaxJobTypeJaccard(), 1), leftX, y - 14);
    
    noFill();
    stroke(LIGHT_GRAY);
    line(rightX - 5, y, leftX + 10, y);
    
    noStroke();
    fill(MID_GRAY);
    text("0", rightX, y - 14);
    
    popStyle();
    popMatrix();
  }
  
  private float getSatisfactionRatioWidth(float ratio) {
    return map(ratio, 1, model.getMaxSatisfactionRatio(), 0, 60);
  }

}


class RespondentCountView {
  
  private final PVector pos;
  private final DataModel model;
  
  public RespondentCountView(PVector newPos, DataModel newModel) {
    pos = newPos;
    model = newModel;
  }
  
  public void draw() {
    pushMatrix();
    pushStyle();
    
    translate(pos.x, pos.y);
    
    drawTitle();
    drawCounts();
    
    popStyle();
    popMatrix();
  }
  
  private void drawTitle() {
    pushMatrix();
    pushStyle();
    
    noFill();
    stroke(VERY_LIGHT_GRAY);
    line(GUTTER_LEFT_X, 14, GUTTER_LEFT_X, COUNTS_HEIGHT - 4);
    
    noStroke();
    fill(NEAR_BLACK);
    textAlign(LEFT, CENTER);
    textFont(SMALL_FONT);
    text("Num\nRespondents", GUTTER_RIGHT_X + 12, COUNTS_HEIGHT / 2);
    
    fill(MID_GRAY);
    textFont(TINY_FONT);
    textAlign(CENTER, CENTER);
    text("0", GUTTER_LEFT_X + 2, 10);
    text(nfc(model.getMaxDevTypeCount() / 1000.0, 1) + "k", GUTTER_LEFT_X + 2, COUNTS_HEIGHT);
    
    popStyle();
    popMatrix();
  }
  
  private void drawCounts() {
    pushMatrix();
    pushStyle();
    
    int i = 0;
    for(String devType : model.getDevTypesBySatisfaction()) {
      float x = GUTTER_LEFT_X + WIDTH_PER_DEV_TYPE * i + WIDTH_PER_DEV_TYPE / 2;
      int count = model.getCountForDevType(devType);
      
      float barHeight = getBarHeight(count);
      noStroke();
      fill(VERY_LIGHT_GRAY);
      rectMode(CORNER);
      rect(x - 7, 10, 14, barHeight);
      
      fill(LIGHT_GRAY);
      textFont(TINY_FONT);
      textAlign(CENTER, CENTER);
      text(nfc(count / 1000.0, 1) + "k", x, 5);
      
      i++;
    }
    
    popStyle();
    popMatrix();
  }
  
  private float getBarHeight(int count) {
    return map(count, 0, model.getMaxDevTypeCount(), 0, COUNTS_HEIGHT - 10);
  }

}
