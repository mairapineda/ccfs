class Acces {
  late String emailAcces;
  late String passeAcces;

  Acces(String corr, String cla) {
    emailAcces = corr;
    passeAcces = cla;
  }

  Map toJson() => {'emailAcces': emailAcces, 'passeAcces': passeAcces};
}
