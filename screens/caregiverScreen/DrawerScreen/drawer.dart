import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seniorconnect/config/colors.dart';
import 'package:seniorconnect/screens/caregiverScreen/caregiverProfile.dart';
import 'package:seniorconnect/screens/caregiverScreen/profileElderly.dart';

class drawer extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Container(child:
             Center(
              child: Column(
              children: [
               
                Container(
                  height: 136,
                  child: Image.asset('lib/assets/images/login_icon.png'))

              ],
            ))),
          ),
          
          const ListTile(
            title: Text('Hi Caregiver !', style: TextStyle( color: Colors.black, fontWeight: FontWeight.bold),),
          ),
           ListTile(
            title: Text('Elderly Profile'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => profileElderly(),));
            },
          ),
           ListTile(
            title: Text('Caregiver Profile'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => profileCaregiver(),));
            },
          ),
          ListTile(
            title: Text('Log out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              //Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
