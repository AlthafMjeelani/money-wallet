import '../../../category/view/screen_category.dart';
import '../../../settings/screen_settings.dart';
import '../../../statistics/screen_satistics.dart';
import '../../view/screen_home.dart';

class ListOfPage {
 static List screens = [
    const ScreenHome(),
    const ScreenCategory(),
    const ScreenStatistics(),
    const ScreenSettings()
  ];
}
