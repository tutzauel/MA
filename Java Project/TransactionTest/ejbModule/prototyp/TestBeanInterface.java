package prototyp;

import javax.ejb.Remote;

@Remote
public interface TestBeanInterface {
	public static final String JNDI_NAME="TransactionBean/remote";

}
