import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../api/api_service.dart';

class RmaProvider extends ChangeNotifier {
  List<Rma> _rmas = [];
  List<RmaReason> _reasons = [];
  bool _isLoading = false;
  String? _error;

  final ApiService _apiService = ApiService();

  List<Rma> get rmas => _rmas;
  List<RmaReason> get reasons => _reasons;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRmas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _rmas = await _apiService.getRmas();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading RMAs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadReasons() async {
    if (_reasons.isNotEmpty) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _reasons = await _apiService.getRmaReasons();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading RMA reasons: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Rma?> createRma(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final rma = await _apiService.createRma(data);
      _rmas.insert(0, rma);
      return rma;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error creating RMA: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Rma?> getRmaDetail(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      return await _apiService.getRmaDetail(id);
    } catch (e) {
      _error = e.toString();
      debugPrint('Error fetching RMA detail: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
