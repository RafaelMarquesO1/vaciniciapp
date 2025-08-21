class HistoricoVacina {
  final int id;
  final int pacienteId;
  final String nomePaciente;
  final int funcionarioId;
  final String nomeFuncionario;
  final int vacinaId;
  final String nomeVacina;
  final String? fabricante;
  final String dose;
  final DateTime dataAplicacao;
  final String lote;
  final DateTime? validade;
  final int? localId;
  final String? nomeLocal;
  final String? comprovanteUrl;
  final String? observacoes;

  HistoricoVacina({
    required this.id,
    required this.pacienteId,
    required this.nomePaciente,
    required this.funcionarioId,
    required this.nomeFuncionario,
    required this.vacinaId,
    required this.nomeVacina,
    this.fabricante,
    required this.dose,
    required this.dataAplicacao,
    required this.lote,
    this.validade,
    this.localId,
    this.nomeLocal,
    this.comprovanteUrl,
    this.observacoes,
  });

  factory HistoricoVacina.fromJson(Map<String, dynamic> json) {
    return HistoricoVacina(
      id: json['id'],
      pacienteId: json['pacienteId'],
      nomePaciente: json['nomePaciente'],
      funcionarioId: json['funcionarioId'],
      nomeFuncionario: json['nomeFuncionario'],
      vacinaId: json['vacinaId'],
      nomeVacina: json['nomeVacina'],
      fabricante: json['fabricante'],
      dose: json['dose'],
      dataAplicacao: DateTime.parse(json['dataAplicacao']),
      lote: json['lote'],
      validade: json['validade'] != null 
          ? DateTime.parse(json['validade']) 
          : null,
      localId: json['localId'],
      nomeLocal: json['nomeLocal'],
      comprovanteUrl: json['comprovanteUrl'],
      observacoes: json['observacoes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pacienteId': pacienteId,
      'funcionarioId': funcionarioId,
      'vacinaId': vacinaId,
      'dose': dose,
      'dataAplicacao': dataAplicacao.toIso8601String().split('T')[0],
      'lote': lote,
      'validade': validade?.toIso8601String().split('T')[0],
      'localId': localId,
      'comprovanteUrl': comprovanteUrl,
      'observacoes': observacoes,
    };
  }

  // Getters para compatibilidade com código existente
  int get historicoID => id;
  int get pacienteID => pacienteId;
  int get funcionarioID => funcionarioId;
  String? get nomeAplicador => nomeFuncionario;
  String? get descricaoVacina => '$nomeVacina${fabricante != null ? ' - $fabricante' : ''}';
}