// Unit tests for OPDSure.
//
// The previous template test (a counter-app smoke test) was fully commented
// out, so the file had no `main()` entry point and failed to load in CI
// ("0 tests passed, 1 failed"). It also referenced `OpdSureApp()` with no
// arguments, which does not match the current app — `OpdSureApp` requires
// `clients` and `store` and bootstraps SharedPreferences, Hive, network
// clients, Provider and GoRouter, which cannot be constructed in a plain test
// without heavy mocking and real I/O.
//
// Instead, these tests exercise the app's own pure, deterministic logic
// (AppConfig constants and CommonMethods helpers). They run with no external
// dependencies and give the CI `flutter test` step real, meaningful coverage.

import 'package:flutter_test/flutter_test.dart';
import 'package:opdsure/config/app_config.dart';
import 'package:opdsure/utils/common_methods.dart';

void main() {
  group('AppConfig', () {
    test('application name is OPD Sure', () {
      expect(AppConfig.applicationName, 'OPD Sure');
    });

    test('default base URL points to the OPDSure API host', () {
      expect(AppConfig.defaultBaseUrl, 'api.opdsure.net');
    });
  });

  group('CommonMethods.genderKey', () {
    test('maps gender labels to their keys', () {
      expect(CommonMethods.genderKey('Male'), '1');
      expect(CommonMethods.genderKey('Female'), '2');
      expect(CommonMethods.genderKey('Other'), '3');
    });

    test('returns empty string for unknown labels', () {
      expect(CommonMethods.genderKey('Unknown'), '');
    });
  });

  group('CommonMethods.getGenderByKey', () {
    test('maps keys back to gender labels', () {
      expect(CommonMethods.getGenderByKey(1), 'Male');
      expect(CommonMethods.getGenderByKey(2), 'Female');
      expect(CommonMethods.getGenderByKey(3), 'Other');
    });

    test('returns empty string for unknown keys', () {
      expect(CommonMethods.getGenderByKey(99), '');
    });

    test('round-trips with genderKey', () {
      for (final label in ['Male', 'Female', 'Other']) {
        final key = int.parse(CommonMethods.genderKey(label));
        expect(CommonMethods.getGenderByKey(key), label);
      }
    });
  });

  group('CommonMethods.getClaimNameById', () {
    test('maps claim ids to names', () {
      expect(CommonMethods.getClaimNameById('0'), 'OPD');
      expect(CommonMethods.getClaimNameById('1'), 'PHARMACY');
      expect(CommonMethods.getClaimNameById('2'), 'LAB TEST');
    });

    test('defaults to OPD for unknown ids', () {
      expect(CommonMethods.getClaimNameById('999'), 'OPD');
    });
  });

  group('CommonMethods.amountFormater', () {
    test('formats integer amounts with Indian grouping', () {
      expect(CommonMethods.amountFormater('100000'), '1,00,000');
    });
  });
}
