import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'company_provider.dart';

/// A provider that returns the BHS score object based on the current company
final bhsProvider = Provider<AsyncValue<Map<String, dynamic>>>((ref) {
  final companyState = ref.watch(companyStreamProvider);
  
  return companyState.whenData((company) {
    if (company == null) {
      return {
        'overallScore': 0.0,
        'categories': <String, int>{},
      };
    }
    
    // Parse from Firestore if exists
    final Map<String, dynamic> bhsScores = company['bhs_scores'] ?? <String, dynamic>{};
    
    return {
      'overallScore': (company['bhsScore'] ?? 0).toDouble(),
      'categories': {
        'chs': bhsScores['chs'] ?? 82, // fallback to previous mock if missing
        'fhs': bhsScores['fhs'] ?? 75,
        'hps': bhsScores['hps'] ?? 68,
        'shs': bhsScores['shs'] ?? 0,
        'oes': bhsScores['oes'] ?? 71,
        'gos': bhsScores['gos'] ?? 85,
      },
    };
  });
});

