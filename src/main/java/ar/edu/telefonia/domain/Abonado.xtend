package ar.edu.telefonia.domain

import java.util.ArrayList
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

@Entity
@Inheritance(strategy=InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name="TIPO_ABONADO", discriminatorType=DiscriminatorType.STRING)
abstract class Abonado {
	private Long id
	private String nombre
	private String numero
	private List<Factura> facturas
	private List<Llamada> llamadas

	/**
	 * ***********************************************************
	 *      INICIO EXTRAS MANUALES QUE NECESITA HIBERNATE        *
	 *************************************************************
	 */
	@Id @GeneratedValue
	def getId() {
		id
	}

	def void setId(Long unId) {
		id = unId
	}

	@Column def String getNombre() {
		nombre
	}

	def void setNombre(String unNombre) {
		nombre = unNombre
	}

	@Column def String getNumero() {
		numero
	}

	def void setNumero(String unNumero) {
		numero = unNumero
	}

	@OneToMany(fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	def List<Factura> getFacturas() {
		facturas
	}

	def void setFacturas(List<Factura> unasFacturas) {
		facturas = unasFacturas
	}

	@OneToMany(fetch=FetchType.LAZY, cascade=CascadeType.ALL)
	def List<Llamada> getLlamadas() {
		llamadas
	}

	def void setLlamadas(List<Llamada> unasLlamadas) {
		llamadas = unasLlamadas
	}

	/** Constructor que necesita Hibernate */	
	new() {
		facturas = new ArrayList<Factura>
		llamadas = new ArrayList<Llamada>
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
@DiscriminatorValue("RS")
class Residencial extends Abonado {

	override def costo(Llamada llamada) {
		2 * llamada.duracion
	}

}

@Entity
@DiscriminatorValue("RU")
class Rural extends Abonado {

	private Integer cantidadHectareas

	/**
	 * ***********************************************************
	 *      INICIO EXTRAS MANUALES QUE NECESITA HIBERNATE        *
	 *************************************************************
	 */

	@Column def getCantidadHectareas() {
		cantidadHectareas
	}

	def void setCantidadHectareas(Integer unaCantidadHectareas) {
		cantidadHectareas = unaCantidadHectareas
	}
	
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

	override def costo(Llamada llamada) {
		3 * llamada.duracion.max(new Integer(5))
	}

}

@Entity
@DiscriminatorValue("EM")
class Empresa extends Abonado {

	String cuit

	/**
	 * ***********************************************************
	 *      INICIO EXTRAS MANUALES QUE NECESITA HIBERNATE        *
	 *************************************************************
	 */

	@Column def getCuit() {
		cuit
	}

	def void setCuit(String unCuit) {
		cuit = unCuit
	}

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

	override def costo(Llamada llamada) {
		1 * llamada.duracion.min(3)
	}

	override def esMoroso() {
		facturas.size > 3
	}

}
