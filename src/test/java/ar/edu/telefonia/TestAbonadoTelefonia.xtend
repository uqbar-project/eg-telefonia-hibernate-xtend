package ar.edu.telefonia

import ar.edu.telefonia.appModel.BusquedaAbonados
import ar.edu.telefonia.domain.Abonado
import ar.edu.telefonia.domain.Empresa
import ar.edu.telefonia.domain.Factura
import ar.edu.telefonia.domain.Llamada
import ar.edu.telefonia.domain.Residencial
import ar.edu.telefonia.domain.Rural
import ar.edu.telefonia.repo.RepoTelefonia
import java.math.BigDecimal
import java.time.LocalDate
import org.hibernate.LazyInitializationException
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertThrows

@DisplayName("Dado un abonado de telefonía")
class TestAbonadoTelefonia {

	Abonado walterWhite
	Abonado jessePinkman
	Llamada primeraLlamada
	RepoTelefonia repoTelefonia 

	@BeforeEach
	def void init() {
		repoTelefonia = RepoTelefonia.instance

		// Creamos los abonados con sus llamadas si no existen
		primeraLlamada = TelefoniaFactory.crearLlamada(walterWhite, jessePinkman, 10)
				
		walterWhite = new Residencial() => [
			nombre = "Walter White"
			numero = "46710080"
			agregarFactura(TelefoniaFactory.crearFactura(LocalDate.of(2009, 2, 10), 500, 240))
			agregarFactura(TelefoniaFactory.crearFactura(LocalDate.of(2011, 3, 8), 1200, 600))
		]
		val existeWalterWhite = createIfNotExists(walterWhite)

		jessePinkman = new Rural(100) => [
			nombre = "Jesse Pinkman"
			numero = "45673887"
		]
		createIfNotExists(jessePinkman)

		var Abonado ibm = new Empresa("30-50396126-8") => [
			nombre = "IBM"
			numero = "47609272"
		]
		val existeIBM = createIfNotExists(ibm)

		// Traemos de la base los abonados
		jessePinkman = repoTelefonia.getAbonado(jessePinkman, true)
		ibm = repoTelefonia.getAbonado(ibm, true)
		walterWhite = repoTelefonia.getAbonado(walterWhite, true)

		// El update lo tenemos que hacer por separado por las referencias circulares
		if (!existeWalterWhite) {
			walterWhite.agregarLlamada(primeraLlamada)
			walterWhite.agregarLlamada(TelefoniaFactory.crearLlamada(walterWhite, ibm, 2))
			repoTelefonia.actualizarAbonado(walterWhite)
		}

		if (!existeIBM) {
			ibm.agregarLlamada(TelefoniaFactory.crearLlamada(ibm, jessePinkman, 5))
			repoTelefonia.actualizarAbonado(ibm)
		}
	}

	def createIfNotExists(Abonado abonado) {
		val reultados = repoTelefonia.searchByExample(abonado,true)
		val existe = !reultados.isEmpty
		if (!existe) {
			repoTelefonia.actualizarAbonado(abonado)
		}
		existe
	}

	@DisplayName("podemos consultar las llamadas de un abonado, forzando a llenar las colecciones lazy")
	@Test
	def void walterWhiteTiene2Llamadas() {
		var walterWhiteBD = repoTelefonia.getAbonado(walterWhite, true)
		var llamadasDeWalterWhite = walterWhiteBD.llamadas
		assertEquals(2, llamadasDeWalterWhite.size)
	}

	@DisplayName("no podemos consultar las llamadas de un abonado si la colección es lazy y el query no hace un fetch")
	@Test
	def void walterWhiteTiene2LlamadasSinSesionHibernate() {
		val walterWhiteBD = repoTelefonia.getAbonado(walterWhite, false)
		assertThrows(LazyInitializationException, [ walterWhiteBD.llamadas.size ])
	}

	@DisplayName("para consultar la deuda debemos conocer la colección de llamadas, haciendo un fetch")
	@Test
	def void deudaDeWalterWhite() {
		val walterWhiteBD = repoTelefonia.getAbonado(walterWhite, true)
		assertEquals(860, walterWhiteBD.deuda, 0.01)
	}

	@DisplayName("para conocer el costo de la primera llamada necesitamos acceder a la colección lazy, haciendo un fetch")
	@Test
	def void walterWhiteCostoDeLlamada1() {
		val walterWhiteBD = repoTelefonia.getAbonado(walterWhite, true)
		assertEquals(20, walterWhiteBD.costo(primeraLlamada), 0.1)
	}

	@DisplayName("la búsqueda by example por total exacto funciona")
	@Test
	def void walterWhiteTieneUnaFacturaDe1200Pesos(){
		val busqueda = new BusquedaAbonados => [
			total = new BigDecimal(1200)
		]
		val abonados = repoTelefonia.getAbonados(busqueda)
		assertEquals(walterWhite.id, abonados.head.id)
	}

	@DisplayName("la búsqueda by example por tiempo de llamada mínimo funciona")
	@Test
	def void walterWhiteTieneUnaLlamadaDeMasDe8Minutos(){
		val busqueda = new BusquedaAbonados => [
			minimoDeMinutos = 8
		]
		val abonados = repoTelefonia.getAbonados(busqueda)
		assertEquals(walterWhite.id, abonados.head.id)		
	}

}

// Clase creacional => helper de diferentes objetos
class TelefoniaFactory {
	
	def static crearLlamada(Abonado _origen, Abonado _destino, int _duracion) {
		new Llamada => [
			origen = _origen
			destino = _destino
			duracion = _duracion
		]
	}

	// tenemos dos formas de crear una factura, asumiendo que si no ingresamos
	// un tercer parámetro, la factura está paga
	def static crearFacturaPaga(LocalDate _fecha, int _total) {
		crearFactura(_fecha, _total, _total)		
	}

	// en este caso funciona como adapter
	def static crearFactura(LocalDate _fecha, int _total, int _totalPagado) {
		new Factura => [
			fecha = _fecha
			total = new BigDecimal(_total)
			totalPagado = new BigDecimal(_totalPagado)
		]
	}

}