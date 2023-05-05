import 'package:cloud_firestore/cloud_firestore.dart';

extension CustomGetters on DocumentSnapshot {
  int getInt(key) {
    return data().toString().contains(key) ? get(key) : 0;
  }

  String getString(key) {
    return data().toString().contains(key) ? get(key) : '';
  }

  List<String> getList(key) {
    return data().toString().contains(key)
        ? (get(key) as List).map((e) => e as String).toList()
        : [];
  }

  Timestamp getTimeStamp(key) {
    return data().toString().contains(key) ? get(key) : Timestamp(0, 0);
  }

  DateTime getDateFromTs(key) {
    return data().toString().contains(key)
        ? (get(key) as Timestamp).toDate()
        : DateTime(0);
  }
}