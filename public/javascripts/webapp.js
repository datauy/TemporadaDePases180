jQuery(function ($) {

  /*
   * Check for Function.prototype.bind and define if not defined.
   */
  if (!Function.prototype.bind) {
    Function.prototype.bind = function (oThis) {
      if (typeof this !== "function") {
        // closest thing possible to the ECMAScript 5 internal IsCallable function
        throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");
      }

      var aArgs = Array.prototype.slice.call(arguments, 1)
        , fToBind = this
        , fNOP = function () {}
        , fBound = function () {
          return fToBind.apply(this instanceof fNOP && oThis ? this : oThis,
            aArgs.concat(Array.prototype.slice.call(arguments)));
      };

      fNOP.prototype = this.prototype;
      fBound.prototype = new fNOP();

      return fBound;
    };
  }

  var App = {
      /**
       *
       */
      initialize: function () {
        this.bindEvents();
        this.tooltips();
      },
      /**
       *
       */
      bindEvents: function () {
        var $form = $("#preguntas-form")
        ,   self = this;

        $form.submit(function (event) {
          var departamento = $("#departamento").val()
            , ginecologia = $("input[name=opcionGinecologia]:checked").val()
            , pediatria = $("input[name=opcionPediatria]:checked").val()
            , fonasa =  $("input[name=opcionFonasa]:checked").val()
            , url, i;

          var prioridad = $('input[name=radioPrioridad]:radio:checked').val();

          // set default en costo
          if (typeof prioridad === "undefined") {
            prioridad = 'costo'; 
          }

          event.preventDefault();

          if (departamento !== "") {
            url = "/departamento/" + departamento;
            url += "?ginecologia=" + ginecologia + "&pediatria=" + pediatria + "&fonasa=" + fonasa + "&prioridad=" + prioridad
            
            if (!!(window.history && history.pushState))
              history.pushState(null, null, url);

            $('#js-ajax-resultados').empty().addClass('loading')
              .load(url + ' #js-ajax-resultados', function (response, status)
              {
                $(this).removeClass('loading');

                if (status === 'success')
                  self.tooltips();
                else
                  location.assign(url);
              });
          }
          else {
            this._displayError({ type: "invalid_departamento" });
          }
        }.bind(this));
      },
      /**
       *
       */      
      _displayError: function (error) {
        var $nameField = $(".form-field:has(#name)")
          , $yearField = $(".form-field:has(#year)");

        this._clearFormErrors();

        switch (error.type) {
          case "invalid_name":
            this._displayInputError($nameField, "El nombre es inv&aacute;lido");
            break;
          case "name_not_found":
            this._displayInputError($nameField, "No se encontr&oacute; el nombre ingresado");
            break;
          case "year_not_found":
            this._displayInputError($yearField, "No se encontr&oacute; el a&ntilde;o ingresado");
            break;

        }
      },
      /**
       *
       */
       render: function() {
        /*alert('render');*/
       },
       /**
       *
       */
      _displayInputError: function ($field, errorMessage) {
        var errorHTML = [
          "<div class=\"form-error\">",
            "<span class=\"tooltip-arrow\"></span>",
            "<p>" + errorMessage + "</p>",
          "</div>"
        ].join("");

        $field.find(".form-input").append(errorHTML);
        $field.addClass("error");
      },
      /**
       *
       */
      _clearFormErrors: function () {
        var $form = $("#preguntas-form");
        $form.find(".form-field.error").removeClass("error");
        $form.find(".form-error").remove();
      }

    , tooltips: function ()
      {
        $('#carousel-resultados').find('[data-toggle="tooltip"]').tooltip();
      }
    };

  App.initialize();


  App.render();

  //$(".help-tooltip").tooltip();

});
