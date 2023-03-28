import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate<String> {

  String seleccion='';

  final peliculasProvider =  new PeliculasProvider();

  final peliculas=[
    'Spiderman',
    'Aquaman',
    'Batman',
    'Narnia',
    'Toy Story',
    'Capitan America',
    'Joker',
    'Avenguers',
    'Avenguers 2',
    'Avenguers 3',
    'Avenguers 4',
    'Avenguers 5',


  ];
  final peliculaRecientes=[
    'Spiderman',
    'Capitan America'
  ];

  DataSearch({
    String hintText = "Buscar",
  }) : super(
    searchFieldLabel: hintText,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.search,
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar iconito de limpiar
    return  [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query='';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar
    return
      IconButton(
        icon: AnimatedIcon(
          icon:AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){
         close(context, null);
        },
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        color: Colors.lightBlueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot){
        if(snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId='';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
              },
              );
            }).toList()
          );
        }else{
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    );


    // son las sugerencias cuando que aparecen cuando las personas escriben
    /*final listaSugerida = (query.isEmpty)
                          ? peliculaRecientes
                          : peliculas.where(
                            (p)=> p.toLowerCase().startsWith(query.toLowerCase())
                          ).toList();



    return ListView.builder(
        itemCount: listaSugerida.length,
        itemBuilder: (context, i){
          return ListTile(
            leading: Icon(Icons.movie),
            title: Text(listaSugerida[i]),
            onTap: (){
              seleccion=listaSugerida[i];
              showResults(context);
            },
          );
        }
    );*/
  }
}
