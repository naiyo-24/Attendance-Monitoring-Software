
// ...existing imports...

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/location_matrix.dart';
import '../services/location_matrix_services.dart';

final locationMatrixNotifierProvider = ChangeNotifierProvider<LocationMatrixNotifier>((ref) => LocationMatrixNotifier());

class LocationMatrixNotifier extends ChangeNotifier {
  final LocationMatrixService _service = LocationMatrixService();
  final List<LocationMatrix> _matrices = [];
  bool _isLoading = false;
  String? _error;

  List<LocationMatrix> get matrices => List.unmodifiable(_matrices);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchMatrices(int adminId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final mats = await _service.getLocationMatricesByAdmin(adminId);
      _matrices.clear();
      _matrices.addAll(mats);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMatrix(LocationMatrix matrix) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final mat = await _service.createLocationMatrix(matrix);
      _matrices.insert(0, mat);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMatrix(LocationMatrix matrix, int adminId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final mat = await _service.updateLocationMatrix(matrix, adminId);
      final idx = _matrices.indexWhere((m) => m.locationMatrixId == mat.locationMatrixId);
      if (idx != -1) {
        _matrices[idx] = mat;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMatrix(int locationMatrixId, int adminId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _service.deleteLocationMatrix(locationMatrixId, adminId);
      _matrices.removeWhere((m) => m.locationMatrixId == locationMatrixId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
