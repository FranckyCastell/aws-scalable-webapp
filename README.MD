# Proyecto: Aplicación Web Escalable y Segura en AWS

Este proyecto despliega una aplicación web altamente disponible, escalable y segura en Amazon Web Services (AWS) utilizando Terraform para la infraestructura como código (IaC). La arquitectura está diseñada para manejar tráfico web dinámico, ofrecer alta disponibilidad y protegerse contra amenazas comunes de seguridad web.

## Tabla de Contenidos

1.  [Visión General del Proyecto](#1-visión-general-del-proyecto)
2.  [Arquitectura](#2-arquitectura)
3.  [Componentes Clave de AWS](#3-componentes-clave-de-aws)
4.  [Requisitos Previos](#4-requisitos-previos)
5.  [Configuración del Proyecto](#5-configuración-del-proyecto)
6.  [Despliegue](#6-despliegue)
7.  [Mantenimiento y Operaciones](#7-mantenimiento-y-operaciones)
8.  [Seguridad](#8-seguridad)

---

## 1. Visión General del Proyecto

Este repositorio contiene el código Terraform necesario para provisionar y gestionar la infraestructura de una aplicación web en AWS. El objetivo principal es establecer un entorno robusto que sea:

* **Escalable:** Capaz de manejar aumentos y disminuciones en la carga de tráfico automáticamente.
* **Altamente Disponible:** Tolerante a fallos de componentes individuales o zonas de disponibilidad completas.
* **Seguro:** Protegido contra ataques web comunes mediante AWS WAF y configuraciones de red adecuadas.
* **Automatizado:** Desplegado y gestionado a través de infraestructura como código (Terraform).

## 2. Arquitectura

La aplicación se despliega siguiendo un patrón de arquitectura de microservicios o monolito moderno, distribuida en múltiples Zonas de Disponibilidad (AZs) para garantizar la resiliencia.

**Diagrama de Arquitectura:**

![Diagrama de Arquitectura AWS](https://d2908q01vomqb2.cloudfront.net/4d134bc072212ace2df385dae143139da74ec0ef/2022/04/11/arquitectura-MPM-1024x763.png)

### Flujo de Tráfico:

1.  **Internet:** Los usuarios acceden a la aplicación a través de la dirección IP o el nombre de dominio.
2.  **AWS Route 53:** Gestiona las resoluciones DNS y enruta el tráfico hacia el WAF.
3.  **AWS WAF (Web Application Firewall):** Inspecciona y filtra el tráfico web malicioso antes de que llegue a la aplicación. Incluye reglas para protección contra inyección SQL, limitación de tasa (rate limiting) y otras amenazas.
4.  **Application Load Balancer (ALB):** Distribuye el tráfico web legítimo a las instancias EC2 del Auto Scaling Group.
5.  **Auto Scaling Group (ASG):** Gestiona la cantidad de instancias EC2 que ejecutan la aplicación, escalando automáticamente hacia arriba o hacia abajo según la demanda. Las instancias se distribuyen entre múltiples Zonas de Disponibilidad.
6.  **Instancias EC2:** Servidores virtuales que alojan y ejecutan el código de la aplicación.
7.  **Amazon S3:** Utilizado para almacenar contenido estático (imágenes, videos), logs de acceso del ALB/WAF y backups.
8.  **Base de Datos (RDS o similar):** Almacena los datos persistentes de la aplicación. Se asume una base de datos gestionada por AWS (como Amazon RDS) para alta disponibilidad y backups automáticos.
9.  **Amazon CloudWatch:** Monitoriza la salud y el rendimiento de todos los componentes de la infraestructura, enviando métricas y logs.

## 3. Componentes Clave de AWS

* **Amazon VPC:** Red virtual aislada para todos los recursos de la aplicación.
* **Amazon Route 53:** Servicio de DNS escalable y de alta disponibilidad.
* **AWS WAFv2:** Protege las aplicaciones web de exploits web comunes.
* **Application Load Balancer (ALB):** Distribuye el tráfico HTTP/S entre múltiples objetivos.
* **Auto Scaling Group (ASG):** Permite escalar automáticamente el número de instancias EC2.
* **Amazon EC2:** Servidores virtuales que ejecutan la aplicación.
* **Amazon S3:** Almacenamiento de objetos escalable para datos estáticos y logs.
* **Amazon RDS:** Servicio de base de datos relacional gestionado (asumido).
* **Amazon CloudWatch:** Servicio de monitoreo y logging.

## 4. Requisitos Previos

Antes de desplegar este proyecto, asegúrate de tener lo siguiente:

* **Cuenta de AWS:** Acceso a una cuenta de AWS con permisos suficientes para crear los recursos necesarios.
* **AWS CLI:** Configurado con credenciales que tengan los permisos adecuados (recomendado el uso de un rol IAM con políticas de mínimo privilegio).
    * `aws configure`
* **Terraform:** Versión 1.0.0 o superior instalada.
    * [Descargar Terraform](https://www.terraform.io/downloads.html)
* **Git:** Para clonar este repositorio.

## 5. Configuración del Proyecto

1.  **Clona el repositorio:**
    ```bash
    git clone aws-scalable-webapp
    cd aws-scalable-webapp
    ```

## 6. Despliegue

Sigue estos pasos para desplegar la infraestructura:

1.  **Inicializar Terraform:**
    ```bash
    terraform init
    ```
    Esto descargará los plugins de los proveedores de AWS necesarios.

2.  **Revisar el Plan de Ejecución:**
    ```bash
    terraform plan
    ```
    Este comando generará un plan de lo que Terraform hará. Revisa cuidadosamente la salida para asegurarte de que los cambios propuestos son los esperados.

3.  **Aplicar el Plan:**
    ```bash
    terraform apply
    ```
    Confirma con `yes` cuando se te solicite para iniciar el despliegue de los recursos en tu cuenta de AWS. Este proceso puede tardar varios minutos.

4.  **Verificar el Despliegue:**
    Una vez que `terraform apply` se haya completado exitosamente, podrás obtener las salidas (outputs) definidas en tu configuración de Terraform, como la URL del ALB o el nombre del WAF.

    ```bash
    terraform output
    ```

## 7. Mantenimiento y Operaciones

* **Monitoreo:** Utiliza Amazon CloudWatch para monitorear la salud de las instancias EC2, el rendimiento del ALB, las métricas del WAF y el estado de la base de datos. Configura alarmas para eventos críticos.
* **Logs:** Los logs del ALB, WAF y las instancias EC2 deben estar configurados para enviarse a S3 o CloudWatch Logs para su análisis y auditoría.
* **Actualizaciones de Código:** Las actualizaciones de la aplicación en las instancias EC2 deben manejarse mediante un proceso de CI/CD (Integración Continua/Despliegue Continuo) o actualizando las AMIs utilizadas por el Auto Scaling Group.
* **Actualizaciones de Infraestructura:** Cualquier cambio en la infraestructura debe realizarse modificando los archivos `.tf` y ejecutando `terraform plan` y `terraform apply` nuevamente.

## 8. Seguridad

* **AWS WAF:** Configurado con reglas gestionadas por AWS (ej., `AWSManagedRulesSQLiRuleSet`) y reglas personalizadas (ej., `rate-limit-rule`) para proteger la aplicación.
* **Security Groups:** Los Security Groups están configurados para permitir solo el tráfico necesario entre componentes (ej., el ALB puede acceder a las instancias EC2 en el puerto de la aplicación, y las instancias EC2 pueden acceder a la base de datos).
* **Network ACLs:** Las ACLs de red (NACLs) se utilizan como una capa adicional de seguridad a nivel de subred si es necesario.
* **IAM Roles:** Las instancias EC2 y otros servicios utilizan roles IAM con el principio de mínimo privilegio para acceder a otros servicios de AWS.
* **HTTPS/SSL:** El ALB debe estar configurado para forzar HTTPS con certificados SSL/TLS (ACM).