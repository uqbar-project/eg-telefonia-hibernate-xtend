package ar.edu.telefonia.domain

import java.util.List
import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.DiscriminatorColumn
import javax.persistence.DiscriminatorType
import javax.persistence.DiscriminatorValue
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.Inheritance
import javax.persistence.InheritanceType
import javax.persistence.OneToMany
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

@Observable
@Entity
@Inheritance(strategy=InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name="TIPO_ABONADO", discriminatorType=DiscriminatorType.STRING)
@Accessors
abstract class Abonado {
	@Id @GeneratedValue
	Long id
	
	@Column
	String nombre
	
	@Column
	String numero
	
	@OneToMany(fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	List<Factura> facturas
	
	@OneToMany(fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	List<Llamada> llamadas

	/**
	 * ***********************************************************
	 *      INICIO EXTRAS MANUALES QUE NECESITA HIBERNATE        *
	 *************************************************************
	 */
	/** Constructor que necesita Hibernate */
	new() {
		facturas = newArrayList
		llamadas = newArrayList
	}

	/**
	 * ***********************************************************
	 *        FIN EXTRAS MANUALES QUE NECESITA HIBERNATE         *
	 *************************************************************
	 */
	abstract def float costo(Llamada llamada)

	def esMoroso() {
		deuda > 0
	}

	def deuda() {
		facturas.fold(0.0, [acum, factura|acum + factura.saldo.floatValue])
	}

	def agregarLlamada(Llamada llamada) {
		llamadas.add(llamada)
	}

	def agregarFactura(Factura factura) {
		facturas.add(factura)
	}

	@Transient
	abstract def String getDatosEspecificos()

	/**
	 *************************************************************************
	 *  EXTENSION METHODS
	 *************************************************************************
	 */
	def max(Integer integer, Integer integer2) {
		if(integer > integer2) integer else integer2
	}

	def min(Integer integer, Integer integer2) {
		max(integer2, integer)
	}

}

@Entity
@Accessors
@DiscriminatorValue("RS")
class Residencial extends Abonado {

	override costo(Llamada llamada) {
		2 * llamada.duracion
	}

	@Transient
	override getDatosEspecificos() {
		"Residencial"
	}

}

@Entity
@Accessors
@Observable
@DiscriminatorValue("RU")
class Rural extends Abonado {

	@Column
	Integer cantidadHectareas

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
	new(Integer unaCantidadHectareas) {
		cantidadHectareas = unaCantidadHectareas
	}

	override costo(Llamada llamada) {
		3 * llamada.duracion.max(new Integer(5))
	}

	@Transient
	override getDatosEspecificos() {
		"Rural (" + cantidadHectareas + " has)"
	}

}

@Entity
@Accessors
@DiscriminatorValue("EM")
class Empresa extends Abonado {

	@Column
	String cuit

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
	new(String unCuit) {
		cuit = unCuit
	}

	override costo(Llamada llamada) {
		1 * llamada.duracion.min(3)
	}

	override esMoroso() {
		facturas.size > 3
	}

	@Transient
	override getDatosEspecificos() {
		"Empresa (" + cuit + ")"
	}

}
