# Full curriculum for the Systems Engineering program.
# SUBJECTS is 0-indexed here; course IDs used everywhere else are 1-based.
 
SUBJECTS = [
    "Deportes1",                          # 1
    "Desarrollo_del_pensamiento_logico",  # 2
    "Matemáticas1",                       # 3
    "Introducción_a_la_informatica",      # 4
    "Programacion1",                      # 5
    "Humanidades1",                       # 6
    "Deportes2",                          # 7
    "Laboratorio_fisica1",                # 8
    "Fisica1",                            # 9
    "Matematicas2",                       # 10
    "Algebra_lineal",                     # 11
    "Programacion2",                      # 12
    "Laboratorio_fisica2",                # 13
    "Fisica2",                            # 14
    "Matematicas3",                       # 15
    "Lógica",                             # 16
    "Estructura_de_datos",                # 17
    "Humanidades2",                       # 18
    "Laboratorio_de_electronica",         # 19
    "Fundamentos_de_electronica",         # 20
    "Fisica3",                            # 21
    "Laboratorio_fisica3",                # 22
    "Matematicas4",                       # 23
    "Programacion3",                      # 24
    "Teoría_de_sistemas",                 # 25
    "Laboratorio_electronica_digital",    # 26
    "electronica_digital",                # 27
    "administración_de_empresas",         # 28
    "estadística",                        # 29
    "programacion4",                      # 30
    "gramática_y_lenguajes_formales",     # 31
    "técnicas_de_la_comunicacion",        # 32
    "arquitectura_de_computadores",       # 33
    "investigación_de_operaciones",       # 34
    "computación_grafica",                # 35
    "estadísticas_especiales",            # 36
    "bases_de_datos1",                    # 37
    "sistemas_operativos1",               # 38
    "comunicaciones1",                    # 39
    "inteligencia_artificial",            # 40
    "ingeniería_de_software1",            # 41
    "compiladores",                       # 42
    "comunicaciones2",                    # 43
    "computación_blanda",                 # 44
    "gerencia_de_proyecto",               # 45
    "legislación_y_etica",                # 46
    "sistemas_distribuidos",              # 47
    "ingeniería_de_software2",            # 48
    "arquitectura_clienteservidor",       # 49
    "administración_proyectos_de_software", # 50
    "laboratorio_software",               # 51
    "proyecto_de_grado1",                 # 52
    "constitucion_politica",              # 53
    "auditoria_de_sistemas",              # 54
    "emprendimiento",                     # 55
    "proyecto_de_grado2",                 # 56
    "electivaA1",                         # 57
    "electivaA2",                         # 58
    "electivaB1",                         # 59
    "electivaB2",                         # 60
]
 
CREDITOS = [
    1, 2, 5, 3, 5, 2, 1, 2, 4, 5, 3, 4, 2, 4, 4, 3, 4, 2, 3, 4,
    4, 2, 3, 3, 2, 3, 4, 3, 2, 3, 5, 4, 4, 3, 3, 2, 4, 4, 3, 4,
    4, 3, 3, 5, 3, 2, 3, 4, 4, 3, 3, 2, 1, 3, 3, 6, 3, 3, 3, 3,
]
 
# Prerequisite pairs (pre, post) — 1-based IDs — mirroring data.dzn
PRECEDENCES = [
    (1, 7),   (4, 16),  (3, 10),  (3, 9),   (3, 8),   (3, 11),
    (6, 18),  (5, 12),  (10, 15), (10, 14), (10, 25), (10, 13),
    (12, 17), (12, 24), (16, 31), (14, 21), (14, 20), (14, 19),
    (13, 22), (24, 35), (11, 35), (15, 21), (15, 23), (15, 34),
    (15, 29), (23, 39), (23, 35), (21, 39), (20, 27), (19, 26),
    (31, 42), (17, 30), (17, 37), (30, 40), (29, 36), (27, 33),
    (33, 38), (37, 41), (38, 47), (39, 43), (40, 44), (41, 48),
    (47, 49), (45, 50), (41, 51), (41, 52), (48, 55), (50, 54),
    (52, 56),
]
 
# Pairs that must be taken together (simultaneous) — 1-based IDs
SIMULTANEO = [
    (9, 8),
    (14, 13),
    (20, 19),
    (21, 22),
]
 
TOTAL_COURSES = len(SUBJECTS)  # 60
