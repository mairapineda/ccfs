class Registre {
  late String nomUtils;
  late String prenomUtils;
  late String dateUtils;
  late String emailAcces;
  late String codInstitution;
  late String codRoles;
  late String passeAcces;
  late String repasseAcces;

  Registre(String nom, String pre, String date, String ema, String pas,
      String ins, String rol, String rpas) {
    nomUtils = nom;
    prenomUtils = pre;
    dateUtils = date;
    emailAcces = ema;
    codInstitution = ins;
    codRoles = rol;
    passeAcces = pas;
    repasseAcces = rpas;
  }

  Map toJson() => {
        'nomUtils': nomUtils,
        'prenomUtils': prenomUtils,
        'dateUtils': dateUtils,
        'emailAcces': emailAcces,
        'codInstitution': codInstitution,
        'codRoles': codRoles,
        'passeAcces': passeAcces,
        'repasseAcces': repasseAcces,
      };
}
