import 'package:appmetrica_plugin/appmetrica_plugin.dart' as m;
import 'package:decimal/decimal.dart' as d;

typedef AppMetricaAdType = m.AppMetricaAdType;
typedef Decimal = d.Decimal;
typedef UserProfile = m.AppMetricaUserProfile;
typedef StringAttribute = m.AppMetricaStringAttribute;
typedef AppMetricaErrorDescription = m.AppMetricaErrorDescription;

/// FROM appmetrica_plugin PACKAGE
/// The class to store Ad Revenue data. You can set:
/// * [adRevenue] - amount of money received via ad revenue (it cannot be negative);
/// * [currency] - Currency in which money from [adRevenue] is represented;
/// * [adType] - ad type;
/// * [adNetwork] - ad network. Maximum length is 100 symbols;
/// * [adUnitId] - id of ad unit. Maximum length is 100 symbols;
/// * [adUnitName] - name of ad unit. Maximum length is 100 symbols;
/// * [adPlacementId] - id of ad placement. Maximum length is 100 symbols;
/// * [adPlacementName] - name of ad placement. Maximum length is 100 symbols;
/// * [precision] - precision. Example: "publisher_defined", "estimated". Maximum length is 100 symbols;
/// * [payload] - arbitrary payload: additional info represented as key-value pairs. Maximum size is 30 KB.
class AppMetricaAdRevenue extends m.AppMetricaAdRevenue {
  /// Creates an object with information about income from in-app purchases. The parameters [adRevenue], [currency] are required.
  AppMetricaAdRevenue({
    required super.adRevenue,
    required super.currency,
    super.adType,
    super.adNetwork,
    super.adUnitId,
    super.adUnitName,
    super.adPlacementId,
    super.adPlacementName,
    super.precision,
    super.payload,
  });
}

