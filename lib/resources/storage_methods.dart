import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadimage(
      String childname, Uint8List file, bool isposted) async {
    Reference ref =
        _storage.ref().child(childname).child(_auth.currentUser!.uid);

    if (isposted) {
      String id = Uuid().v1();
      ref=ref.child(id);
    }
    UploadTask uploadTask = ref.putData(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    TaskSnapshot snap = await uploadTask;
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }
}
