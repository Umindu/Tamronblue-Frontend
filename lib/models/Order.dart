class OrderList {
  final int id;
  final int customer_id;
  final int land_id;
  String customer_name; // Removed final
  String land_name;     // Removed final
  final double total;
  final String status;
  final DateTime created_at;

  OrderList(
    this.id,
    this.customer_id,
    this.land_id,
    this.customer_name,
    this.land_name,
    this.total, 
    this.status,
    this.created_at,
  );

  // Setter for customer_name
  set customerName(String value) {
    customer_name = value;
  }

  // Setter for land_name
  set landName(String value) {
    land_name = value;
  }
}

class Order {
  final int id;
  final int customer_id;
  final int land_id;
  final int agent_id;
  final double total;
  final double discount;
  final double sub_total;
  final bool paid;
  final String status;
  final DateTime created_at;

  Order(
    this.id,
    this.customer_id,
    this.land_id,
    this.agent_id,
    this.sub_total,
    this.discount,
    this.total,
    this.paid,
    this.status,
    this.created_at,
  );
}
