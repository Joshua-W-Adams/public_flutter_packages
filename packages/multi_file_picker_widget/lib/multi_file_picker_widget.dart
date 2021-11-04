library multi_file_picker_widget;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:custom_video_player/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:general_widgets/general_widgets.dart';

/// class to store generic information about a file so differnt file types can
/// be handled
class FileUploadModel {
  String? mimeType;
  File? file;
  String? url;

  FileUploadModel({
    this.mimeType,
    this.file,
    this.url,
  });
}

/// callback function to expose file and remove events
typedef AddRemoveFileFunction = void Function(
  List<FileUploadModel> files,
);

typedef FilePickerFunction = Future<File?> Function();

class MultiFilePicker extends StatefulWidget {
  final List<FileUploadModel>? fileModels;
  final int initialTileCount;
  final int maxTileCount;
  final double? height;
  final double? width;
  final AddRemoveFileFunction? addRemoveFileFunction;
  final FilePickerFunction? cameraImgPickerFunction;
  final FilePickerFunction? cameraVideoPickerFunction;
  final FilePickerFunction? galleryImgPickerFunction;
  final FilePickerFunction? galleryVideoPickerFunction;
  final String displayType;
  final String selectFileText;

  MultiFilePicker({
    this.fileModels,
    this.initialTileCount = 3,
    this.maxTileCount = 9,
    this.height,
    this.width,
    this.addRemoveFileFunction,
    this.cameraImgPickerFunction,
    this.cameraVideoPickerFunction,
    this.galleryImgPickerFunction,
    this.galleryVideoPickerFunction,
    this.displayType = 'grid',
    this.selectFileText = 'Select file',
  });

  @override
  _MultiFilePickerState createState() => _MultiFilePickerState();
}

class _MultiFilePickerState extends State<MultiFilePicker> {
  // Store array of files (img or video) to be displayed in the list tiles.
  List<Object> _files = [];

  @override
  void initState() {
    super.initState();
    if (widget.fileModels != null) {
      // load existing files
      _files = widget.fileModels!.map((fileModel) {
        Object f = fileModel;
        return f;
      }).toList();
      _handleTileDisplay();
    } else {
      // add dummy array of files
      for (var t = 0; t < widget.initialTileCount; t++) {
        _files.add('Add File');
      }
    }
  }

  void _clearFocus() {
    // get current focus and clears when the user taps anywhere on the
    // screen. Will not be fired if the user taps on another widget that
    // already has an onTap event.
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void _handleTileDisplay() {
    // check that minimum amount of tiles exists
    if (_files.length < widget.initialTileCount) {
      for (var f = 0; f < (widget.initialTileCount - _files.length + 1); f++) {
        _files.add('Add File');
      }
    }
    // check that maximum amount of tiles has not been exceeded
    if (_files.length != widget.maxTileCount) {
      // check that there is atleast one available upload tile
      var check = _files.where((file) {
        return file == 'Add File';
      });
      if (check.length == 0) {
        // add all missing tiles
        _files.add('Add File');
      }
    }
  }

  void _addFile({File? file, String? mimeType, required int index}) {
    FileUploadModel fileUpload = new FileUploadModel();
    fileUpload.mimeType = mimeType;
    fileUpload.file = file;
    // add file to current cache
    _files.replaceRange(index, index + 1, [fileUpload]);
    // send details top parent widget to allow handling of file operations
    widget.addRemoveFileFunction == null
        ? null
        : widget.addRemoveFileFunction!(
            _files.whereType<FileUploadModel>().toList(),
          );
    // ensure there are sufficient upload tiles displayed
    _handleTileDisplay();
  }

  void _removeFile(int index) {
    // replace file in current cache
    _files.removeAt(index);
    // send details top parent widget to allow handling of file operations
    widget.addRemoveFileFunction == null
        ? null
        : widget.addRemoveFileFunction!(
            _files.whereType<FileUploadModel>().toList(),
          );
    // ensure there are sufficient upload tiles displayed
    _handleTileDisplay();
  }

  void _selectFile(int index) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            widget.cameraImgPickerFunction == null
                ? Container()
                : SimpleDialogOption(
                    child: const Text('Take a photo'),
                    onPressed: () async {
                      Navigator.pop(context);
                      File? imageFile = await widget.cameraImgPickerFunction!();
                      setState(() {
                        _addFile(
                          file: imageFile,
                          mimeType: 'image/jpg',
                          index: index,
                        );
                      });
                    },
                  ),
            widget.galleryImgPickerFunction == null
                ? Container()
                : SimpleDialogOption(
                    child: const Text('Choose image from gallery'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      File? imageFile =
                          await widget.galleryImgPickerFunction!();
                      setState(() {
                        _addFile(
                          file: imageFile,
                          mimeType: 'image/jpg',
                          index: index,
                        );
                      });
                    },
                  ),
            widget.cameraVideoPickerFunction == null
                ? Container()
                : SimpleDialogOption(
                    child: const Text('Take a video'),
                    onPressed: () async {
                      Navigator.pop(context);
                      File? videoFile =
                          await widget.cameraVideoPickerFunction!();
                      setState(() {
                        _addFile(
                          file: videoFile,
                          mimeType: 'video/mp4',
                          index: index,
                        );
                      });
                    },
                  ),
            widget.galleryVideoPickerFunction == null
                ? Container()
                : SimpleDialogOption(
                    child: const Text('Choose video from gallery'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      File? videoFile =
                          await widget.galleryVideoPickerFunction!();
                      setState(() {
                        _addFile(
                          file: videoFile,
                          mimeType: 'video/mp4',
                          index: index,
                        );
                      });
                    },
                  ),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildContentIndex(int count) {
    // case 1 - no or only one piece of content
    int total = _files.length;
    if (total <= 1) {
      return Text("");
    }
    // case 2 - more than one piece of content
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            '${count + 1} / ${total}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard(int index) {
    return Container(
      color: Theme.of(context).primaryColorLight,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _clearFocus();
                        _selectFile(index);
                      },
                    ),
                    Text(
                      widget.selectFileText,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildContentIndex(index),
        ],
      ),
    );
  }

  Widget _buildVideo({
    File? localFile,
    String? networkUrl,
    bool? mute,
  }) {
    return ChewiePlayerScreen(
      localFile: localFile ?? null,
      networkUrl: networkUrl ?? null,
      looping: true,
      autoPlay: true,
      showControls: false,
      mute: mute ?? true,
    );
  }

  Widget _getFileImage(FileUploadModel uploadModel) {
    Widget image = Container();
    if (uploadModel.mimeType!.contains('image')) {
      if (uploadModel.file != null) {
        image = Image.file(
          uploadModel.file!,
          fit: BoxFit.cover,
        );
      } else if (uploadModel.url != null) {
        image = Image.network(
          uploadModel.url!,
          fit: BoxFit.cover,
        );
      }
    }
    return AspectRatio(
      aspectRatio: 1,
      child: image,
    );
  }

  Widget _getFileVideo(FileUploadModel uploadModel) {
    if (uploadModel.mimeType!.contains('video')) {
      if (uploadModel.file != null) {
        return Container(
          child: _buildVideo(
            localFile: uploadModel.file,
          ),
        );
      } else if (uploadModel.url != null) {
        return Container(
          child: _buildVideo(
            networkUrl: uploadModel.url,
          ),
        );
      }
    }
    return Container();
  }

  Widget _buildFileCard(int index) {
    FileUploadModel uploadModel = _files[index] as FileUploadModel;
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _getFileImage(uploadModel),
          _getFileVideo(uploadModel),
          Positioned(
            left: 5,
            top: 5,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 20,
                color: Colors.red,
              ),
              onPressed: () {
                _clearFocus();
                setState(() {
                  _removeFile(index);
                });
              },
            ),
          ),
          _buildContentIndex(index),
        ],
      ),
    );
  }

  Widget _buildUploadGrid() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: widget.initialTileCount,
      childAspectRatio: 1,
      children: List.generate(
        _files.length,
        (index) {
          if (_files[index] is FileUploadModel) {
            // case 1 - file
            return _buildFileCard(index);
          } else {
            // case 2 - placeholder
            return _buildUploadCard(index);
          }
        },
      ),
    );
  }

  Widget _getUploadCarousel() {
    return CarouselSlider.builder(
      options: CarouselOptions(
        aspectRatio: 16 / 9,
        // take up the entire viewport
        viewportFraction: 1,
        autoPlay: false,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        onPageChanged: (int i, CarouselPageChangedReason reason) {
          // some call back operation
        },
      ),
      itemCount: _files.length,
      itemBuilder: (BuildContext ctx, int index, _) {
        if (_files[index] is FileUploadModel) {
          // case 1 - file
          return _buildFileCard(index);
        } else {
          // case 2 - placeholder
          return _buildUploadCard(index);
        }
      },
    );
  }

  Widget _getDisplayType() {
    if (widget.displayType == 'grid') {
      return _buildUploadGrid();
    } else if (widget.displayType == 'carousel') {
      return _getUploadCarousel();
    }
    return ShowError(
      error: 'Error: unsupported display type. Must be grid or carousel.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: _getDisplayType(),
    );
  }
}
