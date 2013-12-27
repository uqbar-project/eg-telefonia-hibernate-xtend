package ar.edu.telefonia.domain;

import ar.edu.telefonia.domain.Abonado;
import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;

@SuppressWarnings("all")
public class Llamada {
  @Id
  @GeneratedValue
  private Long _id;
  
  public Long getId() {
    return this._id;
  }
  
  public void setId(final Long id) {
    this._id = id;
  }
  
  @ManyToOne
  private Abonado _origen;
  
  public Abonado getOrigen() {
    return this._origen;
  }
  
  public void setOrigen(final Abonado origen) {
    this._origen = origen;
  }
  
  @ManyToOne
  private Abonado _destino;
  
  public Abonado getDestino() {
    return this._destino;
  }
  
  public void setDestino(final Abonado destino) {
    this._destino = destino;
  }
  
  @Column
  private Integer _duracion;
  
  public Integer getDuracion() {
    return this._duracion;
  }
  
  public void setDuracion(final Integer duracion) {
    this._duracion = duracion;
  }
  
  public Llamada(final Abonado unOrigen, final Abonado unDestino, final Integer unaDuracion) {
    this.setOrigen(unOrigen);
    this.setDestino(unDestino);
    this.setDuracion(unaDuracion);
  }
}
