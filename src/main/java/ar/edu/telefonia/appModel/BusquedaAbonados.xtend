package ar.edu.telefonia.appModel

import ar.edu.telefonia.domain.Abonado
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import java.math.BigDecimal

@Observable
@Accessors
class BusquedaAbonados {
	String nombreDesde
	String nombreHasta
	boolean soloMorosos
	BigDecimal total
	Integer minimoDeMinutos
	

	new() {
		clear()
	}

	def cumple(Abonado abonado) {
		abonado.esMoroso || !soloMorosos
	}

	def clear() {
		nombreDesde = ""
		nombreHasta = ""
		soloMorosos = false
	}

	def ingresoAlMenosMinimoDeMintos(){
		minimoDeMinutos !== null && !minimoDeMinutos.equals(0)
	}

	def ingresoTotalExacto(){
		total !== null 
	}

	def ingresoNombreDesde() {
		nombreDesde !== null && !nombreDesde.equals("")
	}

	def ingresoNombreHasta() {
		nombreHasta !== null && !nombreHasta.equals("")
	}

}
