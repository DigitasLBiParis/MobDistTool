import 'package:angular/angular.dart';

List<Map> routeHistory = new List<Map>();

void MDTRouteInitializer(Router router, RouteViewFactory views) {
  print("views.configure");
  views.configure({
    'home': ngRoute(
        path: '/home',
        defaultRoute : true,
        view: 'pages/home.html',
        preLeave: (RoutePreLeaveEvent e) =>  preLeaveRoute(e,"Home"),
        enter: (RouteEnterEvent e) => _enterRoute(e,"Home",0)),
        //preLeave: (RoutePreLeaveEvent e) =>  preLeaveRoute(e)),
    'apps': ngRoute(
        path: '/apps',
        viewHtml: '<application_list></application_list>',
        enter: (RouteEnterEvent e) => _enterRoute(e,"Applications",1),
        preLeave: (RoutePreLeaveEvent e) =>  preLeaveRoute(e,"Applications"),
        //preLeave: (RoutePreLeaveEvent e) =>  preLeaveRoute(e),
        //view: 'pages/apps_list.html',
        mount: {
          'artifacts': ngRoute(
              path: '/:appId/artifacts',
              viewHtml: '<application_detail></application_detail>',
              enter: (RouteEnterEvent e) => _enterRoute(e,"Versions",2),
              preLeave: (RoutePreLeaveEvent e) =>  preLeaveRoute(e,"Versions")
            //  preLeave: (RoutePreLeaveEvent e) =>  preLeaveRoute(e)
          //view: 'pages/artifacts_list.html'
          )}),
    'users': ngRoute(
        path: '/users',
        view: 'pages/users.html')
      //  enter: (RouteEnterEvent e) => _enterRoute(e,1)
  });
}

void _enterRoute(RouteEnterEvent e,String name, int level){
  //this.enterRoute("Home","/home",0);
  //print("Enter route : ${e.path}");

  if (routeHistory.length >= level) {
    routeHistory = routeHistory.sublist(0, level);
  }
  //print("History length ${currentRouteHistory.length}");
  var routePath = e.path;
  if (routePath.isEmpty){
    routePath = "Home";
  }else {
    if (e.route.parent != null && e.route.parent.name!=null){
      routePath = "/${e.route.parent.name}$routePath";
    }
  }
  routeHistory.add({"name":name,"path":routePath});
  //special case for for home
  if (level == 0) {
    //add link to apps
    routeHistory.add({"name":"Applications", "path":"/apps"});
  }
}

void preLeaveRoute(RoutePreLeaveEvent e,String name){
  print("PreLeave route : ${e.path}");
  if (routeHistory.last != null){
    if (routeHistory.last["name"] == name){
      routeHistory.removeLast();
    }
  }
}