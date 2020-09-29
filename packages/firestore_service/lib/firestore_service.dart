library firestore_service;

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Base service to interface with firestore and standardise all requests
class FirestoreService {
  // Private named constructor
  FirestoreService._();
  // when instance gets called in the database service it constructs an instance
  // of this class with the private constructor. This makes the functions within
  // this class available for use.
  static final instance = FirestoreService._();

  // ******************* Core Delete, Add and Edit Functions *******************

  // base function to add a new or edit an existing document
  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(
      data,
    );
  }

  // base function to add a new item to a collection and auto assign a id
  Future<T> addDocumentToCollection<T>({
    @required String path,
    @required Map<String, dynamic> data,
    @required
        T Function(
                Map<String, dynamic> data, DocumentReference documentReference)
            builder,
  }) async {
    final reference = FirebaseFirestore.instance.collection(path);
    final DocumentReference doc = await reference.add(data);
    return builder(data, doc);
  }

  // base function to delete a document
  Future<void> deleteData({
    @required String path,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  // ******************* Core Read Functions *******************

  // ******************* Stream Functions *******************

  // base collection stream function - creates a stream of a firestore
  // collection and parses it to a new datatype with the builder function
  Stream<List<T>> collectionStream<T>({
    @required String path,
    // parsing callback function. Attempts to parse the returned documents to a
    // new datatype.
    @required T Function(DocumentSnapshot doc) builder,
    // passable firestore query extensions (.where etc.)
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  // base function to return a stream of documents parsed to a new datatype with
  // the builder function.
  Stream<T> documentStream<T>({
    @required String path,
    @required T Function(DocumentSnapshot doc) builder,
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot));
  }

  // ******************* Snapshot Functions *******************

  // Creates a snapshot of a firestore collection and parses it to a new
  // datatype with the builder function
  Future<List<T>> collectionSnapshot<T>({
    @required String path,
    // parsing callback function. Attempts to parse the returned documents to a
    // new datatype.
    @required T Function(DocumentSnapshot doc) builder,
    // passable firestore query extensions (.where etc.)
    Query Function(Query query) queryBuilder,
    int Function(T lhs, T rhs) sort,
  }) async {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final QuerySnapshot snapshot = await query.get();
    final result = snapshot.docs
        .map((snapshot) => builder(snapshot))
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  // Get a snapshot of a firestore document parsed to a new datatype with the
  // builder function
  Future<T> documentSnapshot<T>({
    @required String path,
    @required T Function(DocumentSnapshot doc) builder,
  }) async {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final DocumentSnapshot snapshot = await reference.get();
    return builder(snapshot);
  }
}
