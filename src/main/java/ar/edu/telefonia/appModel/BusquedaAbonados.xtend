package ar.edu.telefonia.appModel

import ar.edu.telefonia.domain.Abonado
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable

@Observable
@Accessors
class BusquedaAbonados {
	String nombreDesde
	String nombreHasta
	boolean soloMorosos

	new() {
		clear()
	}

	def cumple(Abonado abonado) {
		(!ingresoNombreDesde || abonado.nombre.toUpperCase >= nombreDesde.toUpperCase) &&
			(!ingresoNombreHasta || abonado.nombre.toUpperCase <= nombreHasta.toUpperCase) && (abonado.esMoroso || !soloMorosos)
	}

	def clear() {
		nombreDesde = ""
		nombreHasta = ""
		soloMorosos = false
	}

	def ingresoNombreDesde() {
		nombreDesde != null && !nombreDesde.equals("")
	}

	def ingresoNombreHasta() {
		nombreHasta != null && !nombreHasta.equals("")
	}

}
