SELECT 
    e.carne AS "CARNÉ",
    e.nombre_completo AS "NOMBRE COMPLETO",
    emp.nombre AS "EMPRESA",
    p.especialidad_tecnica AS "ESPECIALIDAD DE PLAZA"
FROM COLOCACION c
INNER JOIN ESTUDIANTE e 
    ON c.estudiante_id_estudiante = e.id_estudiante
INNER JOIN PLAZA p 
    ON c.plaza_id_plaza = p.id_plaza
INNER JOIN EMPRESA emp 
    ON p.empresa_id_empresa = emp.id_empresa
INNER JOIN ESTADO_COLOCACION ec 
    ON c.estado = ec.id_estado
WHERE ec.nombre = 'Activa';