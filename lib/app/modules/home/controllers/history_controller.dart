import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parking_portable/app/data/models/rekap_ticket.dart';
import 'package:parking_portable/app/data/services/parking_services.dart'; // contoh

class HistoryController extends GetxController
    with StateMixin<List<RekapTicket>> {
  final _page = 1.obs;
  final _isLoadingMore = false.obs;
  final _hasMore = true.obs;

  final List<RekapTicket> _items = [];

  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getData();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
  }

  Future<void> getData({bool refresh = true}) async {
    if (refresh) {
      _page.value = 1;
      _items.clear();
      _hasMore.value = true;
      change(null, status: RxStatus.loading());
    }

    try {
      final result = await ParkingServices.getRekap(page: _page.value);
      // result: List<RekapTicket>

      if (result.data?.isEmpty ?? true) {
        if (refresh) {
          change([], status: RxStatus.empty());
        } else {
          _hasMore.value = false;
        }
      } else {
        _items.addAll(result.data ?? []);
        change(_items, status: RxStatus.success());
        _page.value++;
      }
    } catch (e) {
      if (refresh) {
        change(null, status: RxStatus.error(e.toString()));
      }
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore.value || !_hasMore.value) return;

    _isLoadingMore.value = true;
    await getData(refresh: false);
    _isLoadingMore.value = false;
  }

  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMore => _hasMore.value;
}
