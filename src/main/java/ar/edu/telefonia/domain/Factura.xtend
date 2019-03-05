package ar.edu.telefonia.domain

import java.math.BigDecimal
import java.time.LocalDate
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

@Observable
@Entity
@Accessors
class Factura {

	@Id @GeneratedValue
	Long id

	@Column
	LocalDate fecha

	@Column
	BigDecimal totalPagado

	@Column
	BigDecimal total

	def saldo() {
		totalPagado.subtract(total)
	}

}
