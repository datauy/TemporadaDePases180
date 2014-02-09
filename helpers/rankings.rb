module Helpers
    module Rankings

        def get_rankings(prioridades)
            rankings = [ { :rango => 1, :nombre => "birubiru", :costo => {:a => 100, :b => 100, :ranking => 12}, \
                :metas => {:a => 20, :b => 30, :ranking => 6}, \
                :tiempos_espera => {:a => 100, :b => 100, :ranking => 4}, \
                :satisfaccion => {:a => 100, :b => 100, :ranking => 12}, \
                :personal => {:a => 100, :b => 100, :ranking => 30} }, \

                { :rango => 2, :nombre => "peperina", :costo => {:a => 100, :b => 100, :ranking => 12}, \
                :metas => {:a => 20, :b => 30, :ranking => 2}, \
                :tiempos_espera => {:a => 100, :b => 100, :ranking => 4}, \
                :satisfaccion => {:a => 100, :b => 100, :ranking => 12}, \
                :personal => {:a => 100, :b => 100, :ranking => 30} }, \

                { :rango => 3, :nombre => "tomito", :costo => {:a => 100, :b => 100, :ranking => 12}, \
                :metas => {:a => 20, :b => 30, :ranking => 2}, \
                :tiempos_espera => {:a => 100, :b => 100, :ranking => 4}, \
                :satisfaccion => {:a => 100, :b => 100, :ranking => 12}, \
                :personal => {:a => 100, :b => 100, :ranking => 30} } ]
        end

        def get_prioridades(options)
            
            prioridades = {}

            if not options.empty? 

                consultas = []

                consultas << "ginecologia" if options[:ginecologia]
                consultas << "pediatria" if options[:pediatria]

                otros = []

                otros << "costos" if options[:costos]
                otros << "tiemposEspera" if options[:tiemposEspera]
                otros << "derechos" if options[:derechos]
                otros << "cantidad" if options[:cantidad]
                otros << "servicios" if options[:servicios]

                prioridades[:consultas] = consultas
                prioridades[:fonasa] = options[:fonasa]
                prioridades[:prioridades] = otros
            end

            return prioridades
        end
    end
end
