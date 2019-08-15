package de.viada.schulung.transaction;
import javax.ejb.Remote;


@Remote
public interface TransactionBeanRemote {
	public static final String JNDI_NAME="TransactionBean/remote";
	public void ueberweisen(Konto a, Konto b, float betrag, boolean checkBelowZero);
	public Konto persist(Konto x);
}
