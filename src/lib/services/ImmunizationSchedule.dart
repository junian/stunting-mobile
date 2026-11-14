// Childhood immunization schedule bundled with the app so the vaccination
// screen works without a network connection.
//
// The content mirrors the `vaksin` table of the legacy server
// (server/web-template.sql): the same identifiers, names and `bulan_ke`.
// The vaccine ids are stored in the local vaccination records, so do not
// change them.

class ScheduleVaccine {
  /// Identifier of the vaccine, matching `vaksin_id` on the server.
  final String id;
  final String name;

  const ScheduleVaccine(this.id, this.name);
}

class ImmunizationPeriod {
  /// Age, in months, at which this group of vaccines is recommended.
  final int ageMonths;
  final List<ScheduleVaccine> vaccines;

  const ImmunizationPeriod(this.ageMonths, this.vaccines);
}

const List<ImmunizationPeriod> immunizationSchedule = [
  ImmunizationPeriod(0, [
    ScheduleVaccine('1', 'Hepatitis B 0'),
    ScheduleVaccine('5', 'Polio O'),
    ScheduleVaccine('8', 'BCG'),
  ]),
  ImmunizationPeriod(2, [
    ScheduleVaccine('2', 'Hepatitis B 1'),
    ScheduleVaccine('7', 'Polio 1'),
    ScheduleVaccine('9', 'DTP 1'),
    ScheduleVaccine('12', 'HIB 1'),
    ScheduleVaccine('15', 'PCV 1'),
    ScheduleVaccine('18', 'Rotavirus 1'),
  ]),
  ImmunizationPeriod(3, [
    ScheduleVaccine('3', 'Hepatitis B 2'),
    ScheduleVaccine('6', 'Polio 2'),
    ScheduleVaccine('11', 'DTP 2'),
    ScheduleVaccine('13', 'Hib 2'),
  ]),
  ImmunizationPeriod(4, [
    ScheduleVaccine('4', 'Hepatitis B 3'),
    ScheduleVaccine('10', 'DTP 3'),
    ScheduleVaccine('14', 'Hib 3'),
    ScheduleVaccine('16', 'PCV 2'),
    ScheduleVaccine('19', 'Rotavirus 2'),
    ScheduleVaccine('27', 'Polio 3'),
  ]),
  ImmunizationPeriod(6, [
    ScheduleVaccine('17', 'PCV 3'),
    ScheduleVaccine('20', 'Rotavirus 3'),
  ]),
  ImmunizationPeriod(9, [
    ScheduleVaccine('21', 'MR / MMR'),
  ]),
  ImmunizationPeriod(12, [
    ScheduleVaccine('23', 'Varisela 1'),
    ScheduleVaccine('25', 'Hepatitis A 1'),
  ]),
  ImmunizationPeriod(18, [
    ScheduleVaccine('24', 'Varisela 2'),
    ScheduleVaccine('26', 'Hepatitis A 2'),
  ]),
  ImmunizationPeriod(24, [
    ScheduleVaccine('22', 'Tifoid 1'),
  ]),
];
