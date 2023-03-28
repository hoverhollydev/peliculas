import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget{
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    return Scaffold(
      //backgroundColor: Colors.black26,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Demo Cartelera Cines'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                  context: context,
                  delegate: DataSearch(),
                  //query: 'hola'
              );
            },
          )
        ],
      ),
      body:
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),//el que carga las peliculas de estreno
            _footer(context),
          ],
        ),
      ) ,

    );
  }

  Widget _swiperTarjetas(){

    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        }else{
          return Container(
            height: 400.0,
            child: Center(child: CircularProgressIndicator()
            ),
          );
        }
      },
    );

    //peliculasProvider.getEnCines();

//    return CardSwiper(
//      listaItems: [1,2,3,4,5],
//    );
  }

  Widget _footer(BuildContext context){
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 15.0) ,
              child: Text(
                  'Populares',
                  style:Theme.of(context).textTheme.subhead,
                overflow: TextOverflow.ellipsis,)
          ),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot){
              if(snapshot.hasData) {
                return MovieHorizontal(
                  listaItems: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares);
              }else{
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }

}