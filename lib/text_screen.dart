import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class TextScreen extends StatelessWidget {
  const TextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BaseLayout(
      appBarTitle: 'Text',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [           
            Text('Please upload your text here',
            style: TextStyle(
              fontSize: 20,
            ),),
            SizedBox(height: 20),
            Container(
            
              padding: EdgeInsets.all(15),
              constraints: const BoxConstraints(
                maxHeight: 200,
                maxWidth: double.infinity),
              child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color:Colors.brown, width: 5.0),
                ),
               
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              scrollPhysics: ClampingScrollPhysics(),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                  child: Text('Clear',
                    style: TextStyle(
                    fontSize: 18,
                    color:  const Color.fromARGB(255, 193, 154, 107),
                    ),
                  ),
                  ),
                ),
                SizedBox(width: 20,),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                  onPressed: () {
                    // Add your onPressed logic here
                  },
                  child: Text('Upload text',
                    style: TextStyle(
                    fontSize: 18,
                    color:  const Color.fromARGB(255, 193, 154, 107),
                    ),
                  ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}