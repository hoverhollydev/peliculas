import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget{

  final List<Pelicula> listaItems;
  final Function siguientePagina;


  MovieHorizontal({@required this.listaItems, @required this.siguientePagina});
  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;// para saber el tamaño de la pantalla

    _pageController.addListener((){
      if(_pageController.position.pixels>= _pageController.position.maxScrollExtent -200){
        print('Cargar siguientes peliculas');
        siguientePagina();
      }
    });

    return Container(
      padding: EdgeInsets.only(top: 5.0),
      height: _screenSize.height*0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: listaItems.length,
        //children: _tarjetas(context),
        itemBuilder: (context, i)=> _tarjeta(context, listaItems[i]),
    )
    );
  }

  Widget _tarjeta(BuildContext context, Pelicula pelicula){
    pelicula.uniqueId='${pelicula.id}-poster';
    final _screenSize =MediaQuery.of(context).size;
    final tarjeta = Container(
      margin: EdgeInsets.only(right:15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: _screenSize.height*0.20,
              ),
            ),
          ),
          //SizedBox
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      onTap: (){
        Navigator.pushNamed(context, 'detalle',arguments: pelicula);
        //print('ID de la Película ${pelicula.id}');
      },
    );
  }

  List<Widget> _tarjetas(BuildContext context){
    final _screenSize =MediaQuery.of(context).size;
    return listaItems.map((pelicula){
      return Container(
        margin: EdgeInsets.only(right:15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: _screenSize.height*0.20,
              ),
            ),
            //SizedBox
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );

    }).toList();
  }

}