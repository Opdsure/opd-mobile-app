extension StringValidator on String {
  static final RegExp _phoneRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  static final RegExp _emailRegex = RegExp(r'(.+)@(.+)\.(.+)');
  static final RegExp _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  bool get isValidEmail => _emailRegex.hasMatch(this);

  bool get isValidPhoneNumber => _phoneRegex.hasMatch(this);

  bool get isValidPassword => _passwordRegex.hasMatch(this);
}