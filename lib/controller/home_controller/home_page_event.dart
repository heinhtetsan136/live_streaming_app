abstract class HomePageEvent {
  const HomePageEvent();
}

class gotoHomePage extends HomePageEvent {
  const gotoHomePage();
}

class gotoSearchScreen extends HomePageEvent {
  const gotoSearchScreen();
}

class gotoProfile extends HomePageEvent {
  const gotoProfile();
}
