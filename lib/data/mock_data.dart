import 'package:vaciniciapp/models/historico_vacinas.dart';
import 'package:vaciniciapp/models/usuario.dart';

class MockData {
  static final Usuario loggedInUser = Usuario(
    usuarioID: 1,
    nomeCompleto: 'James Moraes',
    cpf: '111.222.333-44',
    dataNascimento: DateTime(1992, 8, 25),
    tipoUsuario: 'Paciente',
    email: 'jamesmoraes@gmail.com',
    telefone: '11987654321',
  );

  static final List<Usuario> enfermeiros = [
    Usuario(usuarioID: 101, nomeCompleto: 'Enfermeira Maria', cpf: '101.101.101-01', tipoUsuario: 'Funcionario', cargo: 'Enfermeira'),
    Usuario(usuarioID: 102, nomeCompleto: 'Enfermeira Stephanie', cpf: '102.102.102-02', tipoUsuario: 'Funcionario', cargo: 'Enfermeira'),
  ];
  
  static final List<HistoricoVacina> historicoDeVacinas = [
    HistoricoVacina(historicoID: 1, pacienteID: 1, funcionarioID: 102, nomeVacina: 'BCG', dose: 'Dose Única', dataAplicacao: DateTime(1992, 8, 25), lote: 'BCG92A', nomeAplicador: 'Enfermeira Stephanie', descricaoVacina: 'A vacina BCG (Bacilo de Calmette e Guérin) é indicada para prevenir as formas graves de Tuberculose.'),
    HistoricoVacina(historicoID: 2, pacienteID: 1, funcionarioID: 101, nomeVacina: 'Febre Amarela', dose: 'Dose Única', dataAplicacao: DateTime(2010, 3, 15), lote: 'FA10B', nomeAplicador: 'Enfermeira Maria'),
    HistoricoVacina(historicoID: 3, pacienteID: 1, funcionarioID: 101, nomeVacina: 'Influenza', dose: 'Dose Anual', dataAplicacao: DateTime(2024, 4, 22), lote: 'FLU24C', nomeAplicador: 'Enfermeira Maria'),
    HistoricoVacina(historicoID: 4, pacienteID: 1, funcionarioID: 102, nomeVacina: 'COVID-19', dose: '1ª Dose', dataAplicacao: DateTime(2022, 1, 18), lote: 'COV22D', nomeAplicador: 'Enfermeira Stephanie'),
    HistoricoVacina(historicoID: 5, pacienteID: 1, funcionarioID: 102, nomeVacina: 'COVID-19', dose: '2ª Dose', dataAplicacao: DateTime(2022, 4, 18), lote: 'COV22E', nomeAplicador: 'Enfermeira Stephanie'),
    HistoricoVacina(historicoID: 6, pacienteID: 1, funcionarioID: 101, nomeVacina: 'Hepatite A', dose: 'Dose Única', dataAplicacao: DateTime(1993, 11, 5), lote: 'HEPA93F', nomeAplicador: 'Enfermeira Maria'),
  ];
}