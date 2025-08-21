class LocalVacinacao {
  final int id;
  final String nome;
  final String endereco;
  final String cidade;
  final String estado;
  final String? cep;
  final String? telefone;
  final String? horarioFuncionamento;
  final double? latitude;
  final double? longitude;
  final String? tipo;

  LocalVacinacao({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.cidade,
    required this.estado,
    this.cep,
    this.telefone,
    this.horarioFuncionamento,
    this.latitude,
    this.longitude,
    this.tipo,
  });

  factory LocalVacinacao.fromJson(Map<String, dynamic> json) {
    return LocalVacinacao(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
      cidade: json['cidade'],
      estado: json['estado'],
      cep: json['cep'],
      telefone: json['telefone'],
      horarioFuncionamento: json['horarioFuncionamento'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'telefone': telefone,
      'horarioFuncionamento': horarioFuncionamento,
      'latitude': latitude,
      'longitude': longitude,
      'tipo': tipo,
    };
  }

  String get enderecoCompleto {
    return '$endereco, $cidade - $estado${cep != null ? ', $cep' : ''}';
  }

  String get tipoFormatado {
    switch (tipo?.toLowerCase()) {
      case 'posto de saúde':
        return 'Posto de Saúde';
      case 'hospital':
        return 'Hospital';
      case 'clínica':
        return 'Clínica';
      default:
        return tipo ?? 'Não informado';
    }
  }

  bool get temLocalizacao => latitude != null && longitude != null;
}