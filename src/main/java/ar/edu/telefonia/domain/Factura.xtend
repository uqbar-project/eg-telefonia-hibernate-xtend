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
  	private Long id
	
	@Column
	private LocalDate fecha
	
	@Column
	private BigDecimal totalPagado
	
	@Column
	private BigDecimal total

	/**
	 * ***********************************************************
	 *      INICIO EXTRAS MANUALES QUE NECESITA HIBERNATE        *
	 *************************************************************
	 */

	/** Constructor que necesita Hibernate */	
	new() {
	}
	
	/**
	 * ***********************************************************
	 *        FIN EXTRAS MANUALES QUE NECESITA HIBERNATE         *
	 *************************************************************
	 */
	
	new(LocalDate _fecha, int _totalPagado, int _total) {
	  fecha = _fecha
	  totalPagado = new BigDecimal(_totalPagado)
	  total = new BigDecimal(_total)
	}

	def saldo() { 
		totalPagado.subtract(total)
	}
	
}