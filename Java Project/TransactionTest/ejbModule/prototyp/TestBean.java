package prototyp;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.ejb.SessionContext;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import javax.ejb.TransactionAttribute;
import javax.ejb.TransactionAttributeType;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

@Singleton
@Startup
public class TestBean implements TestBeanInterface {

	@PersistenceContext(unitName = "koehl")
	private EntityManager em;

	@Resource
	private SessionContext context;

	@PostConstruct
	public void main() throws ParseException {

		Customer c1 = new Customer("Felix", "Tutzauer", "Besch", "Deutschland", "D-5123");
		ArrayList<Product> products = new ArrayList<Product>();
		Product p1 = em.getReference(Product.class, 14);
		products.add(p1);
		insertOrder(c1, products, new Date()); //Partition 12.08 -> P8

		Customer c2 = new Customer("Laura", "Suss", "Nennig", "Deutschland", "D-5126");
		ArrayList<Product> products2 = new ArrayList<Product>();
		Product p2 = em.getReference(Product.class, 14);
		products2.add(p2);
		insertOrder(c2, products2, parseDate("2019-01-12")); // 12.01 -> P1

	}

	public void erzeugeTestDaten() {
		// Customer erzeugen
		Customer customer1 = new Customer("Leo", "Tutzauer", "Besch", "Deu", "D-5123");

		// Bestellungen erzeugen
		Orders order1 = new Orders(new Date(), 190);
		Orders order2 = new Orders(new Date(), 140);

		// Produkte erzeugen
		Product product1 = new Product("Prod1", 50);
		Product product2 = new Product("prod2", 60);
		Product product3 = new Product("Prod2", 70);

		// Orderitem erzeugen und Verbindung zu order und product bringen
		OrderItem orderitem1 = new OrderItem();
		orderitem1.setOrders(order1);
		orderitem1.setProduct(product1);
		orderitem1.setQuantity(1);
		orderitem1.setUnitPrice(50);

		OrderItem orderitem2 = new OrderItem();
		orderitem2.setOrders(order1);
		orderitem2.setProduct(product2);
		orderitem2.setQuantity(1);
		orderitem2.setUnitPrice(50);

		OrderItem orderitem3 = new OrderItem();
		orderitem3.setOrders(order1);
		orderitem3.setProduct(product3);
		orderitem3.setQuantity(1);
		orderitem3.setUnitPrice(60);

		OrderItem orderitem4 = new OrderItem();
		orderitem4.setOrders(order2);
		orderitem4.setProduct(product1);
		orderitem4.setQuantity(2);
		orderitem4.setUnitPrice(70);

		OrderItem orderitem5 = new OrderItem();
		orderitem5.setOrders(order2);
		orderitem5.setProduct(product2);
		orderitem5.setQuantity(1);
		orderitem5.setUnitPrice(50);

		// Order wurde von Kustomer gelkauft
		order1.setCustomer(customer1);
		order2.setCustomer(customer1);

		// Order enthällt diese Orderitems
		order1.addOrderItems(orderitem1);
		order1.addOrderItems(orderitem2);
		order1.addOrderItems(orderitem3);

		order2.addOrderItems(orderitem4);
		order2.addOrderItems(orderitem5);

		// Objekte speichern
		em.persist(customer1);
		em.persist(product1);
		em.persist(product2);
		em.persist(product3);
		em.persist(order1);
		em.persist(order2);

	}

	// Get Orders
	@SuppressWarnings("unchecked")
	@TransactionAttribute(TransactionAttributeType.REQUIRED)
	public void getAllOrdersAndDetails() {
		Query q = em.createQuery("select a from Orders a", Orders.class);
		List<Orders> list = q.getResultList();
		for (Orders o : list) {

			System.out.println(o.getOrderID() + ", " + o.getTotalAmount() + ", " + o.getOrderDate() + ", "
					+ o.getOrderitems().toString());
		}
	}

	// Insert new Products
	public void insertProduct(String productName, int unitPrice) {
		Product newProduct = new Product(productName, unitPrice);
		System.out.println("neues Produkt eingefügt");
		em.persist(newProduct);
	}

	// Insert new Customer
	public void insertCustomer(String firstName, String lastName, String city, String country, String phone) {
		Customer newCustomer = new Customer(firstName, lastName, city, country, phone);
		em.persist(newCustomer);
	}

	// Insert new Orders (ProducListe, aber nur letzte wird übernommen)
	public void insertOrder(Customer customer, List<Product> products, Date orderDate) {

		int totalPrice = 0;

		Customer newCustomer = customer;

		Orders newOrder = new Orders();
		newOrder.setOrderDate(orderDate);

		OrderItem newOrderItem = new OrderItem();
		for (int i = 0; i < products.size(); i++) {
			newOrderItem.setOrders(newOrder);
			newOrderItem.setProduct(products.get(i));
			newOrderItem.setQuantity(1);
			newOrderItem.setUnitPrice(products.get(i).getUnitPrice());
			totalPrice = totalPrice + products.get(i).getUnitPrice();
			newOrder.addOrderItems(newOrderItem);
		}

		newOrder.setTotalAmount(totalPrice);
		newOrder.setCustomer(newCustomer);

		System.out.println("Neue Bestellung hinzugefügt");
		// Objekte speichern
		em.persist(newCustomer);
		em.persist(newOrder);
	}

	// Update
	public void updateOrders(int id, int totalAmount) {
		Orders updateOrder = em.getReference(Orders.class, id);
		updateOrder.setTotalAmount(totalAmount);
		em.merge(updateOrder);
	}

	// Delete Order
	public void deleteOrder(int id) {
		Orders o = em.getReference(Orders.class, id);
		em.remove(o);
	}

	// String to Date Parser
	public Date parseDate(String orderdate) throws ParseException {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // yyyy-MM-dd'T'HH:mm:ss.SSSZ" dd-M-yyyy hh:mm:ss
		return sdf.parse(orderdate);
	}

//	erzeugeTestDaten();
//	getAllOrdersAndDetails();
//	insertProduct("Laptop Maus", 25);
//	deleteOrder(8);
//	updateOrders(4, 500);
}
