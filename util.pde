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


String getShortFactorName(String factorName) {
  return FACTOR_SHORT_NAMES.getOrDefault(factorName, factorName);
}
