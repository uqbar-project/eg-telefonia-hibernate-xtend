# Telefonía

## Objetivo
El ejemplo de abonados de una empresa telefónica muestra cómo mapear relaciones de herencia, one-to-many y many-to-one en Hibernate.

## Cómo correrlo

* BASE DE DATOS: En MySQL, crear una base de datos telefonia.
* SOLUCION: En Xtend. Cuenta con JUnit tests para probar el dominio en forma aislada
 * Se puede integrar con el proyecto telefonia-ui-arena-xtend (para dar de alta, editar, eliminar y buscar)

Lo que deben hacer es modificar la dependencia del pom del proyecto de Arena, donde dice

``` xml
<!-- Persistencia simulada utlizando una coleccion en memoria -->
<dependency>
    <groupId>org.uqbar-project</groupId>
    <artifactId>telefonia-domain-xtend</artifactId>
    <version>1.0.1</version>
</dependency>
```

 reemplazarlo por

``` xml
<!--  Persistencia utilizando Hibernate como OR/M contra un MySQL -->
<dependency>
     <groupId>org.uqbar-project</groupId>
     <artifactId>telefonia-hibernate-xtend</artifactId>
     <version>1.0.1</version>
</dependency>
```

o la versión que quieras (en git es la versión de trabajo vs. la que está deployada en los repositorios).

## Configuraciones
Previamente, entrá al recurso hibernate.cfg.xml (Ctrl + Shift + R > tipeá hibernate y te aparece) y 
cambiá la contraseña de root de tu base

``` xml
<property name="hibernate.connection.password">xxxxx</property>
```

Si vas a ponerle otro nombre al esquema (base de datos), tenés que modificar la configuración del hibernate.cfg.xml 
para que apunte allí:

``` xml
<property name="hibernate.connection.url">jdbc:mysql://localhost/telefonia</property>
```

## Diagrama de entidad-relación

![Solución](docs/DER telefonia.png)
