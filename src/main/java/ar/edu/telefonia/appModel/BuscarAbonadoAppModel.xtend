package ar.edu.telefonia.appModel

import ar.edu.telefonia.domain.Abonado
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable
import ar.edu.telefonia.home.RepoTelefonia

/**
 * Modelo de la vista de la búsqueda de abonados
 * Pero como no es un componente que dependa de la tecnología
 * de UI, sino que modela el caso de uso, lo ubicamos en este
 * proyecto. De esa manera todos los fwk de UI que soporten
 * binding bidireccional pueden aprovechar este componente.
 */
@Observable
@Accessors
class BuscarAbonadoAppModel {
	BusquedaAbonados busquedaAbonados
	List<Abonado> abonados
	Abonado abonadoSeleccionado
	
	new() {
		busquedaAbonados = new BusquedaAbonados
		abonados = new ArrayList<Abonado>	
	}
	
	def void buscar() {
		abonados = RepoTelefonia.instance.getAbonados(busquedaAbonados)
	}
	
	def void limpiar() {
		busquedaAbonados.clear()
		abonados.clear()
		abonadoSeleccionado = null
	}
	
	def eliminarAbonado() {
		RepoTelefonia.instance.eliminarAbonado(abonadoSeleccionado)
		this.buscar
	}
	
}