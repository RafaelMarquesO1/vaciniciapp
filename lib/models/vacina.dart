class Vacina {
  final int id;
  final String nome;
  final String? fabricante;
  final String? descricao;
  final int? dosesRecomendadas;
  final int? intervaloDoses;
  final int? idadeMinima;
  final int? idadeMaxima;
  final String? categoria;
  final String? imagemUrl;

  Vacina({
    required this.id,
    required this.nome,
    this.fabricante,
    this.descricao,
    this.dosesRecomendadas,
    this.intervaloDoses,
    this.idadeMinima,
    this.idadeMaxima,
    this.categoria,
    this.imagemUrl,
  });

  factory Vacina.fromJson(Map<String, dynamic> json) {
    return Vacina(
      id: json['id'],
      nome: json['nome'],
      fabricante: json['fabricante'],
      descricao: json['descricao'],
      dosesRecomendadas: json['dosesRecomendadas'],
      intervaloDoses: json['intervaloDoses'],
      idadeMinima: json['idadeMinima'],
      idadeMaxima: json['idadeMaxima'],
      categoria: json['categoria'],
      imagemUrl: json['imagemUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'fabricante': fabricante,
      'descricao': descricao,
      'dosesRecomendadas': dosesRecomendadas,
      'intervaloDoses': intervaloDoses,
      'idadeMinima': idadeMinima,
      'idadeMaxima': idadeMaxima,
      'categoria': categoria,
      'imagemUrl': imagemUrl,
    };
  }

  String get categoriaFormatada {
    switch (categoria?.toLowerCase()) {
      case 'obrigatória':
        return 'Obrigatória';
      case 'opcional':
        return 'Opcional';
      case 'sazonal':
        return 'Sazonal';
      default:
        return categoria ?? 'Não informado';
    }
  }

  String get idadeAplicavelTexto {
    if (idadeMinima == null && idadeMaxima == null) {
      return 'Todas as idades';
    } else if (idadeMinima != null && idadeMaxima == null) {
      return 'A partir de ${_formatarIdade(idadeMinima!)}';
    } else if (idadeMinima == null && idadeMaxima != null) {
      return 'Até ${_formatarIdade(idadeMaxima!)}';
    } else {
      return 'De ${_formatarIdade(idadeMinima!)} a ${_formatarIdade(idadeMaxima!)}';
    }
  }

  String _formatarIdade(int meses) {
    if (meses < 12) {
      return '$meses ${meses == 1 ? 'mês' : 'meses'}';
    } else {
      final anos = meses ~/ 12;
      final mesesRestantes = meses % 12;
      if (mesesRestantes == 0) {
        return '$anos ${anos == 1 ? 'ano' : 'anos'}';
      } else {
        return '$anos ${anos == 1 ? 'ano' : 'anos'} e $mesesRestantes ${mesesRestantes == 1 ? 'mês' : 'meses'}';
      }
    }
  }
}