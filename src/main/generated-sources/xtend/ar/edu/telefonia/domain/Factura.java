package ar.edu.telefonia.domain;

import java.math.BigDecimal;
import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
@SuppressWarnings("all")
public class Factura {
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
  private Date _fecha;
  
  public Date getFecha() {
    return this._fecha;
  }
  
  public void setFecha(final Date fecha) {
    this._fecha = fecha;
  }
  
  @Column
  private BigDecimal _totalPagado;
  
  public BigDecimal getTotalPagado() {
    return this._totalPagado;
  }
  
  public void setTotalPagado(final BigDecimal totalPagado) {
    this._totalPagado = totalPagado;
  }
  
  @Column
  private BigDecimal _total;
  
  public BigDecimal getTotal() {
    return this._total;
  }
  
  public void setTotal(final BigDecimal total) {
    this._total = total;
  }
  
  public BigDecimal getSaldo() {
    BigDecimal _totalPagado = this.getTotalPagado();
    BigDecimal _total = this.getTotal();
    BigDecimal _subtract = _totalPagado.subtract(_total);
    return _subtract;
  }
  
  public Factura(final Date unaFecha, final int elTotalPagado, final int elTotal) {
    this.setFecha(unaFecha);
    BigDecimal _bigDecimal = new BigDecimal(elTotalPagado);
    this.setTotalPagado(_bigDecimal);
    BigDecimal _bigDecimal_1 = new BigDecimal(elTotal);
    this.setTotal(_bigDecimal_1);
  }
}
