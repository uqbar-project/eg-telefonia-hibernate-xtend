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
	// Funcionan ok las properties de xtend + column de hibernate si no es id o colección
	@Column @Property private String nombre
	@Column @Property private String numero
	private List<Factura> facturas
	private List<Llamada> llamadas

	/**
	 * ***********************************************************
	 *      INICIO EXTRAS MANUALES QUE NECESITA HIBERNATE        *
	 *************************************************************
	 */
	 /**
	  * Podríamos utilizar annotations de Hibernate a nivel
	  * 1) property: par getter/setter como en este caso
	  * 2) field - o variable
	  * 
	  * El problema es que al anotar como field recibimos un error:
	  * Caused by: java.sql.BatchUpdateException: Field 'Abonado_id' doesn't have a default value
	  * 
	  * La explicación más razonable está aquí:
	  * http://javaprogrammingtips4u.blogspot.com.ar/2010/04/field-versus-property-access-in.html
	  * 
	  * "As per the @AccessType implementation of hibernate, if we intend to get the identifier of an
	  *  associated object in hibernate, if we use property level access, then hibernate understands that 
	  *  there is getId() method in the corresponding POJO and hence gets the id without initializing the
	  *  proxy. However, this does not work if we use filed level access. If we intend to get the id of
	  *  the associated object, since there is property level access defined, hibernate does not know
	  *  about the accessor methods in this domain object and hence tries to initialize the proxy to get
	  *  the id of the associated object! As a result, Hibernate team strongly suggests the use of property
	  *  access if we do not want the proxy initialization to happen since that might result in lazy
	  *  initialization exception if done out side the session.
	  * 
	  * "Adding fuel to this fire is the bug (*) reported in hibernate. While this points to the proxy 
	  *  initialization issue on calling getId() of an embedded object within hibernate, it is very clear that
	  *  Property level access is being discouraged by Hibernate (though Spring's dictum is to opt for field
	  *  level access only as in this link.
	  *  (*) https://hibernate.atlassian.net/browse/HHH-3718
	  * 
	  * Best Practices 
	  * 1. There is not much of difference between the field and property level access with respect to performance.
	  * 2. Field level access would be preferred if the code avoids hibernate proxy pitfalls!If there is a need 
	  *    for property access later, this can always be supported by adding the necessary accessors!
	  * 3. Field level access proves to be good if you really want the annotations closer to the code. 
	  *    This not only gives a fare idea of the property details but also avoids unnecessary accessors 
	  *    that might prove to be great evil. Additionally, having accessors is emphatically not a good OO design strategy!
	  * 4. If you are using field level access, remember that Hibernate would initialize the proxy on getting the id of 
	  *    an associated object at least until the bug gets resolved.
	  * 5. Property level access can be implemented as long as you do not have business logic or validations 
	  *    within your domain objects since one such scenario can prove to be very dangerous! 
	  *    The positive aspect about this type of access is that Hibernate does not initialize the proxy 
	  *    in case of getting the identifier of the associated POJO.
	  *  Overall, the usage of field and property level access depends much on the requirement as the first 
	  *  consideration and then the coding style!
	  */
	@Id @GeneratedValue
	def getId() {
		id
	}

	def void setId(Long unId) {
		id = unId
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
