package ar.edu.telefonia.home

import ar.edu.telefonia.appModel.BusquedaAbonados
import ar.edu.telefonia.domain.Abonado
import java.util.List
import javax.persistence.EntityManager
import javax.persistence.EntityManagerFactory
import javax.persistence.NoResultException
import javax.persistence.Persistence
import javax.persistence.PersistenceException

class RepoTelefonia {

	static RepoTelefonia instance = null

	private new() {
	}

	static def getInstance() {
		if (instance === null) {
			instance = new RepoTelefonia
		}
		instance
	}

	static final EntityManagerFactory entityManagerFactory = Persistence.createEntityManagerFactory("Telefonia")

	def getEntityManager() {
		entityManagerFactory.createEntityManager
	}

	def getAbonado(Abonado abonado) {
		getAbonado(abonado, false)
	}

	def getAbonado(Abonado unAbonado, boolean full) {
		val entityManager = this.entityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery(typeof(Abonado))
			val from = query.from(Abonado)
			query.select(from)
			query.where(criteria.equal(from.get("nombre"), unAbonado.nombre))
			/**
			 * si indicamos qué tipo de fetch debemos hacer
			 * esto no funciona bien con varias listas a la vez, una pena
			if (full) {
				from.fetch("facturas", JoinType.LEFT)
				from.fetch("llamadas", JoinType.LEFT)
			}
			* 
			*/
			try {
				val abonado = entityManager.createQuery(query).setMaxResults(1).singleResult
				if (full) {
					abonado.llamadas.size
					abonado.facturas.size
				}
				return abonado
			} catch (NoResultException e) {
				return null
			}
		} finally {
			entityManager.close
		}
	}

	/**
	 * Para actualizar o eliminar como la base es similar, lo que hacemos es 
	 * pasar un closure (un command) que se construye con un objeto bloque de Xtend.
	 * También podríamos construir una clase con una interfaz execute(EntityManager, Abonado)
	 * pero esto es menos burocrático.
	 */
	def void actualizarAbonado(Abonado abonado) {
		doInTransaction(abonado, [EntityManager em, Abonado _abonado|em.merge(_abonado)])
	}

	def void eliminarAbonado(Abonado abonado) {
		doInTransaction(abonado, [EntityManager em, Abonado _abonado|em.remove(_abonado)])
	}

	def List<Abonado> getAbonados(BusquedaAbonados busquedaAbonados) {
		val entityManager = this.entityManager
		try {
			val criteria = entityManager.criteriaBuilder
			val query = criteria.createQuery(typeof(Abonado))
			val from = query.from(Abonado)
			query.select(from)
			if (busquedaAbonados.ingresoNombreDesde) {
				query.where(criteria.greaterThan(from.get("nombre"), busquedaAbonados.nombreDesde))
			}
			if (busquedaAbonados.ingresoNombreHasta) {
				query.where(criteria.lessThan(from.get("nombre"), busquedaAbonados.nombreHasta))
			}
			val List<Abonado> abonados = entityManager.createQuery(query).resultList
			// Estrategia híbrida
			// La búsqueda por nombre desde/hasta se hace contra la base
			// El filtro de morosidad se hace posteriormente: si tenemos 5M de clientes no es una buena
			// estrategia, hay que pensar en llevar la abstracción "moroso" a la consulta
			// opciones: 1) incluir en la consulta un sum(saldo) de facturas, 2) armar un stored procedure
			return abonados.filter[Abonado abonado|busquedaAbonados.cumple(abonado)].toList()
		} finally {
			entityManager.close
		}
	}

	def void doInTransaction(Abonado abonado, (EntityManager, Abonado)=>void operation) {
		val entityManager = this.entityManager
		try {
			entityManager => [
				transaction.begin
				operation.apply(it, abonado)
				transaction.commit
			]
		} catch (PersistenceException e) {
			e.printStackTrace
			entityManager.transaction.rollback
			throw new RuntimeException("Ha ocurrido un error. La operación no puede completarse.", e)
		} finally {
			entityManager.close
		}
	}

}
