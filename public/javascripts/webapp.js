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
      },
      /**
       *
       */
      bindEvents: function () {
        var $form = $("#preguntas-form");

        $form.submit(function (event) {
          var departamento = $("#departamento").val()
            , ginecologia = $("input[name=opcionGinecologia]:checked").val()
            , pediatria = $("input[name=opcionPediatria]:checked").val()
            , fonasa =  $("input[name=opcionFonasa]:checked").val()
            , precio = $("#checkboxPrecio").is(":checked")
            , tiemposEspera  = $("#checkboxTiempos").is(":checked")
            , derechos = $("#checkboxDerechos").is(":checked")
            , cantidad = $("#checkboxCantidad").is(":checked")
            , servicios = $("#checkboxServicios").is(":checked")
            , url, i;

          event.preventDefault();

          if (departamento !== "") {
            url = "/departamento/" + departamento;
            url += "?ginecologia=" + ginecologia + "&pediatria=" + pediatria + "&fonasa=" + fonasa + "&precio=" + precio + "&tiemposEspera=" + tiemposEspera + "&derechos=" + derechos + "&cantidad=" + cantidad + "&servicios=" + servicios
            document.location.href = url;
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
    };

  App.initialize();

  if ($("#departamento").val() !== "") {
    App.render();
  }

  $(".help-tooltip").tooltip();

});
