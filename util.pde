/**
 * Misc utility functions for the developer satisfaction visualization.
 *
 * Misc utility functions for the developer satisfaction visualization, released under the MIT
 * license as described in LICENSE.txt.
 */


/**
 * Create a shortened name for a developer type.
 *
 * @param devType The original name for the developer type to be shortened.
 * @return Shorter name for that given developer type.
 */
String getDevTypeShort(String devType) {
  return devType.toLowerCase()
    .replace(" or ", " / ")
    .replace(" professional", "")
    .replace(" administrator", " admin")
    .replace("developer,", "")
    .replace("applications", "app")
    .replace("executive", "exec")
    .replace("application", "app")
    .replace("engineering", "eng")
    .replace("engineer", "eng")
    .replace("embedded", "embed")
    .replace("enterprise", "entrpse")
    .replace("entrpse app", "entrpse")
    .replace("machine learning specialist", "ML")
    .replace("-", " ")
    .replace(" researcher", "")
    .replace(" specialist", "")
    .replace("devices", "dev")
    .replace("marketing", "mrkting")
    .replace("data scientist", "data sci")
    .replace("business", "biz")
    .replace("analyst", "anlyst")
    .replace("eng, data", "data engineer");
}


/**
 * Create a shortened name for a job factor.
 *
 * @param devType The original name for the job factor to be shortened.
 * @return Shorter name for that given job factor.
 */
String getShortFactorName(String factorName) {
  return FACTOR_SHORT_NAMES.getOrDefault(factorName, factorName);
}
