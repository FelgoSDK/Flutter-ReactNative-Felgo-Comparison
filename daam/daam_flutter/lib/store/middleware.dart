import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

import 'StoreActions.dart';
import 'AppState.dart';

// void fetchFilmsMiddleware = ({ dispatch, getState }) => next => action => {
//   if (action.type === "FETCH_FILMS") {
//     fetch("http://localhost:5000/api/films")
//       .then(res => res.json())
//       .then(films => films.forEach(film => dispatch({ type: "ADD_FILM", film })))
//       .catch(err => console.error("Couldn't fetch films", err))
//   }
//   next(action);
// }

class FetchFilmsMiddleware extends MiddlewareClass<AppState> {
  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) {
    if (action['type'] == StoreActions.FETCH_FILMS) {
      String url = "http://10.0.0.13:5000/api/films";
      http.get(url).then((res) {
        var films = jsonDecode(res.body);
        for (var i = 0; i < films.length; i++) {
          store.dispatch({"type": StoreActions.ADD_FILM, "film": films[i]});
        }
        print("objects ${films[0]['title']}");
      });
    }
    next(action);
  }
}
