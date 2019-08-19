/**
 * Constants related to the running of the developer satisfaction visualization.
 *
 * Constants related to the running of the developer satisfaction visualization, released under the
 * MIT license as described in LICENSE.txt
 */

final int NEAR_BLACK = #333333;
final int MID_GRAY = #AAAAAA;
final int DARK_GRAY = #777777;
final int LIGHT_GRAY = #CCCCCC;
final int VERY_LIGHT_GRAY = #DDDDDD;
final int TECH_BLUE = #773581EC;
final int TECH_GREEN = #6CD071;
final int WHITE = #FAFAFA;

final int DEV_BAR_HEIGHT = 80;
final int DEV_BAR_LABEL_HEIGHT = 10;
final int DEV_BAR_HEIGHT_NO_LABEL = DEV_BAR_HEIGHT - DEV_BAR_LABEL_HEIGHT;

final int HEADER_HEIGHT = 48;

final int DEV_TYPE_Y = DEV_BAR_HEIGHT + 7 + HEADER_HEIGHT;
final int GUTTER_LEFT_X = 130;
final int GUTTER_RIGHT_X = 1310;
final int BODY_WIDTH = GUTTER_RIGHT_X - GUTTER_LEFT_X;
final int WIDTH_PER_DEV_TYPE = 50;
final int HEIGHT_PER_DEV_TYPE_LABEL = 50;

final int FACTOR_BAR_MAX_WIDTH = 80;

final int FACTORS_Y = DEV_TYPE_Y + DEV_BAR_HEIGHT + HEIGHT_PER_DEV_TYPE_LABEL + 40;
final int FACTOR_HEIGHT = 20;

final int HEATMAP_Y = FACTORS_Y + FACTOR_HEIGHT * 10 + 55;
final int HEATMAP_ROW_HEIGHT = 12;

final int COUNTS_Y = HEATMAP_Y + HEATMAP_ROW_HEIGHT * 24 + 10;
final int COUNTS_HEIGHT = 40;

List<Integer> FACTOR_COLORS;
Map<String, String> FACTOR_SHORT_NAMES;

PFont LARGE_FONT;
PFont MEDIUM_FONT;
PFont MEDIUM_FONT_BOLD;
PFont SMALL_FONT;
PFont SMALL_FONT_BOLD;
PFont TINY_FONT;

/**
 * Load constants which have be initialized after sketch initialization.
 */
void loadSemiconstants() {
  LARGE_FONT = loadFont("Lato-Regular-23.vlw");
  MEDIUM_FONT = loadFont("Lato-Regular-13.vlw");
  MEDIUM_FONT_BOLD = loadFont("Lato-Bold-13.vlw");
  SMALL_FONT = loadFont("Lato-Regular-10.vlw");
  SMALL_FONT_BOLD = loadFont("Lato-Bold-10.vlw");
  TINY_FONT = loadFont("Lato-Regular-8.vlw");

  FACTOR_COLORS = new ArrayList<>();
  FACTOR_COLORS.add(#a6cee3);
  FACTOR_COLORS.add(#1f78b4);
  FACTOR_COLORS.add(#b2df8a);
  FACTOR_COLORS.add(#33a02c);
  FACTOR_COLORS.add(#fb9a99);
  FACTOR_COLORS.add(#e31a1c);
  FACTOR_COLORS.add(#fdbf6f);
  FACTOR_COLORS.add(#ff7f00);
  FACTOR_COLORS.add(#cab2d6);
  FACTOR_COLORS.add(#6a3d9a);

  FACTOR_SHORT_NAMES = new HashMap<>();
  FACTOR_SHORT_NAMES.put("Diversity of the company or organization", "Diversity");
  FACTOR_SHORT_NAMES.put("Financial performance or funding status of the company or organization", "Company finances");
  FACTOR_SHORT_NAMES.put("Flex time or a flexible schedule", "Flex schedule");
  FACTOR_SHORT_NAMES.put("How widely used or impactful my work output would be", "Work impact");
  FACTOR_SHORT_NAMES.put("Industry that I'd be working in", "Industry");
  FACTOR_SHORT_NAMES.put("Languages, frameworks, and other technologies I'd be working with", "Tech / Libs for job");
  FACTOR_SHORT_NAMES.put("Office environment or company culture", "Culture");
  FACTOR_SHORT_NAMES.put("Opportunities for professional development", "Prof Dev");
  FACTOR_SHORT_NAMES.put("Remote work options", "Remote work");
  FACTOR_SHORT_NAMES.put("Specific department or team I'd be working on", "Specific team");
}
