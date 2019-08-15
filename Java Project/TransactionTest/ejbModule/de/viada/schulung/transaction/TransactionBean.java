package de.viada.schulung.transaction;

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

/**
 * Session Bean implementation class TransactionBean
 */
@Singleton
@Startup
public class TransactionBean implements TransactionBeanRemote {
	@PersistenceContext(unitName="koehl")
	private EntityManager em;

	@Resource
	private SessionContext context;

	@PostConstruct
	public void main() {
	
	}
    
	
	//select
	@TransactionAttribute(TransactionAttributeType.REQUIRED)
	public void getKontoByID(Long id)
	{
		Konto k = em.find(Konto.class, id);
		System.out.println("getKontobyId: " + id +", " + k.getIdentifier() +", " + k.getSaldo());		
	}
	
	@TransactionAttribute(TransactionAttributeType.REQUIRED)
	public void getKontoname(String name)
	{
		String hql = "select a from Konto a where a.identifier='"+name+"'";
		Query q = em.createQuery(hql);
		List<Konto> list= q.getResultList();

		for(Konto k : list)
		{
			System.out.println(k.getIdentifier() + ", " + k.getSaldo());
		}
	}
	
//	@TransactionAttribute(TransactionAttributeType.REQUIRED)
//	public void getbyHQL(String hqlString)
//	{
//		String hql = hqlString;
//		Query q = em.createQuery(hql);
//		List<Konto> list = q.getResultList();
//		
//		for(Konto k: list)
//		{
//			System.out.println(k.getIdentifier().length()..);
//		}
//	}
	
	
	@TransactionAttribute(TransactionAttributeType.REQUIRED)
	public void selectAlle()
	{
		String hql = "select a from Konto a";
		Query q = em.createQuery(hql);
		
		List<Konto> list = q.getResultList();
		for(Konto k: list)
		{
			System.out.println(k.getIdentifier()+", "+ k.getSaldo());
		}		
	}
	
	//insert
	@TransactionAttribute(TransactionAttributeType.REQUIRED)
	public void insertInKonto(String identifier, float saldo)
	{
		Konto newKonto = new Konto();
		newKonto.setIdentifier(identifier);
		newKonto.setSaldo(saldo);
		System.out.println("insert Konto");
		em.persist(newKonto);
	}
	
	//update
	public void updateKontoKontonameByID(long id, String newName)
	{
		Konto updatedBook = new Konto();
		updatedBook.setId(id);
		updatedBook.setIdentifier(newName);
		
		System.out.println("updateKontoKontonameByID: " + id + ", " + newName); 
		em.merge(updatedBook);
	}
	
	
//	public void updateKontonameByName(String currentName, String newName)
//	{
//		String hql = "update Konto a set identifier=" + newName + "where a.identidier=" + currentName;
//		Query q = em.createQuery(hql);
//		System.out.println("updateKontonameByName: " + newName + ", " + currentName);	
//	}
		
	//delete
	public void deleteKonto(long id)
	{
		System.out.println("deleteKonto: " + id);
		Konto k = em.getReference(Konto.class, id);
		em.remove(k);
	}
	
//	public void deleteKonto(String name)
//	{
//		String hql = "delete a from Konto a where id=" + name;
//		em.createQuery(hql);
//		System.out.println("deleteKonto " + name);
//	}
	
	
    @TransactionAttribute(TransactionAttributeType.REQUIRED)
    public void ueberweisen(Konto a, Konto b, float betrag, boolean checkBelowZero) {
    	a = em.find(Konto.class, a.getId());
    	a.setSaldo(a.getSaldo()-betrag);
    	if(checkBelowZero && a.getSaldo()<0) {
    		context.setRollbackOnly();
    	} else {
    		b = em.find(Konto.class, b.getId());
    		b.setSaldo(b.getSaldo()+betrag);
    	}
    }
    
	public Konto persist(Konto x) {
		em.persist(x);
		return x;
	}
}
