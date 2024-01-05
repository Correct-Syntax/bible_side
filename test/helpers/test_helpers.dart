import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bible_side/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:bible_side/services/bibles_service.dart';
import 'package:bible_side/services/settings_service.dart';
import 'package:bible_side/services/app_info_service.dart';
import 'package:bible_side/services/side_navigation_service.dart';
import 'package:bible_side/services/reader_service.dart';
import 'package:bible_side/services/json_service.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<NavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BottomSheetService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<DialogService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<BiblesService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SettingsService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<AppInfoService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<SideNavigationService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<ReaderService>(onMissingStub: OnMissingStub.returnDefault),
  MockSpec<JsonService>(onMissingStub: OnMissingStub.returnDefault),
// @stacked-mock-spec
])
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService();
  getAndRegisterDialogService();
  getAndRegisterBiblesService();
  getAndRegisterSettingsService();
  getAndRegisterAppInfoService();
  getAndRegisterSideNavigationService();
  getAndRegisterReaderService();
  getAndRegisterJsonService();
// @stacked-mock-register
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();

  when(service.showCustomSheet<T, T>(
    enableDrag: anyNamed('enableDrag'),
    enterBottomSheetDuration: anyNamed('enterBottomSheetDuration'),
    exitBottomSheetDuration: anyNamed('exitBottomSheetDuration'),
    ignoreSafeArea: anyNamed('ignoreSafeArea'),
    isScrollControlled: anyNamed('isScrollControlled'),
    barrierDismissible: anyNamed('barrierDismissible'),
    additionalButtonTitle: anyNamed('additionalButtonTitle'),
    variant: anyNamed('variant'),
    title: anyNamed('title'),
    hasImage: anyNamed('hasImage'),
    imageUrl: anyNamed('imageUrl'),
    showIconInMainButton: anyNamed('showIconInMainButton'),
    mainButtonTitle: anyNamed('mainButtonTitle'),
    showIconInSecondaryButton: anyNamed('showIconInSecondaryButton'),
    secondaryButtonTitle: anyNamed('secondaryButtonTitle'),
    showIconInAdditionalButton: anyNamed('showIconInAdditionalButton'),
    takesInput: anyNamed('takesInput'),
    barrierColor: anyNamed('barrierColor'),
    barrierLabel: anyNamed('barrierLabel'),
    customData: anyNamed('customData'),
    data: anyNamed('data'),
    description: anyNamed('description'),
  )).thenAnswer((realInvocation) => Future.value(showCustomSheetResponse ?? SheetResponse<T>()));

  locator.registerSingleton<BottomSheetService>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockBiblesService getAndRegisterBiblesService() {
  _removeRegistrationIfExists<BiblesService>();
  final service = MockBiblesService();
  locator.registerSingleton<BiblesService>(service);
  return service;
}

MockSettingsService getAndRegisterSettingsService() {
  _removeRegistrationIfExists<SettingsService>();
  final service = MockSettingsService();
  locator.registerSingleton<SettingsService>(service);
  return service;
}

MockAppInfoService getAndRegisterAppInfoService() {
  _removeRegistrationIfExists<AppInfoService>();
  final service = MockAppInfoService();
  locator.registerSingleton<AppInfoService>(service);
  return service;
}

MockSideNavigationService getAndRegisterSideNavigationService() {
  _removeRegistrationIfExists<SideNavigationService>();
  final service = MockSideNavigationService();
  locator.registerSingleton<SideNavigationService>(service);
  return service;
}

MockReaderService getAndRegisterReaderService() {
  _removeRegistrationIfExists<ReaderService>();
  final service = MockReaderService();
  locator.registerSingleton<ReaderService>(service);
  return service;
}

MockJsonService getAndRegisterJsonService() {
  _removeRegistrationIfExists<JsonService>();
  final service = MockJsonService();
  locator.registerSingleton<JsonService>(service);
  return service;
}
// @stacked-mock-create

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
