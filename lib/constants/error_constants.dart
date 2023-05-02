class MyErrorConstants{
  static const String invalidEmailAddress = "Please type a valid email address";
  static const String invalidPassword = "Password must be of at least 6 characters.";
  static const String wrongOtp = "The code you have entered is incorrect. Please try again";





  static String emptySelectError(String keyword){
    return 'Please select $keyword.';

  }
  static String emptyEnterError(String keyword){
    return 'Please enter $keyword.';
  }
  static String emptyTypeError(String keyword){
    return 'Please type $keyword.';
  }
}
