package ar.edu.telefonia.domain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.ManyToOne
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

@Observable
@Accessors
@Entity
class Llamada {
	@Id @GeneratedValue
	private Long id
	
	@ManyToOne
	private Abonado origen
	
	@ManyToOne
	private Abonado destino
	
	@Column
	private Integer duracion

	/**
	 * ***********************************************************
	 *      INICIO EXTRAS MANUALES QUE NECESITA HIBERNATE        *
	 *************************************************************
	 */
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
