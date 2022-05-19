import 'package:city_guide/constants.dart';

class UtilRatingReview {
  static String averageRatingString(num ratingAverage, int ratingMaxVal) {
    if (ratingAverage == 0 || ratingMaxVal == 0) {
      return Constants.subtitleAvgRating + Constants.avgRatingStringDefault;
    }
    return Constants.subtitleAvgRating +
        ratingAverage.toStringAsFixed(1) +
        Constants.avgRatingStringSeparator +
        ratingMaxVal.toString();
  }
}
