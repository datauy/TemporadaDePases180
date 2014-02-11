# encoding: utf-8
require 'csv'
require 'json'

# El objetivo es convertir los datos en csv a un json por departamento

module DatosMutualistas
    module Datos

        # CSV format: NOMBRE WEB ARTIGAS CANELONES   CERRO_LARGO COLONIA DURAZNO FLORES  FLORIDA 
        # LAVALLEJA   MALDONADO   MONTEVIDEO  PAYSANDU    RIO_NEGRO   RIVERA  ROCHA   SALTO   SAN_JOSE    SORIANO TACUAREMBO  TREINTA_Y_TRES 
        # META_NINOS  META_EMBARAZADAS    META_ ADOLESCENTE   META_ ADULTO    META_ADULTO_MAYOR   MEDICAMENTOS_GENERAL    
        # MEDICAMENTOS_GENERAL_FONASA MEDICAMENTOS_TOPEADOS   MEDICAMENTOS_TOPEADOS_FONASA    CONSULTA_GENERAL   
        # CONSULTA_GENERAL_FONASA CONSULTA_PEDIATRIA  CONSULTA_PEDIATRIA_FONASA   CONTROL_EMBARAZO    CONTROL_EMBARAZO_FONASA
        # CONSULTA_GINECOLOGIA    CONSULTA_GINECOLOGIA_FONASA CONSULT_OTR_ESP CONSULT_OTR_ESP_FONASA  CONSULTA_NO_URG_DOM 
        # CONSULTA_NO_URG_DOM_FONASA  CONS_ODONT  CONS_ODONT_FONASA   CONS_MED_REF    CONS_MED_REF_FONASA CONS_URG_CENTRALIZADA   
        # CONS_URG_CENTRALIZADA_FONASA    CONS_URG_DOM    CONS_URG_DOM_FONASA ESTUDIO_ENDOSCOPIA  ESTUDIO_ENDOSCOPIA_FONASA   
        # ESTUDIO_ECOGRAFIA_SIMPLE    ESTUDIO_ECOGRAFIA_SIMPLE_FONASA ESTUDIO_ECOGRAFIA_OBS   ESTUDIO_ECOGRAFIA_OBS_FONASA    
        # ESTUDIO_ECODOPPLER  ESTUDIO_ECODOPPLER_FONASA   ESTUDIO_IMAGEN_ABDOMEN  ESTUDIO_IMAGEN_ABDOMEN_FONASA   ESTUDIO_IMAGEN_TORAX    
        # ESTUDIO_IMAGEN_TORAX_FONASA ESTUDIO_IMAGEN_COLORECTAL   ESTUDIO_IMAGEN_COLORECTAL_FONASA    ESTUDIO_RESONANCIA  
        # ESTUDIO_RESONANCIA_FONASA   ESTUDIO_TOMOGRAFIA  ESTUDIO_TOMOGRAFIA_FONASA   ESTUDIO_LABORATORIO ESTUDIO_LABORATORIO_FONASA  
        # TIEMPO_ESP_MED_GEN  TIEMPO_ESP_PEDIATRIA    TIEMPO_ESP _CIRUG   TIEMPO_ESP_GIN  ENT_QUEJAS  ENT_DERECHOS    PERSONAL_CANT_MED   
        # PERSONAL_CANT_GIN   PERSONAL_CANT_PED   PERSONAL_CANT_ENF   PERSONAL_CANT_LICENF    CITAS_PERSONAL  CITAS_TELEFONICA    CITAS_WEB   
        # RECORDATORIO_TELEFONO   RECORDATORIO_SMS    RECORDATORIO_CORREO

        DATA_FILE  = './data/datos_mutualistas.csv'
        DATA_FOLDER = './data/'

        DEPARTAMENTOS = ['ARTIGAS', 'CANELONES','CERRO_LARGO','COLONIA','DURAZNO','FLORES','FLORIDA','LAVALLEJA',
        'MALDONADO','MONTEVIDEO','PAYSANDU','RIO_NEGRO','RIVERA','ROCHA','SALTO','SAN_JOSE','SORIANO','TACUAREMBO','TREINTA_Y_TRES']
        
        def self.leer_datos
            
            mutualistas_csv = CSV.read(DATA_FILE, 'r', :headers => true)

            for departamento in DEPARTAMENTOS do
                puts departamento
                mutualistas = []

                mutualistas_csv.each do |mutu|
                    # filtrar por departamento 
                    if mutu[departamento] == '1'

                        # eliminamos los keys de departamentos
                        for dep in DEPARTAMENTOS do
                            mutu.tap { |hm| hm.delete(dep) }
                        end

                        # pasamos los key a symbol
                        mejor_mutu = mutu.to_hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

                        # mejoraremos los datos de mutualista
                        mejor_mutu[:COSTO] = {
                            :MEDICAMENTOS            => calcular_medicamento(mejor_mutu),
                            :CONSULTAS_NO_URGENTES   => calcular_no_urgentes(mejor_mutu), 
                            :CONSULTAS_URGENTES      => calcular_urgentes(mejor_mutu), 
                            :ESTUDIOS_Y_LABORATORIOS => calcular_estudios(mejor_mutu)
                        }
                        mejor_mutu[:METAS] = {
                            :NINOS        => mejor_mutu[:META_NINOS], 
                            :EMBARAZADAS  => mejor_mutu[:META_EMBARAZADAS], 
                            :ADOLESCENTE  => mejor_mutu[:META_ADOLESCENTE], 
                            :ADULTO       => mejor_mutu[:META_ADULTO], 
                            :ADULTO_MAYOR => mejor_mutu[:META_ADULTO_MAYOR]
                        }
                        mejor_mutu[:TIEMPOS_ESPERA] = {
                            :MEDICINA_GENERAL => mejor_mutu[:TIEMPO_ESP_MED_GEN], 
                            :PEDIATRIA        => mejor_mutu[:TIEMPO_ESP_PEDIATRIA], 
                            :CIRUGIA_GENERAL  => mejor_mutu[:TIEMPO_ESP_CIRUG], 
                            :GINECOLOGIA      => mejor_mutu[:TIEMPO_ESP_GIN]        
                        }
                        mejor_mutu[:SATISFACCION] = {
                            :QUEJAS   => mejor_mutu[:ENT_QUEJAS],
                            :DERECHOS => mejor_mutu[:ENT_DERECHOS]    
                        }                    
                        mejor_mutu[:PERSONAL] = {
                            :MEDICOS      => mejor_mutu[:PERSONAL_CANT_MED], 
                            :GINECOLOGOS  => mejor_mutu[:PERSONAL_CANT_GIN], 
                            :PEDIATRAS    => mejor_mutu[:PERSONAL_CANT_PED], 
                            :ENFERMEROS   => mejor_mutu[:PERSONAL_CANT_ENF ], 
                            :LICENFER     => mejor_mutu[:PERSONAL_CANT_LICENF]
                        }

                        mutualistas << mejor_mutu
                    end
                end

                write_to_json(departamento, mutualistas)
            end
        end


        # json format per departamento
        # NOMBRE WEB 
        # META_NINOS  META_EMBARAZADAS    META_ ADOLESCENTE   META_ ADULTO    META_ADULTO_MAYOR   MEDICAMENTOS_GENERAL    
        # MEDICAMENTOS_GENERAL_FONASA MEDICAMENTOS_TOPEADOS   MEDICAMENTOS_TOPEADOS_FONASA    CONSULTA_GENERAL   
        # CONSULTA_GENERAL_FONASA CONSULTA_PEDIATRIA  CONSULTA_PEDIATRIA_FONASA   CONTROL_EMBARAZO    CONTROL_EMBARAZO_FONASA
        # CONSULTA_GINECOLOGIA    CONSULTA_GINECOLOGIA_FONASA CONSULT_OTR_ESP CONSULT_OTR_ESP_FONASA  CONSULTA_NO_URG_DOM 
        # CONSULTA_NO_URG_DOM_FONASA  CONS_ODONT  CONS_ODONT_FONASA   CONS_MED_REF    CONS_MED_REF_FONASA CONS_URG_CENTRALIZADA   
        # CONS_URG_CENTRALIZADA_FONASA    CONS_URG_DOM    CONS_URG_DOM_FONASA ESTUDIO_ENDOSCOPIA  ESTUDIO_ENDOSCOPIA_FONASA   
        # ESTUDIO_ECOGRAFIA_SIMPLE    ESTUDIO_ECOGRAFIA_SIMPLE_FONASA ESTUDIO_ECOGRAFIA_OBS   ESTUDIO_ECOGRAFIA_OBS_FONASA    
        # ESTUDIO_ECODOPPLER  ESTUDIO_ECODOPPLER_FONASA   ESTUDIO_IMAGEN_ABDOMEN  ESTUDIO_IMAGEN_ABDOMEN_FONASA   ESTUDIO_IMAGEN_TORAX    
        # ESTUDIO_IMAGEN_TORAX_FONASA ESTUDIO_IMAGEN_COLORECTAL   ESTUDIO_IMAGEN_COLORECTAL_FONASA    ESTUDIO_RESONANCIA  
        # ESTUDIO_RESONANCIA_FONASA   ESTUDIO_TOMOGRAFIA  ESTUDIO_TOMOGRAFIA_FONASA   ESTUDIO_LABORATORIO ESTUDIO_LABORATORIO_FONASA  
        # TIEMPO_ESP_MED_GEN  TIEMPO_ESP_PEDIATRIA    TIEMPO_ESP _CIRUG   TIEMPO_ESP_GIN  ENT_QUEJAS  ENT_DERECHOS    PERSONAL_CANT_MED   
        # PERSONAL_CANT_GIN   PERSONAL_CANT_PED   PERSONAL_CANT_ENF   PERSONAL_CANT_LICENF    CITAS_PERSONAL  CITAS_TELEFONICA    CITAS_WEB   
        # RECORDATORIO_TELEFONO   RECORDATORIO_SMS    RECORDATORIO_CORREO
        # COSTO => {MEDICAMENTOS, CONSULTAS_NO_URGENTES, CONSULTAS_URGENTES, ESTUDIOS_Y_LABORATORIOS}
        # METAS => {NINOS, EMBARAZADAS, ADOLESCENTE, ADULTO, ADULTO_MAYOR}
        # TIEMPOS_ESPERA => { MEDICINA_GENERAL, PEDIATRIA, CIRUGIA_GENERAL, GINECOLOGIA}
        # PERSONAL => {MEDICOS, GINECOLOGOS, PEDIATRAS, ENFERMEROS, LICENFER}

        def self.sin_datos(*variables)
            for var in variables
                if var == 's/d'
                    return false
                end
            end
            return true
        end

        # todos los costos se calculan como promedios de esos campos
        def self.calcular_medicamento(mutualista)

            if sin_datos(mutualista[:MEDICAMENTOS_GENERAL],mutualista[:MEDICAMENTOS_GENERAL_FONASA].to_i, 
                mutualista[:MEDICAMENTOS_TOPEADOS],mutualista[:MEDICAMENTOS_TOPEADOS_FONASA])
                costos_medicamentos = 's/d'
            else
                # promedio de TICKET DE MEDICAMENTOS - GENERA, MEDICAMENTOS_GENERAL_FONASA, MEDICAMENTOS_TOPEADOS , MEDICAMENTOS_TOPEADOS_FONASA
                costos_medicamentos = (mutualista[:MEDICAMENTOS_GENERAL].to_i + mutualista[:MEDICAMENTOS_GENERAL_FONASA].to_i + 
            mutualista[:MEDICAMENTOS_TOPEADOS].to_i + mutualista[:MEDICAMENTOS_TOPEADOS_FONASA].to_i)/4
            end

            return costos_medicamentos
        end
        def self.calcular_no_urgentes(mutualista)
            if sin_datos(mutualista[:CONSULTA_GENERAL], mutualista[:CONSULTA_GENERAL_FONASA], 
                mutualista[:CONSULTA_PEDIATRIA], mutualista[:CONSULTA_PEDIATRIA_FONASA], mutualista[:CONTROL_EMBARAZO],
                mutualista[:CONTROL_EMBARAZO_FONASA], mutualista[:CONSULTA_GINECOLOGIA], 
                mutualista[:CONSULTA_GINECOLOGIA_FONASA], mutualista[:CONSULT_OTR_ESP], 
                mutualista[:CONSULT_OTR_ESP_FONASA], mutualista[:CONSULTA_NO_URG_DOM], 
                mutualista[:CONSULTA_NO_URG_DOM_FONASA], mutualista[:CONS_ODONT], mutualista[:CONS_ODONT_FONASA], 
                mutualista[:CONS_MED_REF], mutualista[:CONS_MED_REF_FONASA])
                costos_no_urgentes = 's/d'
            else
            costos_no_urgentes = (mutualista[:CONSULTA_GENERAL].to_i+mutualista[:CONSULTA_GENERAL_FONASA].to_i+
                mutualista[:CONSULTA_PEDIATRIA].to_i+mutualista[:CONSULTA_PEDIATRIA_FONASA].to_i+mutualista[:CONTROL_EMBARAZO].to_i+
                mutualista[:CONTROL_EMBARAZO_FONASA].to_i+mutualista[:CONSULTA_GINECOLOGIA].to_i+
                mutualista[:CONSULTA_GINECOLOGIA_FONASA].to_i+mutualista[:CONSULT_OTR_ESP].to_i+mutualista[:CONSULT_OTR_ESP_FONASA].to_i+
                mutualista[:CONSULTA_NO_URG_DOM].to_i+mutualista[:CONSULTA_NO_URG_DOM_FONASA].to_i+mutualista[:CONS_ODONT].to_i+  
                mutualista[:CONS_ODONT_FONASA].to_i+mutualista[:CONS_MED_REF].to_i+mutualista[:CONS_MED_REF_FONASA].to_i)/16
            end
            return costos_no_urgentes
        end
        def self.calcular_urgentes(mutualista)
            if sin_datos(mutualista[:CONS_URG_CENTRALIZADA], mutualista[:CONS_URG_CENTRALIZADA_FONASA],
                mutualista[:CONS_URG_DOM], mutualista[:CONS_URG_DOM_FONASA])
                costos_urgentes = 's/d'
            else
                costos_urgentes = (mutualista[:CONS_URG_CENTRALIZADA].to_i+mutualista[:CONS_URG_CENTRALIZADA_FONASA].to_i+
                    mutualista[:CONS_URG_DOM].to_i+mutualista[:CONS_URG_DOM_FONASA].to_i)/4
            end
            return costos_urgentes
        end
        def self.calcular_estudios(mutualista)
            if sin_datos(mutualista[:ESTUDIO_ENDOSCOPIA], mutualista[:ESTUDIO_ENDOSCOPIA_FONASA],
                mutualista[:ESTUDIO_ECOGRAFIA_SIMPLE], mutualista[:ESTUDIO_ECOGRAFIA_SIMPLE_FONASA],
                mutualista[:ESTUDIO_ECOGRAFIA_OBS], mutualista[:ESTUDIO_ECOGRAFIA_OBS_FONASA],
                mutualista[:ESTUDIO_ECODOPPLER], mutualista[:ESTUDIO_ECODOPPLER_FONASA],
                mutualista[:ESTUDIO_IMAGEN_ABDOMEN], mutualista[:ESTUDIO_IMAGEN_ABDOMEN_FONASA],
                mutualista[:ESTUDIO_IMAGEN_TORAX], mutualista[:ESTUDIO_IMAGEN_TORAX_FONASA],
                mutualista[:ESTUDIO_IMAGEN_COLORECTAL], mutualista[:ESTUDIO_IMAGEN_COLORECTAL_FONASA],
                mutualista[:ESTUDIO_RESONANCIA], mutualista[:ESTUDIO_RESONANCIA_FONASA],
                mutualista[:ESTUDIO_TOMOGRAFIA], mutualista[:ESTUDIO_TOMOGRAFIA_FONASA],
                mutualista[:ESTUDIO_LABORATORIO], mutualista[:ESTUDIO_LABORATORIO_FONASA],
                mutualista[:TIEMPO_ESP_MED_GEN], mutualista[:TIEMPO_ESP_PEDIATRIA], mutualista[:TIEMPO_ESP_CIRUG],
                mutualista[:TIEMPO_ESP_GIN])
                costos_estudios = 's/d'
            else
             costos_estudios = (mutualista[:ESTUDIO_ENDOSCOPIA].to_i+mutualista[:ESTUDIO_ENDOSCOPIA_FONASA].to_i+
                mutualista[:ESTUDIO_ECOGRAFIA_SIMPLE].to_i+mutualista[:ESTUDIO_ECOGRAFIA_SIMPLE_FONASA].to_i+
                mutualista[:ESTUDIO_ECOGRAFIA_OBS].to_i+mutualista[:ESTUDIO_ECOGRAFIA_OBS_FONASA].to_i+
                mutualista[:ESTUDIO_ECODOPPLER].to_i+mutualista[:ESTUDIO_ECODOPPLER_FONASA].to_i+
                mutualista[:ESTUDIO_IMAGEN_ABDOMEN].to_i+mutualista[:ESTUDIO_IMAGEN_ABDOMEN_FONASA].to_i+
                mutualista[:ESTUDIO_IMAGEN_TORAX].to_i+mutualista[:ESTUDIO_IMAGEN_TORAX_FONASA].to_i+
                mutualista[:ESTUDIO_IMAGEN_COLORECTAL].to_i+mutualista[:ESTUDIO_IMAGEN_COLORECTAL_FONASA].to_i+
                mutualista[:ESTUDIO_RESONANCIA].to_i+mutualista[:ESTUDIO_RESONANCIA_FONASA].to_i+
                mutualista[:ESTUDIO_TOMOGRAFIA].to_i+mutualista[:ESTUDIO_TOMOGRAFIA_FONASA].to_i+
                mutualista[:ESTUDIO_LABORATORIO].to_i+mutualista[:ESTUDIO_LABORATORIO_FONASA].to_i+
                mutualista[:TIEMPO_ESP_MED_GEN].to_i+mutualista[:TIEMPO_ESP_PEDIATRIA].to_i+mutualista[:TIEMPO_ESP_CIRUG].to_i +
                mutualista[:TIEMPO_ESP_GIN].to_i)/24
            end

            return costos_estudios
        end

        def self.write_to_json (departamento, mutualistas)
            File.open(File.join(DATA_FOLDER, "#{departamento}.json"), 'w') do |file|
                file.write(JSON.generate(mutualistas))
            end
        end
    end
end

DatosMutualistas::Datos.leer_datos()