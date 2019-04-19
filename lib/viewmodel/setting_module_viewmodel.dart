import 'package:flutter_weather/commom_import.dart';

class SettingModuleViewModel extends ViewModel {
  final pageModules = StreamController<List<PageModule>>();

  List<PageModule> _cacheModules = List();

  SettingModuleViewModel() {
    _cacheModules.addAll(SharedDepository().pageModules);
    streamAdd(pageModules, _cacheModules);
  }

  /// 拖动后改变列表中元素位置
  void indexChange(int before, int after) {
    final beforeModule = _cacheModules[before];
    _cacheModules.removeAt(before);
    _cacheModules.insert(after, beforeModule);

    SharedDepository().setPageModules(_cacheModules);
    streamAdd(pageModules, _cacheModules);
  }

  /// 每个module是否开启
  void valueChange(bool open, {@required String module}) {
    _cacheModules.firstWhere((v) => v.module == module).open = open;
    SharedDepository().setPageModules(_cacheModules);
    streamAdd(pageModules, _cacheModules);
  }

  @override
  void dispose() {
    _cacheModules.clear();

    pageModules.close();

    super.dispose();
  }
}
