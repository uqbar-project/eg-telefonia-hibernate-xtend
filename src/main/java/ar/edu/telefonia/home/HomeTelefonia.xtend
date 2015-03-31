package ar.edu.telefonia.home

import ar.edu.telefonia.appModel.BusquedaAbonados
import ar.edu.telefonia.domain.Abonado
import ar.edu.telefonia.domain.Empresa
import ar.edu.telefonia.domain.Factura
import ar.edu.telefonia.domain.Llamada
import ar.edu.telefonia.domain.Residencial
import ar.edu.telefonia.domain.Rural
import java.util.List
import org.hibernate.HibernateException
import org.hibernate.SessionFactory
import org.hibernate.cfg.AnnotationConfiguration
import org.hibernate.criterion.Restrictions

class HomeTelefonia {

	private static HomeTelefonia instance = null
	
	private new() {
	}
	
	static def getInstance() {
		if (instance == null) {
			instance = new HomeTelefonia
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
	
	def List<Abonado> getAbonados(BusquedaAbonados busquedaAbonados) {
		val session = sessionFactory.openSession
		try {
			// Restricción Dummy - todos los registros tienen id
			val criteria = session.createCriteria(Abonado)
				.add(Restrictions.isNotNull("id"))
			if (busquedaAbonados.ingresoNombreDesde) {
				criteria.add(Restrictions.ge("nombre", busquedaAbonados.nombreDesde))
			} 
			if (busquedaAbonados.ingresoNombreHasta) {
				criteria.add(Restrictions.le("nombre", busquedaAbonados.nombreHasta))
			} 
			// Estrategia híbrida
			// La búsqueda por nombre desde/hasta se hace contra la base
			// El filtro de morosidad se hace posteriormente: si tenemos 5M de clientes no es una buena
			// estrategia, hay que pensar en llevar la abstracción "moroso" a la consulta
			// opciones: 1) incluir en la consulta un sum(saldo) de facturas, 2) armar un stored procedure
			criteria.list().filter [ abonado | busquedaAbonados.cumple(abonado) ].toList()
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}
	
	def eliminarAbonado(Abonado abonado) {
		val session = sessionFactory.openSession
		try {
			session.beginTransaction
			session.delete(abonado)
			session.getTransaction.commit
		} catch (HibernateException e) {
			session.getTransaction.rollback
			throw new RuntimeException(e)
		} finally {
			session.close
		}
	}
	
}
