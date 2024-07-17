extension StringValidator on String {
  static final RegExp _phoneRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
  static final RegExp _emailRegex = RegExp(r'(.+)@(.+)\.(.+)');
  static final RegExp _passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

  bool get isValidEmail => _emailRegex.hasMatch(this);

  bool get isValidPhoneNumber => _phoneRegex.hasMatch(this);

  bool get isValidPassword => _passwordRegex.hasMatch(this);

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  String get capitalize {
    return split(' ').map(_capitalize).join(' ');
  }
}