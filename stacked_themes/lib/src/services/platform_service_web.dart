/// An abstraction over the Platform information so that we can have pure unit tests
class PlatformService {
  bool get isIos => false;
  bool get isAndroid => false;

  bool get isMobilePlatform => false;
}
