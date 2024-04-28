class PollenInfoModel {
  final List<dynamic> currentPollen;

  PollenInfoModel.fromMap(Map<String, dynamic> pollenInfo) 
    : currentPollen = pollenInfo['dailyInfo'][0]['pollenTypeInfo']
  ;
}