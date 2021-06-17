library firestore_service;

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Base service to interface with firestore and standardise all requests
class FirestoreService {
  // Private named constructor
  FirestoreService._();
  // when instance gets called in the database service it constructs an instance
  // of this class with the private constructor. This makes the functions within
  // this class available for use.
  static final instance = FirestoreService._();

  // ******************* Core Delete, Add and Edit Functions *******************

  /// add a new or edit an existing document
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<void> deleteData({
    required String path,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  /// add a new item to a collection and auto assign a id
  Future<T> addDocumentToCollection<T>({
    required String path,
    required Map<String, dynamic> data,
    required T Function(
      Map<String, dynamic> data,
      DocumentReference<Map<String, dynamic>> documentReference,
    )
        builder,
  }) async {
    final reference = FirebaseFirestore.instance.collection(path);
    final DocumentReference<Map<String, dynamic>> doc =
        await reference.add(data);
    return builder(data, doc);
  }

  // ******************* Core Read Functions *******************

  // ******************* Stream Functions *******************

  /// creates a stream of a firestore collection and parses it to a new datatype
  /// with the builder function
  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  /// return a stream of documents parsed to a new datatype with the builder
  /// function.
  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  // ******************* Snapshot Functions *******************

  /// Creates a snapshot of a firestore collection and parses it to a new
  /// datatype with the builder function
  Future<List<T>> collectionSnapshot<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) async {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
    final result = snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  /// Get a snapshot of a firestore document parsed to a new datatype with the
  /// builder function
  Future<T> documentSnapshot<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) async {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await reference.get();
    return builder(snapshot.data(), snapshot.id);
  }
}
