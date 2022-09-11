import 'package:busify_voyageur/Widgets/UsernameGetter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({ Key? key }) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  List infos = [
    {
      "title" : "Page 1",
      "body" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus condimentum turpis eget orci aliquet malesuada.",
      "image" : "assets/voyageur.png"
    },

    {
      "title" : "Page 2",
      "body" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus condimentum turpis eget orci aliquet malesuada.",
      "image" : "assets/voyageur.png"
    },

    {
      "title" : "Page 3",
      "body" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus condimentum turpis eget orci aliquet malesuada.",
      "image" : "assets/voyageur.png"
    },

    {
      "title" : "Page 4",
      "body" : "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus condimentum turpis eget orci aliquet malesuada.",
      "image" : "assets/voyageur.png"
    }
  ]; 


  @override
  Widget build(BuildContext context) {

    Widget buildImage(String path){
      return Center(
        child: Image.asset(path, width: 350,) ,
      );
    }

    PageDecoration getPageDecoration(){
      return PageDecoration(
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins', fontWeight: FontWeight.bold, 
          fontSize: 28, 
          color: Colors.black87
        ),

        bodyTextStyle: const TextStyle(
          fontFamily: 'Poppins', fontWeight: FontWeight.normal, 
          fontSize: 16, 
          color: Colors.black87
        ),

        bodyPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.all(24),
        pageColor: Colors.white
      );
    }

    DotsDecorator getDotsDecoration(){
      return DotsDecorator(
        color: Colors.grey,
        size: const Size(10,10),
        activeColor: Colors.amber,
        activeSize: const Size(25, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)
        )
      );
    }

    return SafeArea(
        child: IntroductionScreen(
          pages: [

            PageViewModel(
              title: infos[0]['title'],
              body: infos[0]['body'],
              image: buildImage(infos[0]['image']),
              decoration: getPageDecoration()
            ), 

            PageViewModel(
              title: infos[1]['title'],
              body: infos[1]['body'],
              image: buildImage(infos[1]['image']),
              decoration: getPageDecoration()
            ), 

            PageViewModel(
              title: infos[2]['title'],
              body: infos[2]['body'],
              image: buildImage(infos[2]['image']),
              decoration: getPageDecoration()
            ), 

            PageViewModel(
              title: infos[3]['title'],
              body: infos[3]['body'],
              image: buildImage(infos[3]['image']),
              decoration: getPageDecoration()
            ),

            

          ],
          done: const Icon(
            CupertinoIcons.arrow_right_circle_fill,
            size: 35,
          ),
          onDone: (){
          
            showModalBottomSheet(
              // so the keybord can't hide the bottomsheet
              isScrollControlled: true,
              context: context, 
              builder: (context) => 
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom
                    ),
                    
                    child: const UsernameGetter() 
                  ),
                ) 
            );
          },
          showSkipButton: true,
          skip: const Text(
            "Skip",
            style: TextStyle(
              color: Colors.blueGrey,
              // fontSize: 18,
              // fontWeight: FontWeight.bold
            ),
          ),
          dotsDecorator: getDotsDecoration(),
          globalBackgroundColor: Colors.white,
          showNextButton: false,
        ),
  
      );
      
  }
}