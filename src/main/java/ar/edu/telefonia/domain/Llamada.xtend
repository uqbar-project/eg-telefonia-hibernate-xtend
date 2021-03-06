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
	Long id
	
	@ManyToOne
	Abonado origen
	
	@ManyToOne
	Abonado destino
	
	@Column
	Integer duracion
}
