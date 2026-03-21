import 'package:flutter/material.dart';
import '../models/location_matrix.dart';

class LocationMatrixNotifier extends ChangeNotifier {
  final List<LocationMatrix> _matrices = [];

  List<LocationMatrix> get matrices => List.unmodifiable(_matrices);

  void addMatrix(LocationMatrix matrix) {
    _matrices.add(matrix);
    notifyListeners();
  }

  void updateMatrix(int index, LocationMatrix matrix) {
    if (index >= 0 && index < _matrices.length) {
      _matrices[index] = matrix;
      notifyListeners();
    }
  }

  void deleteMatrix(int index) {
    if (index >= 0 && index < _matrices.length) {
      _matrices.removeAt(index);
      notifyListeners();
    }
  }
}
