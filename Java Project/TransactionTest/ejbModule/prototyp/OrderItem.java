package prototyp;

import java.io.Serializable;

import javax.persistence.AssociationOverride;
import javax.persistence.AssociationOverrides;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "OrderItem")
@AssociationOverrides({ @AssociationOverride(name = "primaryKey.orders", joinColumns = @JoinColumn(name = "ORDER_ID")),
		@AssociationOverride(name = "primaryKey.product", joinColumns = @JoinColumn(name = "PRODUCT_ID")) })
public class OrderItem implements Serializable {

	private static final long serialVersionUID = 1L;

	private OrderItemCompositeKey primaryKey = new OrderItemCompositeKey();
	private int unitPrice;
	private int quantity;

	@EmbeddedId
	public OrderItemCompositeKey getPrimaryKey() {
		return primaryKey;
	}

	public void setPrimaryKey(OrderItemCompositeKey primaryKey) {
		this.primaryKey = primaryKey;
	}

	@Transient
	public Orders getOrders() {
		return getPrimaryKey().getOrders();
	}

	public void setOrders(Orders orders) {
		getPrimaryKey().setOrders(orders);
	}
	
	@Transient
	public Product getProduct() {
		return getPrimaryKey().getProduct();
	}

	public void setProduct(Product product) {
		getPrimaryKey().setProduct(product);
	}

	public int getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(int unitPrice) {
		this.unitPrice = unitPrice;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

}
