import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as flutter_quill;

class EditScreenPlaceHolder extends StatelessWidget {
  const EditScreenPlaceHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 65,
          child: Center(
            child: Text(
              "Loading ...",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.shade200,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ),
        Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
        flutter_quill.QuillToolbar.basic(
          controller: flutter_quill.QuillController.basic(),
        ),
      ],
    );
  }
}
