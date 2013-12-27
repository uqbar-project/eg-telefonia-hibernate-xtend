package ar.edu.telefonia.domain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToOne

@Entity
class Llamada {
	private Long id
	private Abonado origen
	private Abonado destino
	private Integer duracion

	/**
	 * ***********************************************************
	 *      INICIO EXTRAS MANUALES QUE NECESITA HIBERNATE        *
	 *************************************************************
	 */
	@Id @GeneratedValue
	def Long getId() {
		id
	}
	
	@ManyToOne 
	def Abonado getOrigen() {
		origen	
	}
	
	@ManyToOne
	def Abonado getDestino() {
		destino
	}
	
	@Column 
	def Integer getDuracion() {
		duracion
	}
	
	def setId(Long unId) {
		id = unId
	}
	
	def setOrigen(Abonado unOrigen) {
		origen = unOrigen
	}
	
	def setDestino(Abonado unDestino) {
		destino = unDestino
	}
	
	def setDuracion(Integer unaDuracion) {
		duracion = unaDuracion
	}

	new() {
		
	}
	
	/**
	 * ***********************************************************
	 *        FIN EXTRAS MANUALES QUE NECESITA HIBERNATE         *
	 *************************************************************
	 */
	 
	new(Abonado unOrigen, Abonado unDestino, Integer unaDuracion) {
		origen = unOrigen
		destino = unDestino
		duracion = unaDuracion
	}
	
}
