

import 'package:cloud_firestore/cloud_firestore.dart';

class Api{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String  path;
  CollectionReference ref;

  Api({this.path,}) {
    ref = _db.collection(path);
  }

  // While calling this api If we want to use Future then have to add Api("path",ClassType).getDataCollection().get()
  // if stream then Api("path",ClassType).getDataCollection().snapshots()

  Future<QuerySnapshot<Object>>getDataCollection()  {
    return ref.get().catchError((error){
      
      throw Future.error(error);
    });
  }

  Future<QuerySnapshot<Object>> getDataCollectionByOtherCollectionID(String id,String idKey)  {
    return ref.where(idKey, isEqualTo: id).get().catchError((error){
     
      throw Future.error(error);
    });
  }

  Stream<QuerySnapshot<Object>> streamDataCollection()  {
    return ref.snapshots().handleError((error){
     
      throw Future.error(error);
    });
  }


  ///Todo will use this below code while we start to make table in firebase
  // Future<QuerySnapshot> getDataCollection()  {
  //   return ref.withConverter(
  //     fromFirestore: (snapshots, _) => model.fromJson(snapshots.data()!),
  //     toFirestore: (movie, _) => model.toJson(),
  //   ).orderBy(orderBy!).where(where!).get();
  // }
  //
  // Stream<QuerySnapshot> streamDataCollection(){
  //   return ref.withConverter(
  //     fromFirestore: (snapshots, _) => model.fromJson(snapshots.data()!),
  //     toFirestore: (movie, _) => model.toJson(),
  //   ).orderBy(orderBy!).where(where!).snapshots();
  // }

  Future<DocumentSnapshot<Object>> getDocumentById(String documentId) async {
    return await ref.doc(documentId).get().catchError((error){
      
      throw Future.error(error);
    });
  }
  Future<void> removeDocument(String documentId){
    return ref.doc(documentId).delete().then((value) {
    }).catchError((error){
      
      throw Future.error(error);
    });
  }

  Future<void> addDocument(Map<String, dynamic> data) {
    return ref.add(data).then((value) {
     // logger.d("doc id = ${value.id}");
    }).catchError((error){
      // logger.e(error);
      throw Future.error(error);
    });
  }

  Future<void> updateDoc(Map<String, Object> data , String documentId) {
    return ref.doc(documentId)
        .update(data)
        // .then((value) => logger.d("doc Updated"))
        .catchError((error) {
          // logger.e("Failed to update doc: $error");
          throw Future.error(error);
        });
  }

}