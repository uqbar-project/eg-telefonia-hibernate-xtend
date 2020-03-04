package ar.edu.telefonia.domain

import java.math.BigDecimal
import java.time.LocalDate
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import org.uqbar.commons.model.annotations.Observable
import org.eclipse.xtend.lib.annotations.Accessors

@Observable
@Entity
@Accessors
class Factura {
	// los getters y setters que se generan con @Property hay 
	// que sobreescribirlos, por eso faltan las annotations
  	@Id	@GeneratedValue
  	Long id
	
	@Column
	LocalDate fecha
	
	@Column
	BigDecimal totalPagado
	
	@Column
	BigDecimal total

	def saldo() { 
		total.subtract(totalPagado)
	}
	
}