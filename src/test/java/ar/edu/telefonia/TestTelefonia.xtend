package ar.edu.telefonia

import ar.edu.telefonia.domain.Abonado
import ar.edu.telefonia.domain.Empresa
import ar.edu.telefonia.domain.Factura
import ar.edu.telefonia.domain.Llamada
import ar.edu.telefonia.domain.Residencial
import ar.edu.telefonia.domain.Rural
import ar.edu.telefonia.home.RepoTelefonia
import java.math.BigDecimal
import java.time.LocalDate
import org.hibernate.LazyInitializationException
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class TestTelefonia {

	Abonado walterWhite
	Abonado jessePinkman
	RepoTelefonia homeTelefonia
	Llamada llamada1 = new Llamada => [
		origen = walterWhite
		destino = jessePinkman
		duracion = 10
	]

	@Before
	def init() {
		homeTelefonia = RepoTelefonia.instance

		walterWhite = new Residencial()
		walterWhite.nombre = "Walter White"
		walterWhite.numero = "46710080"
		walterWhite.agregarFactura(new Factura => [
			fecha = LocalDate.of(2009, 2, 10)
			total = new BigDecimal(500)
			totalPagado = new BigDecimal(240)
		])
		walterWhite.agregarFactura(new Factura => [
			fecha = LocalDate.of(2011, 3, 8)
			total = new BigDecimal(1200)
			totalPagado = new BigDecimal(600)
		])

		jessePinkman = new Rural(100)
		jessePinkman.nombre = "Jesse Pinkman"
		jessePinkman.numero = "45673887"
		jessePinkman.agregarFactura(new Factura => [
			fecha = LocalDate.of(2013, 6, 5)
			total = new BigDecimal(1200)
			totalPagado = new BigDecimal(1200)
		])

		var Abonado ibm = new Empresa("30-50396126-8")
		ibm.nombre = "IBM"
		ibm.numero = "47609272"

		createIfNotExists(jessePinkman)
		val existeIBM = createIfNotExists(ibm)
		val existeWalterWhite = createIfNotExists(walterWhite)

		jessePinkman = homeTelefonia.getAbonado(jessePinkman, true)
		val ibmBD = homeTelefonia.getAbonado(ibm, true)
		walterWhite = homeTelefonia.getAbonado(walterWhite, true)

		// El update lo tenemos que hacer por separado por las referencias circulares
		if (!existeWalterWhite) {
			var Llamada llamada2 = new Llamada => [
				origen = walterWhite
				destino = ibmBD
				duracion = 2
			]
			walterWhite.agregarLlamada(llamada1)
			walterWhite.agregarLlamada(llamada2)
			homeTelefonia.actualizarAbonado(walterWhite)
		}

		if (!existeIBM) {
			ibm.agregarLlamada(new Llamada => [
				origen = ibmBD
				destino = jessePinkman
				duracion = 5
			])
			homeTelefonia.actualizarAbonado(ibm)
		}
	}

	def createIfNotExists(Abonado abonado) {
		val existe = homeTelefonia.getAbonado(abonado) !== null
		println("Get abonado: " + abonado.nombre + " - existe " + existe)
		if (!existe) {
			homeTelefonia.actualizarAbonado(abonado)
		}
		existe
	}

	@Test
	def void walterWhiteTiene2Llamadas() {
		var walterWhiteBD = homeTelefonia.getAbonado(walterWhite, true)
		var llamadasDeWalterWhite = walterWhiteBD.llamadas
		Assert.assertEquals(2, llamadasDeWalterWhite.size)
	}

	@Test(expected=LazyInitializationException)
	def void walterWhiteTiene2LlamadasSinSesionHibernate() {
		val walterWhiteBD = homeTelefonia.getAbonado(walterWhite, false)
		walterWhiteBD.llamadas.size
	}

	@Test
	def void deudaDeWalterWhite() {
		val walterWhiteBD = homeTelefonia.getAbonado(walterWhite, true)
		Assert.assertEquals(860, walterWhiteBD.deuda, 0.1)
	}

	@Test
	def void walterWhiteCostoDeLlamada1() {
		val walterWhiteBD = homeTelefonia.getAbonado(walterWhite, true)
		Assert.assertEquals(20, walterWhiteBD.costo(llamada1), 0.1)
	}

}
