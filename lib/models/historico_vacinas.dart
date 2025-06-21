class HistoricoVacina {
  final int historicoID;
  final int pacienteID;
  final int funcionarioID;
  final String nomeVacina;
  final String dose;
  final DateTime dataAplicacao;
  final String lote;
  final String? nomeAplicador;
  final String? descricaoVacina;

  HistoricoVacina({
    required this.historicoID,
    required this.pacienteID,
    required this.funcionarioID,
    required this.nomeVacina,
    required this.dose,
    required this.dataAplicacao,
    required this.lote,
    this.nomeAplicador,
    this.descricaoVacina,
  });
}