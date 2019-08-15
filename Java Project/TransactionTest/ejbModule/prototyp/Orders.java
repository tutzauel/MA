package prototyp;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "Orders")
public class Orders implements Serializable {

	private static final long serialVersionUID = 1L;
	private int orderID;
	private Date orderDate;
	private int totalAmount;
	private Customer customer; // fk Spalte
	
	private Set<OrderItem> orderitems = new HashSet<OrderItem>();

	public Orders() {

	}

	public Orders(Date orderDate, int totalAmount) {
		this.orderDate = orderDate;
		this.totalAmount = totalAmount;
	}

	public Orders(Date orderDate, int totalAmount, Customer customer) {
		this.orderDate = orderDate;
		this.totalAmount = totalAmount;
		this.customer = customer;
	}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "ORDER_ID")
	public int getOrderID() {
		return orderID;
	}

	public void setOrderID(int orderID) {
		this.orderID = orderID;
	}

	public Date getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}

	public int getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(int totalAmount) {
		this.totalAmount = totalAmount;
	}

	@ManyToOne // (cascade = CascadeType.ALL)
	@JoinColumn(name = "CUSTOMER_ID")
	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	@OneToMany(mappedBy = "primaryKey.orders", cascade = CascadeType.ALL)
	public Set<OrderItem> getOrderitems() {
		return orderitems;
	}

	public void setOrderitems(Set<OrderItem> orderitems) {
		this.orderitems = orderitems;
	}

	// Hilfsfunktion
	public void addOrderItems(OrderItem orderitems) {
		this.orderitems.add(orderitems);
	}

}
