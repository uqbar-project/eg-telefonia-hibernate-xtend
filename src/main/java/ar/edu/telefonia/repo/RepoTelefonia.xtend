package ar.edu.telefonia.repo

import ar.edu.telefonia.domain.Abonado
import ar.edu.telefonia.domain.Empresa
import ar.edu.telefonia.domain.Factura
import ar.edu.telefonia.domain.Llamada
import ar.edu.telefonia.domain.Residencial
import ar.edu.telefonia.domain.Rural
import org.hibernate.HibernateException
import org.hibernate.SessionFactory
import org.hibernate.cfg.AnnotationConfiguration
import org.hibernate.criterion.Restrictions

class RepoTelefonia {

	private static RepoTelefonia instance = null
	
	private new() {
	}
	
	static def getInstance() {
		if (instance == null) {
			instance = new RepoTelefonia
		}
		instance
	}
	
	private static final SessionFactory sessionFactory = new AnnotationConfiguration()
			.configure()
			.addAnnotatedClass(Factura)
			.addAnnotatedClass(Residencial)
			.addAnnotatedClass(Rural)
			.addAnnotatedClass(Empresa)
			.addAnnotatedClass(Abonado)
			.addAnnotatedClass(Llamada)
			.buildSessionFactory()

	def getAbonado(Abonado abonado) {
		getAbonado(abonado, false)
	}

	def getAbonado(Abonado unAbonado, boolean full) {
		val session = sessionFactory.openSession
		try {
			var result = session.createCriteria(Abonado)
				.add(Restrictions.eq("nombre", unAbonado.nombre))
				.list()

			if (result.isEmpty) {
				null
			} else {
				var abonado = result.get(0) as Abonado
				if (full) {
					abonado.facturas.size()
					abonado.llamadas.size()
				}
				abonado
			}
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}

	def actualizarAbonado(Abonado abonado) {
		val session = sessionFactory.openSession
		try {
			session.beginTransaction
			session.saveOrUpdate(abonado)
			session.getTransaction.commit
		} catch (HibernateException e) {
			session.getTransaction.rollback
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}

}
