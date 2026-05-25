# Proyecto 6: ECS Fargate + Application Load Balancer

**Despliegue de aplicaciones containerizadas en AWS usando ECS Fargate con balanceo de carga automático.**

---

## 📋 Descripción General

Este proyecto implementa una **infraestructura serverless de contenedores** en AWS. Utiliza ECS Fargate para ejecutar contenedores Docker sin gestionar servidores EC2, y un Application Load Balancer (ALB) para distribuir el tráfico entre múltiples instancias de la aplicación.

**Objetivo:** Aprender a desplegar aplicaciones containerizadas con escalado automático y alta disponibilidad.

---

## 🎯 ¿Qué se espera que pase?

Cuando ejecutes `terraform apply`:

1. ✅ **VPC se crea** con subnets públicas y privadas
2. ✅ **Application Load Balancer se crea** en subnets públicas
3. ✅ **ECS Cluster se crea** para orquestar contenedores
4. ✅ **Task Definition se define** con imagen Docker
5. ✅ **ECS Service se crea** con 2 tareas iniciales
6. ✅ **Auto Scaling se configura** (2 a 4 tareas según CPU/Memoria)
7. ✅ **CloudWatch Logs se configura** para monitoreo
8. ✅ **ALB DNS se muestra** para acceder a la aplicación

**Resultado:** Aplicación NGINX accesible vía URL pública con escalado automático.

---

## 🏗️ Arquitectura

```
                        Internet (0.0.0.0/0)
                               ↓
                    [Application Load Balancer]
                      (puerto 80, públicas)
                               ↓
              ┌────────────────────────────────┐
              │   VPC (10.0.0.0/16)            │
              │                                │
    ┌─────────────────────────────────────────────────┐
    │                                                 │
    │  PUBLIC SUBNETS (ALB)                           │
    │  ├─ 10.0.1.0/24 (us-east-1a)                    │
    │  └─ 10.0.2.0/24 (us-east-1b)                    │
    │                                                 │
    │  PRIVATE SUBNETS (ECS Tasks)                    │
    │  ├─ 10.0.10.0/24 (us-east-1a)                   │
    │  │   └─ [ECS Task 1] (nginx)                    │
    │  └─ 10.0.11.0/24 (us-east-1b)                   │
    │      └─ [ECS Task 2] (nginx)                    │
    │                                                 │
    │  [ECS Cluster] ← Orquesta tareas                │
    │  [Auto Scaling] ← Escala 2-4 tareas             │
    │  [CloudWatch] ← Logs de tareas                  │
    │                                                 │
    └─────────────────────────────────────────────────┘
```

---

## 📦 Estructura del Proyecto

```
proyecto6-ecs-fargate-alb/
├── providers.tf           # Configuración de AWS Provider
├── variables.tf           # Variables de Terraform
├── main.tf                # Recursos: VPC, ALB, ECS, Auto Scaling
├── outputs.tf             # Outputs (URL, ARNs, etc)
├── terraform.tfvars       # Valores de variables
├── .gitignore             # Archivos a ignorar
└── README.md              # Este archivo
```

---

## 🚀 Uso Rápido

### Prerequisitos

- **Terraform** 1.0+ ([Descargar](https://www.terraform.io/downloads))
- **AWS CLI** configurado
- **Cuenta AWS** activa

### Instalación y Despliegue

```bash
# 1. Clona el repositorio
git clone https://github.com/Ferdev49/proyecto6-ecs-fargate-alb.git
cd proyecto6-ecs-fargate-alb

# 2. Inicializa Terraform
terraform init

# 3. Revisa qué se va a crear
terraform plan

# 4. Crea la infraestructura
terraform apply

# 5. Ve los outputs
terraform output

# 6. Accede a la aplicación
echo "http://$(terraform output -raw alb_dns_name)"

# 7. Destruye (para evitar costos)
terraform destroy
```

---

## 📊 Componentes Creados

### VPC y Networking

```
VPC CIDR: 10.0.0.0/16
Subnets públicas: 2 (ALB)
Subnets privadas: 2 (ECS Tasks)
NAT Gateway: 1 (tráfico saliente)
Internet Gateway: 1 (tráfico entrante)
```

**Propósito:** Red aislada con acceso controlado a internet.

---

### Application Load Balancer (ALB)

```
Ubicación: Subnets públicas
Puerto: 80 (HTTP)
Target Group: ECS Tasks
Health Check: Cada 30s
```

**Propósito:** 
- Distribuir tráfico entre múltiples tareas
- Descubrir automáticamente nuevas tareas
- Health checks para retirar tareas no sanas

---

### ECS Cluster

```
Cluster Name: proyecto6-cluster
Capacity Providers: FARGATE + FARGATE_SPOT
Container Insights: Enabled
```

**Propósito:** Orquestar contenedores sin gestionar servidores.

---

### ECS Task Definition

```
Familia: proyecto6-task
CPU: 256 unidades
Memoria: 512 MB
Imagen: nginx:latest
Puerto: 80
Logs: CloudWatch Logs
```

**Propósito:** Define cómo ejecutar la aplicación.

---

### ECS Service

```
Nombre: proyecto6-service
Desired Count: 2 tareas
Launch Type: FARGATE
Redes: Subnets privadas
Load Balancer: ALB
```

**Propósito:** Mantener 2 tareas ejecutándose en todo momento.

---

### Auto Scaling

```
Mínimo: 2 tareas
Máximo: 4 tareas

Escalado por CPU:
  - Target: 70% promedio
  - Acción: Agregar tareas si >70%

Escalado por Memoria:
  - Target: 80% promedio
  - Acción: Agregar tareas si >80%
```

**Propósito:** Ajustar capacidad automáticamente según demanda.

---

### CloudWatch Logs

```
Log Group: /ecs/proyecto6
Retención: 7 días
Stream Prefix: ecs
```

**Propósito:** Centralizar logs de todas las tareas.

---

## 🔧 Variables Configurables

Edita `terraform.tfvars`:

```hcl
aws_region = "us-east-1"              # Región AWS
environment = "dev"                   # Ambiente
project_name = "proyecto6"            # Nombre proyecto

# Networking
vpc_cidr = "10.0.0.0/16"
public_subnet_1_cidr = "10.0.1.0/24"
public_subnet_2_cidr = "10.0.2.0/24"
private_subnet_1_cidr = "10.0.10.0/24"
private_subnet_2_cidr = "10.0.11.0/24"

# Container
container_name = "app-container"
container_image = "nginx:latest"      # Tu imagen Docker
container_port = 80

# Task Resources
task_cpu = "256"                       # CPU units (256, 512, 1024)
task_memory = "512"                    # MB (512, 1024, 2048)

# Scaling
desired_count = 2                      # Tareas iniciales
alb_port = 80                          # Puerto ALB
```

---

## 📤 Outputs

Después de `terraform apply`:

```bash
$ terraform output

vpc_id = "vpc-xxx"

alb_dns_name = "proyecto6-alb-xxx.us-east-1.elb.amazonaws.com"
alb_arn = "arn:aws:elasticloadbalancing:us-east-1:xxx:loadbalancer/app/..."

ecs_cluster_name = "proyecto6-cluster"
ecs_cluster_arn = "arn:aws:ecs:us-east-1:xxx:cluster/proyecto6-cluster"

ecs_service_name = "proyecto6-service"
ecs_task_definition_arn = "arn:aws:ecs:us-east-1:xxx:task-definition/..."

cloudwatch_log_group = "/ecs/proyecto6"

application_url = "http://proyecto6-alb-xxx.us-east-1.elb.amazonaws.com"

ecs_summary = {
  "alb_dns" = "proyecto6-alb-xxx.us-east-1.elb.amazonaws.com"
  "application_url" = "http://proyecto6-alb-xxx.us-east-1.elb.amazonaws.com"
  "cluster_name" = "proyecto6-cluster"
  "desired_count" = 2
  "log_group" = "/ecs/proyecto6"
  "service_name" = "proyecto6-service"
  "task_cpu" = "256"
  "task_memory" = "512"
}
```

---

## 🌐 Acceder a la Aplicación

```bash
# Get ALB URL
terraform output -raw alb_dns_name

# Open in browser
http://proyecto6-alb-xxx.us-east-1.elb.amazonaws.com
```

Deberías ver la página NGINX por defecto.

---

## 📊 Monitoreo

### Ver Logs

```bash
# CloudWatch Logs
aws logs tail /ecs/proyecto6 --follow

# O desde la consola AWS:
# CloudWatch → Log Groups → /ecs/proyecto6
```

### Ver Tareas

```bash
# Listar tareas en ejecución
aws ecs list-tasks --cluster proyecto6-cluster

# Descripción detallada
aws ecs describe-tasks --cluster proyecto6-cluster --tasks <task-arn>
```

### Ver Métricas

CloudWatch → Dashboards → (Ver CPU, Memoria, Request Count)

---

## 💰 Costos Estimados

**Por mes (aprox):**
- ECS Fargate (2 tareas 256 CPU/512 MB): ~$18
- ALB: ~$16
- Data Transfer: ~$0-5
- **Total: ~$35-40/mes**

**Recomendación:** Ejecuta `terraform destroy` cuando no necesites.

---

## 🔍 Debugging

### ALB no recibe tráfico

```bash
# Verificar health checks
aws elbv2 describe-target-health \
  --target-group-arn <target-group-arn>
```

### Tasks no inician

```bash
# Ver logs de CloudWatch
aws logs tail /ecs/proyecto6 --follow

# Ver detalles de tarea
aws ecs describe-tasks \
  --cluster proyecto6-cluster \
  --tasks <task-arn>
```

### Auto Scaling no funciona

```bash
# Verificar target
aws application-autoscaling describe-scalable-targets \
  --service-namespace ecs
```

---

## 📈 Escalado Manual

```bash
# Aumentar a 4 tareas
aws ecs update-service \
  --cluster proyecto6-cluster \
  --service proyecto6-service \
  --desired-count 4

# Volver a 2
aws ecs update-service \
  --cluster proyecto6-cluster \
  --service proyecto6-service \
  --desired-count 2
```

---

## 🔄 Actualizar Imagen Docker

```hcl
# En terraform.tfvars
container_image = "tu-imagen:v2"

# Luego
terraform plan
terraform apply
```

ECS actualizará las tareas automáticamente.

---

## 🎓 Conceptos Aprendidos

1. **ECS Fargate:** Contenedores sin servidores EC2
2. **ALB:** Load Balancer para distribuir tráfico
3. **Target Groups:** Grupo de targets para ALB
4. **Task Definition:** Configuración de contenedor
5. **ECS Service:** Mantiene N tareas ejecutándose
6. **Auto Scaling:** Escala automática por métricas
7. **CloudWatch Logs:** Centralización de logs
8. **IAM Roles:** Permisos para ECS tasks

---

## 🚀 Mejoras Futuras

- Agregar HTTPS (SSL/TLS)
- Integrar con RDS para base de datos
- CI/CD con GitHub Actions
- Canary deployments
- Despliegue de tu aplicación (no nginx)
- Multi-region

---

## 📚 Recursos Adicionales

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Terraform AWS ECS Module](https://registry.terraform.io/modules/terraform-aws-modules/ecs/aws)
- [ALB Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [ECS Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/best_practices.html)

---

**Última actualización:** Mayo 23, 2026
**Versión:** 1.0.0
**Estado:** ✅ Completado y Testeado