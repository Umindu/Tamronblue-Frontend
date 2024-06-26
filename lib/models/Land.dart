class Land {
  final int id;
  final String name;
  final int customer_id;
  final String address;
  final double area;
  final String district;
  final String agricultural_zone;
  final String Density;
  final String acclimatization;
  final String region;
  final String google_map;
  // final int requirements_month;
  // final int requirements_annual;
  final int branch_id;
  final int agent_id;
  final String description;
  final bool status;

  Land(
      this.id,
      this.name,
      this.customer_id,
      this.address,
      this.area,
      this.district,
      this.agricultural_zone,
      this.Density,
      this.acclimatization,
      this.region,
      this.google_map,
      // this.requirements_month,
      // this.requirements_annual,
      this.branch_id,
      this.agent_id,
      this.description,
      this.status);
}


class LandList {
  final int id;
  final String name;
  final String address;
  final String district;
  final String region;

  LandList(
      this.id,
      this.name,
      this.address,
      this.district,
      this.region,);
}

