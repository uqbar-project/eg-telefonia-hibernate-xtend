package ar.edu.telefonia.repo

import ar.edu.telefonia.appModel.BusquedaAbonados
import ar.edu.telefonia.domain.Abonado
import java.util.List
import javax.persistence.EntityManager
import javax.persistence.EntityManagerFactory
import javax.persistence.Persistence
import javax.persistence.PersistenceException
import org.hibernate.HibernateException
import org.hibernate.criterion.Restrictions
import javax.persistence.criteria.Predicate

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

	def getAbonado(Abonado abonado) {
		getAbonado(abonado, false)
	}

	def getAbonado(Abonado unAbonado, boolean full) {
		val entityManager = entityManagerFactory.createEntityManager
		if  (unAbonado.id === null)
			return null
		else {
			
		try {
				var abonado = entityManager.find(entityType, unAbonado.id)

				if (abonado === null) {
					null
				} else {
					if (full) {
						abonado.facturas.size()
						abonado.llamadas.size()
					}
					abonado
				}
			} catch (HibernateException e) {
				throw new RuntimeException(e)
			} finally {
				entityManager.close
			}
		}	
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
			entityManager.createQuery(query).resultList
			// Estrategia híbrida
			// La búsqueda por nombre desde/hasta se hace contra la base
			// El filtro de morosidad se hace posteriormente: si tenemos 5M de clientes no es una buena
			// estrategia, hay que pensar en llevar la abstracción "moroso" a la consulta
			// opciones: 1) incluir en la consulta un sum(saldo) de facturas, 2) armar un stored procedure
			//criteria.list().filter[abonado|busquedaAbonados.cumple(abonado)].toList()
		} catch (HibernateException e) {
			throw new RuntimeException("Ocurrió un error, la operación no puede completarse", e)
		} finally {
			entityManager.close
		}
	}
	def getEntityType(){ typeof(Abonado)}
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
