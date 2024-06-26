class Customer {
  final int id;
  final String first_name;
  final String last_name;
  final String email;
  final String gender;
  final String nic;
  final String phone;
  final String address;
  final String city;
  final String counrty;
  final String zip_code;
  final int branch_id;
  final int agent_id;
  final bool status;

  Customer(
    this.id,
    this.first_name,
    this.last_name,
    this.email,
    this.gender,
    this.nic,
    this.phone,
    this.address,
    this.city,
    this.counrty,
    this.zip_code,
    this.branch_id,
    this.agent_id,
    this.status,
  );
}

class CustomerList {
  final int id;
  final String first_name;
  final String last_name;
  final String email;

  CustomerList(
    this.id,
    this.first_name,
    this.last_name,
    this.email,
  );
}
