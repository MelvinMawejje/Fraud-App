import 'package:flutter/material.dart';
import 'package:fraud_watch/baselayout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(

      // ===========================appbar=======================
      appBarTitle: 'Fraud Watch',
      
      // ================== Body ==================
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome to Fraud Watch',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'How do you expect to check for fraud?',
                style: TextStyle(
                  fontSize: 20,
                  
                ),
                ),

                SizedBox(height: 20),
                
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.keyboard_voice_outlined,
                    size: 50,),
                ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/voice_screen');
                },

                
                child: Text('Go to Voice',
                      style: TextStyle(
                    fontSize: 18,
                    color:  const Color.fromARGB(255, 193, 154, 107),
                    ),)
              ),

               SizedBox(height: 20),
                 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.text_snippet_rounded,
                    size: 50,),
                ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/text_screen');
                },

                
                child: Text('Go to Text',
                    style: TextStyle(
                    fontSize: 18,
                    color:  const Color.fromARGB(255, 193, 154, 107),
                    ),
                      ),),
              
            ],
          ),
        ),
      ),

    );
  }
}