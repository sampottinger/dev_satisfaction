DataModel model;

HeaderView headerView;
DevTypeOverview devTypeOverview;
FactorsView factorsView;
DevTypeOverlapView devTypeOverlapView;
RespondentCountView respondentCountView;


void setup() {
  
  // Prep
  loadSemiconstants();
  model = new DataModel();
  println("Loaded data");
  size(1400, 910);
  background(WHITE);
  
  // Create elements
  headerView = new HeaderView(new PVector(0, 0));
  devTypeOverview = new DevTypeOverview(new PVector(GUTTER_LEFT_X, DEV_TYPE_Y), model);
  factorsView = new FactorsView(new PVector(0, FACTORS_Y), model);
  devTypeOverlapView = new DevTypeOverlapView(new PVector(0, HEATMAP_Y), model);
  respondentCountView = new RespondentCountView(new PVector(0, COUNTS_Y), model);
  
  // Draw
  headerView.draw();
  devTypeOverview.draw();
  factorsView.draw();
  devTypeOverlapView.draw();
  respondentCountView.draw();
  
  // Save out
  save("dev_happiness.png");
  println("Saved image");
}
