// lib/utils/cpf_validator.dart
bool isCPFValid(String cpf) {
  // Remove caracteres não numéricos
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

  // Verifica se tem 11 dígitos
  if (cpf.length != 11) return false;

  // Verifica se todos os dígitos são iguais
  if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

  // Calcula primeiro dígito verificador
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(cpf[i]) * (10 - i);
  }
  int digit1 = 11 - (sum % 11);
  if (digit1 > 9) digit1 = 0;

  // Verifica primeiro dígito
  if (digit1 != int.parse(cpf[9])) return false;

  // Calcula segundo dígito verificador
  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += int.parse(cpf[i]) * (11 - i);
  }
  int digit2 = 11 - (sum % 11);
  if (digit2 > 9) digit2 = 0;

  // Verifica segundo dígito
  return digit2 == int.parse(cpf[10]);
}