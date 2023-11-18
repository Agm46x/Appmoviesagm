//Importe de la libreria
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/movieModel.dart';
import 'package:carousel_slider/carousel_slider.dart';

const baseUrl = "https://api.themoviedb.org/3/movie/";
const baseImagesUrl = "https://image.tmdb.org/t/p/";
const apiKey = "de95caf8529999ac4f86541a282722a8";

const nowPlayingUrl = "${baseUrl}now_playing?api_key=$apiKey";
const upComingUrl = "${baseUrl}upcoming?api_key=$apiKey";
const popularUrl = "${baseUrl}popular?api_key=$apiKey";
const topRatedUrl = "${baseUrl}top_rated?api_key=$apiKey";

//Punto de acceso inicial
void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark(),
      //Widget Statefulwidgte
      home: MyMovieApp(),
    ));

class MyMovieApp extends StatefulWidget {
  @override
  //Creamos un Objeto de clase estado una instacion por ser estado
  _MyMovieApp createState() => new _MyMovieApp();
}

class _MyMovieApp extends State<MyMovieApp> {
  Movie nowPlayingMovies = new Movie();
  Movie upcomingMovies = new Movie();
  Movie popularMovies = new Movie();
  Movie topRatedMovies = new Movie();
  int heroTag = 0;

  @override
  void initState() {
    super.initState();
    _fetchNowPlayingMovies();
    _fetchUpcomingMovies();
    _fetchPopularMovies();
    _fetchTopRatedMovies();
  }

  void _fetchNowPlayingMovies() async {
    var response = await http.get(Uri.parse(nowPlayingUrl));
    var decodeJson = jsonDecode(response.body);
    setState(() {
      nowPlayingMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchUpcomingMovies() async {
    var response = await http.get(Uri.parse(upComingUrl));
    var decodeJson = jsonDecode(response.body);
    setState(() {
      upcomingMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchPopularMovies() async {
    var response = await http.get(Uri.parse(popularUrl));
    var decodeJson = jsonDecode(response.body);
    setState(() {
      popularMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchTopRatedMovies() async {
    var response = await http.get(Uri.parse(topRatedUrl));
    var decodeJson = jsonDecode(response.body);
    setState(() {
      topRatedMovies = Movie.fromJson(decodeJson);
    });
  }

  Widget _buildCarouselSlider() => CarouselSlider(
        items: nowPlayingMovies == null
            ? [Center(child: CircularProgressIndicator())]
            : (nowPlayingMovies.results
                        ?.map((movieItem) => _buildMovieItem(movieItem)))
                    ?.toList() ??
                [],
        options: CarouselOptions(
          // Configuraciones específicas del carrusel
          //  Revisar donde toma las Opciones
          autoPlay: false,
          height: 240.0,
          viewportFraction: 0.5,
        ),
      );

  Widget _buildMovieItem(Results movieItem) {
    heroTag += 1;
    return Material(
      elevation: 15.0,
      child: InkWell(
        onTap: () {},
        child: Hero(
          tag: heroTag,
          child: Image.network(
            "${baseImagesUrl}w342${movieItem.posterPath}",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMovieListItem(Results movieItem) => Material(
        child: Container(
          width: 128.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(6.0),
                  child: _buildMovieItem(movieItem)),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 2.0),
                child: Text(
                  movieItem.title ?? "",
                  style: TextStyle(fontSize: 8.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 2.0),
                child: Text(
                  movieItem.releaseDate ?? "",
                  style: TextStyle(fontSize: 8.0),
                ),
              )
            ],
          ),
        ),
      );

  Widget _buildMoviesListView(Movie movie, String movieListTittle) => Container(
        height: 258.0,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
              child: Text(
                movieListTittle,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400]),
              ),
            ),
            Flexible(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: movie == null
                  ? <Widget>[Center(child: CircularProgressIndicator())]
                  : movie.results
                          ?.map((movieItem) => Padding(
                                padding: EdgeInsets.only(left: 6.0, right: 2.0),
                                child: _buildMovieListItem(movieItem),
                              ))
                          .toList() ??
                      [],
            ))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          'Movies App AGM45X',
          style: TextStyle(
              color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        //Iconos
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      //  Cuerpo
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Now Playing',
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              //Otras propiedades
              expandedHeight: 290.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                //Propiedad
                background: Stack(
                  children: <Widget>[
                    Container(
                      child: Image.network(
                        "${baseImagesUrl}w500//j9mH1pr3IahtraTWxVEMANmPSGR.jpg",
                        fit: BoxFit.cover,
                        width: 1000.0,
                        colorBlendMode: BlendMode.dstATop,
                        color: Colors.blue.withOpacity(0.5),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 35.0),
                        child: _buildCarouselSlider())
                  ],
                ),
              ),
            )
          ];
        },
        body: ListView(
          children: <Widget>[
            _buildMoviesListView(upcomingMovies, 'Coming Soon'),
            _buildMoviesListView(popularMovies, 'Popular'),
            _buildMoviesListView(topRatedMovies, 'Top Rated'),
          ],
        ),
      ),
    );
  }
}
