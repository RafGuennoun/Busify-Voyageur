import 'package:busify_voyageur/views/Main_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsernameGetter extends StatefulWidget {
  const UsernameGetter({
    Key? key,
  }) : super(key: key);

  @override
  State<UsernameGetter> createState() => _UsernameGetterState();
}

class _UsernameGetterState extends State<UsernameGetter> {

  final _nameController = TextEditingController();

  bool? empty;

  late SharedPreferences prefs;

  Future initPrefs() async {
    // instance
    prefs = await SharedPreferences.getInstance();
  }

  @override
  initState(){
    initPrefs();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();  
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color:Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Text(
            "Entrez votre nom",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium
          ),

          const SizedBox(height: 30,),

          TextField(
            controller: _nameController,
            // to write directly instead of clicking on the text field
            autofocus: true,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                // borderSide: const BorderSide(color: Colors.grey),
              ),
              labelText: "Nom",
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              hintText: "Votre nom",
              hintStyle: Theme.of(context).textTheme.bodyMedium,
              errorText: empty == true ? 'Ecrivez votre nom' : null
            ),
            onChanged: (newText){
              setState(() {
                empty = false;
              });
            },
          ),

          const SizedBox(height: 30,),
          
          CupertinoButton(
            color: Theme.of(context).primaryColor,
            child: const Text(
              "Continuer",
            ),
            onPressed: () async {

              if (_nameController.text.isEmpty) {
                setState(() {
                  empty = true;
                });
              } else {
                setState(() {
                  empty = false;
                });

                String username = _nameController.text;
                prefs.setString('user', username);
                
                String? usn = prefs.getString('user');
                debugPrint('Trying to get name : $usn');

                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) => const MainView()), 
                  (route) => false
                );
              }

            }, 
          ),
        ],
      ),
    );
  }
}