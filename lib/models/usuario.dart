class Usuario {
  final int usuarioID;
  final String nomeCompleto;
  final DateTime? dataNascimento;
  final String cpf;
  final String tipoUsuario;
  final String? email;
  final String? telefone;
  final String? cargo;

  Usuario({
    required this.usuarioID,
    required this.nomeCompleto,
    this.dataNascimento,
    required this.cpf,
    required this.tipoUsuario,
    this.email,
    this.telefone,
    this.cargo,
  });
}