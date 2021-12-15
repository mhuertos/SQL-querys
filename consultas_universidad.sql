/*1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els alumnes. 
El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.*/
SELECT apellido1, apellido2, nombre FROM persona 
WHERE tipo='alumno'
ORDER BY apellido1 asc, apellido2 asc, nombre asc;

-- 2. Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre, apellido1, apellido2 FROM persona
WHERE tipo= 'alumno' AND telefono IS NULL;

-- 3. Retorna el llistat dels alumnes que van néixer en 1999.
SELECT * FROM persona
WHERE tipo = 'alumno' AND fecha_nacimiento LIKE '1999%';

-- 4. Retorna el llistat de professors que no han donat d'alta el seu número de telèfon en la base de dades i a més la seva nif acaba en K.
SELECT * FROM persona
WHERE tipo = 'profesor' AND telefono IS NULL AND nif LIKE '%k';

-- 5. Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT * FROM asignatura 
WHERE cuatrimestre=1 AND curso=3 AND id_grado=7;

/* 6. Retorna un llistat dels professors juntament amb el nom del departament al qual estan vinculats. 
El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. 
El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.*/
SELECT p.nombre, p.apellido1, p.apellido2, d.nombre FROM (persona p LEFT JOIN profesor t ON p.id=t.id_profesor) 
LEFT JOIN departamento d ON t.id_departamento=d.id
WHERE d.nombre IS NOT NULL 
ORDER BY p.apellido1 asc, p.apellido2 asc, p.nombre asc;

-- 7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne amb nif 26902806M.
SELECT asignatura.nombre, curso_escolar.anyo_inicio, curso_escolar.anyo_fin FROM 
(alumno_se_matricula_asignatura LEFT JOIN asignatura ON alumno_se_matricula_asignatura.id_asignatura=asignatura.id)
LEFT JOIN curso_escolar ON alumno_se_matricula_asignatura.id_curso_escolar=curso_escolar.id
WHERE alumno_se_matricula_asignatura.id_alumno = (SELECT id FROM persona WHERE nif LIKE '26902806M');

/* 8. Retorna un llistat amb el nom de tots els departaments que tenen professors que imparteixen alguna assignatura 
en el Grau en Enginyeria Informàtica (Pla 2015).*/
SELECT nombre FROM departamento
WHERE id IN (SELECT id_departamento FROM profesor 
			 WHERE id_profesor IN (SELECT a.id_profesor FROM asignatura a LEFT JOIN grado g 
								   ON a.id_grado = g.id
								   WHERE g.nombre LIKE 'Grado en Ingeniería Informática (Plan 2015)'));
                                   
-- 9.Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT DISTINCT alumno_se_matricula_asignatura.id_alumno FROM (alumno_se_matricula_asignatura LEFT JOIN asignatura 
ON alumno_se_matricula_asignatura.id_asignatura=asignatura.id) 
LEFT JOIN curso_escolar ON alumno_se_matricula_asignatura.id_curso_escolar=curso_escolar.id
WHERE anyo_inicio LIKE '2018';

/* 10. Retorna un llistat amb els noms de tots els professors i els departaments que tenen vinculats. 
El llistat també ha de mostrar aquells professors que no tenen cap departament associat. 
El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor. 
El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.*/
SELECT d.nombre, p.apellido1, p.apellido2, p.nombre FROM (persona p RIGHT JOIN profesor t ON p.id=t.id_profesor)
LEFT JOIN departamento d ON t.id_departamento=d.id
ORDER BY d.nombre ASC, p.apellido1 ASC, p.apellido2 ASC, p.nombre ASC;

-- 11. Retorna un llistat amb els professors que no estan associats a un departament.
SELECT t.* FROM profesor t LEFT JOIN departamento d ON t.id_departamento=d.id WHERE d.id IS NULL;

-- 12. Retorna un llistat amb els departaments que no tenen professors associats.
SELECT d.* FROM departamento d LEFT JOIN profesor t ON d.id=t.id_departamento WHERE id_departamento IS NULL;

-- 13. Retorna un llistat amb els professors que no imparteixen cap assignatura.
SELECT t.* FROM profesor t LEFT JOIN asignatura a ON t.id_profesor=a.id_profesor
WHERE a.id IS NULL;

-- 14. Retorna un llistat amb les assignatures que no tenen un professor assignat.
SELECT a.* FROM asignatura a LEFT JOIN profesor t ON a.id_profesor=t.id_profesor
WHERE a.id_profesor IS NULL;

-- 15. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT d.* FROM 
(profesor t LEFT JOIN departamento d ON t.id_departamento=d.id) LEFT JOIN asignatura a ON t.id_profesor=a.id_profesor
WHERE a.id IS NULL;

-- 16. Retorna el nombre total d'alumnes que hi ha.
SELECT count(*) FROM persona WHERE tipo LIKE 'alumno';

-- 17. Calcula quants alumnes van néixer en 1999.
SELECT count(*) FROM persona 
WHERE tipo LIKE 'alumno' 
AND fecha_nacimiento LIKE '1999%';

/* 18. Calcula quants professors hi ha en cada departament. El resultat només ha de mostrar dues columnes, 
una amb el nom del departament i una altra amb el nombre de professors que hi ha en aquest departament. 
El resultat només ha d'incloure els departaments que tenen professors associats i 
haurà d'estar ordenat de major a menor pel nombre de professors.*/
SELECT d.nombre, count(t.id_profesor) AS numTeacher FROM departamento d RIGHT JOIN profesor t ON d.id=t.id_departamento
GROUP BY d.nombre
ORDER BY numTeacher DESC;

/* 19. Retorna un llistat amb tots els departaments i el nombre de professors que hi ha en cadascun d'ells. 
Tingui en compte que poden existir departaments que no tenen professors associats. 
Aquests departaments també han d'aparèixer en el llistat.*/
SELECT d.nombre, count(t.id_profesor) AS numTeacher FROM departamento d LEFT JOIN profesor t ON d.id=t.id_departamento
GROUP BY d.nombre
ORDER BY numTeacher DESC;

/* 20. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. 
Tingui en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. 
El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.*/
SELECT g.nombre, count(a.id) AS numAsignaturas FROM grado g LEFT JOIN asignatura a ON g.id=a.id_grado
GROUP BY g.nombre
ORDER BY numAsignaturas DESC;

/* 21 Retorna un llistat amb el nom de tots els graus existents en la base de dades i 
el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.*/
SELECT g.nombre, count(a.id) AS numAsignaturas FROM grado g LEFT JOIN asignatura a ON g.id=a.id_grado
GROUP BY g.nombre
HAVING count(a.id) > 40;

/*22. Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits 
que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: 
nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.*/
SELECT g.nombre, a.tipo, sum(a.creditos) AS numCredits FROM grado g RIGHT JOIN asignatura a ON g.id=a.id_grado
GROUP BY a.tipo, g.id
ORDER BY g.nombre;

/* 23. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun 
dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar 
i una altra amb el nombre d'alumnes matriculats.*/
SELECT c.anyo_inicio AS AnyInici, count(a.id_alumno) AS numAlumnes FROM curso_escolar c LEFT JOIN alumno_se_matricula_asignatura a 
ON c.id=a.id_curso_escolar
GROUP BY c.anyo_inicio;

/*24. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor. 
El llistat ha de tenir en compte aquells professors que no imparteixen cap assignatura. 
El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. 
El resultat estarà ordenat de major a menor pel nombre d'assignatures.*/
SELECT p.id, p.nombre, p.apellido1, p.apellido2, count(a.id) AS numAsignaturas
FROM (persona p RIGHT JOIN profesor t ON p.id=t.id_profesor) LEFT JOIN asignatura a 
ON t.id_profesor=a.id_profesor
GROUP BY p.id
ORDER BY numAsignaturas DESC;

-- 25. Retorna totes les dades de l'alumne més jove.
SELECT * FROM persona p LEFT JOIN alumno_se_matricula_asignatura a ON p.id=a.id_alumno
WHERE p.fecha_nacimiento = (SELECT max(fecha_nacimiento) FROM persona);

-- 26. Retorna un llistat amb els professors que tenen un departament associat i que no imparteixen cap assignatura.
SELECT p.* FROM (persona p RIGHT JOIN profesor t ON p.id=t.id_profesor) LEFT JOIN asignatura a ON t.id_profesor=a.id_profesor
WHERE a.id IS NULL AND t.id_departamento IS NOT NULL;





















