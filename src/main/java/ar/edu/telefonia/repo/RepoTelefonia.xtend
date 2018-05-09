package ar.edu.telefonia.repo

import ar.edu.telefonia.appModel.BusquedaAbonados
import ar.edu.telefonia.domain.Abonado
import java.util.List
import javax.persistence.EntityManager
import javax.persistence.EntityManagerFactory
import javax.persistence.Persistence
import javax.persistence.PersistenceException
import javax.persistence.criteria.Predicate
import org.hibernate.HibernateException

class RepoTelefonia {

	private static RepoTelefonia instance = null

	private new() {
	}

	static def getInstance() {
		if (instance === null) {
			instance = new RepoTelefonia
		}
		instance
	}

	private static final EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("Telefonia")

	def searchByExample(Abonado unAbonado, boolean full) {
		val entityManager = entityManagerFactory.createEntityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery(entityType)
			val from = query.from(entityType)
			query.select(from)
			var List<Predicate> condiciones = newArrayList
			condiciones.add(criteria.like(from.get("nombre"), "%" + unAbonado.nombre + "%"))
			condiciones.add(criteria.equal(from.get("numero"), unAbonado.numero))
			query.where(condiciones)
			val lista = entityManager.createQuery(query).resultList
			if (full) {
				lista.forEach [ abonado |
					abonado.facturas.size()
					abonado.llamadas.size()
				]
			}
			lista
		} catch (HibernateException e) {
			throw new RuntimeException(e)
		} finally {
			entityManager.close
		}
	}

	def getAbonado(Abonado abonado, boolean full) {
		searchByExample(abonado, full).head
	}

	def getAbonado(Abonado abonado) {
		searchByExample(abonado, false).head
	}

	def actualizarAbonado(Abonado abonado) {
		val EntityManager entityManager = entityManagerFactory.createEntityManager
		try {
			entityManager => [
				transaction.begin
				abonado.id = merge(abonado).id
				transaction.commit
			]
		} catch (PersistenceException e) {
			e.printStackTrace
			entityManager.transaction.rollback
			throw new RuntimeException("Ocurrió un error, la operación no puede completarse", e)
		} finally {
			entityManager.close
		}
	}

	def List<Abonado> getAbonados(BusquedaAbonados busquedaAbonados) {
		getAbonados(busquedaAbonados, true)
	}

	def List<Abonado> getAbonados(BusquedaAbonados busquedaAbonados, boolean full) {
		val EntityManager entityManager = entityManagerFactory.createEntityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery(entityType)
			val from = query.from(entityType)
			query.select(from)
			var List<Predicate> condiciones = newArrayList
			if (busquedaAbonados.ingresoNombreDesde) {
				condiciones.add(criteria.greaterThan(from.get("nombre"), busquedaAbonados.nombreDesde))
			}
			if (busquedaAbonados.ingresoNombreHasta) {
				condiciones.add(criteria.lessThan(from.get("nombre"), busquedaAbonados.nombreHasta))
			}
			query.where(condiciones)
			val lista = entityManager.createQuery(query).resultList
			if (full) {
				lista.forEach [ abonado |
					abonado.facturas.size()
					abonado.llamadas.size()
				]
				/*
				 * Lógica mixta donde filtro los abonados morosos. La lógica de negocio se mantiene del
				 * lado del dominio y no la paso del lado de la base de datos 
				 */ 
				lista.filter[abonado|busquedaAbonados.cumple(abonado)].toList
			}
		} catch (HibernateException e) {
			throw new RuntimeException("Ocurrió un error, la operación no puede completarse", e)
		} finally {
			entityManager.close
		}
	}

	def getEntityType() { typeof(Abonado) }

	def eliminarAbonado(Abonado abonado) {
		val EntityManager entityManager = entityManagerFactory.createEntityManager
		try {
			entityManager => [
				transaction.begin
				remove(abonado)
				transaction.commit
			]
		} catch (PersistenceException e) {
			e.printStackTrace
			entityManager.transaction.rollback
			throw new RuntimeException("Ocurrió un error, la operación no puede completarse", e)
		} finally {
			entityManager.close
		}
	}

}