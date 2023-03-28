

import 'dart:async';
import 'dart:core';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class PeliculasProvider{

  String _apikey='92f06a8fbf4370e08733db4e988aac02';
  String _url='api.themoviedb.org';
  String _language='es-ES';

  int _popularesPage=0;
  bool _cargando= false;

  List<Pelicula> _populares = new List();

  final _popularesSteamController =StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesSteamController.sink.add;

  Stream <List<Pelicula>>get popularesStream => _popularesSteamController.stream;

  void disposeStream(){
    _popularesSteamController?.close();
  }

  Future <List<Pelicula>> _procesarRespuesta(Uri url) async{
    final resp = await http.get(url);
    final decodedData= json.decode(resp.body);
    print(decodedData);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    //print(peliculas.items[0].title);
    //print(peliculas.items[1].title);
    return peliculas.items;
  }

  Future <List<Pelicula>> getEnCines() async{
    final url= Uri.http(_url, '3/movie/now_playing',{
        'api_key': _apikey,
        'language': _language
    });
    return await _procesarRespuesta(url);
  }

  Future <List<Pelicula>> getPopulares() async{

    if(_cargando) return[];

    _cargando=true;

    _popularesPage++;

    final url= Uri.http(_url, '3/movie/popular',{
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);

    popularesSink(_populares);

    _cargando=false;

    return resp;
    //return await _procesarRespuesta(url);
  }

  Future <List<Actor>> getCast(String peliId) async{
    final url= Uri.http(_url, '3/movie/$peliId/credits',{
      'api_key': _apikey,
      'language': _language
    });

    final resp=  http.get(url);
    final decodeData= json.decode(resp.body);

    final cast= new Cast.fromJsonList(decodeData['cast']);

    return castawait.actores;
  }

  Future <List<Pelicula>> buscarPelicula(String query) async{
    final url= Uri.http(_url, '3/search/movie',{
      'api_key': _apikey,
      'language': _language,
      'query' : query
    });
    return await _procesarRespuesta(url);
  }


}