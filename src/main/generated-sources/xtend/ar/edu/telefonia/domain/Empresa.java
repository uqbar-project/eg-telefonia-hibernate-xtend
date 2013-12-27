package ar.edu.telefonia.domain;

import ar.edu.telefonia.domain.Abonado;
import ar.edu.telefonia.domain.Factura;
import ar.edu.telefonia.domain.Llamada;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("EM")
@SuppressWarnings("all")
public class Empresa extends Abonado {
  private String _cuit;
  
  public void setCuit(final String cuit) {
    this._cuit = cuit;
  }
  
  @Column
  public String getCuit() {
    return this._cuit;
  }
  
  public Empresa(final String unCuit) {
    this.setCuit(unCuit);
  }
  
  public float costo(final Llamada llamada) {
    Integer _duracion = llamada.getDuracion();
    Integer _min = this.min(_duracion, Integer.valueOf(3));
    int _multiply = (1 * (_min).intValue());
    return _multiply;
  }
  
  public boolean esMoroso() {
    List<Factura> _facturas = this.getFacturas();
    int _size = _facturas.size();
    boolean _greaterThan = (_size > 3);
    return _greaterThan;
  }
}
