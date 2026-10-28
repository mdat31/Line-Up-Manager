import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recase/recase.dart';

class SearchService {
  Future<QuerySnapshot> searchByName(String searchField) async {
    Future<QuerySnapshot> result;
    String query = ReCase(searchField).titleCase;

    result = FirebaseFirestore.instance
        .collection('Player')
        .where('player_name', isGreaterThanOrEqualTo: query)
        .where("player_name", isLessThan: query + 'z')
        .limit(10)
        .get();

    return searchField.isEmpty ? null : result;
  }
}
