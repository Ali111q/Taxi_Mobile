class Words {
  final String language;
  String loginTitle() {
    if (language == 'ar') {
      return 'اهلا بكم في تطبيق جايك';
    }
    return 'Welcome in jayak';
  }

  String loginSubtitle() {
    if (language == 'ar') {
      return 'قم بإدخال رقم الهاتف لكي تبدأ عملية التسجيل';
    }
    return 'Type Your Phone Number Please';
  }

  String loginButton() {
    if (language == 'ar') {
      return 'تأكيد';
    }
    return 'Continue';
  }

  String loginFieldHint() {
    if (language == 'ar') {
      return 'رقم هاتفك';
    }
    return 'Your Phone Number ex:078*****';
  }

  String otpSubTitle() {
    if (language == 'ar') {
      return 'قم بإدخال الرمز الذي تم ارساله لرقم هاتفك';
    }
    return 'Please Type Verfication Code';
  }

  Words(this.language);
}
