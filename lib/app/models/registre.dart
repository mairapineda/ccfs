

class Registre {
  late String nomUtils;
  late String prenomUtils;
  late String dateUtils;
  late String emailAcces;
  late String passeAcces;
  late String repasseAcces;


  Registre(String nom, String pre, String  date, String ema, String pas, String rpas) {
    nomUtils = nom;
    prenomUtils = pre;
    dateUtils = date;
    emailAcces = ema;
    passeAcces = pas;
    repasseAcces = rpas;
    
  }

  Map toJson() => {
        'nomUtils': nomUtils,
        'prenomUtils': prenomUtils,
        'dateUtils': dateUtils,
        'emailAcces': emailAcces,
        'passeAcces': passeAcces,
        'repasseAcces': repasseAcces,
        
      };
}
