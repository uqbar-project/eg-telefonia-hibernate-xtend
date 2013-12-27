package ar.edu.telefonia.domain;

import ar.edu.telefonia.domain.Factura;
import ar.edu.telefonia.domain.Llamada;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.DiscriminatorType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.OneToMany;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Functions.Function2;
import org.eclipse.xtext.xbase.lib.IterableExtensions;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "TIPO_ABONADO", discriminatorType = DiscriminatorType.STRING)
@SuppressWarnings("all")
public abstract class Abonado {
  @Id
  @GeneratedValue
  private Long _id;
  
  public Long getId() {
    return this._id;
  }
  
  public void setId(final Long id) {
    this._id = id;
  }
  
  @Column
  private String _nombre;
  
  public String getNombre() {
    return this._nombre;
  }
  
  public void setNombre(final String nombre) {
    this._nombre = nombre;
  }
  
  @Column
  private String _numero;
  
  public String getNumero() {
    return this._numero;
  }
  
  public void setNumero(final String numero) {
    this._numero = numero;
  }
  
  @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
  private List<Factura> _facturas = new Function0<List<Factura>>() {
    public List<Factura> apply() {
      ArrayList<Factura> _arrayList = new ArrayList<Factura>();
      return _arrayList;
    }
  }.apply();
  
  public List<Factura> getFacturas() {
    return this._facturas;
  }
  
  public void setFacturas(final List<Factura> facturas) {
    this._facturas = facturas;
  }
  
  @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
  private List<Llamada> _llamadas = new Function0<List<Llamada>>() {
    public List<Llamada> apply() {
      ArrayList<Llamada> _arrayList = new ArrayList<Llamada>();
      return _arrayList;
    }
  }.apply();
  
  public List<Llamada> getLlamadas() {
    return this._llamadas;
  }
  
  public void setLlamadas(final List<Llamada> llamadas) {
    this._llamadas = llamadas;
  }
  
  public abstract float costo(final Llamada llamada);
  
  public boolean esMoroso() {
    Double _deuda = this.deuda();
    boolean _greaterThan = ((_deuda).doubleValue() > 0);
    return _greaterThan;
  }
  
  public Double deuda() {
    List<Factura> _facturas = this.getFacturas();
    final Function2<Double,Factura,Double> _function = new Function2<Double,Factura,Double>() {
      public Double apply(final Double acum, final Factura factura) {
        BigDecimal _saldo = factura.getSaldo();
        float _floatValue = _saldo.floatValue();
        double _plus = ((acum).doubleValue() + _floatValue);
        return Double.valueOf(_plus);
      }
    };
    Double _fold = IterableExtensions.<Factura, Double>fold(_facturas, Double.valueOf(0.0), _function);
    return _fold;
  }
  
  public boolean agregarLlamada(final Llamada llamada) {
    List<Llamada> _llamadas = this.getLlamadas();
    boolean _add = _llamadas.add(llamada);
    return _add;
  }
  
  public boolean agregarFactura(final Factura factura) {
    List<Factura> _facturas = this.getFacturas();
    boolean _add = _facturas.add(factura);
    return _add;
  }
  
  /**
   * EXTENSION METHODS
   */
  public Integer max(final Integer integer, final Integer integer2) {
    Integer _xifexpression = null;
    boolean _greaterThan = (integer.compareTo(integer2) > 0);
    if (_greaterThan) {
      _xifexpression = integer;
    } else {
      _xifexpression = integer2;
    }
    return _xifexpression;
  }
  
  public Integer min(final Integer integer, final Integer integer2) {
    Integer _max = this.max(integer2, integer);
    return _max;
  }
}
