import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchAlbum() async{
  final response = await http
      .get(Uri.parse('https://randomuser.me/api/?results=10'));
  if (response.statusCode == 200){
    return json.decode(response.body)['results'];
  } else{
    throw Exception('error');
  }

}
String _name(dynamic user){
  return user['name']['title']+ " " + user['name']['first'];
}

String _age(Map<dynamic, dynamic> user){
  return "Age: " + user['dob']['age'].toString();
}


void main() {
  runApp(MaterialApp(
    title: 'App',
    home: Vista(),
  ));
}

class Vista extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Primera vista'),
      ),
      body: Center(
        child: new Column(
          children: [

            Text('Este es solo un ejemplo de Flutter para consumir una api que se visualizara en la segunda vista'),


             ElevatedButton(
              child: Text('Segunda vista'),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SegundaVista()),
                );

              },
            ),

          ],
        )

      ),


    );
  }
}

class SegundaVista extends StatefulWidget {

  const SegundaVista({Key? key}) : super(key: key);

  @override
  _SegundaVistaState createState() => _SegundaVistaState();
}
class _SegundaVistaState extends State<SegundaVista> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Segunda vista'),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchAlbum(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){

              print(_age(snapshot.data[0]));

              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index){
                  return
                  Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(snapshot.data[index]['picture']['large']),
                          ),
                          title: Text(_name(snapshot.data[index])),
                          trailing: Text(_age(snapshot.data[index])),
                        )
                      ],
                    ),

                  );

                },
              );

            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }



        ),
      ),


    );
  }
}


