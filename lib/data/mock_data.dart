import 'package:vaciniciapp/models/historico_vacinas.dart';
import 'package:vaciniciapp/models/usuario.dart';

class MockData {
  static final Usuario loggedInUser = Usuario(
    id: 1,
    nomeCompleto: 'James Moraes',
    cpf: '111.222.333-44',
    dataNascimento: DateTime(1992, 8, 25),
    tipoUsuario: 'Paciente',
    email: 'jamesmoraes@gmail.com',
    telefone: '11987654321',
  );

  static final List<Usuario> enfermeiros = [
    Usuario(
      id: 101, 
      nomeCompleto: 'Enfermeira Maria Silva', 
      cpf: '101.101.101-01', 
      tipoUsuario: 'Funcionario', 
      cargo: 'Enfermeira',
      email: 'maria.silva@ubs.gov.br',
      telefone: '(11) 98765-4321',
    ),
    Usuario(
      id: 102, 
      nomeCompleto: 'Enfermeira Stephanie Santos', 
      cpf: '102.102.102-02', 
      tipoUsuario: 'Funcionario', 
      cargo: 'Enfermeira',
      email: 'stephanie.santos@ubs.gov.br',
      telefone: '(11) 91234-5678',
    ),
  ];
  
  static final List<HistoricoVacina> historicoDeVacinas = [
    HistoricoVacina(id: 1, pacienteId: 1, nomePaciente: 'James Moraes', funcionarioId: 102, nomeFuncionario: 'Enfermeira Stephanie', vacinaId: 1, nomeVacina: 'BCG', dose: 'Dose Única', dataAplicacao: DateTime(1992, 8, 25), lote: 'BCG92A'),
    HistoricoVacina(id: 2, pacienteId: 1, nomePaciente: 'James Moraes', funcionarioId: 101, nomeFuncionario: 'Enfermeira Maria', vacinaId: 2, nomeVacina: 'Febre Amarela', dose: 'Dose Única', dataAplicacao: DateTime(2010, 3, 15), lote: 'FA10B'),
    HistoricoVacina(id: 3, pacienteId: 1, nomePaciente: 'James Moraes', funcionarioId: 101, nomeFuncionario: 'Enfermeira Maria', vacinaId: 3, nomeVacina: 'Influenza', dose: 'Dose Anual', dataAplicacao: DateTime(2024, 4, 22), lote: 'FLU24C'),
    HistoricoVacina(id: 4, pacienteId: 1, nomePaciente: 'James Moraes', funcionarioId: 102, nomeFuncionario: 'Enfermeira Stephanie', vacinaId: 4, nomeVacina: 'COVID-19', dose: '1ª Dose', dataAplicacao: DateTime(2022, 1, 18), lote: 'COV22D'),
    HistoricoVacina(id: 5, pacienteId: 1, nomePaciente: 'James Moraes', funcionarioId: 102, nomeFuncionario: 'Enfermeira Stephanie', vacinaId: 4, nomeVacina: 'COVID-19', dose: '2ª Dose', dataAplicacao: DateTime(2022, 4, 18), lote: 'COV22E'),
    HistoricoVacina(id: 6, pacienteId: 1, nomePaciente: 'James Moraes', funcionarioId: 101, nomeFuncionario: 'Enfermeira Maria', vacinaId: 5, nomeVacina: 'Hepatite A', dose: 'Dose Única', dataAplicacao: DateTime(1993, 11, 5), lote: 'HEPA93F'),
  ];
}