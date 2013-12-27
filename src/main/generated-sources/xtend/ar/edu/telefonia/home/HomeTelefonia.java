package ar.edu.telefonia.home;

import ar.edu.telefonia.domain.Abonado;
import ar.edu.telefonia.domain.Empresa;
import ar.edu.telefonia.domain.Factura;
import ar.edu.telefonia.domain.Llamada;
import ar.edu.telefonia.domain.Residencial;
import ar.edu.telefonia.domain.Rural;
import java.util.List;
import javax.xml.transform.Result;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.classic.Session;
import org.hibernate.criterion.Restrictions;
import org.hibernate.criterion.SimpleExpression;

@SuppressWarnings("all")
public class HomeTelefonia {
  private final static SessionFactory sessionFactory = new Function0<SessionFactory>() {
    public SessionFactory apply() {
      AnnotationConfiguration _annotationConfiguration = new AnnotationConfiguration();
      AnnotationConfiguration _configure = _annotationConfiguration.configure();
      AnnotationConfiguration _addAnnotatedClass = _configure.addAnnotatedClass(Factura.class);
      AnnotationConfiguration _addAnnotatedClass_1 = _addAnnotatedClass.addAnnotatedClass(Llamada.class);
      AnnotationConfiguration _addAnnotatedClass_2 = _addAnnotatedClass_1.addAnnotatedClass(Residencial.class);
      AnnotationConfiguration _addAnnotatedClass_3 = _addAnnotatedClass_2.addAnnotatedClass(Rural.class);
      AnnotationConfiguration _addAnnotatedClass_4 = _addAnnotatedClass_3.addAnnotatedClass(Empresa.class);
      AnnotationConfiguration _addAnnotatedClass_5 = _addAnnotatedClass_4.addAnnotatedClass(Abonado.class);
      SessionFactory _buildSessionFactory = _addAnnotatedClass_5.buildSessionFactory();
      return _buildSessionFactory;
    }
  }.apply();
  
  public Abonado getAbonado(final Abonado abonado) {
    Abonado _abonado = this.getAbonado(abonado, false);
    return _abonado;
  }
  
  public Abonado getAbonado(final Abonado pAbonado, final boolean full) {
    Abonado _xblockexpression = null;
    {
      List<Result> result = null;
      final Session session = HomeTelefonia.sessionFactory.openSession();
      Abonado _xtrycatchfinallyexpression = null;
      try {
        Abonado _xblockexpression_1 = null;
        {
          Criteria _createCriteria = session.createCriteria(Abonado.class);
          String _nombre = pAbonado.getNombre();
          SimpleExpression _eq = Restrictions.eq("nombre", _nombre);
          Criteria _add = _createCriteria.add(_eq);
          List _list = _add.list();
          result = _list;
          Abonado _xifexpression = null;
          boolean _isEmpty = result.isEmpty();
          if (_isEmpty) {
            _xifexpression = null;
          } else {
            Abonado _xblockexpression_2 = null;
            {
              Result _get = result.get(0);
              Abonado abonado = ((Abonado) _get);
              if (full) {
                List<Factura> _facturas = abonado.getFacturas();
                _facturas.size();
                List<Llamada> _llamadas = abonado.getLlamadas();
                _llamadas.size();
              }
              _xblockexpression_2 = (abonado);
            }
            _xifexpression = _xblockexpression_2;
          }
          _xblockexpression_1 = (_xifexpression);
        }
        _xtrycatchfinallyexpression = _xblockexpression_1;
      } catch (final Throwable _t) {
        if (_t instanceof HibernateException) {
          final HibernateException e = (HibernateException)_t;
          RuntimeException _runtimeException = new RuntimeException(e);
          throw _runtimeException;
        } else {
          throw Exceptions.sneakyThrow(_t);
        }
      } finally {
        session.close();
      }
      _xblockexpression = (_xtrycatchfinallyexpression);
    }
    return _xblockexpression;
  }
  
  public void actualizarAbonado(final Abonado abonado) {
    final Session session = HomeTelefonia.sessionFactory.openSession();
    try {
      session.beginTransaction();
      session.saveOrUpdate(abonado);
      Transaction _transaction = session.getTransaction();
      _transaction.commit();
    } catch (final Throwable _t) {
      if (_t instanceof HibernateException) {
        final HibernateException e = (HibernateException)_t;
        Transaction _transaction_1 = session.getTransaction();
        _transaction_1.rollback();
        RuntimeException _runtimeException = new RuntimeException(e);
        throw _runtimeException;
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    } finally {
      session.close();
    }
  }
}
