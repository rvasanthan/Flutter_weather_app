import 'package:flutter_application_1/weather/model/pollen_model.dart';
import 'package:flutter_application_1/weather/model/visual_cross_model.dart';

class WeatherModel {
  late VisualCrossModel visualCrossModel;
  late PollenInfoModel pollenInfoModel;

  WeatherModel.getInstanceWithoutParams();
  WeatherModel.getInstance(this.visualCrossModel, this.pollenInfoModel);

  void setPollenInfoModel(PollenInfoModel pollenInfoModel) {
    this.pollenInfoModel = pollenInfoModel;
  }

  void setVisualCrossMode(VisualCrossModel visualCrossModel) {
    this.visualCrossModel = visualCrossModel;
  }

  VisualCrossModel getVisualCrossModel() {
    return visualCrossModel;
  }

}