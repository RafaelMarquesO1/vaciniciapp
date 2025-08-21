class Usuario {
  final int id;
  final String nomeCompleto;
  final DateTime? dataNascimento;
  final String cpf;
  final String tipoUsuario;
  final String? email;
  final String? telefone;
  final String? genero;
  final String? cargo;
  final String? fotoPerfil;
  final DateTime? dataCadastro;

  Usuario({
    required this.id,
    required this.nomeCompleto,
    this.dataNascimento,
    required this.cpf,
    required this.tipoUsuario,
    this.email,
    this.telefone,
    this.genero,
    this.cargo,
    this.fotoPerfil,
    this.dataCadastro,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nomeCompleto: json['nomeCompleto'],
      dataNascimento: json['dataNascimento'] != null 
          ? DateTime.parse(json['dataNascimento']) 
          : null,
      cpf: json['cpf'],
      tipoUsuario: json['tipoUsuario'],
      email: json['email'],
      telefone: json['telefone'],
      genero: json['genero'],
      cargo: json['cargo'],
      fotoPerfil: json['fotoPerfil'],
      dataCadastro: json['dataCadastro'] != null 
          ? DateTime.parse(json['dataCadastro']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeCompleto': nomeCompleto,
      'dataNascimento': dataNascimento?.toIso8601String().split('T')[0],
      'cpf': cpf,
      'tipoUsuario': tipoUsuario,
      'email': email,
      'telefone': telefone,
      'genero': genero,
      'cargo': cargo,
      'fotoPerfil': fotoPerfil,
    };
  }

  // Getter para compatibilidade com código existente
  int get usuarioID => id;
}