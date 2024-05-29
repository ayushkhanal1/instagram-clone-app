import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/models/user.dart';
import 'package:instaclone/provider/user_provider.dart';
import 'package:instaclone/resources/firestore_methods.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:instaclone/utils/imageutil.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  bool _isloading = false;
  final TextEditingController captioncontroler = TextEditingController();
  void dispose() {
    super.dispose();
    captioncontroler.dispose();
  }

  void clearimage() {
    setState(() {
      _file = null;
    });
  }

  void imageposted(String uid, String username, String profileimage) async {
    setState(() {
      _isloading = true;
    });
    try {
      String res = await FirestoreMethods().uploadpost(
          captioncontroler.text, _file!, uid, username, profileimage);
      if (res == 'success') {
        setState(() {
          _isloading = false;
        });
        showsnackbar('Posted', context);
        clearimage();
      } else {
        setState(() {
          _isloading = false;
        });
        showsnackbar(res, context);
      }
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      showsnackbar(e.toString(), context);
    }
  }

  _selectimage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickimage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickimage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getter;

    return _file == null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => _selectimage(context),
                icon: const Icon(Icons.upload),
                iconSize: 50,
              ),
              const Text('UPLOAD'),
            ],
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text('Post to'),
              centerTitle: false,
              leading: IconButton(
                onPressed: clearimage,
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      imageposted(user!.uid, user.username, user.photourl),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _isloading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user!.photourl),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              controller: captioncontroler,
                              decoration: const InputDecoration(
                                  hintText: 'Write a caption',
                                  border: InputBorder.none),
                              maxLines: 8,
                            ),
                          ),
                        ],
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
