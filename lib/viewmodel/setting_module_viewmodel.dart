import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/page_module_data.dart';
import 'package:flutter_weather/model/holder/shared_depository.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class SettingModuleViewModel extends ViewModel {
  final pageModules = StreamController<List<PageModule>>();

  final List<PageModule> _cacheModules = [];

  SettingModuleViewModel() {
    _cacheModules.addAll(SharedDepository().pageModules);
    pageModules.safeAdd(_cacheModules);
  }

  /// 拖动后改变列表中元素位置
  void indexChange(int before, int after) {
    final beforeModule = _cacheModules[before];
    _cacheModules.removeAt(before);
    _cacheModules.insert(after, beforeModule);

    SharedDepository().setPageModules(_cacheModules);
    pageModules.safeAdd(_cacheModules);
  }

  /// 每个module是否开启
  void valueChange(bool open, {@required String module}) {
    _cacheModules.firstWhere((v) => v.module == module).open = open;
    SharedDepository().setPageModules(_cacheModules);
    pageModules.safeAdd(_cacheModules);
  }

  @override
  void dispose() {
    _cacheModules.clear();

    pageModules.close();

    super.dispose();
  }
}
