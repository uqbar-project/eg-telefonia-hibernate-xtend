package ar.edu.telefonia.domain;

import ar.edu.telefonia.domain.Abonado;
import ar.edu.telefonia.domain.Llamada;
import javax.persistence.Column;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("RU")
@SuppressWarnings("all")
public class Rural extends Abonado {
  private Integer _cantidadHectareas;
  
  public void setCantidadHectareas(final Integer cantidadHectareas) {
    this._cantidadHectareas = cantidadHectareas;
  }
  
  @Column
  public Integer getCantidadHectareas() {
    return this._cantidadHectareas;
  }
  
  public Rural(final Integer laCantidadHectareas) {
    this.setCantidadHectareas(this._cantidadHectareas);
  }
  
  public float costo(final Llamada llamada) {
    Integer _duracion = llamada.getDuracion();
    Integer _integer = new Integer(5);
    Integer _max = this.max(_duracion, _integer);
    int _multiply = (3 * (_max).intValue());
    return _multiply;
  }
}
