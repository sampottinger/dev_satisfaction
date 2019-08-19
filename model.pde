import java.util.*;
import java.util.stream.Collectors;


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
  
  public DataModel() {
    loadDevTypeSatisfaction();
    loadDevTypeCounts();
    loadDevTypeCompensation();
    loadDevTypeOverlapJaccards();
    loadDevTypeFactorRankings();
    loadFactorCounts();
    loadDevTypeOverlapJaccards();
  }
  
  public List<String> getDevTypesBySatisfaction() {
    return devTypesBySatisfaction;
  }
  
  public List<String> getFactorsByPopulation() {
    return factorsByPopulation;
  }
  
  public float getSatisfactionRatio(String devType) {
    return devTypeSatisfaction.get(devType);
  }
  
  public int getCountForDevType(String devType) {
    return devTypeCounts.get(devType);
  }
  
  public float getCompensationForDevType(String devType) {
    return devTypeCompensation.get(devType);
  }
  
  public float getOverlapJaccardForDevType(String devType1, String devType2) {
    String pairKey = getKeyForDevTypes(devType1, devType2);
    return devTypeOverlapJaccard.getOrDefault(pairKey, 0.0);
  }
  
  public Map<String, FactorRanking> getFactorRanking(String devType) {
    return devTypeFactorRanking.get(devType);
  }
  
  public int getFactorCount(String factor) {
    return factorCounts.get(factor);
  }
  
  public float getMaxSatisfactionRatio() {
    return maxSatisfactionRatio;
  }
  
  public int getMaxDevTypeCount() {
    return maxDevTypeCount;
  }
  
  public float getMaxDevTypeCompensation() {
    return maxDevTypeCompensation;
  }
  
  public int getMaxFactorPopulation() {
    return maxFactorPopulation;
  }
  
  public float getMaxJobTypeJaccard() {
    return maxJobTypeJaccard;
  }

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
  
  public String getKeyForDevTypes(String devType1, String devType2) {
    if (devType1.compareTo(devType2) > 0) {
      return devType1 + "\t" + devType2;
    } else {
      return devType2 + "\t" + devType1;
    }
  }
  
}


class ScoredFactor implements Comparable<ScoredFactor>{

  private final String factorName;
  private final float score;
  
  public ScoredFactor(String newFactorName, float newScore) {
    factorName = newFactorName;
    score = newScore;
  }
  
  public String getFactorName() {
    return factorName;
  }
  
  public float getScore() {
    return score;
  }
  
  public int compareTo(ScoredFactor other) {
    Float thisScore = getScore();
    Float otherScore = other.getScore();
    return thisScore.compareTo(otherScore);
  }
  
  public FactorRanking getAsRanking(int rank) {
    return new FactorRanking(getFactorName(), rank, getScore());
  }
  
}


class FactorRanking {
  
  private final String factorName;
  private final int ranking;
  private final float score;
  
  public FactorRanking(String newFactorName, int newRanking, float newScore) {
    factorName = newFactorName;
    ranking = newRanking;
    score = newScore;
  }
  
  public String getFactorName() {
    return factorName;
  }
  
  public int getRanking() {
    return ranking;
  }
  
  public float getScore() {
    return score;
  } 
  
}
