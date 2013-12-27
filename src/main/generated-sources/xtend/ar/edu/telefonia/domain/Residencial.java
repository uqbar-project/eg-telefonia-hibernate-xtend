package ar.edu.telefonia.domain;

import ar.edu.telefonia.domain.Abonado;
import ar.edu.telefonia.domain.Llamada;
import javax.persistence.DiscriminatorValue;
import javax.persistence.Entity;

@Entity
@DiscriminatorValue("RS")
@SuppressWarnings("all")
public class Residencial extends Abonado {
  public float costo(final Llamada llamada) {
    Integer _duracion = llamada.getDuracion();
    int _multiply = (2 * (_duracion).intValue());
    return _multiply;
  }
}
