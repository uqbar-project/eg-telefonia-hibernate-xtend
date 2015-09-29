package ar.edu.telefonia.domain

import java.math.BigDecimal
import java.util.Date
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import org.uqbar.commons.utils.Observable

@Observable
@Entity
class Factura {
	// los getters y setters que se generan con @Property hay 
	// que sobreescribirlos, por eso faltan las annotations
  	@Id	@GeneratedValue
  	private Long id
	
	@Column
	private Date fecha
	
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
	
	new(Date unaFecha, int elTotalPagado, int elTotal) {
	  fecha = unaFecha
	  totalPagado = new BigDecimal(elTotalPagado)
	  total = new BigDecimal(elTotal)
	}

	def saldo() { 
		totalPagado.subtract(total)
	}
	
}