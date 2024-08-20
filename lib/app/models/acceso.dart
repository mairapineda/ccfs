class Acces {
  late String codUtils;
  late String emailAcces;
  late String passeAcces;

  Acces(String cod, String corr, String cla) {
    codUtils = cod;
    emailAcces = corr;
    passeAcces = cla;
  }

  Map toJson() => {'emailAcces': emailAcces, 'passeAcces': passeAcces,'codUtils': codUtils};
}
