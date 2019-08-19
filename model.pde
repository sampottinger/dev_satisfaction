/**
 * Data access layer for the visualization including DTO models.
 *
 * Data access layer for the visualization including data transfer objects to be used within the
 * larger visualization. This is released under the MIT license. See LICENSE.txt.
 */

import java.util.*;
import java.util.stream.Collectors;


/**
 * Entry point for querying the dataset.
 */
class DataModel {

  private Map<String, Float> devTypeSatisfaction;
  private Map<String, Integer> devTypeCounts;
  private Map<String, Float> devTypeCompensation;
  private Map<String, Float> devTypeOverlapJaccard;
  private Map<String, Map<String, FactorRanking>> devTypeFactorRanking;
  private Map<String, Integer> factorCounts;
  private List<String> devTypesBySatisfaction;
  private List<String> factorsByPopulation;

  private float maxSatisfactionRatio;
  private int maxDevTypeCount;
  private float maxDevTypeCompensation;
  private int maxFactorPopulation;
  private float maxJobTypeJaccard;

  /**
   * Create a new data model and load data from disk.
   */
  public DataModel() {
    loadDevTypeSatisfaction();
    loadDevTypeCounts();
    loadDevTypeCompensation();
    loadDevTypeOverlapJaccards();
    loadDevTypeFactorRankings();
    loadFactorCounts();
    loadDevTypeOverlapJaccards();
  }

  /**
   * Get the list of developer types.
   *
   * @return List of developer types ordered by ascending satisfaction ratio.
   */
  public List<String> getDevTypesBySatisfaction() {
    return devTypesBySatisfaction;
  }

  /**
   * Get the job factors investigated by the survey.
   *
   * @return List of job factors ordered descending by the number of times that factor was selected.
   */
  public List<String> getFactorsByPopulation() {
    return factorsByPopulation;
  }

  /**
   * Get the satisfaction ratio for a given developer type.
   *
   * @param devType The name of the developer type for which a satisfaction ratio should be
   *    returned.
   * @return The number of people identifying with a developer type that are satisfied divided by
   *    the number of people identifying with a developer type that are dissatisfied.
   */
  public float getSatisfactionRatio(String devType) {
    return devTypeSatisfaction.get(devType);
  }

  /**
   * Get the number of respondents identifying as a developer type.
   *
   * @param devType The name of the developer type.
   * @return The number of respondents identifying as that developer type.
   */
  public int getCountForDevType(String devType) {
    return devTypeCounts.get(devType);
  }

  /**
   * Get the median converted USD compensation for a developer type.
   *
   * @param devType The name of the developer type.
   * @return The median compensation for that developer type.
   */
  public float getCompensationForDevType(String devType) {
    return devTypeCompensation.get(devType);
  }

  /**
   * Get the Jaccard index for shared respondents between two developer types.
   *
   * @param devType1 The first developer type.
   * @param devType2 The second developer type.
   * @return The amount of overlap 0 to 1 between the two given developer types.
   */
  public float getOverlapJaccardForDevType(String devType1, String devType2) {
    String pairKey = getKeyForDevTypes(devType1, devType2);
    return devTypeOverlapJaccard.getOrDefault(pairKey, 0.0);
  }

  /**
   * Get the ranking of factors for a given developer type.
   *
   * @param devType The name of the developer type.
   * @return Map from name of job factor to information about that factor's ranking for respondents
   *    identifying with the given devType.
   */
  public Map<String, FactorRanking> getFactorRanking(String devType) {
    return devTypeFactorRanking.get(devType);
  }

  /**
   * Get the number of times a job factor was indicated as important across all dev types.
   *
   * @param factor The name of the factor whose count should be returned.
   * @return The number of times the given factor was indicated as important across all dev types.
   */
  public int getFactorCount(String factor) {
    return factorCounts.get(factor);
  }

  /**
   * Get the highest satisfaction ratio seen across all dev types.
   *
   * @return The highest satisfaction ratio seen across all dev types.
   */
  public float getMaxSatisfactionRatio() {
    return maxSatisfactionRatio;
  }

  /**
   * Get the count of respondents seen for the dev type with the most respondents.
   *
   * @return The largest count of individuals reporting as a given devType.
   */
  public int getMaxDevTypeCount() {
    return maxDevTypeCount;
  }

  /**
   * Get the maximum USD median compensation seen among the dev types.
   *
   * @return The median compensation seen across dev types.
   */
  public float getMaxDevTypeCompensation() {
    return maxDevTypeCompensation;
  }

  /**
   * Get the maximum times a job factor was seen as important.
   *
   * @return The maximum times a job factor was marked as importnat.
   */
  public int getMaxFactorPopulation() {
    return maxFactorPopulation;
  }

  /**
   * Get the maximum jaccard score seen across all pairs of dev types.
   *
   * @return The maximum observed jaccard score.
   */
  public float getMaxJobTypeJaccard() {
    return maxJobTypeJaccard;
  }

  /**
   * Load information on dev type satisfaction.
   */
  private void loadDevTypeSatisfaction() {
    devTypeSatisfaction = new HashMap<>();

    maxSatisfactionRatio = 0;

    Table table = loadTable("dev_type_satisfaction_summary.csv", "header");
    for (TableRow row : table.rows()) {
      String devType = row.getString("devType");

      float satisfiedCount = row.getFloat("satisfiedCount");
      float dissatisfiedCount = row.getFloat("dissatisfiedCount");
      float satisfiedRatio = satisfiedCount / dissatisfiedCount;

      maxSatisfactionRatio = max(satisfiedRatio, maxSatisfactionRatio);

      devTypeSatisfaction.put(devType, satisfiedRatio);
    }

    devTypesBySatisfaction = devTypeSatisfaction.entrySet().stream()
      .sorted(Map.Entry.comparingByValue())
      .map((x) -> x.getKey())
      .collect(Collectors.toList());
  }

  /**
   * Load information on how many times each dev type was seen.
   */
  private void loadDevTypeCounts() {
    devTypeCounts = new HashMap<>();
    maxDevTypeCount = 0;

    Table table = loadTable("dev_type_counts.csv", "header");
    for (TableRow row : table.rows()) {
      String devType = row.getString("devType");
      int count = row.getInt("respondentCount");
      maxDevTypeCount = max(maxDevTypeCount, count);
      devTypeCounts.put(devType, count);
    }
  }

  /**
   * Load compensation information.
   */
  private void loadDevTypeCompensation() {
    devTypeCompensation = new HashMap<>();
    maxDevTypeCompensation = 0;

    Table table = loadTable("dev_type_comp.csv", "header");
    for (TableRow row : table.rows()) {
      String devType = row.getString("devType");
      float comp = row.getFloat("compensation");
      maxDevTypeCompensation = max(maxDevTypeCompensation, comp);
      devTypeCompensation.put(devType, comp);
    }
  }

  /**
   * Load information on the overlap between devTypes.
   */
  private void loadDevTypeOverlapJaccards() {
    devTypeOverlapJaccard = new HashMap<>();
    maxJobTypeJaccard = 0;

    Table table = loadTable("dev_type_to_dev_type_jaccard.csv", "header");
    for (TableRow row : table.rows()) {
      String devTypeSource = row.getString("devTypeSource");
      String devTypeDestination = row.getString("devTypeDestination");
      String pairKey = getKeyForDevTypes(devTypeSource, devTypeDestination);
      float jaccard = row.getFloat("jaccard");
      maxJobTypeJaccard = max(maxJobTypeJaccard, jaccard);
      devTypeOverlapJaccard.put(pairKey, jaccard);
    }
  }

  /**
   * Load ranking information about job factors across dev types.
   */
  private void loadDevTypeFactorRankings() {
    Map<String, List<ScoredFactor>> factorsByDevType = new HashMap<>();
    devTypeFactorRanking = new HashMap<>();

    Table table = loadTable("job_factor_to_dev_type_percent.csv", "header");
    for (TableRow row : table.rows()) {
      String devType = row.getString("devType");

      if (!factorsByDevType.containsKey(devType)) {
        factorsByDevType.put(devType, new ArrayList<>());
      }

      String name = row.getString("jobFactor");
      float score = row.getFloat("percentReporting");
      factorsByDevType.get(devType).add(new ScoredFactor(name, score));
    }

    for (String devType : factorsByDevType.keySet()) {
      List<ScoredFactor> factors = factorsByDevType.get(devType);
      Collections.sort(factors, Collections.reverseOrder());

      int numFactors = factors.size();
      Map<String, FactorRanking> factorRankings = new HashMap<>();
      for (int i = 0; i < numFactors; i++) {
        ScoredFactor scoredFactor = factors.get(i);
        factorRankings.put(scoredFactor.getFactorName(), scoredFactor.getAsRanking(i));
      }

      devTypeFactorRanking.put(devType, factorRankings);
    }
  }

  /**
   * Load information about how many times a job factor was marked as important.
   */
  private void loadFactorCounts() {
    factorCounts = new HashMap<>();
    maxFactorPopulation = 0;

    Table table = loadTable("job_factor_counts.csv", "header");
    for (TableRow row : table.rows()) {
      String devType = row.getString("jobFactor");
      int count = row.getInt("respondentCount");
      maxFactorPopulation = max(maxFactorPopulation, count);
      factorCounts.put(devType, count);
    }

    factorsByPopulation = factorCounts.entrySet().stream()
      .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
      .map((x) -> x.getKey())
      .collect(Collectors.toList());
  }

  /**
   * Generate a key that uniquely identifies a pair of dev types.
   *
   * Generate a key that uniquely identifies a pair of dev types such that the same key will be
   * given no matter what order the dev types are provided.
   *
   * @param devType1 The first dev type in the pair.
   * @param devType2 The second dev type in the pair.
   * @return The key for this pair.
   */
  public String getKeyForDevTypes(String devType1, String devType2) {
    if (devType1.compareTo(devType2) > 0) {
      return devType1 + "\t" + devType2;
    } else {
      return devType2 + "\t" + devType1;
    }
  }

}


/**
 * Job factor with scoring information (how often that factor was marked as important).
 */
class ScoredFactor implements Comparable<ScoredFactor>{

  private final String factorName;
  private final float score;

  /**
   * Create a new scored job factor.
   *
   * @param newFactorName The name of the job factor.
   * @param newScore Score for how often that job factor was seen as important.
   */
  public ScoredFactor(String newFactorName, float newScore) {
    factorName = newFactorName;
    score = newScore;
  }

  /**
   * Get the human readable name for this factor.
   *
   * @return The name of this factor.
   */
  public String getFactorName() {
    return factorName;
  }

  /**
   * Get the frequency or popularity score for this factor.
   *
   * @return Measure of how often this factor was seen as important.
   */
  public float getScore() {
    return score;
  }

  /**
   * Compare this factor to another on score.
   *
   * @param other The factor to compare this factor against.
   * @return >0 if this factor has a higher score, 0 if they are the same, and <0x if lower.
   */
  public int compareTo(ScoredFactor other) {
    Float thisScore = getScore();
    Float otherScore = other.getScore();
    return thisScore.compareTo(otherScore);
  }

  /**
   * Create a FactorRanking from this ScoredFactor given a rank.
   *
   * @param rank The rank to associate with this factor.
   * @return A FactorRanking with this ScoredFactor's data as well as the given rank.
   */
  public FactorRanking getAsRanking(int rank) {
    return new FactorRanking(getFactorName(), rank, getScore());
  }

}


/**
 * A job factor that is scored and ranked based on how often that factor was marked as important.
 */
class FactorRanking {

  private final String factorName;
  private final int ranking;
  private final float score;

  /**
   * Create a new record which describes a job factor.
   *
   * @param newFactorName The name of the job factor.
   * @param newRanking The rank of this job factor within some parent series.
   * @param newScore Score indicating how frequently this factor was seen as important.
   */
  public FactorRanking(String newFactorName, int newRanking, float newScore) {
    factorName = newFactorName;
    ranking = newRanking;
    score = newScore;
  }

  /**
   * Get the human readable name for this factor.
   *
   * @return The name of this factor.
   */
  public String getFactorName() {
    return factorName;
  }


  /**
   * Get the rank (0, 1, 2, ...) of this score within this factor's parent population.
   *
   * @return Rank for this factor's score.
   */
  public int getRanking() {
    return ranking;
  }

  /**
   * Get the frequency or popularity score for this factor.
   *
   * @return Measure of how often this factor was seen as important.
   */
  public float getScore() {
    return score;
  }

}
