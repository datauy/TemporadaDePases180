require 'json'

module Helpers
    module Rankings

        def get_mutualistas(departamento)

            datos_folder = root_path('public', 'data')
            file_path = File.join(datos_folder, "#{departamento}.json")
            mutualistas = []

            File.open(file_path, 'r') do |file|
                mutualistas = JSON.load(file)
            end

            return mutualistas
        end

        def filtrar_variables(prioridades)

            todas_las_variables = ['META_NINOS', 'META_EMBARAZADAS', 'META_ ADOLESCENTE', ' META_ ADULTO', 'META_ADULTO_MAYOR', 
                'MEDICAMENTOS_GENERAL', 'MEDICAMENTOS_GENERAL_FONASA', 'MEDICAMENTOS_TOPEADOS', ' MEDICAMENTOS_TOPEADOS_FONASA', 
                'CONSULTA_GENERAL', 'CONSULTA_GENERAL_FONASA', 'CONSULTA_PEDIATRIA', 'CONSULTA_PEDIATRIA_FONASA', 'CONTROL_EMBARAZO', 
                'CONTROL_EMBARAZO_FONASA', 'CONSULTA_GINECOLOGIA', 'CONSULTA_GINECOLOGIA_FONASA', 'CONSULT_OTR_ESP', 'CONSULT_OTR_ESP_FONASA',
                'CONSULTA_NO_URG_DOM', 'CONSULTA_NO_URG_DOM_FONASA', 'CONS_ODONT', 'CONS_ODONT_FONASA', 'CONS_MED_REF', 'CONS_MED_REF_FONASA',
                'CONS_URG_CENTRALIZADA','CONS_URG_CENTRALIZADA_FONASA', 'CONS_URG_DOM', 'CONS_URG_DOM_FONASA', 'ESTUDIO_ENDOSCOPIA', 
                'ESTUDIO_ENDOSCOPIA_FONASA', 'ESTUDIO_ECOGRAFIA_SIMPLE', 'ESTUDIO_ECOGRAFIA_SIMPLE_FONASA','ESTUDIO_ECOGRAFIA_OBS',
                'ESTUDIO_ECOGRAFIA_OBS_FONASA', 'ESTUDIO_ECODOPPLER', 'ESTUDIO_ECODOPPLER_FONASA', 'ESTUDIO_IMAGEN_ABDOMEN', 
                'ESTUDIO_IMAGEN_ABDOMEN_FONASA', 'ESTUDIO_IMAGEN_TORAX', 'ESTUDIO_IMAGEN_TORAX_FONASA ESTUDIO_IMAGEN_COLORECTAL', 
                'ESTUDIO_IMAGEN_COLORECTAL_FONASA', 'ESTUDIO_RESONANCIA', 'ESTUDIO_RESONANCIA_FONASA', ' ESTUDIO_TOMOGRAFIA', 
                'ESTUDIO_TOMOGRAFIA_FONASA', 'ESTUDIO_LABORATORIO', 'ESTUDIO_LABORATORIO_FONASA', 'TIEMPO_ESP_MED_GEN', 'TIEMPO_ESP_PEDIATRIA',
                'TIEMPO_ESP _CIRUG', 'TIEMPO_ESP_GIN', 'ENT_QUEJAS', 'ENT_DERECHOS', 'PERSONAL_CANT_MED', 'PERSONAL_CANT_GIN', 
                'PERSONAL_CANT_PED', 'PERSONAL_CANT_ENF', ' PERSONAL_CANT_LICENF', 'CITAS_PERSONAL', 'CITAS_TELEFONICA', 'CITAS_WEB', 
                'RECORDATORIO_TELEFONO', 'RECORDATORIO_SMS', 'RECORDATORIO_CORREO', 'INCOMPLETA']

            variables_a_ignorar = []
            

            if not prioridades[:ginecologia]
                variables_a_ignorar = variables_a_ignorar + ['META_EMBARAZADAS', 'CONTROL_EMBARAZO', 'CONTROL_EMBARAZO_FONASA', 'CONSULTA_GINECOLOGIA', 
                    'CONSULTA_GINECOLOGIA_FONASA', 'ESTUDIO_ECOGRAFIA_OBS', 'ESTUDIO_ECOGRAFIA_OBS_FONASA', 'PERSONAL_CANT_GIN']

            end
            if not prioridades[:pediatria]
                variables_a_ignorar = variables_a_ignorar + ['META_NINOS', 'META_ ADOLESCENTE', 'CONSULTA_PEDIATRIA', 'CONSULTA_PEDIATRIA_FONASA', 
                    'TIEMPO_ESP_PEDIATRIA']
            end
            if prioridades[:fonasa]
                variables_a_ignorar = variables_a_ignorar + ['MEDICAMENTOS_GENERAL', 'MEDICAMENTOS_TOPEADOS', 'CONSULTA_GENERAL', 'CONSULTA_PEDIATRIA', 'CONTROL_EMBARAZO', 
                    'CONSULTA_GINECOLOGIA', 'CONSULT_OTR_ESP', 'CONSULTA_NO_URG_DOM', 'CONS_ODONT', 'CONS_MED_REF', 'CONS_URG_CENTRALIZADA', 
                    'CONS_URG_DOM', 'ESTUDIO_ENDOSCOPIA', 'ESTUDIO_ECOGRAFIA_SIMPLE', 'ESTUDIO_ECOGRAFIA_OBS', 'ESTUDIO_ECODOPPLER', 
                    'ESTUDIO_IMAGEN_ABDOMEN', 'ESTUDIO_IMAGEN_TORAX', 'ESTUDIO_IMAGEN_COLORECTAL', 'ESTUDIO_RESONANCIA', 'ESTUDIO_TOMOGRAFIA', 
                    'ESTUDIO_LABORATORIO']
            else
                variables_a_ignorar = variables_a_ignorar + ['MEDICAMENTOS_GENERAL_FONASA', 'MEDICAMENTOS_TOPEADOS_FONASA', 'CONSULTA_GENERAL_FONASA', 
                    'CONSULTA_PEDIATRIA_FONASA', 'CONTROL_EMBARAZO_FONASA', 'CONSULTA_GINECOLOGIA_FONASA', 'CONSULT_OTR_ESP_FONASA', 
                    'CONSULTA_NO_URG_DOM_FONASA', 'CONS_ODONT_FONASA', 'CONS_MED_REF_FONASA', 'CONS_URG_CENTRALIZADA_FONASA', 
                    'CONS_URG_DOM_FONASA', 'ESTUDIO_ENDOSCOPIA_FONASA', 'ESTUDIO_ECOGRAFIA_SIMPLE_FONASA', 'ESTUDIO_ECOGRAFIA_OBS_FONASA', 
                    'ESTUDIO_ECODOPPLER_FONASA', 'ESTUDIO_IMAGEN_ABDOMEN_FONASA', 'ESTUDIO_IMAGEN_TORAX_FONASA', 
                    'ESTUDIO_IMAGEN_COLORECTAL_FONASA', 'ESTUDIO_RESONANCIA_FONASA', 'ESTUDIO_TOMOGRAFIA_FONASA', 
                    'ESTUDIO_LABORATORIO_FONASA']
            end

            variables = []

            case prioridades[:prioridad]
            when 'costo'
                variables = ['MEDICAMENTOS_GENERAL', 'MEDICAMENTOS_GENERAL_FONASA', 'MEDICAMENTOS_TOPEADOS', 'MEDICAMENTOS_TOPEADOS_FONASA', 
                    'CONSULTA_GENERAL', 'CONSULTA_GENERAL_FONASA', 'CONSULTA_PEDIATRIA', 'CONSULTA_PEDIATRIA_FONASA', 'CONTROL_EMBARAZO', 
                    'CONTROL_EMBARAZO_FONASA', 'CONSULTA_GINECOLOGIA', 'CONSULTA_GINECOLOGIA_FONASA', 'CONSULT_OTR_ESP', 
                    'CONSULT_OTR_ESP_FONASA', 'CONSULTA_NO_URG_DOM', 'CONSULTA_NO_URG_DOM_FONASA', 'CONS_ODONT', 'CONS_ODONT_FONASA', 
                    'CONS_MED_REF', 'CONS_MED_REF_FONASA', 'CONS_URG_CENTRALIZADA', 'CONS_URG_CENTRALIZADA_FONASA', 'CONS_URG_DOM', 
                    'CONS_URG_DOM_FONASA', 'ESTUDIO_ENDOSCOPIA', 'ESTUDIO_ENDOSCOPIA_FONASA', 'ESTUDIO_ECOGRAFIA_SIMPLE', 
                    'ESTUDIO_ECOGRAFIA_SIMPLE_FONASA', 'ESTUDIO_ECOGRAFIA_OBS', 'ESTUDIO_ECOGRAFIA_OBS_FONASA', 'ESTUDIO_ECODOPPLER', 
                    'ESTUDIO_ECODOPPLER_FONASA', 'ESTUDIO_IMAGEN_ABDOMEN', 'ESTUDIO_IMAGEN_ABDOMEN_FONASA', 'ESTUDIO_IMAGEN_TORAX', 
                    'ESTUDIO_IMAGEN_TORAX_FONASA', 'ESTUDIO_IMAGEN_COLORECTAL', 'ESTUDIO_IMAGEN_COLORECTAL_FONASA', 'ESTUDIO_RESONANCIA', 
                    'ESTUDIO_RESONANCIA_FONASA', 'ESTUDIO_TOMOGRAFIA', 'ESTUDIO_TOMOGRAFIA_FONASA', 'ESTUDIO_LABORATORIO', 
                    'ESTUDIO_LABORATORIO_FONASA'] - variables_a_ignorar
            when 'tiempo'
                variables = ['TIEMPO_ESP_MED_GEN', 'TIEMPO_ESP_PEDIATRIA', 'TIEMPO_ESP _CIRUG', 'TIEMPO_ESP_GIN'] - variables_a_ignorar
            when 'derechos'
                variables = ['ENT_QUEJAS', 'ENT_DERECHOS'] - variables_a_ignorar
            when 'personal'
                variables = ['PERSONAL_CANT_MED', 'PERSONAL_CANT_GIN', 'PERSONAL_CANT_PED', 'PERSONAL_CANT_ENF', 'PERSONAL_CANT_LICEN'] - variables_a_ignorar
            else
                variables = todas_las_variables
            end

            return variables
        end

        def calcular_ranking(mutualista, variables)

            ranking = 0

            for variable in variables do 
                ranking = ranking +  mutualista[variable].to_i
            end

            return ranking
        end

        def get_rankings(departamento, prioridades)
            # prioridades se divide en las opciones (ginecologia, pediatria, fonasa) y la prioridad (tiempo, costo, derechos o personal)

            mutualistas = []
            unless prioridades.empty?
                # tomamos los datos para solo mutualistas del departamento
                todas_las_mutualistas = get_mutualistas(departamento.upcase)

                # en base a las opciones y la prioridad tomamos que variables hay que sumar
                variables_a_usar = filtrar_variables(prioridades)

                # algunas mutualistas tienen todos los datos y otras no. Solo vamos a rankear las que tienen todos los datos
                mutualistas_completas   = []
                mutualistas_incompletas = []

                # calcular el ranking de solo las mutualistas con datos completos
                for mutu in todas_las_mutualistas do
                    if to_boolean(mutu["INCOMPLETA"])
                        mutu["RANKING"] = 0
                        mutualistas_incompletas << mutu
                    else
                        mutu["RANKING"] = calcular_ranking(mutu, variables_a_usar)
                        mutualistas_completas << mutu
                    end
                end

                # ordenar el ranking de acuerdo a valor de ranking hallado (precio o tiempo en subida y derechos o personal en bajada)
                if prioridades[:prioridad] == "tiempo" || prioridades[:prioridad] == "costo" 
                    mutualistas_completas.sort_by { |m| m["RANKING"] }
                else # personal o derechos
                    mutualistas_completas.sort_by { |m| m["RANKING"] }.reverse
                end
                
                mutualistas = mutualistas_completas + mutualistas_incompletas

                return mutualistas
            end

            return mutualistas
        end

        # don't like this to be monkey patch
        def to_boolean(palabra)
            case palabra.downcase
            when 'false'
                return false
            when 'true'
                return true
            else
                return nil
            end
        end

        def get_prioridades(opciones)
            # opciones deberia tener true or false en ginecologia, pediatria y fonasa Y la prioridad (tiempos, costo, personal o derechos)
            
            prioridades = {}

            if not opciones.empty? 
                prioridades[:ginecologia] = to_boolean(opciones[:ginecologia])
                prioridades[:pediatria] = to_boolean(opciones[:pediatria])
                prioridades[:fonasa] = to_boolean(opciones[:fonasa])

                prioridades[:prioridad] =  (opciones[:prioridad].nil? || opciones[:prioridad] == 'undefined') ? 'costo' : opciones[:prioridad]
            end

            return prioridades
        end
    end
end
