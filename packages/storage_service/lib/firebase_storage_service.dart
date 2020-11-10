part of storage_service;

/// instance of the firebase storage service specific to the currently signed in user
/// so all uploads are enforced against the current user object
class FirebaseStorageService {
  final String uid;

  FirebaseStorageService({
    @required this.uid,
  }) : assert(uid != null);
  // assert used to validate the assumption that uid is not null

  // *********************** Generic Upload Methods ***********************

  // double _getUploadProgress(StorageTaskSnapshot snapshot) {
  //   int transferred = snapshot.bytesTransferred;
  //   int total = snapshot.totalByteCount;
  //   return (transferred / total * 100);
  // }

  /// Generic file upload for any [path] and [contentType]
  /// uploads file to firebase then returns the download url to the user
  Future<String> upload({
    @required File file,
    @required String path,
    @required String mimeType,
  }) async {
    // get a reference to the provided file path on firebase
    final storageReference = FirebaseStorage.instance.ref().child(path);
    try {
      // upload passed file to referenced filepath
      final uploadTask = await storageReference.putFile(
        file,
        SettableMetadata(
          contentType: mimeType,
        ),
      );
      // Url used to download file/image
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      rethrow;
    }
    // TODO - Display upload progress to user
    // // listen to the upload task and log the progress of the upload to the console.
    // uploadTask.events.listen((event) {
    //   double progress = _bytesTransferred(event.snapshot);
    //   // switch (event.snapshot.) {
    //   //     case firebase.storage.TaskState.PAUSED: // or 'paused'
    //   //       console.log('Upload is paused');
    //   //       break;
    //   //     case firebase.storage.TaskState.RUNNING: // or 'running'
    //   //       console.log('Upload is running');
    //   //       break;
    //   //   }
    // }).onError((error) {
    //   // some error handling
    //   throw error;
    // A full list of error codes is available at
    // https://firebase.google.com/docs/storage/web/handle-errors
    // switch (error.code) {
    //   case 'storage/unauthorized':
    //     // User doesn't have permission to access the object
    //     break;
    //   case 'storage/canceled':
    //     // User canceled the upload
    //     break;
    //   ...
    //   case 'storage/unknown':
    //     // Unknown error occurred, inspect error.serverResponse
    //     break;
    // }
    // });
  }

  // *********************** Specific Upload Methods ***********************

  Future<List<UploadAsset>> uploadAssets({
    @required List<UploadAsset> assets,
    @required Function(String uuid, UploadAsset asset) pathBuilder,
  }) async {
    // execute upload tasks for all content in paralell
    await Future.wait(
      assets.map(
        (asset) async {
          // generate universally unique identifier to use for file name
          String uuid = Uuid().v1();
          // execute upload task
          String downloadUrl = await upload(
            path: pathBuilder(uuid, asset),
            // File or Blob
            file: asset.file,
            mimeType: asset.mimeType,
          );
          // update class with download url
          asset.downloadUrl = downloadUrl;
        },
      ),
      // Entire future will resolve if any future throws an error
      eagerError: true,
      // Any completed futures before an error was thrown
      cleanUp: (_) {
        // do nothing
      },
    );
    return assets;
  }

  // Upload an avatar from file
  Future<List<UploadAsset>> uploadAvatar({
    @required List<UploadAsset> assets,
  }) async {
    return uploadAssets(
      assets: assets,
      pathBuilder: (String uuid, UploadAsset asset) {
        return 'users/$uid/avatar/$uuid.${_getFileExtension(mimeType: asset.mimeType)}';
      },
    );
  }

  String _getFileType({
    @required String mimeType,
  }) {
    List mimeDetails = mimeType.split('/');
    if (mimeDetails.length == 2) {
      return mimeDetails[0];
    }
    // unable to extract mime file type. Therefore file in misc folder.
    return 'misc';
  }

  String _getFileExtension({
    @required String mimeType,
  }) {
    List mimeDetails = mimeType.split('/');
    if (mimeDetails.length == 2) {
      return mimeDetails[1];
    }
    // unable to extract mime file type. Therefore file in misc folder.
    return 'unknown';
  }

  Future<List<UploadAsset>> uploadPostContent({
    @required List<UploadAsset> assets,
  }) async {
    return uploadAssets(
      assets: assets,
      pathBuilder: (String uuid, UploadAsset asset) {
        return 'users/$uid/posts/${_getFileType(mimeType: asset.mimeType)}/$uuid.${_getFileExtension(mimeType: asset.mimeType)}';
      },
    );
  }

  // Future<void> deletePostContent({@required PostModel post}) async {
  //   List<Future<StorageReference>> paralellRefs = [];
  //   for (var i = 0; i < post.post_content_urls.length; i++) {
  //     Map<String, dynamic> content = post.post_content_urls[i];
  //     var url = content['url'];
  //     // get a reference to the provided file path on firebase
  //     final ref = FirebaseStorage.instance.getReferenceFromUrl(url);
  //     paralellRefs.add(ref);
  //   }
  //   List<StorageReference> storageRefs = await Future.wait(paralellRefs);
  //   // paralell delete
  //   List<Future> paralellDelete = [];
  //   storageRefs.forEach((ref) {
  //     paralellDelete.add(ref.delete());
  //   });
  //   return Future.wait(paralellDelete);
  // }
}

class UploadAsset {
  File file;
  String mimeType;
  String downloadUrl;

  UploadAsset({
    @required this.file,
    @required this.mimeType,
    this.downloadUrl,
  });
}
